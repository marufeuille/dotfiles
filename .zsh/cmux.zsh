# cmux 用ヘルパー関数
#
# cmux-pr <pr-number>:
#   現在の cmux ワークスペースを 3 ペインのレイアウトに分割し、PR レビュー用の
#   作業環境を立ち上げる。さらにバックグラウンドで CI ステータスを監視し、
#   ワークスペースのタイトル・色を都度更新する。
#
#     +---------------+-----------+
#     |   lazygit     |           |
#     +---------------+   yazi    |
#     |   PR Webview  |  →nvim    |
#     +---------------+-----------+
#
#     タブ (Workspace title):  ✓ PR #200 (3/3)   [Green]
#                              … PR #200 (1 running)  [Amber]
#                              ✗ PR #200 (1/3 fail)   [Red]

# バックグラウンドで CI ステータスを取得し、Workspace のタイトルと色を更新する
# ワーカー。cmux-pr から disown で起動される。全チェックが確定したら自動終了。
cmux-pr-status-loop() {
  emulate -L zsh
  setopt local_options no_err_return

  local ws="$1"
  local pr="$2"
  local interval="${3:-30}"
  local prefix="PR #${pr}"

  while :; do
    local json total pass fail pending title color
    json=$(gh pr checks "$pr" --json bucket 2>/dev/null)
    if [[ -z "$json" ]]; then
      sleep "$interval"
      continue
    fi

    total=$(print -r -- "$json" | jq 'length')
    pass=$(print -r -- "$json" | jq '[.[] | select(.bucket=="pass" or .bucket=="skipping")] | length')
    fail=$(print -r -- "$json" | jq '[.[] | select(.bucket=="fail" or .bucket=="cancel")] | length')
    pending=$(print -r -- "$json" | jq '[.[] | select(.bucket=="pending")] | length')

    if (( total == 0 )); then
      title="${prefix} (no checks)"; color="Charcoal"
    elif (( fail > 0 )); then
      title="✗ ${prefix} (${fail}/${total} fail)"; color="Red"
    elif (( pending > 0 )); then
      title="… ${prefix} (${pending}/${total} running)"; color="Amber"
    else
      title="✓ ${prefix} (${pass}/${total})"; color="Green"
    fi

    cmux workspace-action --workspace "$ws" --action rename --title "$title" \
      >/dev/null 2>&1 || break
    cmux workspace-action --workspace "$ws" --action set-color --color "$color" \
      >/dev/null 2>&1 || break

    # pending がなくなった = CI が確定したのでループ終了
    (( pending == 0 )) && break

    sleep "$interval"
  done
}

cmux-pr() {
  emulate -L zsh
  # err_return は使わない。各所で明示的に失敗を判定する。
  setopt local_options pipefail

  local pr="$1"
  if [[ -z "$pr" ]]; then
    print -u2 "usage: cmux-pr <pr-number-or-url>"
    return 1
  fi

  if [[ -z "$CMUX_SURFACE_ID" || -z "$CMUX_WORKSPACE_ID" ]]; then
    print -u2 "cmux-pr: cmux ターミナルの中から実行してください"
    return 1
  fi

  local dep
  for dep in cmux gh git jq yazi lazygit; do
    if ! command -v "$dep" >/dev/null 2>&1; then
      print -u2 "cmux-pr: $dep が見つかりません"
      return 1
    fi
  done

  local repo_root
  repo_root=$(git rev-parse --show-toplevel 2>/dev/null) || {
    print -u2 "cmux-pr: git リポジトリの中で実行してください"
    return 1
  }

  local pr_json pr_url pr_number
  pr_json=$(gh pr view "$pr" --json url,number 2>/dev/null) || {
    print -u2 "cmux-pr: PR '$pr' の情報を取得できませんでした"
    return 1
  }
  pr_url=$(print -r -- "$pr_json" | jq -r '.url')
  pr_number=$(print -r -- "$pr_json" | jq -r '.number')

  local lg_surface="$CMUX_SURFACE_ID"
  local ws="$CMUX_WORKSPACE_ID"

  # 右 → yazi 用ターミナル
  local yazi_surface
  yazi_surface=$(
    cmux rpc pane.create "$(jq -cn --arg s "$lg_surface" \
      '{type:"terminal",direction:"right",surface:$s}')" \
      | jq -r '.surface_ref'
  )
  if [[ -z "$yazi_surface" || "$yazi_surface" == "null" ]]; then
    print -u2 "cmux-pr: yazi ペインの作成に失敗しました"; return 1
  fi

  # 左下 → PR Webview
  cmux rpc pane.create "$(jq -cn --arg s "$lg_surface" --arg u "$pr_url" \
    '{type:"browser",direction:"down",surface:$s,url:$u}')" >/dev/null 2>&1
  if (( $? != 0 )); then
    print -u2 "cmux-pr: Webview ペインの作成に失敗しました"; return 1
  fi

  # CI ステータス監視をバックグラウンドで起動（lazygit で shell を exec しても
  # 生き残るよう &! で disown する）
  (cmux-pr-status-loop "$ws" "$pr_number" 30) >/dev/null 2>&1 &!

  # 新しいペインの shell 起動が落ち着くまで待つ
  sleep 2

  # yazi を起動。Enter で $EDITOR (=nvim) が開く。
  cmux send --surface "$yazi_surface" "cd ${(q)repo_root} && yazi" || true
  cmux send-key --surface "$yazi_surface" enter || true

  # 自分のペイン（左上）で lazygit を起動。`cmux send` で自分に送ると
  # prompt タイミングに依存するため、直接 exec に置き換える。
  cd "$repo_root" 2>/dev/null || true
  exec lazygit --path "$repo_root"
}
