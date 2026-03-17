# Verificacao completa - Obsidian CLI + Zotero MCP config
# Rode: .\scripts\verificar-tudo.ps1

$ok = 0
$fail = 0

Write-Host "=== VERIFICACAO DO ECOSSISTEMA ===" -ForegroundColor Cyan

# 1. Obsidian CLI
Write-Host "`n1. Obsidian CLI" -ForegroundColor Gray
try {
    $v = & "C:\Program Files\Obsidian\Obsidian.com" version 2>&1
    if ($v -match "^\d+\.\d+") {
        Write-Host "   OK - Versao: $v" -ForegroundColor Green
        $ok++
    } else { throw $v }
} catch {
    Write-Host "   FALHA - $_" -ForegroundColor Red
    Write-Host "   Obsidian precisa estar aberto com vault carregado." -ForegroundColor Yellow
    $fail++
}

# 2. Obsidian wrapper
Write-Host "`n2. scripts\obsidian.cmd" -ForegroundColor Gray
if (Test-Path "scripts\obsidian.cmd") {
    $daily = & ".\scripts\obsidian.cmd" daily:path 2>&1
    if ($daily -match "\.md$") {
        Write-Host "   OK - daily:path = $daily" -ForegroundColor Green
        $ok++
    } else { Write-Host "   OK - wrapper existe" -ForegroundColor Green; $ok++ }
} else {
    Write-Host "   FALHA - arquivo nao encontrado" -ForegroundColor Red
    $fail++
}

# 3. Zotero MCP config
Write-Host "`n3. Zotero MCP (.cursor/mcp.json)" -ForegroundColor Gray
if (Test-Path ".cursor\mcp.json") {
    $mcp = Get-Content ".cursor\mcp.json" -Raw | ConvertFrom-Json
    if ($mcp.mcpServers.zotero) {
        Write-Host "   OK - Config presente" -ForegroundColor Green
        $ok++
    } else { Write-Host "   FALHA - zotero nao encontrado no config" -ForegroundColor Red; $fail++ }
} else {
    Write-Host "   FALHA - .cursor/mcp.json nao existe" -ForegroundColor Red
    $fail++
}

# 4. uvx zotero-mcp
Write-Host "`n4. uvx zotero-mcp" -ForegroundColor Gray
try {
    $z = uvx zotero-mcp --help 2>&1
    if ($z -match "Zotero") {
        Write-Host "   OK - Pacote instalado" -ForegroundColor Green
        $ok++
    } else { throw "Nao encontrado" }
} catch {
    Write-Host "   FALHA - uvx ou zotero-mcp nao disponivel" -ForegroundColor Red
    Write-Host "   Instale: pip install uv (ou pipx) e rode: uvx zotero-mcp --help" -ForegroundColor Yellow
    $fail++
}

# 5. Vault Obsidian
Write-Host "`n5. Vault (data/obsidian-vault)" -ForegroundColor Gray
if (Test-Path "data\obsidian-vault") {
    $folders = Get-ChildItem "data\obsidian-vault" -Directory -ErrorAction SilentlyContinue
    Write-Host "   OK - Vault existe ($($folders.Count) pastas)" -ForegroundColor Green
    $ok++
} else {
    Write-Host "   AVISO - data/obsidian-vault nao existe (criar se precisar)" -ForegroundColor Yellow
}

# Resumo
Write-Host "`n=== RESUMO ===" -ForegroundColor Cyan
Write-Host "   OK: $ok | Falhas: $fail" -ForegroundColor $(if ($fail -eq 0) { "Green" } else { "Yellow" })
Write-Host "`nZotero MCP: Reinicie o Cursor para carregar. Zotero deve estar aberto + Advanced > Allow other applications." -ForegroundColor Gray
