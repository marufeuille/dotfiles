# yazi: ディレクトリ移動対応ラッパー
function yy() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

# yazi ネスト表示
if [ -n "$YAZI_LEVEL" ]; then
  export PS1="(yazi) $PS1"
fi

# starship prompt
eval "$(starship init zsh)"
if [ -n "$YAZI_LEVEL" ]; then
  RPROMPT="%F{yellow}(yazi)%f"
fi
