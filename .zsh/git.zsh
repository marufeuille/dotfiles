# Git関連のエイリアス

# Dotfiles管理用エイリアス（ベアリポジトリ方式）
alias dotfiles='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
alias dotfiles-status='dotfiles status'
alias dotfiles-add='dotfiles add -A'
alias dotfiles-commit='dotfiles commit'
alias dotfiles-push='dotfiles push'
alias dotfiles-pull='dotfiles pull'
alias dotfiles-log='dotfiles log --oneline --graph --decorate -10'

# 短縮エイリアス
alias dfs='dotfiles status'
alias dfa='dotfiles add -A'
alias dfc='dotfiles commit'
alias dfp='dotfiles push'
alias dfpull='dotfiles pull'
alias dfl='dotfiles log --oneline --graph --decorate -10'

# 一般的なGitエイリアス
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate -10'
alias gb='git branch'
alias gco='git checkout'
alias gd='git diff'
