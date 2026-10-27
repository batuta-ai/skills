#!/usr/bin/env bash
# Mutation test for grants contract checks in check.sh.
# Verifies that check.sh fails for each expected mutation.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"

mutations=(
  "citation_removed"
  "reason_not_covered_removed"
  "reason_malformed_clause_removed"
  "reason_turn_cap_removed"
  "reason_repeat_removed"
  "reason_deadline_removed"
  "until_task_removed"
)

apply_mutation() {
  local mutation="$1"
  local target_dir="$2"

  case "$mutation" in
    citation_removed)
      # remove citation of references/grants.md in skills/batuta-loop/SKILL.md
      python3 -c '
path = "'"$target_dir"'/skills/batuta-loop/SKILL.md"
with open(path, "r") as f:
    content = f.read()
content = content.replace("references/grants.md", "references/other.md")
with open(path, "w") as f:
    f.write(content)
'
      ;;
    reason_not_covered_removed)
      python3 -c '
path = "'"$target_dir"'/skills/batuta-loop/references/grants.md"
with open(path, "r") as f:
    lines = f.readlines()
with open(path, "w") as f:
    for line in lines:
        if not line.startswith("- `not_covered` →"):
            f.write(line)
'
      ;;
    reason_malformed_clause_removed)
      python3 -c '
path = "'"$target_dir"'/skills/batuta-loop/references/grants.md"
with open(path, "r") as f:
    lines = f.readlines()
with open(path, "w") as f:
    for line in lines:
        if not line.startswith("- `malformed_clause` →"):
            f.write(line)
'
      ;;
    reason_turn_cap_removed)
      python3 -c '
path = "'"$target_dir"'/skills/batuta-loop/references/grants.md"
with open(path, "r") as f:
    lines = f.readlines()
with open(path, "w") as f:
    for line in lines:
        if not line.startswith("- `turn_cap` →"):
            f.write(line)
'
      ;;
    reason_repeat_removed)
      python3 -c '
path = "'"$target_dir"'/skills/batuta-loop/references/grants.md"
with open(path, "r") as f:
    lines = f.readlines()
with open(path, "w") as f:
    for line in lines:
        if not line.startswith("- `repeat` →"):
            f.write(line)
'
      ;;
    reason_deadline_removed)
      python3 -c '
path = "'"$target_dir"'/skills/batuta-loop/references/grants.md"
with open(path, "r") as f:
    lines = f.readlines()
with open(path, "w") as f:
    for line in lines:
        if not line.startswith("- `deadline` →"):
            f.write(line)
'
      ;;
    until_task_removed)
      python3 -c '
path = "'"$target_dir"'/skills/batuta-loop/references/grants.md"
with open(path, "r") as f:
    content = f.read()
content = content.replace("--until task", "")
with open(path, "w") as f:
    f.write(content)
'
      ;;
    *)
      echo "Unknown mutation: $mutation" >&2
      return 1
      ;;
  esac
}

all_passed=true

for mutation in "${mutations[@]}"; do
  tmp_dir=$(mktemp -d)
  mkdir -p "$tmp_dir/skills" "$tmp_dir/tests"
  cp -R "$REPO_ROOT/skills/"* "$tmp_dir/skills/"
  cp -R "$REPO_ROOT/tests/"* "$tmp_dir/tests/"

  # Also copy .batuta/profile.md if it exists so line budget / token accounting in check.sh works identically
  if [ -f "$REPO_ROOT/.batuta/profile.md" ]; then
    mkdir -p "$tmp_dir/.batuta"
    cp "$REPO_ROOT/.batuta/profile.md" "$tmp_dir/.batuta/"
  fi
  # docs/ if referenced by check.sh
  if [ -d "$REPO_ROOT/docs" ]; then
    mkdir -p "$tmp_dir/docs"
    cp -R "$REPO_ROOT/docs/"* "$tmp_dir/docs/"
  fi
  for f in README.md README.pt-BR.md; do
    if [ -f "$REPO_ROOT/$f" ]; then
      cp "$REPO_ROOT/$f" "$tmp_dir/$f"
    fi
  done

  apply_mutation "$mutation" "$tmp_dir"

  if (cd "$tmp_dir" && bash tests/skills/check.sh >/dev/null 2>&1); then
    echo "mutation $mutation: PASSED GATE (expected failure)"
    all_passed=false
  else
    echo "mutation $mutation: FAILED GATE as expected"
  fi

  rm -rf "$tmp_dir"
done

if [ "$all_passed" = true ]; then
  exit 0
else
  exit 1
fi
