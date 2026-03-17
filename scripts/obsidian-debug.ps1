# Debug Obsidian CLI - captura toda saida
$obsidian = "C:\Program Files\Obsidian\Obsidian.com"
$logFile = "C:\Dev\Projetos\Organizacao\data\obsidian-cli-output.txt"

$dataDir = Split-Path $logFile -Parent
if (-not (Test-Path $dataDir)) { New-Item -ItemType Directory -Path $dataDir -Force | Out-Null }

Write-Host "Executando: $obsidian version" -ForegroundColor Gray

# Executar e redirecionar tudo para arquivo
& $obsidian version *> $logFile
$exitCode = $LASTEXITCODE

$content = Get-Content $logFile -Raw -ErrorAction SilentlyContinue
Write-Host "`n--- Saida capturada ---"
Write-Host ($content.Trim() ?? "(nenhuma saida)")
Write-Host "`nExit code: $exitCode"
