# Plan — Make QA round outcomes honest and references reachable
<!-- inputs: profile.md@sha256:3f3de48a1e13 routing.md@sha256:556eb69f6375 -->

**Goal:** Close the remaining QA review findings: independently unique run artifacts and an explicit failure verdict. Prevent shipped references from becoming unreachable without broadening the QA feature or changing host integration.
**Created:** 2026-09-10 · **Status:** approved

## Tasks
- [ ] 1. Give each QA run a stable unique identity and preserve observed failures — docs/high
      Scope: skills/batuta-qa-run/references/close.md, skills/batuta-qa-plan/references/tree.md, skills/batuta-qa-plan/references/planning.md, tests/skills/check.sh
      Accept: the existing gate passes → bash tests/skills/check.sh; both references retain Contents sections → grep -q '^## Contents' skills/batuta-qa-run/references/close.md && grep -q '^## Contents' skills/batuta-qa-plan/references/tree.md; every new run uses an independently generated UUID in both report and evidence paths and resume reuses that identity without renaming historical artifacts; the layout and Id and merge rules distinguish stable scenario identities from unique run identities without counters or local-existence-only collision prevention; a terminal Fail ledger row maps to qa_status fail and every observed unresolved failure remains fail even when repair needs human approval or a replay fails; blocked-decision means evaluation or expected behavior needs a human decision and blocked-verify means evaluation needs unavailable verification, neither erases an already observed failure; final readiness cannot be ready or ready with blocked items while an observed failure remains unresolved

- [ ] 2. Reject references unreachable from shipped skill entrypoints — testing/medium
      Depends on: 1
      Scope: tests/skills/check.sh, tests/skills/reference_reachability.py, tests/skills/test_reference_reachability.py
      Accept: fixture regressions pass → PYTHONDONTWRITEBYTECODE=1 python3 -m unittest discover -s tests/skills -p 'test_reference_reachability.py'; the public gate passes with the new checker and regression suite wired in → bash tests/skills/check.sh; fixtures cover direct and transitive links, bare sibling citations, cross-skill paths, anchors, an orphan, an unreachable two-file cycle and a reachable cycle without hanging; a fixture matching the former QA defect fails when the close or probes citation is removed and succeeds when restored; the checker reports each unreachable references Markdown path deterministically and returns nonzero through the public gate; the gate stays read-only against the checkout, preserves existing missing-target checks and budget checks, and requires no new third-party dependency

## Decisions and context

The user approved this plan and execution on 2026-09-10. The current branch is
`feat/qa-skills`; the planning checkpoint was `c6a3019` and guard setup is
`d6bc86f`. Prior deliveries are terminal `done`. Do not resume or abandon them.

Repository policy: English prose, sequential execution, worktrees always, one
verified commit per task. Routing predicts codex/gpt-6-astra for task 1 and
codex/gpt-5.6-sol for task 2. The routing table, not this advisory text, decides.
Keep existing skill bodies, budgets, bug lifecycle and fix-governor bounds intact.
Executors follow their delegated brief only and never start a nested conductor.

Evidence was inspected while planning. The saved review has two findings in
`close.md` and one stale WORK entry, not three findings in `close.md`. The WORK
finding was already addressed by `c6a3019`. The full requirements below are
self-contained because excluded review artifacts do not reach worktrees.

**Task 1.** Change only the three QA references. `tests/skills/check.sh` is in
Scope because it is the proof command, not permission to alter the gate in this
task. Capture the current contradictory passages before editing, rewrite the
contract, run the gate and review each acceptance criterion against the full
resulting prose. Do not add a runtime UUID generator to this prose-only package.

**Task 1.** New artifacts use
`reports/<YYYY-MM-DD>-<scope>-<run-id>.md` and
`evidence/<YYYY-MM-DD>-<scope>-<run-id>/`. Define `run-id` as a UUID v4 minted
once by a host-available UUID facility before the first session, recorded in the
report and reused by all checkpoints and resume. A counter, timestamp alone or
checking the current branch for an existing filename is insufficient. Refuse an
unexpected existing new-run path rather than overwriting it. Existing reports
retain their paths and evidence links when resumed, including legacy reports
without UUIDs. Independent runs get different identities even with equal dates
and scopes. Stable scenario, journey and bug ids retain their existing rules.
Update both the layout and the paragraph that currently calls run files
content-addressed; changing only the layout leaves a contradiction.
Update the report-path example in `planning.md` as well so the planner directs
the runner to the same identity contract, without duplicating UUID policy.

