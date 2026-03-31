#!/usr/bin/env bash
# Claude Code hook: Stop
# Beep + toast quando Claude termina de responder.
# Evento: Stop | Timeout: 10s | Exit: sempre 0 (nunca bloqueia)

powershell.exe -NoProfile -Command "
  [console]::Beep(1200, 150)
  Add-Type -AssemblyName System.Windows.Forms
  \$n = New-Object System.Windows.Forms.NotifyIcon
  \$n.Icon = [System.Drawing.SystemIcons]::Information
  \$n.Visible = \$true
  \$n.BalloonTipTitle = 'Claude Code'
  \$n.BalloonTipText = 'Pronto'
  \$n.ShowBalloonTip(2000)
  Start-Sleep -Milliseconds 2500
  \$n.Dispose()
" 2>/dev/null

exit 0
