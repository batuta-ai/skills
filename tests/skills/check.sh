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

if [ "$fail" -ne 0 ]; then note "skills check: FAILED"; exit 1; fi
note "skills check: ok"
