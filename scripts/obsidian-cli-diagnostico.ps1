# Diagnostico Obsidian CLI - rode no SEU PowerShell (com Obsidian ABERTO)
# O agente Cursor pode rodar em contexto diferente e nao conseguir conectar via IPC

Write-Host "=== Diagnostico Obsidian CLI ===" -ForegroundColor Cyan

# 1. Processo Obsidian rodando
$proc = Get-Process -Name "Obsidian" -ErrorAction SilentlyContinue | Select-Object -First 1
if ($proc) {
    Write-Host "1. Obsidian rodando: $($proc.Path)" -ForegroundColor Green
} else {
    Write-Host "1. Obsidian NAO esta rodando. Abra o Obsidian e rode de novo." -ForegroundColor Red
    exit 1
}

# 2. Arquivos na pasta (Obsidian.exe vs Obsidian.com)
$obsDir = Split-Path $proc.Path -Parent
Write-Host "`n2. Pasta: $obsDir" -ForegroundColor Gray
$files = Get-ChildItem $obsDir -Filter "Obsidian*" | Select-Object Name
foreach ($f in $files) { Write-Host "   - $($f.Name)" }

if (-not (Test-Path (Join-Path $obsDir "Obsidian.com"))) {
    Write-Host "`n   AVISO: Obsidian.com NAO existe!" -ForegroundColor Yellow
    Write-Host "   O in-app updater nao cria esse arquivo. Solucao:" -ForegroundColor Yellow
    Write-Host "   - Baixe o instalador completo: https://obsidian.md/download" -ForegroundColor Yellow
    Write-Host "   - Reinstale (sobrescreve, mantem config)" -ForegroundColor Yellow
}

# 3. Testar CLI
Write-Host "`n3. Testando CLI..." -ForegroundColor Gray
$result = & $proc.Path version 2>&1
Write-Host $result

if ($result -match "Unable to connect") {
    Write-Host "`nFALHA: Unable to connect to main process" -ForegroundColor Red
    Write-Host "`nPossiveis causas:" -ForegroundColor Yellow
    Write-Host "  a) CLI nao habilitada: Settings > General > Command line interface = ON" -ForegroundColor Gray
    Write-Host "  b) Falta Obsidian.com: reinstale via instalador completo (nao in-app)" -ForegroundColor Gray
    Write-Host "  c) Terminal em contexto diferente: rode este script no MESMO terminal" -ForegroundColor Gray
    Write-Host "     onde voce usa o Obsidian (nao via Cursor/agent)" -ForegroundColor Gray
} elseif ($result -match "^\d+\.\d+") {
    Write-Host "`nOK - CLI funcionando!" -ForegroundColor Green
}
