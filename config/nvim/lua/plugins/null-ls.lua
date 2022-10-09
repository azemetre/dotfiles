local null_ls = require("null-ls")

-- null_ls.setup({
--     on_attach = function(client, bufnr)
--         if client.server_capabilities.documentFormattingProvider then
--             vim.cmd("nnoremap <silent><buffer> <Leader>p :lua vim.lsp.buf.formatting()<CR>")

--             -- format on save
--             vim.cmd("autocmd BufWritePost <buffer> lua vim.lsp.buf.formatting()")
--         end

--         if client.server_capabilities.documentRangeFormattingProvider then
--             vim.cmd("xnoremap <silent><buffer> <Leader>p :lua vim.lsp.buf.range_formatting({})<CR>")
--         end
--     end,
--     sources = {
--         null_ls.builtins.formatting.stylua,
--         null_ls.builtins.diagnostics.eslint,
--         null_ls.builtins.code_actions.eslint,
--         null_ls.builtins.formatting.prettier,
--         -- null_ls.builtins.completion.spell,
--     },
-- })
