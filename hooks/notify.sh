#!/usr/bin/env bash
# Claude Code hook: Notification
# Toast notification no Windows 11 quando Claude precisa de input.
# Evento: Notification | Timeout: 10s | Exit: sempre 0 (nunca bloqueia)

# Drain stdin (hook protocol — prevent parent process stall)
cat >/dev/null 2>&1

powershell.exe -NoProfile -Command "
  Add-Type -AssemblyName System.Windows.Forms
  \$n = New-Object System.Windows.Forms.NotifyIcon
  \$n.Icon = [System.Drawing.SystemIcons]::Information
  \$n.Visible = \$true
  \$n.BalloonTipTitle = 'Claude Code'
  \$n.BalloonTipText = 'Aguardando input'
  \$n.ShowBalloonTip(3000)
  Start-Sleep -Milliseconds 3500
  \$n.Dispose()
" 2>/dev/null

exit 0
