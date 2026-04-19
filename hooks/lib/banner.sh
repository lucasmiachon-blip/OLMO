#!/usr/bin/env bash
# banner.sh — Semantic banner library for OLMO hooks
# Source: . "$PROJECT_ROOT/hooks/lib/banner.sh"
# Usage: banner_warn "Title" "Line 2" "Line 3"
# Created: S230 Phase G.9 (bubbly-forging-cat)

# ANSI codes
readonly _RESET="\033[0m"
readonly _BOLD="\033[1m"
readonly _BG_GREEN="\033[42m"
readonly _BG_CYAN="\033[46m"
readonly _BG_YELLOW="\033[43m"
readonly _BG_ORANGE="\033[48;5;208m"
readonly _BG_RED="\033[41m"
readonly _BG_MAGENTA="\033[45m"
readonly _FG_BLACK="\033[30m"
readonly _FG_WHITE="\033[97m"

# Pad string to 60 chars (banner internal width)
_pad60() {
  local s="$1"
  printf "%-60s" "$s"
}

# 🟢 SUCCESS (1 line)
banner_success() {
  local msg="$1"
  printf '%b ✓ %s%b\n' "${_BG_GREEN}${_FG_BLACK}${_BOLD}" "$msg" "${_RESET}"
}

# 🔵 INFO (3-4 li)
banner_info() {
  local title="$1" line2="${2:-}" line3="${3:-}"
  printf '%b%b%b\n' "${_BG_CYAN}${_FG_BLACK}${_BOLD}" "$(_pad60 "")" "${_RESET}"
  printf '%b%b%b\n' "${_BG_CYAN}${_FG_BLACK}${_BOLD}" "$(_pad60 "  ℹ  $title")" "${_RESET}"
  printf '%b%b%b\n' "${_BG_CYAN}${_FG_BLACK}" "$(_pad60 "    $line2")" "${_RESET}"
  [ -n "$line3" ] && printf '%b%b%b\n' "${_BG_CYAN}${_FG_BLACK}" "$(_pad60 "    $line3")" "${_RESET}"
}

# 🟡 WARN (3-4 li)
banner_warn() {
  local title="$1" line2="${2:-}" line3="${3:-}"
  printf '%b%b%b\n' "${_BG_YELLOW}${_FG_BLACK}${_BOLD}" "$(_pad60 "")" "${_RESET}"
  printf '%b%b%b\n' "${_BG_YELLOW}${_FG_BLACK}${_BOLD}" "$(_pad60 "  ⚠  $title")" "${_RESET}"
  printf '%b%b%b\n' "${_BG_YELLOW}${_FG_BLACK}" "$(_pad60 "    $line2")" "${_RESET}"
  [ -n "$line3" ] && printf '%b%b%b\n' "${_BG_YELLOW}${_FG_BLACK}" "$(_pad60 "    $line3")" "${_RESET}"
}

# 🟠 ATTN (3-4 li)
banner_attn() {
  local title="$1" line2="${2:-}" line3="${3:-}"
  printf '%b%b%b\n' "${_BG_ORANGE}${_FG_WHITE}${_BOLD}" "$(_pad60 "")" "${_RESET}"
  printf '%b%b%b\n' "${_BG_ORANGE}${_FG_WHITE}${_BOLD}" "$(_pad60 "  ⚡ ATENCAO: $title")" "${_RESET}"
  printf '%b%b%b\n' "${_BG_ORANGE}${_FG_WHITE}" "$(_pad60 "    $line2")" "${_RESET}"
  [ -n "$line3" ] && printf '%b%b%b\n' "${_BG_ORANGE}${_FG_WHITE}" "$(_pad60 "    $line3")" "${_RESET}"
}

# 🔴 CRITICAL (3-4 li)
banner_critical() {
  local title="$1" line2="${2:-}" line3="${3:-}"
  printf '%b%b%b\n' "${_BG_RED}${_FG_WHITE}${_BOLD}" "$(_pad60 "")" "${_RESET}"
  printf '%b%b%b\n' "${_BG_RED}${_FG_WHITE}${_BOLD}" "$(_pad60 "  🚨 CRITICO: $title")" "${_RESET}"
  printf '%b%b%b\n' "${_BG_RED}${_FG_WHITE}${_BOLD}" "$(_pad60 "     $line2")" "${_RESET}"
  [ -n "$line3" ] && printf '%b%b%b\n' "${_BG_RED}${_FG_WHITE}${_BOLD}" "$(_pad60 "     $line3")" "${_RESET}"
}

# 🟣 DECISION (3-4 li)
banner_decision() {
  local title="$1" line2="${2:-}" line3="${3:-}"
  printf '%b%b%b\n' "${_BG_MAGENTA}${_FG_WHITE}${_BOLD}" "$(_pad60 "")" "${_RESET}"
  printf '%b%b%b\n' "${_BG_MAGENTA}${_FG_WHITE}${_BOLD}" "$(_pad60 "  ❓ DECISAO: $title")" "${_RESET}"
  printf '%b%b%b\n' "${_BG_MAGENTA}${_FG_WHITE}" "$(_pad60 "    $line2")" "${_RESET}"
  [ -n "$line3" ] && printf '%b%b%b\n' "${_BG_MAGENTA}${_FG_WHITE}" "$(_pad60 "    $line3")" "${_RESET}"
}
