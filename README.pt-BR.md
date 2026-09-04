# batuta-ai/skills

> 🇺🇸 [English version](README.md)

> *Quem rege não toca.*

As skills do Batuta: um ciclo de regência para agentes de código. O agente
com quem você conversa vira o **maestro** — classifica a tarefa, roteia
para o executor mais barato que dá conta, escreve o brief, delega,
verifica o diff e commita. Quem escreve o código são os **instrumentistas**:
`codex`, `opencode` (Kimi, DeepSeek, GLM…), `cursor-agent`, `gemini`, um
`claude` em background, ou o próprio maestro só no trabalho crítico.

Este repositório é markdown puro no formato [agentskills.io](https://agentskills.io).
Instala em qualquer host que leia `SKILL.md`. Os pacotes por host, com
hooks, comandos e manifestos, ficam em
[batuta-ai/batuta](https://github.com/batuta-ai/batuta); a extensão do
CompozyOS em [batuta-ai/compozy](https://github.com/batuta-ai/compozy); o
binário `batuta` (gates, inventário, loop autônomo) em
[batuta-ai/core](https://github.com/batuta-ai/core).

## Instalação

```bash
npx skills add batuta-ai/skills            # todo agente detectado, neste projeto
npx skills add batuta-ai/skills -g         # para o usuário inteiro
npx skills add batuta-ai/skills -a codex   # um agente só
```

Depois, num projeto: `/batuta-init` uma vez, `/batuta` dali em diante.

## As quatro garantias

| Garantia | Como |
|---|---|
| **Commits atômicos** | uma tarefa verificada = um commit; uma lista de seis vira seis ciclos |
| **Estado retomável** | `WORK.md` em prosa na raiz; `/batuta-pause` e `/batuta-resume` entre sessões |
| **Plano quando precisa** | tarefa clara vai direto; ambígua ganha duas ou três perguntas; trabalho longo ganha `/batuta-plan` |
| **Verificação sempre** | checagem de escopo, review do diff, testes rodados pelo maestro, critérios com prova reexecutada — o relato do executor nunca é evidência |

## Skills

| Skill | Invocada por | Faz |
|---|---|---|
| `batuta` | o modelo, em qualquer tarefa delegável | o ciclo: classificar → decompor → brief → delegar → verificar → commitar |
| `batuta-review` | o modelo, em "revisa isso" | Step 4 sobre qualquer diff, segundo revisor opcional |
| `batuta-init` | `/batuta-init` | onboarding e reconfiguração: perfil, lanes, modelos, mapa do projeto |
| `batuta-plan` | `/batuta-plan` | plano aprovável de tarefas do tamanho de um commit |
| `batuta-loop` | `/batuta-loop` | execução autônoma de um plano aprovado pelo binário `batuta` |
| `batuta-status` | `/batuta-status` | em andamento, feito, sobras, taxas de delegação e escalada |
| `batuta-route` | `/batuta-route` | ver e editar a tabela de roteamento |
| `batuta-pause` / `batuta-resume` | `/batuta-pause`, `/batuta-resume` | handoff entre sessões |

Só `batuta` e `batuta-review` carregam por iniciativa do modelo; as demais
custam zero até serem invocadas.

## Roteamento

Quatro lanes por complexidade, opcionalmente divididas por domínio, cada
uma nomeando executor e modelo exato:

| Lane | Executor default | Custo |
|---|---|---|
| `low` | opencode + modelo barato | centavos |
| `medium` | codex, modelo default | assinatura ChatGPT |
| `high` | codex, modelo mais forte, reasoning alto | assinatura ChatGPT |
| `critical` | o próprio host que rege | assinatura do host |

O onboarding descobre o que está instalado e propõe a tabela; você
confirma. Executor que falha duas vezes escala uma linha. Adicionar um
executor é um arquivo markdown: copie
`skills/batuta/adapters/_template.md`, preencha o frontmatter YAML,
adicione uma linha.

## Estrutura

```
skills/
  batuta/            SKILL.md + references/ (brief, verification, routing, state, scout, worktree, method/)
                     adapters/ (self, claude, codex, opencode, cursor-agent, gemini) · templates/ (por stack)
  batuta-<comando>/  um diretório por skill de comando, agents/openai.yaml para o Codex
tests/skills/check.sh   lint e orçamento de tokens — gate de CI
docs/qa-retro.md        o protocolo de dogfooding
```

Tudo em `references/`, `adapters/` e `templates/` é dormente: lido só
pelo passo que precisa.

## Contribuindo

`bash tests/skills/check.sh` precisa passar. Texto de skills e referências
em inglês; o README é bilíngue. Rodadas de retrô seguem `docs/qa-retro.md`.

## Licença

[MIT](LICENSE)
