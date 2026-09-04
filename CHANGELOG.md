# Changelog

## 0.3.0 (unreleased)

First release as `batuta-ai/skills`, extracted from `franciscpd/batuta` with its history.

### Breaking

- Skills renamed with the `batuta-` prefix (`/batuta:init` → `/batuta-init`, and so on) so they install on any agentskills.io host.
- Complexity taxonomy is now `low | medium | high | critical`, optionally split by domain, matching the CompozyOS extension. `/batuta-init` migrates an existing `.batuta/routing.md`.
- The `claude` adapter is a background `claude -p`; the conducting host is the new `self` adapter.
- Integrations with the superpowers plugin, the Codex companion plugin and CompozyOS are removed from the skills. Their method is inlined under `skills/batuta/references/method/`; CompozyOS is served by `batuta-ai/compozy`.

### Added

- `batuta-loop`: unattended execution of an approved plan through the `batuta` binary (`batuta-ai/core`).
- Adapters for `cursor-agent` and `agy` (Antigravity CLI); machine-readable YAML frontmatter on every adapter.
- Four mechanical verification gates, scoped-write contract for scouts and reviewers, findings-file cross-review, staleness stamps, learnings ledger.
- `tests/skills/check.sh`: lint and token budget, run in CI.
