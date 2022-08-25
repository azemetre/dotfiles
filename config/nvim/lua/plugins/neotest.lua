local neotest = require("neotest")

neotest.setup({
    status = {
      virtual_text = true,
      signs = true,
    },
    strategies = {
      integrated = {
        width = 180,
      },
    },
    adapters = {
      require("neotest-go"),
      require("neotest-vim-test")({
        allow_file_types = { "rust", "javascript", "typescript" },
      }),
    },
})
