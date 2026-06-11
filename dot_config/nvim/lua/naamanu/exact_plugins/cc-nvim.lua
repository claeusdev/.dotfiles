-- cc-nvim: my own Neovim plugin (github.com/nmanu-dev/cc-nvim).
-- Use the local checkout at ~/projects/cc-nvim when it exists (live dev),
-- otherwise lazy clones it from GitHub. lazy's default dev.path is ~/projects,
-- so `dev = true` resolves to ~/projects/cc-nvim with no explicit `dir`.
local local_checkout = vim.fn.expand("~/projects/cc-nvim")

return {
  "nmanu-dev/cc-nvim",
  dev = vim.uv.fs_stat(local_checkout) ~= nil,
  lazy = true,
  dependencies = { "folke/snacks.nvim" },
  cmd = {
    "CcToggle", "CcSplit", "CcFloat", "CcResume", "CcSessions", "CcSend", "CcMention",
    "CcExplain", "CcWalk", "CcIdiomatic", "CcCritique", "CcDiag", "CcDiff",
    "CcQuiz", "CcPrompt", "CcNote", "CcNotes", "CcQuizMe",
    "CcCommit", "CcReview", "CcPR",
    "CcAsk", "CcMentionSymbol", "CcMentionFiles",
  },
  keys = {
    { "<leader>aa", function() require("cc-nvim").toggle() end,       desc = "Claude: toggle (right)" },
    { "<leader>aA", function() require("cc-nvim").split() end,        desc = "Claude: toggle bottom split" },
    { "<leader>af", function() require("cc-nvim").float() end,        desc = "Claude: toggle float" },
    { "<leader>as", function() require("cc-nvim").send_visual() end,  mode = "x", desc = "Claude: send selection" },
    { "<leader>am", function() require("cc-nvim").mention_file() end, desc = "Claude: @file" },
    { "<leader>ar", function() require("cc-nvim").resume() end,       desc = "Claude: --resume" },
    { "<leader>al", function() require("cc-nvim").pick_session() end, desc = "Claude: sessions" },

    { "<leader>ae", function() require("cc-nvim").explain() end,      mode = { "n", "x" }, desc = "Claude: explain" },
    { "<leader>aw", function() require("cc-nvim").walk_through() end, mode = { "n", "x" }, desc = "Claude: walk through" },
    { "<leader>ai", function() require("cc-nvim").idiomatic() end,    mode = { "n", "x" }, desc = "Claude: idiomatic" },
    { "<leader>ac", function() require("cc-nvim").critique() end,     mode = { "n", "x" }, desc = "Claude: critique" },
    { "<leader>ad", function() require("cc-nvim").diag() end,         desc = "Claude: explain diagnostic" },
    { "<leader>aD", function() require("cc-nvim").diff() end,         desc = "Claude: explain git diff" },
    { "<leader>aq", function() require("cc-nvim").quiz() end,         mode = { "n", "x" }, desc = "Claude: quiz me on this" },
    { "<leader>ap", function() require("cc-nvim").prompt_picker() end, desc = "Claude: prompt picker" },
    { "<leader>an", function() require("cc-nvim").note() end,         desc = "Claude: save note" },
    { "<leader>aN", function() require("cc-nvim").open_notes() end,   desc = "Claude: open notes" },
    { "<leader>aQ", function() require("cc-nvim").quiz_me() end,      desc = "Claude: quiz me from notes" },

    { "<leader>agc", function() require("cc-nvim").commit_msg() end,     desc = "Claude: commit message" },
    { "<leader>agr", function() require("cc-nvim").review_staged() end,  desc = "Claude: review staged" },
    { "<leader>agp", function() require("cc-nvim").pr_description() end, desc = "Claude: PR description" },

    { "<leader>a?", function() require("cc-nvim").ask() end,             desc = "Claude: quick ask" },
    { "<leader>aS", function() require("cc-nvim").mention_symbol() end,  desc = "Claude: @-mention symbol definition" },
    { "<leader>aM", function() require("cc-nvim").mention_files() end,   desc = "Claude: @-mention multiple files" },
  },
  opts = {},
  config = function(_, opts) require("cc-nvim").setup(opts) end,
}