**Task 1.** Add terminal ledger value `Fail` mapping to `qa_status: fail` with
linked `bug_ids`. Pending or deferred repair decisions belong in `fix_status`
and `Decisions for a Human`, not in the evaluation verdict. A failed replay
remains a failure with `retest_status: fail` when applicable, following the
existing bug lifecycle. Preserve `Fixed` only after the required proof and
replay. Reconcile the introductory rule, mapping table, escalation instructions,
closure checklist and final readiness rule. Check these cases explicitly:
observed failure with deferred repair, ambiguous expected behavior, unavailable
verification without an observed failure, successful repair/replay, and failed
replay. They resolve respectively to Fail, Blocked (human decision), Blocked
(needs human verify), Fixed, and Fail. No new qa_status or bug lifecycle enum.

**Task 2.** Implement a small Python-standard-library reference graph checker
and unittest fixture suite, invoked by the existing shell gate. Start from all
`skills/*/SKILL.md` entrypoints and follow actual Markdown links and backticked
Markdown-file citations through shipped Markdown files. Require every file
under `skills/*/references/**/*.md` to be reachable, not merely cited somewhere.
Cross-skill reachability is valid; disconnected cycles and README-only citations
must not hide an orphan. Use a visited set for cycles and sorted diagnostics.
Do not require every adapter, template or asset to be reachable: only references
are targets of this new rule, though other Markdown files can be intermediates.

**Task 2.** Resolve citations relative to the citing file, then its owning skill
root, and support existing cross-skill forms under `skills/`. Strip link anchors
for local-file lookup. Recognize sibling `no-workarounds.md` in
`references/method/debug.md`; the current shell regex misses that legitimate
edge. Ignore remote URLs and placeholder paths as graph edges. Keep the existing
missing-reference gate intact; no broad Markdown parser or resolver rewrite is
needed. Restrict graph traversal to existing files inside the supplied skills
root. Fixtures live in temporary directories and never mutate the real skills.

**Task 2.** Write failing fixtures first, implement the checker, then integrate
it and its tests into `bash tests/skills/check.sh` so existing CI runs both.
Set `PYTHONDONTWRITEBYTECODE=1` for imports/tests to preserve the read-only gate.
Test direct links, reference-to-reference links, basename and cross-skill links,
fragment links, an orphan and disconnected cycle, a reachable cycle, and the
QA missing-link/restored-link pair. For a shell propagation test use a temporary
copy of the repository with an injected orphan: require nonzero and its exact
path in the output. Avoid recursive invocation of the test suite from fixtures.

## Conductor preparation and completion (outside the delivery)

After the user approves, before launching any executor:

1. Create root `AGENTS.md` from
   `skills/batuta-init/assets/agents-md-block.md` verbatim. Verify with
   `cmp AGENTS.md skills/batuta-init/assets/agents-md-block.md` and
   `git diff --check`, then commit it separately as
   `chore(batuta): add delegated-brief guard`. Do not route this prerequisite
   through an unguarded executor. This is local setup, not a new plugin fix.
2. Mark this plan approved, record the checkpoint in WORK, and commit the managed
   state separately from feature changes. The guard must be on the delivery base
   so it cannot become an out-of-scope feature-review finding.
3. Probe capabilities and use the batuta-loop skill to preflight/dry-run, then
   launch `batuta loop qa-skills-round3` only with execution authorization.
4. Run the public gate and a separate delivery review against this plan after
   the loop. Judge findings, record evidence and update WORK honestly. Do not
   silently iterate into new scope or merge/publish as part of planning.

The handoff is consumed into this plan and WORK. Host commands/vendoring,
Compozy setup, issues for nested conductors and verifier retry policy, and
`loop --review` design remain follow-ups, not acceptance criteria for this plan.
