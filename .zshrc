# Amazon Q pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zshrc.pre.zsh"

source ~/.zsh/omz.zsh      # Oh My Zsh
source ~/.zsh/editor.zsh   # エディタ
source ~/.zsh/lang.zsh     # 言語/ランタイム (pyenv, Volta, bun)
source ~/.zsh/path.zsh     # PATH・外部SDK
source ~/.zsh/aliases.zsh  # エイリアス
source ~/.zsh/git.zsh      # Git関連のエイリアス
source ~/.zsh/tools.zsh    # ツール (yazi, starship)
source ~/.zsh/search.zsh   # 検索系 (fzf, zoxide, ripgrep)
source ~/.zsh/cmux.zsh     # cmux ヘルパー (cmux-pr など)

# SOPSで暗号化されたシークレットを読み込む
if [[ -f ~/.zsh/secrets.sops.zsh ]] && command -v sops >/dev/null 2>&1; then
  eval "$(sops --decrypt ~/.zsh/secrets.sops.zsh)" 2>/dev/null || {
    echo "⚠️ secrets.sops.zsh の復号に失敗しました。KMSアクセス権限を確認してください。" >&2
  }
elif [[ -f ~/.zsh/secrets.zsh ]]; then
  source ~/.zsh/secrets.zsh  # フォールバック（平文、Git管理外）
fi

source ~/.zsh/claude-glm.zsh

# Amazon Q post block. Keep at the bottom of this file.
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zshrc.post.zsh"
export PATH=$PATH:~/Library/Android/sdk/platform-tools
export PATH=$PATH:/Users/masahiro/Library/Android/sdk/platform-tools

