# Learnings — skills

Rules distilled from rejected findings and loop incidents, append-only.

- 2026-09-19 research-ladder loop: agy cannot see hidden directories. Asked to edit `.batuta/routing.md` inside its worktree it searched the filesystem for the file, wrote nothing and reported the proofs as passed; the loop then accepted a false "already satisfied on the base" from the cheap verifier without running the proofs. Never seat a task whose Scope lives under a dot-directory (`.batuta/`, `.github/`, `.claude/`) on agy; route it to codex or self.