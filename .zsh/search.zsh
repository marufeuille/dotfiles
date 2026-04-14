# ---- fzf ----
# キーバインド (Ctrl-T: ファイル, Ctrl-R: 履歴, Alt-C: ディレクトリ) と補完
source <(fzf --zsh)

# fd をデフォルトの探索コマンドに (高速 + .gitignore 尊重 + 隠しファイルも対象)
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'

# 見た目とプレビュー (bat / eza でリッチ表示)
export FZF_DEFAULT_OPTS="
  --height 60% --layout=reverse --border --info=inline
  --bind 'ctrl-/:toggle-preview'
"
export FZF_CTRL_T_OPTS="--preview 'bat --style=numbers --color=always --line-range :200 {}'"
export FZF_ALT_C_OPTS="--preview 'ls -la {}'"
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview'"

# ---- zoxide ----
# z <部分一致> で移動, zi でインタラクティブ (fzf) 選択
eval "$(zoxide init zsh --cmd z)"

# ---- ripgrep ----
export RIPGREP_CONFIG_PATH="$HOME/.config/ripgrep/ripgreprc"

# ---- aliases ----
alias cat='bat --paging=never'
alias ll='ls -lah'
