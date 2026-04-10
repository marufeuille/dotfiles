# dotfiles

macOS の設定ファイルを管理するリポジトリ。bare repo 方式で `~/.dotfiles` に格納。

## 構成

```
~/.zshrc              # source ハブ（各ファイルを読み込むだけ）
~/.zsh/
  omz.zsh             # Oh My Zsh (テーマ・プラグイン)
  editor.zsh           # エディタ設定 (nvim / vim)
  lang.zsh             # 言語ランタイム (pyenv, Volta, bun)
  path.zsh             # PATH 追加・外部 SDK (GCloud, OpenFaaS 等)
  aliases.zsh          # エイリアス
  tools.zsh            # ツール初期化 (yazi, starship)
```

## 使い方

`dot` は `git --git-dir=$HOME/.dotfiles --work-tree=$HOME` のエイリアス。

```bash
dot status                    # 変更確認
dot add ~/.zsh/editor.zsh     # ファイル追加
dot commit -m "update editor" # コミット
dot push                      # リモートに反映
```

## セットアップ（別マシン）

```bash
git clone --bare <url> ~/.dotfiles
alias dot='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
dot config status.showUntrackedFiles no
dot checkout
```

既存ファイルと競合する場合は、バックアップしてから `dot checkout` を再実行する。
