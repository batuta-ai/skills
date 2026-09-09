# Plan — Distilled real-user QA skills (batuta-qa-plan, batuta-qa-run)
<!-- inputs: profile.md@sha256:411240c70639 routing.md@sha256:0788f392741d -->

**Goal:** Give Batuta a real-user QA phase of its own: two new skills distilled
from `qa-execution`/`qa-report` in pedronauck/skills — `batuta-qa-plan` owns the
living QA tree and plans persona sessions, `batuta-qa-run` walks them and writes
results back. Rewritten for Batuta's register and constraints, never copied. The
dead reference in `docs/qa-retro.md` is corrected in the same delivery.
**Created:** 2026-09-09 · **Status:** approved

## Tasks
- [ ] 1. QA tree contract reference — docs/medium
      Scope: skills/batuta-qa-plan/references/tree.md, tests/skills/check.sh
      Accept: the gate passes → bash tests/skills/check.sh; the tree defaults to `.batuta/qa/` and nothing defaults to `docs/qa` → grep -q '\.batuta/qa' skills/batuta-qa-plan/references/tree.md; a reference over 100 lines opens with a Contents section → test $(wc -l < skills/batuta-qa-plan/references/tree.md) -le 100 || grep -q '^## Contents' skills/batuta-qa-plan/references/tree.md; the file defines the directory layout, what is durable versus per-run, the exclude policy, the bootstrap procedure, the scenario frontmatter schema with its status enum, and content-addressed id minting; every rule is written in Batuta's own words with no paragraph carried over verbatim from the source

- [ ] 2. Planner skill — docs/high
      Depends on: 1
      Scope: skills/batuta-qa-plan/SKILL.md, skills/batuta-qa-plan/references/planning.md, skills/batuta-qa-plan/agents/openai.yaml, tests/skills/check.sh
      Accept: the gate passes → bash tests/skills/check.sh; the body stays inside the 60-line budget → test $(wc -l < skills/batuta-qa-plan/SKILL.md) -le 60; the skill routes its steps to the references that own them → grep -q 'references/tree.md' skills/batuta-qa-plan/SKILL.md; the host interface file exists → test -f skills/batuta-qa-plan/agents/openai.yaml; `planning.md` carries personas, journeys mapped as flows before any scenario, the five coverage dimensions, session charters and a short automation-backlog section, each with its file format inline; the SKILL.md steps are pointers to those contracts, never the contracts themselves

- [ ] 3. Bug registry reference — docs/medium
      Depends on: 1
      Scope: skills/batuta-qa-plan/references/bugs.md, tests/skills/check.sh
      Accept: the gate passes → bash tests/skills/check.sh; a reference over 100 lines opens with a Contents section → test $(wc -l < skills/batuta-qa-plan/references/bugs.md) -le 100 || grep -q '^## Contents' skills/batuta-qa-plan/references/bugs.md; the file is the single severity model both skills cite, and defines id minting, dedup before filing, the bug statuses including re-found and regressed, the five user-impact tiers and the required fields

- [ ] 4. Runner skill and cross-skill references in the gate — docs/high
      Depends on: 1, 3
      Scope: skills/batuta-qa-run/SKILL.md, skills/batuta-qa-run/references/session.md, skills/batuta-qa-run/agents/openai.yaml, tests/skills/check.sh
      Accept: the gate passes → bash tests/skills/check.sh; the body stays inside the 60-line budget → test $(wc -l < skills/batuta-qa-run/SKILL.md) -le 60; the runner cites the planner's shared severity model → grep -q 'batuta-qa-plan/references/bugs.md' skills/batuta-qa-run/SKILL.md; the host interface file exists → test -f skills/batuta-qa-run/agents/openai.yaml; the gate's reference resolver accepts a citation of the form `../<skill>/references/<file>.md` and still reports a reference that genuinely does not exist; `session.md` carries the public-interface rule, stall-is-a-finding, the enter-act-verify-capture loop, the evidence standard, and the CLI or HTTP path as a first-class journey surface with the browser named as one instrument among several and never as a requirement

- [ ] 5. Probe catalogs — docs/medium
      Depends on: 4
      Scope: skills/batuta-qa-run/references/probes.md, tests/skills/check.sh
      Accept: the gate passes → bash tests/skills/check.sh; a reference over 100 lines opens with a Contents section → test $(wc -l < skills/batuta-qa-run/references/probes.md) -le 100 || grep -q '^## Contents' skills/batuta-qa-run/references/probes.md; the file merges the tour catalog, the six experiential lenses and the non-technical user edge cases into one reference, each entry reduced to what a runner needs to pick it and apply it; every entry is reachable from a headless host

- [ ] 6. Close and fix governor — docs/medium
      Depends on: 3, 4
      Scope: skills/batuta-qa-run/references/close.md, tests/skills/check.sh
      Accept: the gate passes → bash tests/skills/check.sh; a reference over 100 lines opens with a Contents section → test $(wc -l < skills/batuta-qa-run/references/close.md) -le 100 || grep -q '^## Contents' skills/batuta-qa-run/references/close.md; the file defines the session status enum, the dated report written before the first session, the write-back into the tree, the governor that judges a fix before any edit, the regression proof each auto-fix ships, the escalation path for everything outside the bounds, and the round-close checklist

