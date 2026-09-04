# Changelog

## [0.3.0](https://github.com/batuta-ai/skills/compare/batuta-skills-v0.2.14...batuta-skills-v0.3.0) (2026-09-04)


### ⚠ BREAKING CHANGES

* host-agnostic skills with inlined method, unified taxonomy and machine-readable adapters
* comandos renomeados — plan, status, route e review sem prefixo

### Features

* /batuta:review roda a checagem de escopo quando há brief associado ([ea5e66a](https://github.com/batuta-ai/skills/commit/ea5e66a529ff760f5045cd97e22769d0a7556255))
* agy adapter replaces the discontinued Gemini CLI ([93129a5](https://github.com/batuta-ai/skills/commit/93129a5e30bc0b3edfe1e96e1c1359dc06ac52a7))
* brief endurecido — evidência esperada, stop conditions e anti-workaround (Onda 2 da destilação) ([5e500cf](https://github.com/batuta-ai/skills/commit/5e500cf12cd0b9b200923f37337a34849a4bda8b))
* ciclo aponta para codex-plugin.md nos Steps 2–4 ([c020e82](https://github.com/batuta-ai/skills/commit/c020e82750d58a60b91783ba40758060e14e7ad2))
* ciclo aponta para superpowers.md nos Steps 1–4 ([6a55ce3](https://github.com/batuta-ai/skills/commit/6a55ce37cdaf93b785d9f8b5bf976b9a4f8b3a32))
* ciclo ganha o caminho worktree por tarefa (Steps 1.5, 3–5) ([f8b15b1](https://github.com/batuta-ai/skills/commit/f8b15b1a067e27ace232eb2f5be0803dba3a217b))
* contrato de cross-review — lentes, findings como artefato e julgamento do maestro (Onda 3 da destilação) ([3cd8b5c](https://github.com/batuta-ai/skills/commit/3cd8b5c3998a3fa01e032a42910256f0bcd2d1ac))
* descoberta de provedor/modelo do opencode via CLI no onboarding ([2ffa22f](https://github.com/batuta-ai/skills/commit/2ffa22ff9e9dd9af544239f5bdffb3c82831c5c2))
* diário de regência no WORK.md e leitura de roteamento no status ([f435f2b](https://github.com/batuta-ai/skills/commit/f435f2bef0ee20caee06ac8cbc79938d9e3b2e60))
* escopo declarado no brief — campo Scope no Step 2 e checagem mecânica no Step 4 ([adb1750](https://github.com/batuta-ai/skills/commit/adb1750a1d335496bd206c9a6a13a44a7b33f1fe))
* estrutura inicial do plugin (skills, adapters, templates, routing) ([8183642](https://github.com/batuta-ai/skills/commit/8183642abfc7bbc4a58fb7206ad96806dc912af8))
* fronteira de escrita explícita e detecção de conflito com CLAUDE.md/AGENTS.md ([9112d81](https://github.com/batuta-ai/skills/commit/9112d813cbb905a875c6fa3b07214671f7497249))
* host-agnostic skills with inlined method, unified taxonomy and machine-readable adapters ([c668835](https://github.com/batuta-ai/skills/commit/c66883537c7b4e60f86505078a8c1f3b1cce5e1f))
* init asks batch execution mode (sequential default) ([6525275](https://github.com/batuta-ai/skills/commit/6525275817380557771da95a04ca1a7833d4db71))
* init oferece pointer de descoberta do Batuta no AGENTS.md ([f8bba42](https://github.com/batuta-ai/skills/commit/f8bba42246212e10d8672aab76b85f681f28586c))
* init pergunta modo worktree e comando de instalação ([b2a7862](https://github.com/batuta-ai/skills/commit/b2a7862fe8a44b67e872a35148a1ac5c012044c4))
* integração Compozy runtime — compozy.md dormante e delegação como sessão gerenciada ([95ba6fc](https://github.com/batuta-ai/skills/commit/95ba6fc62a8a85a42924534b36a1939dad223368))
* invocação read-only de pesquisa nos adapters (sandbox, tools bloqueadas, guarda de git) ([d9fa4c9](https://github.com/batuta-ai/skills/commit/d9fa4c9ea7d16d72ddc5e4096d78eee8527281bd))
* lane complexa delegável ao codex e mapeamento de lanes escolhido pelo usuário ([6074f4d](https://github.com/batuta-ai/skills/commit/6074f4da9f701a13086b7705dd0830240986a625))
* lane de apoio Research na tabela de roteamento — o batedor ([ceb6200](https://github.com/batuta-ai/skills/commit/ceb62007ec80914b4cee2a7561e230ad6b75932e))
* mapa do projeto no perfil, takeover de outros frameworks e identidade visual ([3afc424](https://github.com/batuta-ai/skills/commit/3afc424d05dc6a5852136c15c11a175a536f6a8f))
* modelos explícitos no roteamento e checagem de executores no onboarding ([57f5ab5](https://github.com/batuta-ai/skills/commit/57f5ab5a7c15dccaa2f4849d4de9b38b93926359))
* nota do catálogo e blocos Never nos templates existentes ([0e03259](https://github.com/batuta-ai/skills/commit/0e032596c2760d41b444a1f482c63cc157b47108))
* plan e review apontam para superpowers.md ([97d837d](https://github.com/batuta-ai/skills/commit/97d837dd2b9d9c861ff33f02a30a99d803a21bab))
* protocolo do batedor no ciclo — brief de pesquisa, contrato de relatório e verificação estrutural ([10a88c9](https://github.com/batuta-ai/skills/commit/10a88c9de62e22cfc675b27f1bd1294d1a4c9fa5))
* review e adapter codex apontam para codex-plugin.md ([ffa6126](https://github.com/batuta-ai/skills/commit/ffa612622e73a6005e58e5085b13642de6df84dc))
* runtime compozy no init, status e pause — oferta, listagem e handoff de sessões ([fa0ef76](https://github.com/batuta-ai/skills/commit/fa0ef7664ddcbb5373f674d2763550f914cd3cd5))
* skill init — onboarding movido e modo reconfiguração ([3bbf8c4](https://github.com/batuta-ai/skills/commit/3bbf8c4e528614d8f15b70fcb57d55c3c8f1dd52))
* skills pause e resume — handoff de sessão consumível ([ca5f1fc](https://github.com/batuta-ai/skills/commit/ca5f1fc3890c507ad59120d6c1927d76e154faf7))
* Step 1.5 Decompose — full cycle and atomic commit per item ([b166bb6](https://github.com/batuta-ai/skills/commit/b166bb6b5743c505b50eb2539603d4471025ebd7))
* task board Compozy — itens do WORK.md como tasks, delegação como task run ([0a3320c](https://github.com/batuta-ai/skills/commit/0a3320cd658606cc74ddbbe2bee7dae84dc03801))
* template NestJS e catálogo completo no init ([9ed2fc8](https://github.com/batuta-ai/skills/commit/9ed2fc8c0a73bc523a41aa035dc440aa1521ffe0))
* templates Next.js e React Native ([9003afb](https://github.com/batuta-ai/skills/commit/9003afb950b69e15dab18adc09f56c3f7dae9746))
* templates Python e Laravel ([5bce503](https://github.com/batuta-ai/skills/commit/5bce5039323e208283010694646b963d74f260f1))
* trilha de execução — .batuta/runs/ por tarefa com runs.md dormante ([29ab71d](https://github.com/batuta-ai/skills/commit/29ab71dd11908cd7879a7cc9931e4206121a9e48))
* variante Claude na lane complexa — opus em background como alternativa ao codex ([b339b01](https://github.com/batuta-ai/skills/commit/b339b01f27c0eac2c91813e08b3f0f5a0ef485eb))
* verificação endurecida — relato não é evidência (Onda 1 da destilação) ([10e0cbc](https://github.com/batuta-ai/skills/commit/10e0cbc96fd778c158f5ed5e27a68d58de3b3091))


### Bug Fixes

* achados do review final da integração do plugin codex (guarda de escrita, wording) ([73350cd](https://github.com/batuta-ai/skills/commit/73350cd13e08198e713e1ac945a540c4068ad1a3))
* achados do review final do worktree por tarefa (wording, contagens, fallback e guardas) ([230ef9c](https://github.com/batuta-ai/skills/commit/230ef9cf995d9f4cef6f6b1e2d3c486c5cbd4141))
* achados do review final dos templates por stack (cadeia Extends, guardas restauradas) ([eafd218](https://github.com/batuta-ai/skills/commit/eafd2182789e89dc5b6c07fb9579e8d34d16b7dd))
* **agy:** slugs carry the reasoning level, disable slash expansion, note glog noise ([00df038](https://github.com/batuta-ai/skills/commit/00df03859539444e31b4059cd8ad478359e3e84a))
* alinha docs e skills ao default sequencial da decomposição ([8a42dde](https://github.com/batuta-ai/skills/commit/8a42ddecbdfd564fd70a68702c35e23ae4b6425d))
* compozy.md — worktree explícito no spawn, carve-out da lane crítica e ciclo de vida das sessões ([9deff2e](https://github.com/batuta-ai/skills/commit/9deff2efce96e359d93376f7f028abb0d4b21d93))
* gate no Step 0 — meta-perguntas sobre integrações leem o arquivo de integração antes de responder ([c38f2a6](https://github.com/batuta-ai/skills/commit/c38f2a6823e6bd35d9d3409233704c592274ade0))
* init — idempotência explícita do pointer e reconciliação do reconfigure ([8a38ad2](https://github.com/batuta-ai/skills/commit/8a38ad228b1a520160f511dede5966488f2d6e8d))
* prosa dos ponteiros do ciclo (Step 4 antes da lista, quebras de linha) ([e3a983e](https://github.com/batuta-ai/skills/commit/e3a983e00e171eb52d0f3835e593d9de54c29e08))
* sweep do mapa adiado pós-mapeamento e guarda do batedor sob paralelismo ([143dcd9](https://github.com/batuta-ai/skills/commit/143dcd98fdc43bb8a9873187d32f0f1dd76f94c1))
* trilha de item abortado no Step 4, checagem de escopo path-completa e ajustes de review ([4865c2d](https://github.com/batuta-ai/skills/commit/4865c2d565f1b39b15f528a5a7b1d46cec16f12f))


### Code Refactoring

* comandos renomeados — plan, status, route e review sem prefixo ([37cbfba](https://github.com/batuta-ai/skills/commit/37cbfba43cfa1bfaff65e64d52a006f55ae6eb0b))

## Changelog

Releases below this section are generated by release-please from commit messages.

## Migrating from franciscpd/batuta 0.2.x

The first release here (0.3.0) is extracted from `franciscpd/batuta` with its history.

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
