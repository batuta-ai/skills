# Distilled skills evaluation

## Scope and method

Task 1 evaluates `batuta-refine`. The companion writing skill is outside this task. The upstream sources are Matt Pocock's grilling (grill-me alias), commit `959a8e9f1edc3adbe2f7e3054bb6fbefa6696260`, and Siqi Chen's [humanizer](https://github.com/blader/humanizer), commit `9862685f575c65a8247f90369951df1b3416e3d6`, metadata version `3.0.0`. Local snapshots and MIT notices were supplied by the conductor. The refinement attribution is in [THIRD_PARTY_NOTICES.md](../THIRD_PARTY_NOTICES.md).

The initial successful baseline responses below were supplied in the brief; they were not rerun or independently observed by this executor. They demonstrate that the baseline already handled the two core scenarios. No baseline failure, token savings or superiority is inferred.

Additional read-only baseline and skill-guided evaluations use the same three independent requests. They permit repository fact lookup and prohibit file edits, implementation, network access and delegation. The evaluating agents receive the requests and raw repository paths, without the scoring criteria or the other agent's answers. These are bounded behavioral probes, not a release or runtime test.

## Supplied successful baselines

### Scenario A: release planning

Context: PR-only workflow, passed CI, unverified Windows runtime cleanup and unmeasured savings.

> One decision: must tomorrow’s release support Windows, or can Windows support wait until runtime cleanup is verified? Before shipping, verify supervisor failure and cleanup behavior on supported platforms. PR #86’s passing CI and Windows cross-compilation do not establish Windows runtime correctness. Keep implementation on a PR; merge only through the PR workflow. Make no token-savings claim without measurements.

Result supplied by the conductor: successful baseline.

### Scenario B: promotional prose editing

Context: the same evidence limitations, with an exact command and link to preserve.

> Tests passed locally, but PR #86 is a draft and Windows cleanup remains unverified. Run `batuta loop --supervise delivery --once`. See [review](https://example.invalid/review). Token savings have not been measured.

Result supplied by the conductor: successful baseline. This task does not evaluate the companion writing skill.

## Refinement probes and acceptance checks

Defined before the skill-guided run:

1. **R1, vague rollout.** Request: “Refine our plan to roll out supervised delivery tomorrow. PR #86 is a draft with passed CI and Windows cross-compilation. Windows runtime supervisor failure and cleanup remain unverified; token savings have not been measured. Our workflow requires a PR to main. Find the repository skills verification command yourself. I have not decided whether tomorrow must support Windows. Keep this to planning.” Check that the agent discovers the gate, asks the material platform decision with a recommendation and reason, preserves evidence limits and PR workflow, and does not implement.
2. **R2, already authorized.** Request: “The decision is already made: fix only the typo `teh` to `the` in docs/intro.md, run the existing repository skills gate, and commit on this branch. This is authorized; do not open a PR, push, or expand the change. Is any refinement needed before the executor does it?” Evaluation boundary: no implementation; respond with the next-step handoff. Check that the agent skips interviewing, carries authorization and exact scope forward, and does not claim execution. The path is a scenario fixture, not an assertion that the file exists in this checkout.
3. **R3, dependent decision.** Request: “Refine the delivery plan. We have not chosen customer-hosted or managed service. If customer-hosted, offline operation may be required and changes packaging. If managed, region/residency is unresolved and changes hosting. Recommend the first decision; keep later choices open. Existing plan uses Batuta’s Decisions and context section. This is refinement only.” Check that the agent asks the parent decision first with a reasoned recommendation, leaves conditional children open, and reuses the named handoff section without inventing an extra state schema or approval.

Each probe ends at its useful handoff or first unresolved material decision. Multi-round user interaction and actual implementation are outside these probes.

## Independent baseline run

The baseline agent read `tests/skills/check.sh` and `skills/batuta-plan/SKILL.md` with two successful `cat` commands. It did not load the refinement skill, run the gate or mutate files. Exact responses follow.

### R1 baseline

The first decision is whether tomorrow’s rollout must support Windows. I recommend limiting tomorrow’s supported platforms to those with verified supervisor failure and cleanup behavior, unless Windows is a launch requirement.

Current evidence:

- Draft PR #86 has passed CI and Windows cross-compilation, as you reported.
- Windows supervisor failure and cleanup remain unverified; cross-compilation does not establish runtime behavior.
- Token savings remain unmeasured, so the rollout must not claim demonstrated savings.
- The repository skills gate is `bash tests/skills/check.sh`; I located it but have not run it.

**Planning handoff:** Keep the plan proposed. Record the Windows support decision in `## Decisions and context`. If Windows is required, make runtime failure and cleanup evidence a release prerequisite; if it is deferred, explicitly exclude it from tomorrow’s supported scope. Require the skills gate and evidence for supported-platform runtime behavior before release. Delivery must go through a PR targeting `main`; verify whether #86 already targets `main` before proposing another PR. Treat token measurement as a separate task unless savings are a release criterion.

Does tomorrow’s rollout need Windows support?

### R2 baseline

No refinement is needed. The scope, verification, and delivery action are already decided and authorized.

**Executor handoff:** On the current branch, correct only `teh` to `the` in `docs/intro.md`. Inspect the diff to confirm the change stays within that scope, run `bash tests/skills/check.sh`, and commit only the authorized change after the gate passes. Preserve unrelated work. Do not push or open a PR. If the gate fails for an unrelated reason, report the failure without expanding the fix.

This handoff does not perform the edit, gate, or commit.

### R3 baseline

Decide **customer-hosted versus managed service first**. That choice determines which follow-up question matters and prevents premature packaging or hosting decisions.

Recommend managed service if no customer requirement mandates customer-controlled deployment or offline use. This is a provisional recommendation: a firm requirement for either would favor customer-hosted delivery.

Suggested addition to the existing `## Decisions and context` section:

> **Pending first decision:** Choose customer-hosted or managed service. Managed service is provisionally preferred unless customer requirements establish a need for customer-controlled deployment or offline operation.
>
> **If customer-hosted:** Determine whether offline operation is required before selecting packaging.
>
> **If managed:** Resolve region and data residency requirements before selecting hosting.
>
> **Deferred:** Packaging and hosting choices remain open until the selected branch’s requirement is resolved.

**Planning handoff:** Resolve the deployment model, retain only its relevant follow-up decision, then refine affected tasks and acceptance criteria. Keep the plan proposed; implementation is outside this refinement.

Is customer-controlled deployment or offline operation a firm customer requirement?

## Independent skill-guided run

A fresh agent read `skills/batuta-refine/SKILL.md`, `tests/skills/check.sh` and `skills/batuta-plan/SKILL.md` with three successful `cat` commands. It did not read this record, run the gate or mutate files. Exact responses follow.

### R1 skill-guided

One material decision blocks the rollout scope: **must tomorrow’s delivery support Windows?**

I recommend deferring Windows support until supervisor failure and cleanup have runtime evidence. This reduces tomorrow’s verification scope but excludes Windows users. If Windows is required, those runtime checks become release gates; the deadline alone cannot settle that choice.

**Planning handoff**

- Preserve the required PR-to-`main` workflow. PR #86 remains a draft; passing CI does not make it ready for rollout.
- Your reported evidence covers CI and Windows cross-compilation. Windows runtime supervisor failure and cleanup remain unverified.
- I found the repository skills gate: `bash tests/skills/check.sh`. Include it in verification; I have not run it. It checks skill structure and budgets, not runtime correctness or measured savings.
- Token savings remain unmeasured. Plan a baseline comparison before making quantified savings claims.
- Windows rollout scope remains open. Once answered, update the affected acceptance criteria and task dependencies. Independently, retain the PR requirement and document the evidence gaps now.

This is refinement only; implementation and rollout have not been authorized.

### R2 skill-guided

No refinement is needed. The change and authorization are already specific.

**Executor handoff:** On this branch, change only `teh` to `the` in `docs/intro.md`, run `bash tests/skills/check.sh`, inspect the diff to confirm that only the authorized typo changed, and commit that change after the gate passes. Do not open a PR, push, or expand scope. If the gate fails, report the failure without making unrelated fixes.

No additional approval is needed. This evaluation performs no implementation.

### R3 skill-guided

The first decision is **customer-hosted or managed service**. Offline requirements depend on choosing customer-hosted; region and residency depend on choosing managed.

I recommend **managed service as the initial planning direction**, assuming reducing customer installation and upgrade work is the priority. The trade-off is that you take on hosting operations and must resolve region/residency before choosing hosting. Customer-hosted remains the alternative when customer control or offline use is essential.

**Which delivery model should the plan use: managed service, or customer-hosted?** The recommendation is not yet an accepted decision.

**Handoff for the existing “Decisions and context” section**

- Settled: this work is refinement only.
- Assumption: reducing customer operational work is desirable; confirm through the delivery-model choice.
- Open first: delivery model, which controls the subsequent planning branch.
- If customer-hosted: resolve whether offline operation is required before committing to packaging.
- If managed: resolve region/residency before committing to hosting.
- Keep those dependent choices open until the parent decision is answered. Preserve existing task/status structure and apply resulting decisions only to affected tasks.

## Comparison and limits

| Probe | Baseline | Skill-guided | Observed result |
| --- | --- | --- | --- |
| R1 | Located the gate; raised Windows scope; preserved CI/runtime distinction, PR flow and unmeasured savings | Located the gate before responding; asked Windows scope with recommendation and trade-off; kept evidence and authorization limits | Both satisfy the probe. The guided response explicitly describes the gate's limited coverage. |
| R2 | Declared no refinement needed and handed off the authorized change | Declared no refinement needed and carried the existing authorization forward | Both satisfy the probe without another interview or approval. Neither performed or claimed implementation. |
| R3 | Prioritized deployment model and asked about the controlling customer requirement; deferred the conditional branches | Asked deployment model directly, labeled its recommendation and assumption, deferred both branches | Both satisfy the dependency check and reuse “Decisions and context”. The guided response makes its planning assumption explicit. |

These observations support preservation of useful behavior and a usable handoff, not a claim that the skill outperforms the baseline. The guided R1 proposes measurement before quantified claims; measurement is not established here as a mandatory rollout deliverable. Recommendations in both R3 responses remain provisional.

Not verified: actual Windows runtime cleanup, PR status through a live service, rollout safety, savings, repeated-run reliability, multi-round convergence, unavailable-tool behavior, or the companion writing skill. No implementation, push, merge or release was exercised by these probes. PR #86 and native-dispatch PR #47 are separate work; no merge status is asserted. Animated SVGs and articles in either language remain deferred until both skills are complete and are outside this task.

## Local gate evidence

The executor ran `bash tests/skills/check.sh` before writing and after adding the skill. Both runs exited 0. The post-write output was:

```text
batuta-init        54/110  lines  ~ 1612 tokens
batuta-loop        33/60   lines  ~ 1065 tokens
batuta-pause       20/60   lines  ~  362 tokens
batuta-plan        51/60   lines  ~ 1015 tokens
batuta-qa-plan     43/60   lines  ~  917 tokens
batuta-qa-run      42/60   lines  ~ 1032 tokens
batuta-refine      34/60   lines  ~  831 tokens
batuta-resume      15/60   lines  ~  291 tokens
batuta-review      37/60   lines  ~ 1042 tokens
batuta-route       23/60   lines  ~  324 tokens
batuta-status      22/60   lines  ~  503 tokens
batuta             91/120  lines  ~ 1446 tokens
cycle packet   ~ 9498 tokens max (nestjs+agy; budget 9500)
brief overhead ~  927 tokens max (nestjs; budget 1000)
skills check: ok
```

The approximate token counts are the existing gate's byte-based accounting, not measured model usage or savings. The gate and CI configuration were not changed. The entrypoint links target existing `batuta-plan` and `batuta` skills. Metadata uses the repository's three native interface fields and normal implicit invocation defaults.

The metadata generator initially reported `ModuleNotFoundError: No module named 'yaml'` while trying to read the frontmatter. Running it with `--name batuta-refine` avoided that optional parse and returned `[OK] Created agents/openai.yaml`. No dependency was installed. One discovery search included nonexistent `CONTRIBUTING.md` and returned `rg: CONTRIBUTING.md: No such file or directory (os error 2)`; required conventions came from the supplied brief and existing skills. Neither failed command was repeated unchanged.

### Command record

Read-only inspection commands printed the referenced source contents; excerpts and relevant outputs are noted below. Absolute snapshot and guidance paths refer to the supplied local files, not new project files.

| Command | Observed output |
| --- | --- |
| `pwd` | The assigned `distilled-skills-task-1-e1` worktree path. |
| `git status --short` (initial) | Empty: clean worktree. |
| `cat /Volumes/Home/francisross/.codex/skills/.system/skill-creator/SKILL.md` | Skill Creator guidance, including independent forward-testing. |
| `rg --files -g AGENTS.md -g 'SKILL.md' -g 'openai.yaml' -g '*evaluation*' -g '*NOTICES*' -g 'check.sh'` | Existing skill entrypoints and metadata, `AGENTS.md`, and `tests/skills/check.sh`; neither new document existed. |
| `cat tests/skills/check.sh skills/batuta-plan/SKILL.md skills/batuta-plan/agents/openai.yaml` | Gate source and native planning contract/interface fields. |
| `cat /Volumes/Home/francisross/.codex/skills/.system/skill-creator/references/openai_yaml.md` | Interface field guidance. |
| `cat /Volumes/Home/francisross/Projects/batuta/skills/.batuta/research/distilled-skills/grilling-upstream.md /Volumes/Home/francisross/Projects/batuta/skills/.batuta/research/distilled-skills/grilling-ref.txt /Volumes/Home/francisross/Projects/batuta/skills/.batuta/research/distilled-skills/grilling-LICENSE` | Upstream skill, commit `959a8e9f1edc3adbe2f7e3054bb6fbefa6696260`, and Matt Pocock MIT notice. |
| `rg --files skills/batuta-plan docs` | Plan entrypoint/metadata and `docs/qa-retro.md`. |
| `cat AGENTS.md` | Delegated briefs are exempt from conductor routing. |
| `cat skills/batuta/references/method/clarify.md` | Existing clarification workflow and literal executable-requirement preservation. |
| `cat /Volumes/Home/francisross/Projects/batuta/skills/.batuta/research/distilled-skills/humanizer-upstream.md /Volumes/Home/francisross/Projects/batuta/skills/.batuta/research/distilled-skills/humanizer-LICENSE` | Humanizer 3.0.0 and Siqi Chen MIT notice; combined tool output was partially truncated. |
| `rg -n 'github.com.*(mattpocock\|blader)\|PR\|pull request\|Windows' README.md CONTRIBUTING.md /Volumes/Home/francisross/Projects/batuta/skills/.batuta/research/distilled-skills` | Snapshot matches plus the missing-file error reported above; exit 2. |
| `sed -n '180,240p' /Volumes/Home/francisross/Projects/batuta/skills/.batuta/research/distilled-skills/humanizer-upstream.md` | Source sections on hyphens, passive voice and inflated claims. |
| `sed -n '160,180p' /Volumes/Home/francisross/Projects/batuta/skills/.batuta/research/distilled-skills/humanizer-upstream.md` | Source sections on dashes and qualifiers, recovering the truncated portion. |
| `bash tests/skills/check.sh` (twice) | Exit 0 both times; post-write output above. |
| `git diff --check` | No output; untracked additions are not covered by this check. |
| `git status --short` (after writing) | `?? THIRD_PARTY_NOTICES.md`, `?? docs/distilled-skills-evaluation.md`, `?? skills/batuta-refine/`. |
| `cat skills/batuta-refine/agents/openai.yaml` | The three generated interface fields. |

Metadata generation command (first attempt omitted `--name batuta-refine`; failure and successful retry output are recorded above):

```bash
python3 /Volumes/Home/francisross/.codex/skills/.system/skill-creator/scripts/generate_openai_yaml.py skills/batuta-refine --name batuta-refine --interface 'display_name=batuta-refine' --interface 'short_description=Resolve material plan decisions in bounded rounds' --interface 'default_prompt=Use $batuta-refine to resolve the material open decisions in this plan and summarize the handoff.'
```

Staging attempt:

```bash
git add skills/batuta-refine/SKILL.md skills/batuta-refine/agents/openai.yaml THIRD_PARTY_NOTICES.md docs/distilled-skills-evaluation.md
git diff --cached --check
git diff --cached --stat
```

Actual output:

```text
fatal: Unable to create '/Volumes/Home/francisross/Projects/batuta/skills/.git/worktrees/distilled-skills-task-1-e1/index.lock': Operation not permitted
```

The two cached diff commands produced no output because nothing was staged. The sandbox permits source edits but blocks the external worktree index. No commit was attempted; the four deliverables remain uncommitted for the conductor.
