# Amazon Q pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zshrc.pre.zsh"

source ~/.zsh/omz.zsh      # Oh My Zsh
source ~/.zsh/editor.zsh   # エディタ
source ~/.zsh/lang.zsh     # 言語/ランタイム (pyenv, Volta, bun)
source ~/.zsh/path.zsh     # PATH・外部SDK
source ~/.zsh/aliases.zsh  # エイリアス
source ~/.zsh/tools.zsh    # ツール (yazi, starship)
source ~/.zsh/search.zsh   # 検索系 (fzf, zoxide, ripgrep)
source ~/.zsh/cmux.zsh     # cmux ヘルパー (cmux-pr など)

# Amazon Q post block. Keep at the bottom of this file.
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zshrc.post.zsh"
