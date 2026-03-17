# Teste do Workflow MBE: PubMed -> Obsidian + Notion
# Uso: .\scripts\testar-workflow.ps1

$ErrorActionPreference = "Stop"
$tema = "restricao sodica ascite"

Write-Host "=== Teste Workflow MBE ===" -ForegroundColor Cyan
Write-Host ""

# 1. Script atualizar_tema
Write-Host "1. Rodando atualizar_tema.py..." -ForegroundColor Yellow
uv run python scripts/atualizar_tema.py -t $tema --fetch --sources pubmed --tier1 --max-refs 3 --tags ascite,cirrose,hepatologia
if ($LASTEXITCODE -ne 0) { exit 1 }

Write-Host ""

# 2. Verificar Obsidian
$slug = ($tema -replace '[\s]+', '-').ToLower()
$obsidianPath = "03-Resources/$slug.md"
if (Test-Path $obsidianPath) {
    Write-Host "2. Obsidian: OK - $obsidianPath" -ForegroundColor Green
} else {
    Write-Host "2. Obsidian: FALHOU - arquivo nao encontrado" -ForegroundColor Red
}

# 3. Verificar output Notion
$notionPath = "scripts/output/notion-$slug-masterpiece.md"
if (Test-Path $notionPath) {
    Write-Host "3. Notion (copiar para Masterpiece): OK - $notionPath" -ForegroundColor Green
    Write-Host ""
    Write-Host "   Proximo passo: abra o arquivo e copie para Notion" -ForegroundColor Gray
    Write-Host "   code $notionPath" -ForegroundColor Gray
} else {
    Write-Host "3. Notion: FALHOU - arquivo nao encontrado" -ForegroundColor Red
}

Write-Host ""
Write-Host "=== Fim do teste ===" -ForegroundColor Cyan
