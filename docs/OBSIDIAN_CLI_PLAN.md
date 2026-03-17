# Plano: Incorporar Obsidian CLI ao Ecossistema

> Coautoria: Lucas + opus | 2026-03-14
> Ref: [Obsidian CLI](https://obsidian.md/cli) | [Help](https://help.obsidian.md/cli)

## Contexto

- **KnowledgeOrganizer** já escreve notas no vault via file I/O (`Path.write_text`)
- Obsidian está em PENDENCIAS como "futuro" e HANDOFF como "Obsidian + Zotero (futuro)"
- **Obsidian CLI** (v1.12.4+, atual 1.12.5) permite comandar o vault via terminal
- Regra de ouro: `Obsidian = CONECTAR` (ECOSYSTEM.md)

## Objetivo

Incorporar Obsidian CLI para:
1. Automação via scripts e workflows (cron, pipelines)
2. Integração com agentes (KnowledgeOrganizer, Organização)
3. Daily notes, tasks, search, create — tudo via CLI
4. Preparar para "agentic tools" (Obsidian como playground programático)

---

## Fase 1: Pré-requisitos (Manual)

### 1.1 Instalar/Atualizar Obsidian

- **Versão mínima**: 1.12.4 (CLI introduzido)
- **Versão atual**: 1.12.5 (mar/2026)
- Download: https://obsidian.md/download

### 1.2 Ativar CLI

1. Abrir Obsidian
2. **Settings → General**
3. Habilitar **Command line interface**
4. Seguir instruções para registrar no PATH

### 1.3 Windows (seu ambiente)

- O instalador **completo** adiciona `Obsidian.com` terminal redirector ao lado de `Obsidian.exe`
- **Problema conhecido**: O in-app updater NÃO cria `Obsidian.com` — use o instalador de https://obsidian.md/download
- **Workaround**: Use `scripts\obsidian.cmd` ou `Obsidian.exe` com caminho completo:
  ```powershell
  & "C:\Users\lucas\AppData\Local\Programs\Obsidian\Obsidian.exe" version
  .\scripts\obsidian.cmd daily
  ```
- Reiniciar terminal após instalação

### 1.4 Verificar instalação

```powershell
obsidian help
obsidian version
```

**Importante**: O app Obsidian precisa estar **rodando** para a CLI funcionar (exceto Headless Sync).

---

## Fase 2: Configuração no Projeto

### 2.1 Variáveis de ambiente

Em `.env`:

```env
# Obsidian vault (caminho absoluto recomendado)
OBSIDIAN_VAULT=C:\Dev\Projetos\Organizacao\data\obsidian-vault

# Habilitar uso da CLI (fallback para file write se false)
OBSIDIAN_CLI_ENABLED=true
```

### 2.2 Atualizar .env.example

Descomentar e documentar:

```env
# Obsidian vault - caminho absoluto ao vault
OBSIDIAN_VAULT=data/obsidian-vault
# Usar CLI quando disponível (obsidian app rodando)
OBSIDIAN_CLI_ENABLED=true
```

### 2.3 Criar vault se não existir

```powershell
cd C:\Dev\Projetos\Organizacao
mkdir -p data/obsidian-vault
# Estrutura PARA (KnowledgeOrganizer já define):
# 00-Inbox, 01-Projects, 02-Areas, 03-Resources, 04-Archive, Templates, Attachments
```

---

## Fase 3: Wrapper Python (lib/obsidian_cli.py)

Criar módulo que:
- Detecta se `obsidian` está no PATH
- Executa comandos via `subprocess.run`
- Retorna stdout/stderr e exit code
- Fallback gracioso se CLI indisponível

### 3.1 Interface proposta

```python
# lib/obsidian_cli.py
async def obsidian_run(cmd: str, *args: str, vault: str | None = None) -> ObsidianResult
def obsidian_available() -> bool
```

### 3.2 Comandos prioritários

| Comando | Uso no ecossistema |
|---------|---------------------|
| `obsidian daily` | Abrir daily note |
| `obsidian daily:append content="..."` | Adicionar tasks ao daily |
| `obsidian create name="..." template=...` | Criar nota de template |
| `obsidian search query="..."` | Buscar no vault |
| `obsidian tasks daily` | Listar tasks do daily |
| `obsidian files sort=modified limit=5` | Arquivos recentes |
| `obsidian read` | Ler arquivo atual |
| `obsidian tags counts` | Tags com frequência |
| `obsidian unresolved` | Links não resolvidos |

### 3.3 Parâmetro vault

```powershell
obsidian search query="meeting" vault="C:\Dev\Projetos\Organizacao\data\obsidian-vault"
```

---

## Fase 4: Integrar ao KnowledgeOrganizer

### 4.1 Estratégia híbrida

- **CLI disponível** (app rodando): usar `obsidian create` ou `obsidian daily:append` quando fizer sentido
- **CLI indisponível**: manter file write atual (já funciona)

### 4.2 Novas ações possíveis

| Ação | Descrição |
|------|-----------|
| `daily_append` | Adicionar task ao daily note |
| `search_vault` | Buscar e retornar resultados |
| `create_from_template` | Criar nota via template Obsidian |

### 4.3 Manter compatibilidade

- `_sync_to_obsidian` continua escrevendo arquivos (funciona sem app)
- Adicionar `_obsidian_cli_create` como alternativa quando CLI disponível
- Config `OBSIDIAN_CLI_ENABLED` controla qual caminho usar

---

## Fase 5: Workflows

### 5.1 Workflow: Morning routine (exemplo)

```yaml
obsidian_morning_routine:
  name: "Rotina Matinal Obsidian"
  trigger: "cron"
  schedule: "0 7 * * *"
  steps:
    - obsidian_cli: "daily:append" content="- [ ] Review inbox"
    - obsidian_cli: "daily:append" content="- [ ] Check calendar"
    - obsidian_cli: "files" sort=modified limit=5
```

### 5.2 Workflow: Digest → Obsidian

Quando digest médico for criado, além de Notion:
- `obsidian create name="Digest Semana X" template=Digest`
- Ou `daily:append` com link para o digest

---

## Fase 6: Headless Sync (Futuro)

Para automação **sem** app GUI rodando:
- Obsidian Sync + Headless
- Ref: https://help.obsidian.md/sync/headless
- Casos: cron em servidor, agentic tools, backup remoto

---

## Checklist de Implementação

- [ ] Fase 1: Instalar Obsidian 1.12.4+, ativar CLI, registrar PATH
- [ ] Fase 2: Configurar OBSIDIAN_VAULT e OBSIDIAN_CLI_ENABLED no .env
- [ ] Fase 2: Criar estrutura vault (00-Inbox, 01-Projects, etc.)
- [ ] Fase 3: Criar `lib/obsidian_cli.py` (wrapper subprocess)
- [ ] Fase 3: Testar `obsidian help` e `obsidian daily` via wrapper
- [ ] Fase 4: Adicionar `obsidian_available()` e lógica híbrida no KnowledgeOrganizer
- [ ] Fase 4: Novas ações `daily_append`, `search_vault`, `create_from_template`
- [ ] Fase 5: Workflow `obsidian_morning_routine` em workflows.yaml
- [ ] Documentar em PENDENCIAS.md (Obsidian CLI como item configurado)
- [ ] Atualizar HANDOFF.md (remover "Obsidian + Zotero futuro" quando concluído)

---

## Referências

- [Obsidian CLI](https://obsidian.md/cli) — página oficial
- [Obsidian Help - CLI](https://help.obsidian.md/cli) — documentação completa
- [Obsidian Changelog 1.12.4](https://obsidian.md/changelog) — CLI introduzido
- KnowledgeOrganizer: `subagents/processors/knowledge_organizer.py`
- Config: `config/ecosystem.yaml` (knowledge_organizer subagent)
