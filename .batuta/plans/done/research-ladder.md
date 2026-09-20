# Plan — research lane ladder (doctrine)
<!-- inputs: profile.md@sha256:3f3de48a1e13 routing.md@sha256:556eb69f6375 -->

**Goal:** Turn the flat research support lane into a small ladder (`low`, `medium`, optional `high`) with the same escalation rule as the implementation lanes, so a hard discovery question climbs to a stronger read-only model before falling back to the conducting host, and the loop's independent verifier can be seated on a research row of the task's lane. Doctrine, onboarding, route editing and adapter notes change; the table format gains a `Lane` column in the Role table and stays backward compatible (no `Lane` = `low`).
**Created:** 2026-09-19 · **Status:** done

## Tasks
- [x] 1. Research ladder doctrine in routing.md and scout.md — docs/medium
      Scope: skills/batuta/references/routing.md, skills/batuta/references/scout.md
      Accept: the gate passes → bash tests/skills/check.sh; the Role table carries a Lane column with research rows per lane → grep -q '^| Role | Lane | Executor | Model |' skills/batuta/references/routing.md; the flat-lane wording is gone from both references → ! grep -q 'Nothing escalates' skills/batuta/references/routing.md skills/batuta/references/scout.md; scout.md classifies a research brief by lane and escalates one row up before falling back to self → grep -q 'one row up' skills/batuta/references/scout.md; both references keep their Contents section → grep -q '^## Contents' skills/batuta/references/scout.md
- [x] 2. Onboarding proposes the research ladder and route edits it — docs/medium
      Depends on: 1
      Scope: skills/batuta-init/SKILL.md, skills/batuta-route/SKILL.md
      Accept: the gate passes → bash tests/skills/check.sh; batuta-init step 4 proposes research rows per lane from installed executors → grep -q 'research' skills/batuta-init/SKILL.md; batuta-route step 2 adds, removes or reseats a research row by lane → grep -q 'research' skills/batuta-route/SKILL.md; both SKILL.md bodies stay within their budgets → bash tests/skills/check.sh
- [x] 3. Adapter notes follow the research ladder — docs/low
      Depends on: 1
      Scope: skills/batuta/adapters/agy.md, skills/batuta/adapters/opencode.md, skills/batuta/adapters/codex.md, skills/batuta/adapters/claude.md, skills/batuta/adapters/cursor-agent.md, skills/batuta/adapters/_template.md
      Accept: the gate passes → bash tests/skills/check.sh; codex.md seats the verifier on the research row of the task's lane instead of "the research row" → grep -q "task's lane" skills/batuta/adapters/codex.md; agy.md maps Flash -low to research low and Flash -high to research medium → grep -q 'research medium' skills/batuta/adapters/agy.md; no adapter references the flat research row wording → ! grep -q 'the research row, not' skills/batuta/adapters/codex.md
- [x] 4. Reseat this repository's own research rows — docs/low
      Result: already satisfied on the base 277b6327a828, no commit
      Depends on: 1
      Scope: .batuta/routing.md
      Accept: the Role table has the Lane column with research low and medium rows → grep -q '^| research | medium |' .batuta/routing.md; the stamp line still references the profile → grep -q 'profile.md@sha256' .batuta/routing.md

## Decisions and context

Research is read-only discovery: project map sweeps, "where does X live", cross-module tracing, evidence-ranked hypotheses, and the loop's independent verifier. Today `routing.md` declares it "orthogonal to the ladder", one row, and the only fallback after two failed scouts is the conducting host. That skips from cents straight to the most expensive context. The core loop (`loop/attempt.go`) also seats the verifier on the implementation `low` row, so a `high` task is verified by the cheapest coding model; a companion core plan (`core/.batuta/plans/research-ladder.md`) teaches the parser and the verifier to read research rows by lane. Doctrine lands first so the core implements against a fixed table format.

Table format, fixed here and read by core: the Role table becomes `| Role | Lane | Executor | Model | Cost |`. `review` keeps a single row (its `Lane` cell is `—`). `research` has one row per lane it seats, `low` mandatory when research exists, `medium` recommended, `high` optional. A Role table without a `Lane` column stays valid and means research `low`. Every research row names a CLI executor (never `self`) and an exact model, like review.

Classification of a research brief: `low` locates (one symbol, one file, a directory map); `medium` synthesizes (how a flow crosses modules, several questions in one brief, an independent verification of a diff against criteria); `high` judges (ranked hypotheses for an ambiguous failure, a read-only architecture assessment). In doubt, `low`: a wrong `low` costs one cheap retry, a wrong `medium` costs only price.

Escalation: a ghost anchor or a guard violation is one retry on the same row with the specific feedback; a second failure moves one row up; the top research row failing falls back to researching it yourself. The scout guard, report contract and read-only contract in `scout.md` do not change.

**Task 1.** Keep `routing.md` within the spirit of its current length: replace the "Support lane: research" section with a "Research ladder" section holding the classification table, the Role table format and the escalation rule, and add the `Lane` column to the default Role table. In `scout.md`, add the lane choice to the research brief section and rewrite the fallback sentence in Verification. Do not touch `skills/batuta/SKILL.md`; its Step 2 pointer to the scout stays valid.

**Task 2.** `batuta-init` step 4 proposes research rows from installed executors with the same cheap-candidate filter it already uses: the `low` research row from the cheapest read-capable model, `medium` from the mid-tier one; loop-first and one-vendor setups still get at least research `low`. `batuta-route` step 2 gains "reseat a research row by lane". Both files are under line budgets enforced by the gate; prefer replacing sentences over adding them.

**Task 3.** Adapter notes only describe which of that CLI's models fit which research lane and how the `readonly` line serves the verifier; the `readonly` lines themselves do not change. `_template.md` line 50 describes the verifier seat generically as "the research row of the task's lane".

**Task 4.** This repository's own table: research `low` stays `agy gemini-3.8-flash-low`; research `medium` is `codex gpt-5.6-sol` (already the medium implementation row, ChatGPT subscription, read-only through `codex exec --sandbox read-only`). No `high` research row. Refresh the confirmation sentence's date.
