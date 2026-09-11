# Native dispatch acceptance scenarios

This compact matrix is reused by the cross-repository pilot. It defines
decisions, not a separate QA framework; lint alone does not prove native runtime
compatibility or token savings.

| Scenario | Setup | Expected decision | Receipt and verification |
|---|---|---|---|
| Native available | `Dispatch: auto`; current host exposes a compatible executor, exact routed model/effort and required controls. | Use native transport for the frozen route in an isolated child context. | Worker claim names outcome, changed paths, proof references and uncertainty; conductor reruns every gate. |
| Native eligible, CLI missing | `Dispatch: auto`; native is eligible but the routed executor's CLI is absent. | Check and invoke the native facility; missing CLI does not block native. | Receipt identifies task, attempt, native transport, requested and observed model/effort, worker claims, evidence references and uncertainty. |
| Native unavailable | `Dispatch: auto`; current host lacks the native facility or a required control. | Use the frozen route's legacy CLI adapter and report the failed eligibility condition. | Verify the CLI result normally; availability is observed from host tools, not installed CLIs. |
| Model mismatch | Native facility cannot confirm the route's exact model or effort, including an explicit user override. | Mark native ineligible and use that route's CLI adapter; do not substitute or reroute. | Receipt records routed and observed values; mismatch is not success. |
| Inherited context | Native facility defaults to inheriting the full conversation but accepts a bounded child context. | Send only the self-sufficient brief; no full conversation fork by default. | Confirm the brief retains all eight sections, conventions, criteria, permissions and stop conditions. |
| Cancellation | Native worker is cancelled before delivery. | Record cancellation as a non-success outcome and retain any owned artifacts; do not hide it or claim completion. | Run gates only for usable results and identify all unverified criteria. |
| Partial results | Worker returns some changes or evidence but not the complete task. | Record a partial non-success outcome without promoting the worker claim to a verdict. | Receipt identifies completed claims, missing work and uncertainty; conductor verifies only reproducible proof. |
| Uncertain after submission | Native submission was accepted, but its final state or result cannot be confirmed. | Record an uncertain non-success outcome; do not replay automatically through CLI. | Receipt records the task and attempt, requested values, observed values or `unknown`, evidence references and uncertainty. |
| Skills-only fallback | Headless core or a skills-only host cannot expose the parent's native tool, whether or not a CLI is installed. | Preserve legacy CLI behavior; add no native adapter, daemon or installation requirement. | Verify through existing state, worktree, scope, diff, test and criterion gates. |

Receipts target at most 4 KiB. Explicit overflow points to an owned full-log
artifact and explains why selective reading is needed. Actual smoke tests and
matched token measurements belong to the cross-repository pilot.
