#!/usr/bin/env bash
# toast.sh — Windows 11 NotifyIcon toast wrapper for OLMO hooks
# Source: . "$PROJECT_ROOT/hooks/lib/toast.sh"
# Created: S255 Phase 3 A.3 (DRY extract from notify.sh + stop-notify.sh)
#
# Provides:
#   show_toast <title> <text> <duration_ms>
#     title:        BalloonTipTitle (e.g., 'Claude Code')
#     text:         BalloonTipText  (e.g., 'Pronto', 'Aguardando input')
#     duration_ms:  ShowBalloonTip duration in ms; Sleep = duration + 500ms

# S255 Phase 3 A.3: idempotent include guard (banner.sh:7-11 model)
[[ -n "${_TOAST_LIB_LOADED:-}" ]] && return 0
readonly _TOAST_LIB_LOADED=1

# Visual-only toast (Lucas preference: no beep — listens to music while working)
# Errors suppressed: 2>/dev/null — toast failures must not break hook flow
show_toast() {
  local title="${1:-Claude Code}"
  local text="${2:-Notification}"
  local duration_ms="${3:-3000}"
  local sleep_ms=$((duration_ms + 500))

  powershell.exe -NoProfile -Command "
    Add-Type -AssemblyName System.Windows.Forms
    \$n = New-Object System.Windows.Forms.NotifyIcon
    \$n.Icon = [System.Drawing.SystemIcons]::Information
    \$n.Visible = \$true
    \$n.BalloonTipTitle = '$title'
    \$n.BalloonTipText = '$text'
    \$n.ShowBalloonTip($duration_ms)
    Start-Sleep -Milliseconds $sleep_ms
    \$n.Dispose()
  " 2>/dev/null
}
