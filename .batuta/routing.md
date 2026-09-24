# Routing — skills

<!-- inputs: profile.md@sha256:3f3de48a1e13 -->

Confirmed with the user by /batuta-init on 2026-09-09; research ladder reseated on 2026-09-19; codex removed from every row on 2026-09-20 because the ChatGPT usage limit is too low. Installed and probed: agy, claude, cursor-agent, opencode. cursor-agent runs Grok only (no Claude models there, by the user's choice). Model IDs come from `batuta inventory` and each adapter's `models` line on this machine. Reseated on 2026-09-24: opencode Zen credits ran out (`Insufficient account funds`) and the cursor-agent executable is missing, so `medium` moved to claude sonnet and `high` to codex gpt-6-sol (the account is ChatGPT Pro); agy stays on `low` by the user's choice.

| Lane | Domain | Executor | Model | Cost |
|---|---|---|---|---|
| low | * | agy | gemini-3.8-flash-low | free quota |
| medium | * | claude | sonnet | Claude subscription, CLI contained by sandbox settings |
| high | * | codex | gpt-6-sol | ChatGPT Pro, `--sandbox workspace-write` |
| critical | * | claude | opus | Claude subscription, background session |

| Role | Lane | Executor | Model | Cost |
|---|---|---|---|---|
| research | low | agy | gemini-3.8-flash-low | free quota |
| research | medium | claude | sonnet | Claude subscription, read-only (`--disallowedTools`) |
| research | high | codex | gpt-6-sol | ChatGPT Pro, native `--sandbox read-only` |

No domain rows: the whole repository is prose, so a `docs` row would only repeat `*`.

Loop-first trade, accepted by the user on 2026-09-09: `critical` never opens a conversation. A decision the task cannot take alone parks it with `BATUTA-QUESTION` and waits for `batuta loop --answer`, so a plan's Decisions must carry what a conducting session would have said.
