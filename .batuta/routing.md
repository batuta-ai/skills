# Routing — skills

<!-- inputs: profile.md@sha256:3f3de48a1e13 -->

Confirmed with the user by /batuta-init on 2026-09-09. Installed and probed by `batuta inventory`: agy, claude, codex, cursor-agent, opencode — all available. cursor-agent and opencode are installed and left unrouted by choice. Loop-first setup: `critical` names a CLI so every task can run unattended through `batuta loop`.

| Lane | Domain | Executor | Model | Cost |
|---|---|---|---|---|
| low | * | agy | gemini-3.8-flash-low | free quota |
| medium | * | codex | gpt-5.6-sol | ChatGPT subscription |
| high | * | codex | gpt-6-astra | ChatGPT subscription, reasoning high |
| critical | * | claude | opus | Claude subscription, background session |

| Role | Executor | Model | Cost |
|---|---|---|---|
| research | agy | gemini-3.8-flash-low | free quota |

No domain rows: the whole repository is prose, so a `docs` row would only repeat `*`.

Loop-first trade, accepted by the user on 2026-09-09: `critical` never opens a conversation. A decision the task cannot take alone parks it with `BATUTA-QUESTION` and waits for `batuta loop --answer`, so a plan's Decisions must carry what a conducting session would have said.
