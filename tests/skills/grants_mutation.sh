#!/usr/bin/env bash
# Mutation test for the grants contract checks in check.sh: each mutation
# runs on a fresh copy of the repository and must make the gate fail.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
LOOP_SKILL=skills/batuta-loop/SKILL.md
GRANTS=skills/batuta-loop/references/grants.md

tmp_dir=""
trap '[ -n "$tmp_dir" ] && rm -rf "$tmp_dir"' EXIT

# replace_text <file> <old> <new>: replace every occurrence of a literal string.
replace_text() {
  python3 - "$1" "$2" "$3" <<'EOF'
import sys
path, old, new = sys.argv[1:]
with open(path) as f:
    content = f.read()
with open(path, "w") as f:
    f.write(content.replace(old, new))
EOF
}

# drop_lines <file> <prefix>: remove every line that starts with a literal prefix.
drop_lines() {
  python3 - "$1" "$2" <<'EOF'
import sys
path, prefix = sys.argv[1:]
with open(path) as f:
    lines = f.readlines()
with open(path, "w") as f:
    f.writelines(line for line in lines if not line.startswith(prefix))
EOF
}

apply_mutation() {
  case "$1" in
    citation_removed) replace_text "$LOOP_SKILL" "references/grants.md" "references/other.md" ;;
    reason_*_removed)
      local reason=${1#reason_}
      drop_lines "$GRANTS" "- \`${reason%_removed}\` →"
      ;;
    until_task_removed) replace_text "$GRANTS" "--until task" "" ;;
    *) echo "unknown mutation: $1" >&2; return 1 ;;
  esac
}

mutations=(
  citation_removed
  reason_not_covered_removed
  reason_malformed_clause_removed
  reason_turn_cap_removed
  reason_repeat_removed
  reason_deadline_removed
  until_task_removed
)

# copy_repo: a fresh copy of what check.sh reads, in a new temporary directory.
copy_repo() {
  tmp_dir=$(mktemp -d)
  cp -R "$REPO_ROOT/skills" "$REPO_ROOT/tests" "$REPO_ROOT/docs" \
    "$REPO_ROOT/README.md" "$REPO_ROOT/README.pt-BR.md" "$tmp_dir/"
  # check.sh reads the profile's Conventions section.
  if [ -f "$REPO_ROOT/.batuta/profile.md" ]; then
    mkdir -p "$tmp_dir/.batuta"
    cp "$REPO_ROOT/.batuta/profile.md" "$tmp_dir/.batuta/"
  fi
}

# Without this baseline, a copy that fails for an unrelated reason would make
# every mutation look caught.
copy_repo
if ! (cd "$tmp_dir" && bash tests/skills/check.sh >/dev/null 2>&1); then
  echo "baseline: the unmutated copy fails the gate" >&2
  exit 1
fi
rm -rf "$tmp_dir"
tmp_dir=""

failed=0
for mutation in "${mutations[@]}"; do
  copy_repo
  (cd "$tmp_dir" && apply_mutation "$mutation")

  if (cd "$tmp_dir" && bash tests/skills/check.sh >/dev/null 2>&1); then
    echo "mutation $mutation: PASSED GATE (expected failure)"
    failed=1
  else
    echo "mutation $mutation: FAILED GATE as expected"
  fi
  rm -rf "$tmp_dir"
  tmp_dir=""
done

exit "$failed"
