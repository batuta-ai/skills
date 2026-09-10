# WORK — skills

## In progress
- [ ] QA round 3: delivery `qa-skills-round3-20260910-132031` is terminal `done`, with both tasks integrated on their first attempt (08e53d9, b37f520). Plan archived at `.batuta/plans/done/qa-skills-round3.md`. Independent public gate and delivery review are now the remaining checks. No push or merge authorized.

## Follow-ups
- [ ] After QA skills are reviewed and merged: host command wiring and vendoring in a separate repository plan.
- [ ] File the nested-conductor and verifier-incomplete retry-policy issues recorded below. No issues filed in this planning session.
  - Nested conductors: qa-skills task 5 e1 and qa-skills-fixes task 1 e1 tried nested `codex exec` and hit `Operation not permitted (os error 1)`. The AGENTS guard is partial mitigation, not a complete plugin-level fix.
  - Verifier retry policy: qa-skills-fixes journal seq 47 records `verifier_incomplete` because agy emitted no parseable `TASK n: DONE|INCOMPLETE` lines. The loop reran implementation despite green task gates. Investigate retrying/escalating verification rather than implementation.
- [ ] Deferred decisions: preventive Compozy guard and whether delivery review becomes a loop gate.

## Done
- [x] Root `AGENTS.md` delegated-brief guard copied verbatim from the init asset, verified with cmp and git diff --check, committed separately as d6bc86f before executors (2026-09-10).
- [x] QA tree contract reference → codex (gpt-5.6-sol), commit 6d35c183b876 (trail: .batuta/runs/2026-09-09-qa-skills-task-1.md, delivery qa-skills-20260909-154719, plan qa-skills, 2026-09-09)
- [x] Planner skill → codex (gpt-6-astra), commit 37b6467391b6 (trail: .batuta/runs/2026-09-09-qa-skills-task-2.md, delivery qa-skills-20260909-154719, plan qa-skills, 2026-09-09)
- [x] Bug registry reference → codex (gpt-5.6-sol), commit 9863015b2a2b (trail: .batuta/runs/2026-09-09-qa-skills-task-3.md, delivery qa-skills-20260909-154719, plan qa-skills, 2026-09-09)
- [x] Runner skill and cross-skill references in the gate → codex (gpt-6-astra), commit 138a5df46ce5 (trail: .batuta/runs/2026-09-09-qa-skills-task-4.md, delivery qa-skills-20260909-154719, plan qa-skills, 2026-09-09)
- [x] Probe catalogs → codex (gpt-5.6-sol), 1 retry, commit 057bee84529b (trail: .batuta/runs/2026-09-09-qa-skills-task-5.md, delivery qa-skills-20260909-154719, plan qa-skills, 2026-09-09)
- [x] Close and fix governor → codex (gpt-5.6-sol), commit cdddfadcf61f (trail: .batuta/runs/2026-09-09-qa-skills-task-6.md, delivery qa-skills-20260909-154719, plan qa-skills, 2026-09-09)
- [x] Docs wiring → agy (gemini-3.8-flash-low), commit 3a20fc204302 (trail: .batuta/runs/2026-09-09-qa-skills-task-7.md, delivery qa-skills-20260909-154719, plan qa-skills, 2026-09-09)
- [x] Dedup transitions bound to explicit statuses → codex (gpt-5.6-sol), commit 929fd7b98ec4 (trail: .batuta/runs/2026-09-09-qa-skills-fixes-task-1.md, delivery qa-skills-fixes-20260909-205535, plan qa-skills-fixes, 2026-09-10)
- [x] Wire the unreachable references into their skills → codex (gpt-6-astra), 1 retry, commit ae269d1b2169 (trail: .batuta/runs/2026-09-09-qa-skills-fixes-task-2.md, delivery qa-skills-fixes-20260909-205535, plan qa-skills-fixes, 2026-09-10)
- [x] Give each QA run a stable unique identity and preserve observed failures → codex (gpt-6-astra), commit 08e53d9dc9c2 (trail: .batuta/runs/2026-09-10-qa-skills-round3-task-1.md, delivery qa-skills-round3-20260910-132031, plan qa-skills-round3, 2026-09-10)
- [x] Reject references unreachable from shipped skill entrypoints → codex (gpt-5.6-sol), commit b37f520a3257 (trail: .batuta/runs/2026-09-10-qa-skills-round3-task-2.md, delivery qa-skills-round3-20260910-132031, plan qa-skills-round3, 2026-09-10)
