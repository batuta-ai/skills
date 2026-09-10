# Plan — Close the qa-skills review blockers
<!-- inputs: profile.md@sha256:3f3de48a1e13 routing.md@sha256:0788f392741d -->

**Goal:** Close the two blockers `batuta review` raised against the `qa-skills`
delivery: the bug registry's dedup step contradicts its own lifecycle table, and
three reference files are cited by no skill, so the procedures that own tours,
lenses, edge probes, round closing and the shared severity model are unreachable.
**Created:** 2026-09-09 · **Status:** done

## Tasks
- [x] 1. Dedup transitions bound to explicit statuses — docs/medium
      Scope: skills/batuta-qa-plan/references/bugs.md, tests/skills/check.sh
      Accept: the gate passes → bash tests/skills/check.sh; the dedup step no longer routes every non-verified match to re-found → test $(grep -c 'matches an unverified bug' skills/batuta-qa-plan/references/bugs.md) -eq 0; the file stays inside its Contents contract → grep -q '^## Contents' skills/batuta-qa-plan/references/bugs.md; the dedup step names the transition for each current status it can meet, so a `verified` match becomes `regressed`, a `wont-fix` match stays `wont-fix` until its stated reconsideration condition holds, an `invalid` match is re-examined rather than reopened by default, and only genuinely unresolved statuses take the ordinary `re-found` transition; the lifecycle table and the dedup step state the same rules with no contradiction left between them

- [x] 2. Wire the unreachable references into their skills — docs/high
      Depends on: 1
      Scope: skills/batuta-qa-run/SKILL.md, skills/batuta-qa-plan/SKILL.md, tests/skills/check.sh
      Accept: the gate passes → bash tests/skills/check.sh; the runner reads the probe catalogs before walking → grep -q 'references/probes.md' skills/batuta-qa-run/SKILL.md; the runner reads the closing contract → grep -q 'references/close.md' skills/batuta-qa-run/SKILL.md; the planner reads its own registry contract → grep -q 'references/bugs.md' skills/batuta-qa-plan/SKILL.md; both bodies stay inside the 60-line budget → test $(wc -l < skills/batuta-qa-run/SKILL.md) -le 60 && test $(wc -l < skills/batuta-qa-plan/SKILL.md) -le 60; every reference under both skills is cited by the skill that owns it, and each citation sits in the step that actually needs it rather than being appended as a list

## Decisions and context

These fixes answer a `batuta review` run whose artifacts are in
`.batuta/reviews/`. Do not restructure the skills: both `SKILL.md` files are
correct in shape and inside budget, and the references are correct in content.
The defect is that three of them are unreachable and one contradicts itself.

`tests/skills/check.sh` validates that every reference a skill **cites** exists.
It does not validate the converse — that every reference a skill **ships** is
cited — which is why this defect reached integration with a green gate. Do not
extend the gate in this plan; the rule is worth adding, but adding it while the
violation is still open would fail the gate mid-task. It is recorded as
follow-up work instead.

**Task 1.** The contradiction is between `## Deduplicate before filing` step 4
and the `## Lifecycle statuses` table. Step 4 sends any match that is not
`verified` to `re-found`, which silently swallows `wont-fix` (the table says it
is reconsidered only when scope or risk changes), `invalid` (the table says the
record is kept with its reasoning), `regressed` (already the more specific
status, so `re-found` would lose information) and `fixed` (a fix applied but
never replayed). Rewrite the step so the transition is chosen by the match's
current status, keep the table as the single source of truth for what each
status means, and keep both consistent. Do not add a status.

**Task 2.** `skills/batuta-qa-run/SKILL.md` routes steps 2, 3 and 5 to
`references/session.md` and never names `references/probes.md` or
`references/close.md`; `skills/batuta-qa-plan/SKILL.md` never names
`references/bugs.md` even though the planner owns it and the runner cites it
across skills. Read all five reference files, then place each citation in the
step whose deliverable depends on it: the probe catalogs belong to the step that
walks tours, lenses and edge probes; the closing contract belongs to the steps
that open the dated report, govern fixes and close the round; the registry
belongs to the planner's step that registers and dedups bugs. The runner's step
list may gain a step if the walking step is genuinely doing two jobs, as long as
the body stays within 60 lines. Keep the existing markdown link style.
