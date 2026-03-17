# my_conf

Personal dev environment setup — one script to bootstrap a new Mac.

## Quick Start

```bash
git clone https://github.com/banuni/my_conf.git
cd my_conf
./install.sh
```

This will:
- Install Homebrew (if missing)
- Install all packages from `Brewfile`
- Source shell config into `~/.zshrc`
- Set up Node (LTS via fnm) and Python (latest via pyenv)
- Install Claude Code CLI

## What's Inside

| File | Purpose |
|------|---------|
| `Brewfile` | All Homebrew packages and casks — run `brew bundle` |
| `nuni_zsh.sh` | ZSH config: aliases, functions, tool init |
| `starship.toml` | Starship prompt theme |
| `island.sh` | Work-specific (Island) aliases |
| `install.sh` | Full bootstrap script for a fresh Mac |
| `manual-installations.md` | Apps that need manual install |

## Key Features

- **Smart `nx`** — auto-detects package manager (bun/pnpm/yarn/npm)
- **Lazy pyenv** — doesn't slow down shell startup
- **Modern CLI** — `eza`, `bat`, `ripgrep`, `fzf` with aliases
- **AI tools** — Claude desktop + Claude Code CLI + Cursor editor
- **Claude Code aliases** — `cc`, `ccc` (continue), `ccr` (resume)

## Updating

After editing configs, sync across machines:

```bash
brew bundle dump --force --file=Brewfile  # refresh Brewfile from current installs
git add -A && git commit -m "update configs"
git push
```

On another machine: `git pull && brew bundle`
