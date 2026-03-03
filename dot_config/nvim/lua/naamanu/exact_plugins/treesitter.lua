return {
  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      ensure_installed = {
        "c",
        "cpp",
        "rust",
        "python",
        "ocaml",
        "ocaml_interface",
        "haskell",
        "racket",
        "scheme",
        "commonlisp",
        "nix",
        "lean",
        "lua",
        "vim",
        "vimdoc",
        "bash",
        "json",
        "yaml",
        "toml",
        "markdown",
        "markdown_inline",
        "latex",
        "ruby",
        "typescript",
        "tsx",
        "javascript",
        "html",
        "css",
        "graphql",
        "dockerfile",
      },
      highlight = { enable = true },
      indent = { enable = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
    },
    config = function(_, opts)
      require("nvim-treesitter").setup(opts)
    end,
  },

  -- Treesitter text objects (new API)
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("nvim-treesitter-textobjects").setup {
        select = { lookahead = true },
        move = { set_jumps = true },
      }

      -- select
      vim.keymap.set({ "x", "o" }, "af", function()
        require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects")
      end)
      vim.keymap.set({ "x", "o" }, "if", function()
        require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects")
      end)
      vim.keymap.set({ "x", "o" }, "ac", function()
        require("nvim-treesitter-textobjects.select").select_textobject("@class.outer", "textobjects")
      end)
      vim.keymap.set({ "x", "o" }, "ic", function()
        require("nvim-treesitter-textobjects.select").select_textobject("@class.inner", "textobjects")
      end)

      -- move
      vim.keymap.set({ "n", "x", "o" }, "]f", function()
        require("nvim-treesitter-textobjects.move").goto_next_start("@function.outer", "textobjects")
      end)
      vim.keymap.set({ "n", "x", "o" }, "]c", function()
        require("nvim-treesitter-textobjects.move").goto_next_start("@class.outer", "textobjects")
      end)
      vim.keymap.set({ "n", "x", "o" }, "[f", function()
        require("nvim-treesitter-textobjects.move").goto_previous_start("@function.outer", "textobjects")
      end)
      vim.keymap.set({ "n", "x", "o" }, "[c", function()
        require("nvim-treesitter-textobjects.move").goto_previous_start("@class.outer", "textobjects")
      end)
    end,
  },

  -- Auto-close/rename HTML and JSX tags
  {
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
    opts = {},
  },

  -- Treesitter context (sticky headers)
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      max_lines = 3,
    },
  },
}
