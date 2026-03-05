#!/usr/bin/env bash
set -uo pipefail

###############################################################################
# oxidise.sh — Userland CLI stack (pacman-first, paru fallback)
###############################################################################

# ─────────────────────────────── UI helpers ───────────────────────────────── #
GREEN="\033[1;32m"
BLUE="\033[1;34m"
YELLOW="\033[1;33m"
RED="\033[1;31m"
RESET="\033[0m"

log()   { echo -e "${GREEN}[+]${RESET} $1"; }
info()  { echo -e "${BLUE}[i]${RESET} $1"; }
warn()  { echo -e "${YELLOW}[!]${RESET} $1"; }
fatal() { echo -e "${RED}[✗]${RESET} $1"; exit 1; }

has() { command -v "$1" >/dev/null 2>&1; }
try() { "$@" || warn "Failed: $*"; }

# ─────────────────────────────── Safety ───────────────────────────────────── #
[[ "$EUID" -eq 0 ]] && fatal "Do NOT run as root"
has pacman || fatal "pacman not found"
has paru   || fatal "paru not found (run base.sh first)"
has sudo   || fatal "sudo not found"

# ───────────────────────────── Environment ────────────────────────────────── #
ENV="bare-metal"
if grep -qi microsoft /proc/version 2>/dev/null; then
  ENV="wsl"
elif has systemd-detect-virt && systemd-detect-virt -q; then
  ENV="vm"
fi

info "Detected environment: $ENV"

# ───────────────────────────── Sudo keepalive ─────────────────────────────── #
sudo -v || fatal "sudo authentication failed"
while true; do sudo -n true; sleep 60; done 2>/dev/null &
SUDO_PID=$!
trap 'kill $SUDO_PID' EXIT

# ───────────────────────────── Install logic ──────────────────────────────── #
install_pkg() {
  local pkg="$1"

  if pacman -Si "$pkg" >/dev/null 2>&1; then
    log "pacman → $pkg"
    try sudo pacman -S --needed --noconfirm "$pkg"
  else
    log "paru   → $pkg"
    try paru -S --needed --noconfirm "$pkg"
  fi
}

install_group() {
  local title="$1"; shift
  echo
  log "$title"
  for pkg in "$@"; do
    install_pkg "$pkg"
  done
}

# ───────────────────────────── Core CLI (Rust-first) ──────────────────────── #
CORE_CLI=(
  zoxide
  fd
  ripgrep
  bat
  eza
  sd
  hexyl
  dust 
  dua-cli
  aria2
  fsel-git
)

install_group "Core CLI tools" "${CORE_CLI[@]}"

# ───────────────────────────── Git / Dev UX ───────────────────────────────── #
DEV_TOOLS=(
  git
  fzf
  lazygit
  github-cli
)

install_group "Git & developer tools" "${DEV_TOOLS[@]}"

# ───────────────────────────── Editor & Files ─────────────────────────────── #
EDITOR_TOOLS=(
  neovim
  yazi
)

install_group "Editor & file management" "${EDITOR_TOOLS[@]}"

# ───────────────────────────── Terminal workflow ──────────────────────────── #
TERM_TOOLS=(
  tmux
  zellij
)

install_group "Terminal multiplexers" "${TERM_TOOLS[@]}"

# ───────────────────────────── Terminal emulator ──────────────────────────── #
if [[ "$ENV" != "wsl" ]]; then
  install_group "Terminal emulator" alacritty
else
  info "Skipping terminal emulator (WSL)"
fi

# ───────────────────────────── System monitoring ──────────────────────────── #
SYS_TOOLS=(
  btop
  fastfetch
)

install_group "System monitoring & info" "${SYS_TOOLS[@]}"

# ───────────────────────────── Security & Dotfiles ────────────────────────── #
SECURITY_TOOLS=(
  gnupg
  pass
  age
  stow
)

install_group "Security & dotfiles" "${SECURITY_TOOLS[@]}"

# ───────────────────────────── Spacedrive (AUR) ───────────────────────────── #
echo
log "Spacedrive (optional)"

# Prefer binary if available
if paru -Si spacedrive-bin >/dev/null 2>&1; then
  install_pkg spacedrive-bin
elif paru -Si spacedrive >/dev/null 2>&1; then
  install_pkg spacedrive
else
  warn "spacedrive not available — skipping"
fi

# ───────────────────────────── Shell integration ──────────────────────────── #
echo
log "Shell integration"

if [[ -f "$HOME/.bashrc" ]]; then
  grep -q zoxide "$HOME/.bashrc" || echo 'eval "$(zoxide init bash)"' >> ~/.bashrc
fi

# ───────────────────────────── Done ───────────────────────────────────────── #
echo
log "oxidise.sh completed 🦀"
log "CLI environment is ready"
log "Restart shell or source ~/.bashrc"
