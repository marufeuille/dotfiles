# dotfiles

macOS の設定ファイルを管理するリポジトリ。bare repo 方式で `~/.dotfiles` に格納。

## 構成

```
~/.zshrc                        # source ハブ（各ファイルを読み込むだけ）
~/.sops.yaml                    # SOPS設定（シークレット暗号化）
~/.zsh/
  omz.zsh                       # Oh My Zsh (テーマ・プラグイン)
  editor.zsh                    # エディタ設定 (nvim / vim)
  lang.zsh                      # 言語ランタイム (pyenv, Volta, bun)
  path.zsh                      # PATH 追加・外部 SDK (GCloud, OpenFaaS 等)
  aliases.zsh                   # エイリアス
  git.zsh                       # Git関連のエイリアス
  tools.zsh                     # ツール初期化 (yazi, starship)
  search.zsh                    # 検索系 (fzf, zoxide, ripgrep)
  cmux.zsh                      # cmux ヘルパー
  secrets.sops.zsh              # 暗号化済みシークレット（SOPS+KMS）
  claude-glm.zsh                # Claude GLM設定
~/.gitconfig                    # Git 設定 (delta, merge 等)
~/.config/git/ignore            # グローバル gitignore
~/.config/nvim/                 # Neovim (LazyVim)
~/.config/yazi/                 # yazi ファイルマネージャ
~/.config/lazygit/config.yml    # lazygit
~/.config/helix/config.toml    # Helix エディタ
```

## 使い方

### Dotfiles管理用エイリアス

`dotfiles` は `git --git-dir=$HOME/.dotfiles --work-tree=$HOME` のエイリアス。

```bash
dotfiles status                    # 変更確認 (短縮: dfs)
dotfiles add ~/.zsh/editor.zsh     # ファイル追加 (短縮: dfa)
dotfiles commit -m "update editor" # コミット (短縮: dfc)
dotfiles push                      # リモートに反映 (短縮: dfp)
dotfiles pull                      # リモートから取得 (短縮: dfpull)
dotfiles log                       # ログ表示 (短縮: dfl)
```

### 一般的なGitエイリアス

```bash
gs  # git status
ga  # git add
gc  # git commit
gp  # git push
gl  # git log --oneline --graph --decorate -10
gb  # git branch
gco # git checkout
gd  # git diff
```

## シークレット管理

APIキーなどの機密情報は **SOPS + Google KMS** で暗号化してGit管理します。

### 構成

- `~/.sops.yaml`: SOPS設定（Google KMSキー参照）
- `~/.zsh/secrets.sops.zsh`: 暗号化済みシークレットファイル（Git管理対象）
- `~/.zshrc` 起動時に `sops --decrypt` で復号して読み込む

### 使い方

#### シークレットを編集

```bash
# 復号してエディタで編集（保存時に自動暗号化）
sops ~/.zsh/secrets.sops.zsh
```

#### 新しいシークレットファイルを作成

```bash
# 1. 平文ファイルを一時作成
cat > /tmp/secrets.zsh << 'EOF'
export MY_API_KEY="xxx"
EOF

# 2. 暗号化して配置
sops --encrypt --gcp-kms "projects/marufeuille-lab/locations/global/keyRings/dotfiles/cryptoKeys/sops-key" /tmp/secrets.zsh > ~/.zsh/secrets.sops.zsh

# 3. コミット
dotfiles add ~/.zsh/secrets.sops.zsh
dotfiles commit -m "Add secrets"
dotfiles push
```

#### セットアップ（別マシンでのSOPSアクセス）

別マシンでシークレットを復号するには、Google KMSへのアクセス権限が必要です。

```bash
# gcloud 認証
gcloud auth login

# 権限確認（CryptoKeys Encrypter/Decrypter）
gcloud kms keys list-iam-policies sops-key --keyring dotfiles --location global

# .zshrc 起動時に自動復号されます
```

## セットアップ（別マシン）

```bash
git clone --bare git@github.com:marufeuille/dotfiles.git ~/.dotfiles
alias dotfiles='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
dotfiles config status.showUntrackedFiles no
dotfiles checkout
```

既存ファイルと競合する場合は、バックアップしてから `dotfiles checkout` を再実行する。
