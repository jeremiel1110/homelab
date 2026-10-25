#!/usr/bin/env bash
# setup-terminal.sh — zsh + Starship (pastel-powerline preset) on a fresh Ubuntu/Debian VM.
#
# Usage:
#   bash scripts/setup-terminal.sh
#   curl -fsSL https://raw.githubusercontent.com/jeremiel1110/homelab/main/scripts/setup-terminal.sh | bash
#
# Safe to run more than once. Needs sudo (apt, chsh).
# The Nerd Font goes on the machine you SSH FROM (e.g. Windows Terminal), not on the VM.

set -euo pipefail

PRESET="pastel-powerline"
MARKER_BEGIN="# >>> setup-terminal >>>"
MARKER_END="# <<< setup-terminal <<<"

log() { printf '\n==> %s\n' "$*"; }

# --- 1. Packages -------------------------------------------------------------
log "Installing packages"
sudo apt-get update
sudo apt-get install -y zsh git curl zsh-autosuggestions zsh-syntax-highlighting

# --- 2. Starship -------------------------------------------------------------
log "Installing Starship to ~/.local/bin"
mkdir -p "$HOME/.local/bin" "$HOME/.config"
curl -fsSL https://starship.rs/install.sh | sh -s -- -b "$HOME/.local/bin" -y

# --- 3. Starship config (never overwrite an existing one) --------------------
log "Configuring Starship"
if [ -f "$HOME/.config/starship.toml" ]; then
  echo "~/.config/starship.toml already exists, keeping it."
else
  "$HOME/.local/bin/starship" preset "$PRESET" -o "$HOME/.config/starship.toml"
  echo "Applied the '$PRESET' preset."
fi

# --- 4. ~/.zshrc -------------------------------------------------------------
log "Updating ~/.zshrc"
touch "$HOME/.zshrc"   # also skips zsh's first-run setup wizard

if ! grep -qF "$MARKER_BEGIN" "$HOME/.zshrc"; then
  cat >> "$HOME/.zshrc" <<EOF

$MARKER_BEGIN
export PATH="\$HOME/.local/bin:\$PATH"
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
eval "\$(starship init zsh)"
$MARKER_END
EOF
  echo "Added the setup block."
else
  echo "Setup block already present, skipping."
fi

# --- 5. Default shell --------------------------------------------------------
log "Setting zsh as the default shell"
sudo chsh -s "$(command -v zsh)" "$USER"

log "Done. Log out and back in (or run: exec zsh)."