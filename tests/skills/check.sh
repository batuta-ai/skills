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

# Dispatch documentation carries stable scenario IDs so coverage is checked as
# structure, while the prose remains free to explain each decision naturally.
dispatch_scenarios='native-mismatch core-missing core-old-unqualified adapter-missing provider-version model-effort quota callback-denied disconnected canceled timeout cli-recovery'
scenario_doc=docs/native-dispatch-scenarios.md
if [ ! -f "$scenario_doc" ] || [ ! -r "$scenario_doc" ]; then
  bad "$scenario_doc: missing or unreadable"
else
  for scenario in $dispatch_scenarios; do
    count=$(grep -c "^| \`$scenario\` |" "$scenario_doc" 2>/dev/null)
    count=${count:-0}
    [ "$count" -eq 1 ] || bad "$scenario_doc: scenario '$scenario' appears $count times"
  done
fi
for readme in README.md README.pt-BR.md; do
  grep -q '](docs/native-dispatch-scenarios.md)' "$readme" || bad "$readme: dispatch scenario link missing"
done
if grep -Rqn 'Dispatch: cli' skills/batuta/SKILL.md skills/batuta/references/dispatch.md skills/batuta-loop/SKILL.md; then
  bad "dispatch guidance invents unsupported profile value 'Dispatch: cli'"
fi
for form in '--transport <mode> --dry-run' '--transport <mode> .batuta/plans' '--transport <mode> --answer' '--transport <mode> --resume' '--transport <mode> --roadmap'; do
  grep -q -- "$form" skills/batuta-loop/SKILL.md || bad "batuta-loop: selected transport missing from '$form'"
done
grep -q 'same-route CLI.*available' skills/batuta/references/dispatch.md || bad "dispatch: same-route CLI availability check missing"
grep -q 'unavailable-route policy' skills/batuta/references/dispatch.md || bad "dispatch: routing unavailable-executor policy missing"
grep -q 'adapter.*readonly.*cheap model' skills/batuta/references/verification.md || bad "verification: cheap-model adapter readonly rule missing"
grep -q 'no summarizing LLM' skills/batuta/references/dispatch.md || bad "dispatch: summarizing-LLM prohibition missing"

