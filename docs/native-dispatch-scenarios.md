# Dispatch acceptance scenarios

These are planned decisions, not proof. Native host children and core's external
CLI/ACP sessions are separate. Freeze executor, model, effort, cost, isolation
and permissions first. `Dispatch: auto` only opts an interactive host into
native eligibility; external `--transport cli|acp|auto` is independent and
defaults to CLI. An explicit user ACP request remains explicit without a
profile entry. Never install, substitute a model or widen permissions.

| ID | Setup | Expected decision | Recovery | Evidence boundary |
|---|---|---|---|---|
| `native-mismatch` | Native facility cannot map the executor or accept exact model/effort, isolation and permissions. | Native is ineligible; CLI inventory does not change that. | Apply the independently selected external policy to the frozen route. | Record requested/observed controls; unknown stays unknown. |
| `core-missing` | Core is absent. | Default/auto invokes the adapter CLI directly; explicit ACP is unavailable. | Use CLI or install core only through a separately authorized project path. | No ACP attempt or proof. |
| `core-old-unqualified` | Core is below `v1.1.0-beta.24`, including a release exposing `dispatch` without qualification. | Compare semver, never prerelease text lexically; default/auto uses CLI, explicit ACP is unavailable. | Upgrade only with separate authorization, or use CLI. | Capability alone is not qualification. |
| `adapter-missing` | Selected CLI adapter or binary is absent. | Follow the routing unavailable-executor policy; do not reroute merely to gain native/ACP. | The next row becomes a newly frozen route; never install or silently swap its model. | Pre-submission failure only. |
| `provider-version` | `opencode --version` is not exactly `1.18.31`. | Explicit ACP is unavailable; auto may use CLI before submission. | Reconcile the installed provider or choose CLI prospectively. | Adapter metadata never qualifies a version. |
| `model-effort` | Model is not `opencode/big-pickle` or effort is nonempty. | Reject before ACP launch; never inherit or substitute. | Correct the route explicitly or use its CLI adapter. | Record requested values and no observed values. |
| `quota` | Provider reports quota/rate limit after possible submission. | Preserve artifacts/worktree and classify the attempt; do not replay automatically. | Reconcile first; a later attempt needs normal policy. | Missing usage remains `unknown`, not zero. |
| `callback-denied` | ACP worker requests a new permission. | Callback denies by default; existing provider permissions remain unchanged. | Reconcile any possible work; do not grant or widen permissions silently. | Denial is non-success, even with a worker success claim. |
| `disconnected` | Session disconnects after possible submission. | Park as uncertain; never switch transport or resubmit automatically. | Reconcile brief digest, dispatch identity and workspace. | Retain owned raw logs and bounded receipt. |
| `canceled` | Attempt is canceled after possible submission. | Park as uncertain until shutdown and work ownership are reconciled. | Preserve artifacts/worktree; never assume cancellation means no work. | Cancellation acknowledgement and cleanup are separate facts. |
| `timeout` | Attempt times out after possible submission. | Park as uncertain; later snapshots cannot erase an evidence gap. | Reconcile before any prospective CLI attempt. | Observed model/effort or usage may remain `unknown`. |
| `cli-recovery` | Reconciliation established what the uncertain ACP attempt changed. | Operator may select CLI for a new attempt; `auto` is not recovery. | Start a distinct attempt only when normal delivery policy says it is safe. | Keep prior attempt, costs and uncertainty in evidence. |

Receipts stay at most 4 KiB and name selected transport, requested/observed
model and effort, changed paths, worker claims, proof references, uncertainty
and an owned overflow-log pointer. Claims and progress never become verified
criteria: independently check scope, tree/diff, tests, proofs and the separate
CLI verifier.

## Observed proof

Released core `v1.1.0-beta.24` was checksum-verified with source adapters:
wrong-model explicit ACP returned unavailable without launching the synthetic
provider, while unchanged CLI launched its marker provider. Those checks used
no real provider. Separately, core records real functional qualification only
for OpenCode 1.18.31, `opencode acp`, darwin-arm64,
`opencode/big-pickle`, empty effort, with new callbacks rejected. That proof
does not establish token savings; unmatched or missing counters remain unknown.
