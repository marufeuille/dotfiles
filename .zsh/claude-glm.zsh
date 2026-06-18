# GLM (z.ai) のエンドポイント経由で claude を起動するヘルパー
# APIキーは ~/.zsh/secrets.zsh の $GLM_API_KEY を参照（このファイルにキーは書かない）

claude-glm() {
  if [[ -z "$GLM_API_KEY" || "$GLM_API_KEY" == "YOUR_NEW_GLM_API_KEY" ]]; then
    echo "claude-glm: GLM_API_KEY が未設定です。~/.zsh/secrets.zsh を確認してください。" >&2
    return 1
  fi

  ANTHROPIC_BASE_URL="https://api.z.ai/api/anthropic" \
  ANTHROPIC_AUTH_TOKEN="$GLM_API_KEY" \
  API_TIMEOUT_MS="3000000" \
  ANTHROPIC_DEFAULT_OPUS_MODEL="glm-4.5-air" \
  ANTHROPIC_DEFAULT_SONNET_MODEL="GLM-5.2[1m]" \
  CLAUDE_CODE_AUTO_COMPACT_WINDOW="1000000" \
  claude "$@"
}