- [ ] 7. Docs wiring — docs/low
      Depends on: 2, 4
      Scope: docs/qa-retro.md, README.md, README.pt-BR.md, tests/skills/check.sh
      Accept: the gate passes → bash tests/skills/check.sh; the dead spec path is gone → test $(grep -c 'docs/superpowers' docs/qa-retro.md) -eq 0; both new skills are listed in both READMEs → grep -q 'batuta-qa-run' README.md && grep -q 'batuta-qa-run' README.pt-BR.md; `docs/qa-retro.md` keeps its own subject, the retro protocol for testing Batuta itself, and points at the two new skills as the method they implement without absorbing their content

## Decisions and context

The two skills are **distilled, not vendored**. The maintainer decided on
2026-09-09 that Batuta owns this method in its own register: new names, new
prose, Batuta's constraints. The earlier design that called for copying the two
source skills verbatim with provenance hashes and a later hard cut to a
first-party bundle is superseded; its issue will be updated after this delivery.
The source repository publishes no licence, which is the second reason nothing
is copied: only the method is reused, never the text.

Attribution is mandatory and goes in two places per skill: a `metadata` block in
the frontmatter naming Pedro Nauck and `https://github.com/pedronauck/skills`,
and one prose line in the body saying the method is distilled from that work.

**Read the sources, do not copy them.** They live outside this repository, at
`/Volumes/Home/francisross/Projects/compozy/compozy/.agents/skills/qa-report/`
and `/Volumes/Home/francisross/Projects/compozy/compozy/.agents/skills/qa-execution/`.
Your sandbox allows reading an absolute path outside the workspace; this was
verified before the plan was approved. Read the files your task names, in full,
then write Batuta's version from understanding. Never write outside the
workspace, and never add a source file to this repository.

The living QA tree defaults to `.batuta/qa/` and is committed: it is durable
project memory, not one of the excluded `.batuta/` subtrees. Both skills accept
a path argument to move it. A path outside the repository is refused, never
silently replaced by a temp directory.

Every skill runs on every supported host, headless. The source assumes a browser
driver for the whole execution phase; the distilled runner does not. A CLI or
HTTP journey verified through an independent public read path is a first-class
session, the browser is one instrument among several, and a leg that genuinely
needs a human or a browser the host lacks is recorded as blocked with the exact
prerequisite. No scripts of any kind: this repository is pure markdown in the
agentskills.io format, so the two Python state helpers in the source are dropped
and their behaviour is described as procedure.

`tests/skills/check.sh` is the gate for every task. It gives each new skill a
60-line body budget, requires `name` to equal the directory, caps the
description at 300 characters, requires a `## Contents` section on references
over 100 lines, resolves every relative reference a skill cites, and rejects a
set of forbidden strings anywhere under `skills/` — among them the name of the
source's parent framework and the name of the CompozyOS extension repository.
Neither string may appear in the new files; cite `pedronauck/skills` instead.
Except in task 4, the file is in Scope only so the proof may run it: no other
task changes it.

**Task 1.** This reference is the contract both skills read; it is written first
so the later tasks cite it instead of restating it. Sources:
`qa-report/references/qa-docs-layout.md` and `qa-report/references/state-schema.md`.
Keep the merge-safety property intact — content-addressed ids, one file per
scenario, one dated file per run, no shared counter — because parallel Batuta
worktrees will run QA at the same time.

**Task 2.** Sources: `qa-report/SKILL.md` and its `personas.md`,
`journeys-and-flows.md`, `taxonomy.md`, `session-charters.md` and
`automation-backlog.md`. Two rules survive compression above all others: living
docs rather than round artifacts, and sessions rather than test cases — the
planning unit is the charter, coverage is a session ledger and never a per-case
count. Fold the automation backlog into one short section rather than a file of
its own. The formats the source keeps as `assets/` templates are inlined into
the reference instead: this repository ships no asset templates.

**Tasks 2, 4.** The 60-line budget is the hard part. Each numbered step names its
reference and the deliverable that ends it, in one or two sentences, and nothing
more. Read the reference a step points at before writing the step, so the
pointer is accurate. Copy the shape of an existing skill: frontmatter with
`name`, `description` under 300 characters, `disable-model-invocation: true` and
`argument-hint`, then a title, the anchoring rules, the numbered procedure, a
companion-skills section and an error-handling section. Model
`agents/openai.yaml` on `skills/batuta-review/agents/openai.yaml`.

**Task 3.** Source: `qa-report/references/bug-registry.md`. It stays under the
planner's directory because the planner owns the tree's schemas, and the runner
cites it as `../batuta-qa-plan/references/bugs.md`.

**Task 4.** Sources: `qa-execution/SKILL.md`, `references/persona-fidelity.md`
and `references/session-protocol.md`. The three non-negotiables are the spine: in
persona through public surfaces only, proof rather than optimism confirmed
through an independent read path, and write back or it did not happen. These are
the same rules `docs/qa-retro.md` already applies to Batuta itself, so keep the
wording consistent with that file. This task also fixes the gate: its reference
resolver currently tries a citation only against the citing file's directory and
the skill root, so `../batuta-qa-plan/references/bugs.md` cannot resolve and the
gate fails. Teach it the cross-skill form as a third candidate path, resolved
under `skills/`, and keep a citation that points at nothing reported as before.

**Tasks 5, 6.** These two references complete the runner. Either order once task
4 has fixed the runner's step numbering; each must match the step that cites it.

**Task 7.** `docs/qa-retro.md` points at a distillation spec under a
`docs/superpowers/specs/` path that exists in no repository — remove the dead
pointer and keep the credit line to pedronauck/skills. The retro protocol keeps
its own subject: it is how a persona tests Batuta itself, and it now names the
two skills as the reusable method. Add one row per skill to the skill table in
both READMEs, matching the existing row style in each language.
