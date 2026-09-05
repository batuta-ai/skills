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

# Adapters: the frontmatter is a machine contract. Parse it as the YAML
# subset it uses (one `key: scalar` per line, ` #` starts a comment): a
# plain scalar may not carry `: `, quoted scalars must close, and every key
# that promises a placeholder carries it. self.md is the conductor itself and is exempt from
# the placeholder rules.
adapter_findings=$(python3 - skills/batuta/adapters/*.md <<'PY'
import re, sys
required = ["name", "run", "readonly", "available", "models", "finished"]
placeholders = {"run": ["{brief}"], "run_file": ["{brief_file}"], "readonly": ["{prompt}", "{model}"], "model_flags": ["{model}"]}
for path in sys.argv[1:]:
    text = open(path).read()
    if not text.startswith("---\n") or "\n---\n" not in text[4:]:
        print(f"{path}: no frontmatter block"); continue
    block = text[4:].split("\n---\n", 1)[0]
    keys = {}
    for n, line in enumerate(block.splitlines(), 2):
        if not line.strip() or line.startswith("#"):
            continue
        m = re.match(r"^([A-Za-z_][A-Za-z0-9_]*):(?:\s+(.*))?$", line)
        if not m:
            print(f"{path}:{n}: not a `key: value` line: {line}"); continue
        key, value = m.group(1), (m.group(2) or "").strip()
        keys[key] = value
        if value[:1] in ("'", '"'):
            if len(value) < 2 or value[-1] != value[0]:
                print(f"{path}:{n}: unterminated quoted scalar for {key}")
        else:
            value = re.split(r"\s+#", value, maxsplit=1)[0].rstrip()
            keys[key] = value
            if ": " in value or value.endswith(":"):
                print(f"{path}:{n}: plain scalar for {key} contains `: ` — quote it")
    for key in required:
        if key not in keys:
            print(f"{path}: frontmatter missing '{key}'")
    if keys.get("name") == "self":
        continue
    for key, wanted in placeholders.items():
        if key in keys:
            for ph in wanted:
                if ph not in keys[key]:
                    print(f"{path}: {key} does not carry {ph}")
PY
)
[ -z "$adapter_findings" ] || bad "adapter frontmatter:"$'\n'"$adapter_findings"

# References over 100 lines open with a Contents section.
for r in skills/batuta/references/*.md; do
  if [ "$(wc -l < "$r")" -gt 100 ] && ! grep -q '^## Contents' "$r"; then
    bad "$r: over 100 lines without '## Contents'"
  fi
done

# Token accounting beyond the resident body. Two packets, bytes/4 each:
# what the conductor loads across one cycle (SKILL.md, the references a
# cycle reads, one adapter, the longest template chain), and the overhead
# every executor brief carries (the chain's Conventions sections, the test
# laws and the method line). Budgets are ceilings, not targets.
tokens() { cat "$@" | wc -c | awk '{print int($1/4)}'; }
conventions() {
  # The "## Conventions for briefs" section of a template, up to the next H2.
  awk '/^## Conventions for briefs/{on=1; next} /^## /{on=0} on' "$1"
}
chain() {
  # A template followed by its Extends chain, child first up to generic.
  local t=$1 seen=""
  while [ -n "$t" ] && ! printf '%s' "$seen" | grep -q " $t "; do
    seen="$seen $t "; printf '%s\n' "skills/batuta/templates/$t.md"
    t=$(head -8 "skills/batuta/templates/$t.md" | tr '\n' ' ' | grep -oE 'Extends[^`]*`templates/[a-z0-9-]+\.md`' | grep -oE '[a-z0-9-]+\.md' | head -1 | sed 's/\.md$//')
  done
}
laws=$( { awk '/^## Test laws/{on=1; next} /^## /{on=0} on' skills/batuta/references/brief.md
          awk '/^## Method/{on=1; next} /^## /{on=0} on' skills/batuta/references/brief.md; } | wc -c)
cycle_max=0; cycle_max_at=""; brief_max=0; brief_max_at=""
for tmpl in skills/batuta/templates/*.md; do
  name=$(basename "$tmpl" .md); [ "$name" = "_template" ] && continue
  files=$(chain "$name")
  b=$(( ( $(for f in $files; do conventions "$f"; done | wc -c) + laws ) / 4 ))
  [ "$b" -gt "$brief_max" ] && { brief_max=$b; brief_max_at=$name; }
  for adapter in skills/batuta/adapters/*.md; do
    aname=$(basename "$adapter" .md); [ "$aname" = "_template" ] && continue
    c=$(tokens skills/batuta/SKILL.md skills/batuta/references/brief.md skills/batuta/references/verification.md \
      skills/batuta/references/routing.md skills/batuta/references/state.md skills/batuta/references/worktree.md "$adapter" $files)
    [ "$c" -gt "$cycle_max" ] && { cycle_max=$c; cycle_max_at="$name+$aname"; }
  done
done
printf 'cycle packet   ~%5d tokens max (%s; budget 9500)\nbrief overhead ~%5d tokens max (%s; budget 1000)\n' "$cycle_max" "$cycle_max_at" "$brief_max" "$brief_max_at"
[ "$cycle_max" -le 9500 ] || bad "conductor cycle packet ~$cycle_max tokens ($cycle_max_at) > 9500"
[ "$brief_max" -le 1000 ] || bad "executor brief overhead ~$brief_max tokens ($brief_max_at) > 1000"

if [ "$fail" -ne 0 ]; then note "skills check: FAILED"; exit 1; fi
note "skills check: ok"
