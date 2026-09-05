# Retro protocol — real-use QA of Batuta

Reusable script for Batuta test rounds on a guinea-pig project. It turns
the PRD §8 success criteria into dogfooding sessions: one persona (you, a
developer using Batuta for real) walks complete journeys and records what a
real user would experience. The protocol lives here and is versioned with
Batuta; the **results** of each round (findings, verdicts, debrief) belong
to the retro session and stay with the guinea pig.

Distilled from `qa-execution`/`qa-report` in
[pedronauck/skills](https://github.com/pedronauck/skills) — see the
distillation spec under `docs/superpowers/specs/`.

## The session's three non-negotiables

1. **In persona** — every interaction goes through Batuta's public surface
   (commands, briefs, WORK.md, commits). Peeking at the skills'
   implementation to decide what "should" happen is forbidden, and so is
   working around a stall from the inside. What the persona cannot reach,
   the real user cannot reach either.
2. **Proof, not optimism** — a Pass requires the expected observable
   confirmed through an independent path: the commit exists and is atomic
   (`git log`), WORK.md has the line, the diff traces back to the request.
   Batuta *saying* it did something is not confirmation — that is exactly
   the rule of `skills/batuta/references/verification.md` applied to Batuta
   itself. The task's trail in `.batuta/runs/` is first-class evidence: the
   brief sent, the executor's report and the reproduced proofs, independent
   of the session's memory (`skills/batuta/references/state.md`).
3. **Write back or it did not happen** — every finding becomes a record in
   the session (with evidence: command, output, hash) before moving on.

## A stall is a finding

A freeze, a question that should not exist, a non-atomic commit, state lost
on resume, a brief the executor did not understand: each one is a finding
to record with evidence — never something to push through, re-prompt or fix
on the spot "to keep the test going". Fixing mid-session contaminates the
round; the fix comes later, through the normal cycle, in Batuta's repository.

## Journeys to walk

Every round covers the journeys touched by the changes since the previous
round, plus one adjacent journey as a canary. A release round covers all:

| # | Journey | True final state |
|---|---|---|
| J1 | `init` → first simple cycle | a trivial task delegated and committed in < 3 interactions (PRD §8.1) |
| J2 | Cycle with decomposition | a list request becomes N cycles and N atomic commits, not one big commit |
| J3 | Failure → retry → escalation | specific feedback on the retry; escalation goes one row up the table; the diagnosis enriches the re-brief |
| J4 | `pause` → new session → `resume` | work resumed from the files alone, with no extra context (PRD §8.4) |
| J5 | Worktree per task | main stays clean during execution; squash with the conductor's message; worktree removed |
| J6 | Hardened verification | an executor that declares without evidence is caught; the test-hygiene scan fires when provoked; the trail in `.batuta/runs/` exists and supports the verdict |

Each journey is walked to its **true final state** — not to "it seems to
have worked". Each round includes at least one abandonment path (e.g.
rejecting a plan, cancelling mid-cycle).

## Impact rubric (finding severity)

| Tier | Meaning for the user |
|---|---|
| 1 — Blocks | the journey does not finish; no in-persona workaround |
| 2 — Loses work | state, commit or diff lost or corrupted |
| 3 — Breaks trust | Batuta claims something the evidence contradicts |
| 4 — Friction | the journey finishes, but cost extra interactions or confusion |
| 5 — Paper cut | an annoyance no formal criterion catches; record it anyway |

## Finding record (minimum format)

```markdown
### <short slug> — tier N
Journey: J<n> · Round: <date>
What happened: <1-3 sentences, in persona>
Evidence: <command + output, hash, WORK.md excerpt>
Expected: <what the user expected to see>
```

Dedupe before recording: a finding re-encountered from a previous round is
added to the existing entry ("re-found"), not opened as a new finding.

## Closing the round

- Every journey in scope has a verdict (Pass / findings / blocked — with the
  exact prerequisite that was missing). Cut a journey for lack of time?
  Cut by risk (tier 1 first) and **declare the cut** — coverage shrinks
  visibly or does not shrink.
- Final status: ready or not for the next version, with totals per tier.
- Findings become work in Batuta's repository through the normal cycle
  (one fix = one cycle = one commit), prioritized by tier.
