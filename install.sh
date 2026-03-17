#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> my_conf setup starting..."

# ─── Xcode Command Line Tools ───────────────────────────
if ! xcode-select -p &>/dev/null; then
  echo "==> Installing Xcode Command Line Tools..."
  xcode-select --install
  echo "    Press any key after installation completes..."
  read -n 1 -s
fi

# ─── Homebrew ────────────────────────────────────────────
if ! command -v brew &>/dev/null; then
  echo "==> Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# ─── Brew Bundle ─────────────────────────────────────────
echo "==> Installing packages from Brewfile..."
brew bundle --file="$SCRIPT_DIR/Brewfile"

# ─── Shell Config ────────────────────────────────────────
ZSHRC="$HOME/.zshrc"
SOURCE_LINE="source \"$SCRIPT_DIR/nuni_zsh.sh\""

if ! grep -qF "$SOURCE_LINE" "$ZSHRC" 2>/dev/null; then
  echo "==> Adding shell config to ~/.zshrc..."
  echo "" >> "$ZSHRC"
  echo "# my_conf" >> "$ZSHRC"
  echo "$SOURCE_LINE" >> "$ZSHRC"
  echo "    Added: $SOURCE_LINE"
else
  echo "==> Shell config already sourced in ~/.zshrc"
fi

# ─── Island-specific config (optional) ──────────────────
if [ -f "$SCRIPT_DIR/island.sh" ]; then
  ISLAND_LINE="source \"$SCRIPT_DIR/island.sh\""
  if ! grep -qF "$ISLAND_LINE" "$ZSHRC" 2>/dev/null; then
    echo "==> Adding Island config to ~/.zshrc..."
    echo "$ISLAND_LINE" >> "$ZSHRC"
  fi
fi

# ─── Python (via pyenv) ─────────────────────────────────
if command -v pyenv &>/dev/null; then
  LATEST_PYTHON=$(pyenv install --list | grep -E '^\s+3\.[0-9]+\.[0-9]+$' | tail -1 | tr -d ' ')
  echo "==> Latest Python available: $LATEST_PYTHON"
  read -p "    Install Python $LATEST_PYTHON via pyenv? [y/N] " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    pyenv install -s "$LATEST_PYTHON"
    pyenv global "$LATEST_PYTHON"
  fi
fi

# ─── Node (via fnm) ─────────────────────────────────────
if command -v fnm &>/dev/null; then
  echo "==> Installing latest LTS Node via fnm..."
  fnm install --lts
  fnm default lts-latest
fi

# ─── Claude Code ─────────────────────────────────────────
if command -v node &>/dev/null && ! command -v claude &>/dev/null; then
  echo "==> Installing Claude Code..."
  npm install -g @anthropic-ai/claude-code
fi

# ─── fzf keybindings ────────────────────────────────────
if command -v fzf &>/dev/null; then
  echo "==> fzf installed, keybindings configured via shell config"
fi

echo ""
echo "==> Setup complete!"
echo "    Restart your terminal or run: source ~/.zshrc"
echo ""
echo "==> Manual steps remaining:"
echo "    - See manual-installations.md for apps that need manual install"
echo "    - Set up git credentials: gh auth login"
echo "    - Set up AWS SSO if needed"
