# Dispatch — native, then external

## Selection

1. Freeze executor, model/effort, isolation and permissions; never reroute or
   substitute. User overrides win.
2. Absent `Dispatch:`/`Dispatch: cli` uses checked same-route CLI. Only
   `Dispatch: auto` opts into native eligibility; core is not opt-in.
3. Prefer a compatible isolated native child matching that route. Otherwise
   apply external `cli`, `acp` or `auto` policy.
4. ACP needs `batuta capabilities`: `dispatch` listed and version ≥
   `v1.1.0-beta.24`. Missing/old core keeps default/auto on adapter CLI before
   submission; explicit ACP is unavailable. Do not install.
5. Invoke one qualified attempt:
   `batuta dispatch --brief-file <abs> --executor <id> --model <id>
   [--effort <v>] --cwd <abs> --transport <mode> --timeout 45m`.
   Omit empty effort. Core, not metadata, enforces the qualification tuple.

Native isolation retains criteria, conventions, scope, boundaries, proofs,
permissions and stops; a CLI proves no native capability.

## Receipt

Classes/codes: completed/0, failed/1, unavailable/2, invalid_arguments/2,
waiting_input/3, rate_limited/4, uncertain/5; interrupt/timeout use 130/124.
Worker output is an unverified claim: read JSON
and evidence; independently gate scope, diff, tests and criteria. Never use
the worker session as verifier. Permission callbacks default deny.

After possible submission, any incomplete/uncertain outcome preserves artifacts
and worktree for reconciliation: never replay, switch transport, reuse the session
or inject protocol. `auto` fallback is only before submission and verified shutdown.