# Every relative reference cited in a skill must exist (relative to the
# citing file, to the skill root, or under skills/ for a cross-skill path).
while IFS= read -r line; do
  file=${line%%:*}; ref=${line#*:}
  base=$(dirname "$file")
  [ -e "$base/$ref" ] || [ -e "$(dirname "$base")/$ref" ] || [ -e "skills/${ref#../}" ] || bad "$file cites missing $ref"
done < <(grep -roE '(\.\./[a-z0-9-]+/)?(references|adapters|templates|assets)/[A-Za-z0-9_./-]+\.md' skills/ --include='*.md' | sort -u)

# References must be reachable from a shipped skill entrypoint, including
# through other local Markdown files.
if ! reachability_tests=$(PYTHONDONTWRITEBYTECODE=1 python3 -m unittest discover -s tests/skills -p 'test_reference_reachability.py' 2>&1); then
  bad "reference reachability tests:"$'\n'"$reachability_tests"
fi
if ! unreachable_references=$(PYTHONDONTWRITEBYTECODE=1 python3 tests/skills/reference_reachability.py skills 2>&1); then
  bad "reference reachability:"$'\n'"$unreachable_references"
fi

# Adapters: the frontmatter is a machine contract. Parse it as the YAML
# subset it uses (one `key: scalar` per line, ` #` starts a comment): a
# plain scalar may not carry `: `, quoted scalars must close, and every key
# that promises a placeholder carries it. self.md is the conductor itself and is exempt from
# the placeholder rules.
adapter_findings=$(python3 - skills/batuta/adapters/*.md <<'PY'
import json, re, sys
required = ["name", "run", "readonly", "available", "models", "finished"]
placeholders = {"run": ["{brief}"], "run_file": ["{brief_file}"], "readonly": ["{prompt}", "{model}"], "model_flags": ["{model}"]}
acp_keys = {"acp_run", "acp_version", "acp_model_config", "acp_effort_config", "acp_mode", "acp_session_meta"}
acp_required = acp_keys - {"acp_effort_config", "acp_mode", "acp_session_meta"}
# This is the shipped metadata inventory, not ACP qualification evidence.
expected_acp = {
    "opencode": {"acp_run": "opencode acp", "acp_version": "1.18.31", "acp_model_config": "model"},
    "codex": {"acp_run": "codex-acp", "acp_version": "@agentclientprotocol/codex-acp 1.13.1", "acp_model_config": "model", "acp_mode": "read-only"},
    "claude": {"acp_run": "claude-agent-acp", "acp_version": "0.81.1", "acp_model_config": "model", "acp_mode": "acceptEdits", "acp_session_meta": '{"claudeCode":{"options":{"sandbox":{"enabled":true,"autoAllowBashIfSandboxed":true}}}}'},
}
def acp_errors(keys):
    errors = []
    present = acp_keys & keys.keys()
    if present:
        errors += [f"ACP metadata missing '{key}'" for key in sorted(acp_required - present)]
        errors += [f"ACP metadata '{key}' is empty" for key in sorted(present) if not keys[key]]
        if any(mark in keys.get("acp_run", "") for mark in ("{", "}", "<", ">", "|", "&", ";")):
            errors.append("acp_run must be fixed argv without placeholders or shell syntax")
        meta = keys.get("acp_session_meta")
        if meta:
            try:
                parsed = json.loads(meta)
            except ValueError:
                parsed = None
            if not isinstance(parsed, dict):
                errors.append("acp_session_meta must be a JSON object")
    name = keys.get("name")
    if name in expected_acp:
        expected = expected_acp[name]
        errors += [f"{key} must be '{value}'" for key, value in expected.items() if keys.get(key) != value]
        errors += [f"unexpected ACP metadata '{key}'" for key in sorted(present - expected.keys())]
    elif present:
        errors.append(f"ACP launch metadata is not recorded for '{name}'")
    return errors
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
    for finding in acp_errors(keys):
        print(f"{path}: {finding}")
    if keys.get("name") == "self":
        continue
    for key, wanted in placeholders.items():
        if key in keys:
            for ph in wanted:
                if ph not in keys[key]:
                    print(f"{path}: {key} does not carry {ph}")

for fixture, expect in (
    ({"name": "opencode", "acp_run": "opencode acp"}, "missing 'acp_model_config'"),
    ({"name": "opencode", "acp_run": "opencode acp {brief}", "acp_version": "1.18.31", "acp_model_config": "model"}, "fixed argv"),
    ({"name": "opencode", "acp_run": "opencode acp", "acp_version": "1.18.31", "acp_model_config": "model", "acp_effort_config": "effort"}, "unexpected ACP metadata"),
    ({"name": "gemini", "acp_run": "gemini-acp", "acp_version": "1", "acp_model_config": "model"}, "not recorded"),
    ({"name": "claude", "acp_run": "claude-agent-acp", "acp_version": "0.81.1", "acp_model_config": "model", "acp_mode": "acceptEdits", "acp_session_meta": "[1]"}, "JSON object"),
):
    errors = acp_errors(fixture)
    if not any(expect in error for error in errors):
        print(f"ACP lint self-test missed {expect!r} for {fixture}: {errors}")
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
      skills/batuta/references/routing.md skills/batuta/references/dispatch.md skills/batuta/references/state.md \
      skills/batuta/references/worktree.md "$adapter" $files)
    [ "$c" -gt "$cycle_max" ] && { cycle_max=$c; cycle_max_at="$name+$aname"; }
  done
done
printf 'cycle packet   ~%5d tokens max (%s; budget 9500)\nbrief overhead ~%5d tokens max (%s; budget 1000)\n' "$cycle_max" "$cycle_max_at" "$brief_max" "$brief_max_at"
[ "$cycle_max" -le 9500 ] || bad "conductor cycle packet ~$cycle_max tokens ($cycle_max_at) > 9500"
[ "$brief_max" -le 1000 ] || bad "executor brief overhead ~$brief_max tokens ($brief_max_at) > 1000"

if [ "$fail" -ne 0 ]; then note "skills check: FAILED"; exit 1; fi
note "skills check: ok"
