# Test Obsidian CLI - rode no seu PowerShell
# Uso: .\scripts\test-obsidian-cli.ps1
#
# Nota: O in-app updater do Obsidian NAO cria Obsidian.com (redirector).
# Usamos Obsidian.exe diretamente.

Write-Host "=== Teste Obsidian CLI ===" -ForegroundColor Cyan
Write-Host "   (Abra o Obsidian antes de rodar para facilitar a busca)" -ForegroundColor DarkGray

# 1. Procurar Obsidian.exe em locais comuns
$candidates = @(
    "$env:LOCALAPPDATA\Programs\Obsidian\Obsidian.exe",
    "C:\Users\lucas\AppData\Local\Programs\Obsidian\Obsidian.exe",
    "$env:ProgramFiles\Obsidian\Obsidian.exe",
    "${env:ProgramFiles(x86)}\Obsidian\Obsidian.exe"
)

$obsidianExe = $null
foreach ($path in $candidates) {
    if (Test-Path $path) {
        $obsidianExe = $path
        break
    }
}

# 2. Se nao encontrou, verificar se Obsidian esta rodando (pegar caminho do processo)
if (-not $obsidianExe) {
    $proc = Get-Process -Name "Obsidian" -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($proc) {
        $obsidianExe = $proc.Path
        Write-Host "   (encontrado via processo em execucao)" -ForegroundColor Gray
    }
}

# 3. Busca recursiva em AppData\Local (pode demorar)
if (-not $obsidianExe) {
    $found = Get-ChildItem "$env:LOCALAPPDATA\Programs" -Recurse -Filter "Obsidian.exe" -ErrorAction SilentlyContinue -Depth 2 | Select-Object -First 1
    if ($found) { $obsidianExe = $found.FullName }
}

if (-not $obsidianExe) {
    Write-Host "1. Obsidian.exe NAO encontrado." -ForegroundColor Red
    Write-Host "   Locais verificados:" -ForegroundColor Gray
    foreach ($p in $candidates) { Write-Host "   - $p" }
    Write-Host "`n   O Obsidian esta instalado? Se sim, abra o Obsidian e:" -ForegroundColor Yellow
    Write-Host "   - Clique com botao direito no icone da barra de tarefas" -ForegroundColor Yellow
    Write-Host "   - Clique com botao direito em 'Obsidian' > Abrir localizacao do arquivo" -ForegroundColor Yellow
    Write-Host "   - Copie o caminho da pasta e informe aqui" -ForegroundColor Yellow
    Write-Host "`n   Ou reinstale: https://obsidian.md/download" -ForegroundColor Yellow
    exit 1
}

Write-Host "1. Obsidian.exe encontrado: $obsidianExe" -ForegroundColor Green

# 3. Testar via caminho completo
Write-Host "`n2. Executando: Obsidian.exe version" -ForegroundColor Gray
& $obsidianExe version 2>&1

if ($LASTEXITCODE -eq 0) {
    Write-Host "`nOK - CLI funcionando!" -ForegroundColor Green
    Write-Host "   Atualize scripts\obsidian.cmd com o caminho: $obsidianExe" -ForegroundColor Gray
    Write-Host "   Use: .\scripts\obsidian.cmd <comando>" -ForegroundColor Gray
} else {
    Write-Host "`nFalha. Obsidian precisa estar ABERTO com um vault carregado." -ForegroundColor Yellow
}
