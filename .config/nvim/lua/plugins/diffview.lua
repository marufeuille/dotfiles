-- diffview.nvim: PR レビュー用にファイル一覧＋左右 diff を出す
-- 使い方:
--   :DiffviewOpen                     カレントブランチ vs index/HEAD
--   :DiffviewOpen origin/main...HEAD  PR 全体の差分
--   :DiffviewFileHistory %            今開いているファイルの履歴
--   :DiffviewClose                    閉じる
return {
  {
    "sindrets/diffview.nvim",
    cmd = {
      "DiffviewOpen",
      "DiffviewClose",
      "DiffviewToggleFiles",
      "DiffviewFocusFiles",
      "DiffviewRefresh",
      "DiffviewFileHistory",
    },
    keys = {
      { "<leader>gdd", "<cmd>DiffviewOpen<cr>", desc = "Diffview open" },
      { "<leader>gdp", "<cmd>DiffviewOpen origin/main...HEAD<cr>", desc = "Diffview PR (vs origin/main)" },
      { "<leader>gdh", "<cmd>DiffviewFileHistory %<cr>", desc = "Diffview file history" },
      { "<leader>gdc", "<cmd>DiffviewClose<cr>", desc = "Diffview close" },
    },
  },
}
