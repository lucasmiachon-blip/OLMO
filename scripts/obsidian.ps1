# Wrapper Obsidian CLI - mostra stdout e stderr para debug
$obsidian = "C:\Program Files\Obsidian\Obsidian.com"

try {
    if ($args.Count -gt 0) {
        & $obsidian @args 2>&1 | ForEach-Object { Write-Host $_ }
    } else {
        & $obsidian help 2>&1 | ForEach-Object { Write-Host $_ }
    }
} catch {
    Write-Host "Erro: $_" -ForegroundColor Red
}
exit $LASTEXITCODE
