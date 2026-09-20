# Routing — skills

<!-- inputs: profile.md@sha256:3f3de48a1e13 -->

Confirmed with the user by /batuta-init on 2026-09-09; research ladder reseated on 2026-09-19; codex removed from every row on 2026-09-20 because the ChatGPT usage limit is too low. Installed and probed: agy, claude, cursor-agent, opencode. cursor-agent runs Grok only (no Claude models there, by the user's choice). Model IDs come from `batuta inventory` and each adapter's `models` line on this machine.

| Lane | Domain | Executor | Model | Cost |
|---|---|---|---|---|
| low | * | agy | gemini-3.8-flash-low | free quota |
| medium | * | opencode | opencode/glm-5.3-flash | opencode credits, cents |
| high | * | cursor-agent | cursor-grok-4.6-high | Cursor subscription, Grok 4.6 high |
| critical | * | claude | opus | Claude subscription, background session |

| Role | Lane | Executor | Model | Cost |
|---|---|---|---|---|
| research | low | agy | gemini-3.8-flash-low | free quota |
| research | medium | opencode | opencode/glm-5.3-flash | opencode credits, cents |
| research | high | cursor-agent | cursor-grok-4.6-high | Cursor subscription, native read-only `--mode ask` |

No domain rows: the whole repository is prose, so a `docs` row would only repeat `*`.

Loop-first trade, accepted by the user on 2026-09-09: `critical` never opens a conversation. A decision the task cannot take alone parks it with `BATUTA-QUESTION` and waits for `batuta loop --answer`, so a plan's Decisions must carry what a conducting session would have said.
