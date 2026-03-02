#!/usr/bin/env bash
set -uo pipefail

###############################################################################
# base.sh — Universal Arch base bootstrap (Laptop / VM / WSL / Existing Arch)
###############################################################################

# ─────────────────────────────── Helpers ──────────────────────────────────── #
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
try() { "$@" || warn "Command failed: $*"; }

# ─────────────────────────────── Safety ───────────────────────────────────── #
[[ "$EUID" -eq 0 ]] && fatal "Do NOT run as root"
has pacman || fatal "pacman not found"
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

# ───────────────────────────── System update ─────────────────────────────── #
log "Updating system"
try sudo pacman -Syu --noconfirm

# ───────────────────────────── Base packages ─────────────────────────────── #
BASE_PKGS=(
  base-devel git curl wget openssh ca-certificates
  man-db man-pages less which
  tar gzip unzip zip rsync
)

log "Installing base packages"
try sudo pacman -S --needed --noconfirm "${BASE_PKGS[@]}"

has git     || fatal "git missing"
has makepkg || fatal "base-devel missing"

# ───────────────────────────── Networking ────────────────────────────────── #
if [[ "$ENV" != "wsl" ]]; then
  NETWORK_PKGS=(networkmanager iwd)

  log "Installing networking stack"
  try sudo pacman -S --needed --noconfirm "${NETWORK_PKGS[@]}"
  try sudo systemctl enable --now NetworkManager
else
  info "Skipping NetworkManager (WSL)"
fi

# ───────────────────────────── Audio (PipeWire) ──────────────────────────── #
if [[ "$ENV" != "wsl" ]]; then
  AUDIO_PKGS=(
    pipewire pipewire-alsa pipewire-pulse
    wireplumber alsa-utils
  )

  log "Installing audio stack (PipeWire)"

  if pacman -Q jack2 >/dev/null 2>&1; then
    warn "jack2 detected → replacing with pipewire-jack"
    try sudo pacman -R --noconfirm jack2
  fi

  try sudo pacman -S --needed --noconfirm "${AUDIO_PKGS[@]}"
  try sudo pacman -S --needed --noconfirm pipewire-jack

  try systemctl --user enable --now wireplumber
else
  info "Skipping audio stack (WSL)"
fi

# ───────────────────────────── Bluetooth ─────────────────────────────────── #
if [[ "$ENV" == "bare-metal" ]]; then
  BT_PKGS=(bluez bluez-utils)

  log "Installing Bluetooth stack"
  try sudo pacman -S --needed --noconfirm "${BT_PKGS[@]}"
  try sudo systemctl enable --now bluetooth
else
  info "Skipping Bluetooth (not bare metal)"
fi

# ───────────────────────────── Power (Laptop) ────────────────────────────── #
if [[ "$ENV" == "bare-metal" ]]; then
  POWER_PKGS=(tlp acpid)

  log "Installing power management tools"
  try sudo pacman -S --needed --noconfirm "${POWER_PKGS[@]}"
  try sudo systemctl enable --now tlp
  try sudo systemctl enable --now acpid
else
  info "Skipping power management"
fi

# ───────────────────────────── Paru (AUR) ────────────────────────────────── #
if has paru; then
  log "paru already installed"
else
  log "Installing paru (AUR helper)"
  cd /tmp || fatal "/tmp unavailable"
  rm -rf paru
  try git clone https://aur.archlinux.org/paru.git
  cd paru || fatal "paru clone failed"
  makepkg -si --noconfirm || fatal "paru build failed"
fi

has paru || fatal "paru not available"

# ───────────────────────────── Done ───────────────────────────────────────── #
log "Base system bootstrap complete ✅"
log "Safe on laptop / VM / WSL / existing Arch"
log "Next step: oxidise.sh"
