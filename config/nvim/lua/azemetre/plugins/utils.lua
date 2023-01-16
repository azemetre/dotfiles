return {

  -- measure startuptime
  {
    "dstein64/vim-startuptime",
    cmd = "StartupTime",
    config = function()
      vim.g.startuptime_tries = 10
    end,
  },

  -- session management
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = { options = { "buffers", "curdir", "tabpages", "winsize", "help" } },
        -- stylua: ignore
    keys = {
        { "<leader>qs", function() require("persistence").load() end, desc = "Restore Session" },
        { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
        { "<leader>qd", function() require("persistence").stop() end, desc = "Don't Save Current Session" },
    },
  },

  -- fugitive - git workflow
  {
    "tpope/vim-fugitive",
    keys = {
      { "<leader>Fq", ":q<CR>", desc = "Close Fugitive" },
      { "<leader>FF", ":G<CR>", desc = "Git Status" },
      { "<leader>Fb", ":G blame<CR>", desc = "Git Blame" },
      { "<leader>Fp", ":G push<CR>", desc = "Git Push" },
    },
  },

  -- markdown preview
  {
    "iamcco/markdown-preview.nvim",
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
  },

  -- library used by other plugins
  "nvim-lua/plenary.nvim",
}
