# Close and fix governor

Close a QA round without turning its ledger green by omission. The dated report
is the resumable run record; the living tree keeps the latest settled truth.

## Contents

- Run ledger states
- Open the report
- Write back each session
- Govern fixes
- Prove an automatic fix
- Escalate work outside the bounds
- Close the round
- Failure patterns

## Run ledger states

Every session row uses exactly one of these values. Put qualifications, links,
and explanations beside the row rather than inventing another status.

| Status | Use when | Terminal for this round |
|---|---|---|
| `Pending` | The planned session has not been walked | no |
| `Pass` | The expected public result and an independent reread agree | yes |
| `Fixed` | A found failure was governed, fixed, proven, and re-walked | yes |
| `Skipped` | Risk ordering cut the session; the reason is recorded | yes |
| `Blocked (needs human verify)` | Completion needs a named human action or unavailable capability | yes |
| `Blocked (human decision)` | Product judgment or an unsafe fix must be decided by a person | yes |

A round cannot close while any row is `Pending`. A failure that is not fixed in
the round must end as `Blocked (human decision)`, with its registered bug and
recommendation linked. Human verification is distinct: it records exact steps a
person can perform without making a product choice.

Map settled rows into scenario frontmatter from the tree contract:

| Ledger | `qa_status` | Fix fields |
|---|---|---|
| `Pass` | `pass` | empty unless a linked historical bug requires them |
| `Fixed` | `pass` | `fix_status: fixed`; `retest_status: pass`; commit recorded |
| `Skipped` | `skipped` | reason in the scenario body |
| `Blocked (needs human verify)` | `blocked-verify` | exact prerequisite in the body |
| `Blocked (human decision)` | `blocked-decision` | pending or deferred fix and decision link |

## Open the report

Create `[qa-root]/reports/<YYYY-MM-DD>-<scope>.md` as soon as scope and the
risk-ordered session ledger are known, before entering the first session. Seed
every planned row as `Pending`, and include the target build, personas, journeys,
charters, tour, time box, and intended evidence location.

Never overwrite an earlier round. If a filename for the date and scope already
exists, choose a stable distinguishing scope suffix. Resume an interrupted round
by reopening its existing report and continuing its `Pending` rows; do not make
a second report for the same run.

The report is the checkpoint for the active round. Update it on disk after every
session, governed fix, retest, skip, or block so another runner can resume without
replaying completed work.

## Write back each session

Immediately after a charter ends:

1. Set its report-ledger rows to a closed result, or leave only work that truly
   has not begun as `Pending`.
2. Append the persona, entry point, public actions, observed result, independent
   reread, evidence paths, timing, end state, branches, paper cuts, and bug ids to
   the report debrief.
3. Update each affected scenario's verdict fields, `evidence`, and `last_report`.
4. Deduplicate failures in the shared bug registry before linking `bug_ids`.
5. Record blocked prerequisites or skipped reasoning in both the report and the
   scenario body.

Do not batch this work until the end. A result missing from the committed tree
did not become durable QA knowledge.

## Govern fixes

End the persona session before considering an edit. For each registered failure
or sharp paper cut, write down the user-visible symptom and its root cause, then
judge all four bounds before changing product code:

- **Narrow:** only a few files; no schema, data, protocol, dependency, or public
  contract migration.
- **Understood:** evidence identifies the cause, not merely the failing surface.
- **Contained:** the likely blast radius is local and the adjacent journeys are
  known and runnable.
- **Unambiguous:** reasonable product or design owners would not choose different
  behavior.

Automatic repair is allowed only when every bound passes. Record that judgment
in the report first. If new evidence breaks a bound after editing starts, restore
the complete pre-fix state, keep the bug open, and escalate it. Never leave a
partial repair in order to improve the ledger.

## Prove an automatic fix

Each automatic repair is one logical commit tied to its bug id and carries all
of this evidence:

1. A focused regression test that fails against the unfixed behavior and passes
   after the repair.
2. The bug record's separate root-cause statement, fix commit, and test path.
3. A fresh persona walk of the affected journey from its real entry point.
4. Fresh walks of adjacent journeys that share the changed surface or service.
5. Independent public rereads and new evidence from the repaired build.

When an automated assertion cannot meaningfully prove a copy-only or visual
change, use a documented replay: exact steps, before-and-after evidence, the
reason automation is unsuitable, and a linked automation-backlog entry. That is
the only substitute for red-before and green-after proof.

Move the bug to `fixed` after the commit, and to `verified` only after the
original persona and journey confirm the result. A failed replay reopens the bug;
revert a harmful repair, and escalate rather than widening the governor.

## Escalate work outside the bounds

Anything failing one governor bound goes into the dated report under
`Decisions for a Human`. Include:

- the user-visible problem, impact tier, bug id, and evidence;
- the bound that prevents automatic repair;
- two or more viable options with their trade-offs when alternatives exist;
- one recommendation and the evidence behind it;
- the owner or exact prerequisite needed to continue.

Set the report row to `Blocked (human decision)` and the scenario to
`blocked-decision`. For an unavailable browser, account, role, external service,
or required person, use `Blocked (needs human verify)` and `blocked-verify`, with
reproducible instructions. Continue independent runnable sessions; never hide an
escalation as a retry, skip, or optimistic pass.

## Close the round

Before writing Final Status, check every item:

- [ ] No ledger row remains `Pending`; every skip and block explains why.
- [ ] Every in-scope journey has a persona session or a disclosed coverage gap.
- [ ] Every failed or fixed row links one deduplicated registry bug.
- [ ] Bug lifecycle, scenario verdict, fix fields, and retest fields agree.
- [ ] Every automatic fix has a commit and regression proof or the documented
      replay exception, plus affected and adjacent journey results.
- [ ] Every session has a debrief; all evidence links resolve or name the
      retained external artifact.
- [ ] Production-parity differences and unavailable instruments are disclosed.
- [ ] The project's required local gate was run after the last fix and its real
      output is recorded; exact-head CI is recorded when available.
- [ ] Totals use the shared impact tiers and include open, blocked, and skipped
      work rather than counting only passes.
- [ ] Final Status says `ready`, `not ready`, or `ready with blocked items` in one
      actionable sentence supported by the ledger and gates.

A green session ledger cannot overrule a failed gate, missing regression proof,
or an undisclosed parity gap. Write Final Status last, then leave the report and
tree mutually consistent for the next planning round.

## Failure patterns

- Writing the report after testing discards resumability.
- Adding prose variants to the enum makes the ledger impossible to reconcile.
- Patching during a persona walk contaminates the observation.
- Fixing without a pre-edit governor decision turns QA into self-approval.
- Retesting only the changed path misses adjacent regressions.
- Treating a blocked leg as a pass or silently dropping it falsifies coverage.
