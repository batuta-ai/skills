#!/usr/bin/env bash
# Lint and token-budget gate for every skill in skills/.
# Read-only. Exit 1 on the first class of failure found; prints all findings.
set -u
cd "$(dirname "$0")/../.."

fail=0
note() { printf '%s\n' "$*"; }
bad()  { fail=1; printf 'FAIL %s\n' "$*"; }

# Line budgets per SKILL.md (the body is resident whenever the skill loads).
budget_for() {
  case "$1" in
    batuta) echo 120 ;;
    batuta-init) echo 110 ;;
    *) echo 60 ;;
  esac
}

# Strings that must never appear in a skill, adapter or reference:
# third-party plugins we no longer depend on, and host-specific tool names.
FORBIDDEN='superpowers|codex-plugin|codex:rescue|compozy|AskUserQuestion|TodoWrite|TaskCreate|run_in_background|SlashCommand|\bTask tool\b'

for skill_md in skills/*/SKILL.md; do
  dir=$(basename "$(dirname "$skill_md")")
  name=$(sed -n 's/^name: *//p' "$skill_md" | head -1)
  desc=$(sed -n 's/^description: *//p' "$skill_md" | head -1)
  lines=$(wc -l < "$skill_md")
  budget=$(budget_for "$dir")

  [ "$name" = "$dir" ] || bad "$skill_md: name '$name' != directory '$dir'"
  [ -n "$desc" ] || bad "$skill_md: missing description"
  [ "${#desc}" -le 300 ] || bad "$skill_md: description ${#desc} chars > 300"
  [ "$lines" -le "$budget" ] || bad "$skill_md: $lines lines > budget $budget"
  printf '%-16s %4d/%-4d lines  ~%5d tokens\n' "$dir" "$lines" "$budget" $(( $(wc -c < "$skill_md") / 4 ))
done

# Forbidden strings anywhere under skills/ (CHANGELOG and README are exempt).
hits=$(grep -rnE "$FORBIDDEN" skills/ || true)
[ -z "$hits" ] || bad "forbidden strings:"$'\n'"$hits"

# Every relative reference cited in a skill must exist (relative to the
# citing file, or to the skill root when a template cites `templates/...`).
while IFS= read -r line; do
  file=${line%%:*}; ref=${line#*:}
  base=$(dirname "$file")
  [ -e "$base/$ref" ] || [ -e "$(dirname "$base")/$ref" ] || bad "$file cites missing $ref"
done < <(grep -roE '(\.\./batuta/)?(references|adapters|templates|assets)/[A-Za-z0-9_./-]+\.md' skills/ --include='*.md' | sort -u)

# Adapters: frontmatter must carry the machine contract.
for a in skills/batuta/adapters/*.md; do
  for key in name run readonly available models finished; do
    grep -qE "^$key:" "$a" || bad "$a: frontmatter missing '$key'"
  done
done

# References over 100 lines open with a Contents section.
for r in skills/batuta/references/*.md; do
  if [ "$(wc -l < "$r")" -gt 100 ] && ! grep -q '^## Contents' "$r"; then
    bad "$r: over 100 lines without '## Contents'"
  fi
done

if [ "$fail" -ne 0 ]; then note "skills check: FAILED"; exit 1; fi
note "skills check: ok"
