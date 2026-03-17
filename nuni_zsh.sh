# Resolve this repo's directory (works even when sourced via relative path or symlink)
MY_CONF_DIR="${${(%):-%x}:A:h}"

build_and_push_docker_image() {(
    set -e
    docker build -t $1 .
    docker push $1
)}

# Add brew to path
export PATH="/opt/homebrew/bin:$PATH"

# Pyenv (lazy-loaded for fast shell startup)
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
export PATH="$HOME/.pyenv/shims:$PATH"

pyenv() {
  unfunction pyenv
  eval "$(command pyenv init --path)"
  eval "$(command pyenv init -)"
  pyenv "$@"
}


alias pipu="pip install --upgrade pip"
alias zshconfig="vi ~/.zshrc"

# requires fnm installation (brew)
eval "$(fnm env --use-on-cd)"

# requires starship
export STARSHIP_CONFIG="$MY_CONF_DIR/starship.toml"
eval "$(starship init zsh)"

# increase node memory limit
export NODE_OPTIONS="--max-old-space-size=8192"

# ─── Modern CLI aliases ──────────────────────────────────
# Use modern replacements if available
command -v eza &>/dev/null && alias ls="eza" && alias ll="eza -la --git" && alias tree="eza --tree"
command -v bat &>/dev/null && alias cat="bat --plain"

# ─── Package manager aliases ─────────────────────────────
alias pp="pnpm"

# ─── Git aliases ─────────────────────────────────────────
alias grom='git fetch origin && git rebase origin/main'
alias gs='git status'
alias gd='git diff'
alias gl='git log --oneline -20'

# ─── AI tool aliases ─────────────────────────────────────
alias cc='claude'
alias ccc='claude --continue'
alias ccr='claude --resume'

# ─── fzf integration ─────────────────────────────────────
if command -v fzf &>/dev/null; then
  source <(fzf --zsh 2>/dev/null) || true
fi

# Smart nx alias that detects package manager
nx() {
    # Check for lock files to determine package manager
    if [ -f "bun.lockb" ]; then
        echo "Using bun nx"
        bun nx "$@"
    elif [ -f "pnpm-lock.yaml" ]; then
        echo "Using pnpm nx"
        pnpm nx "$@"
    elif [ -f "yarn.lock" ]; then
        echo "Using yarn nx"
        yarn nx "$@"
    elif [ -f "package-lock.json" ]; then
        echo "Using npm nx"
        npm run nx "$@"
    else
        # Fallback: check if nx is globally installed by looking for the actual binary
        local nx_path
        for path in /usr/local/bin/nx ~/.npm-global/bin/nx ~/.yarn/bin/nx ~/.local/share/pnpm/nx $(npm root -g 2>/dev/null)/nx/bin/nx.js; do
            if [ -f "$path" ] || [ -x "$path" ]; then
                nx_path="$path"
                break
            fi
        done

        if [ -n "$nx_path" ]; then
            echo "Using global nx"
            "$nx_path" "$@"
        else
            echo "No package manager detected and nx not found globally"
            return 1
        fi
    fi
}

# ─── Island (work-specific, optional) ────────────────────
if [ -f "$MY_CONF_DIR/island.env" ]; then
  source "$MY_CONF_DIR/island.env"
fi
if [ -f "$MY_CONF_DIR/island.sh" ]; then
  source "$MY_CONF_DIR/island.sh"
fi
