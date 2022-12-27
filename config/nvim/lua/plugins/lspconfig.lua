local utils = require("utils")
local util = require("lspconfig.util")
local lsp_installer = require("nvim-lsp-installer")
local nvim_lsp = require("lspconfig")
local lsp_format = require("lsp-format")
local nmap = utils.nmap
local imap = utils.imap
local cmd = vim.cmd
local vo = vim.o
local api = vim.api
local fn = vim.fn
local lsp = vim.lsp
local theme = require("theme")
local colors = theme.colors
local icons = theme.icons

local border = {
    { "🭽", "FloatBorder" },
    { "▔", "FloatBorder" },
    { "🭾", "FloatBorder" },
    { "▕", "FloatBorder" },
    { "🭿", "FloatBorder" },
    { "▁", "FloatBorder" },
    { "🭼", "FloatBorder" },
    { "▏", "FloatBorder" },
}

local format_async = function(err, _, result, _, bufnr)
    if err ~= nil or result == nil then
        return
    end
    if not api.nvim_buf_get_option(bufnr, "modified") then
        local view = fn.winsaveview()
        lsp.util.apply_text_edits(result, bufnr)
        fn.winrestview(view)
        if bufnr == api.nvim_get_current_buf() then
            api.nvim_command("noautocmd :update")
        end
    end
end

lsp.handlers["textDocument/formatting"] = format_async

-- _G makes this function available to vimscript lua calls
_G.lsp_organize_imports = function()
    local params = {
        command = "_typescript.organizeImports",
        arguments = { api.nvim_buf_get_name(0) },
        title = "",
    }
    lsp.buf.execute_command(params)
end

-- show diagnostic line with custom border and styling
_G.lsp_show_diagnostics = function()
    vim.diagnostic.open_float({ border = border })
end

local on_attach = function(client, bufnr)
    lsp_format.on_attach(client)
    cmd([[command! LspDef lua vim.lsp.buf.definition()]])
    cmd([[command! LspFormatting lua vim.lsp.buf.format({async = true})]])
    cmd([[command! LspCodeAction lua vim.lsp.buf.code_action()]])
    cmd([[command! LspHover lua vim.lsp.buf.hover()]])
    cmd([[command! LspRename lua vim.lsp.buf.rename()]])
    cmd([[command! LspOrganize lua lsp_organize_imports()]])
    cmd([[command! OR lua lsp_organize_imports()]])
    cmd([[command! LspRefs lua vim.lsp.buf.references()]])
    cmd([[command! LspTypeDef lua vim.lsp.buf.type_definition()]])
    cmd([[command! LspImplementation lua vim.lsp.buf.implementation()]])
    cmd([[command! LspDiagPrev lua vim.diagnostic.goto_prev()]])
    cmd([[command! LspDiagNext lua vim.diagnostic.goto_next()]])
    cmd([[command! LspDiagLine lua lsp_show_diagnostics()]])
    cmd([[command! LspSignatureHelp lua vim.lsp.buf.signature_help()]])
    -- highlight errors on cursor position in floating window

    lsp.handlers["textDocument/hover"] = lsp.with(lsp.handlers.hover, { border = border })
    lsp.handlers["textDocument/signatureHelp"] = lsp.with(lsp.handlers.hover, { border = border })

    nmap("gd", ":LspDef<CR>", { bufnr = bufnr })
    nmap("gR", ":LspRename<CR>", { bufnr = bufnr })
    nmap("gr", ":LspRefs<CR>", { bufnr = bufnr })
    nmap("gt", ":LspTypeDef<CR>", { bufnr = bufnr })
    nmap("K", ":LspHover<CR>", { bufnr = bufnr })
    nmap("gs", ":LspOrganize<CR>", { bufnr = bufnr })
    nmap("gf", ":LspDiagNext<CR>", { bufnr = bufnr })
    nmap("gb", ":LspDiagPrev<CR>", { bufnr = bufnr })
    nmap("ga", ":LspCodeAction<CR>", { bufnr = bufnr })
    nmap("<Leader>a", ":LspDiagLine<CR>", { bufnr = bufnr })
    nmap("<Leader>LR", ":LspRestart<CR>", { bufnr = bufnr })
    nmap("<Leader>LS", ":LspStart<CR>", { bufnr = bufnr })
    nmap("ge", ":lua vim.diagnostic.open_float(nil, {focus=false, scope='line'})<CR>")
    imap("<C-x><C-x>", ":LspSignatureHelp<CR>", { bufnr = bufnr })

    if client.server_capabilities.documentHighlightProvider then
        api.nvim_exec(
            [[
    augroup lsp_document_highlight
      autocmd! * <buffer>
      autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
      autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
    augroup END
    ]]       ,
            false
        )
    end

    -- disable document formatting (currently handled by formatter.nvim)
    client.server_capabilities.documentHighlightProvider = true

    if client.server_capabilities.document_formatting then
        api.nvim_exec(
            [[
        augroup LspAutocommands
        autocmd! * <buffer>
        augroup END
      ]]     ,
            true
        )
    end
end

local diagnosticls_settings = {
    filetypes = {
        "sh",
    },
    init_options = {
        linters = {
            shellcheck = {
                sourceName = "shellcheck",
                command = "shellcheck",
                debounce = 100,
                args = { "--format=gcc", "-" },
                offsetLine = 0,
                offsetColumn = 0,
                formatLines = 1,
                formatPattern = {
                    "^[^:]+:(\\d+):(\\d+):\\s+([^:]+):\\s+(.*)$",
                    { line = 1, column = 2, message = 4, security = 3 },
                },
                securities = { error = "error", warning = "warning", note = "info" },
            },
        },
        filetypes = {
            sh = "shellcheck",
        },
    },
}

local lua_settings = {
    Lua = {
        runtime = {
            -- LuaJIT in the case of Neovim
            version = "LuaJIT",
            path = vim.split(package.path, ";"),
        },
        diagnostics = {
            -- Get the language server to recognize the `vim` global
            globals = { "vim", "require" },
        },
        workspace = {
            -- Make the server aware of Neovim runtime files
            library = {
                [fn.expand("$VIMRUNTIME/lua")] = true,
                [fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
            },
        },
    },
}

local function make_config()
    local capabilities = lsp.protocol.make_client_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    capabilities.textDocument.completion.completionItem.resolveSupport = {
        properties = {
            "documentation",
            "detail",
            "additionalTextEdits",
        },
    }
    capabilities.textDocument.colorProvider = { dynamicRegistration = false }

    return {
        capabilities = capabilities,
        on_attach = on_attach,
    }
end

lsp_installer.setup({
    ensure_installed = {
        "ansiblels",
        "awk_ls",
        "bashls",
        "cmake",
        "cssls",
        "dockerls",
        "emmet_ls",
        "eslint",
        "gopls",
        "html",
        "kotlin_language_server",
        "lemminx",
        "marksman",
        "rust_analyzer",
        "sqlls",
        "sumneko_lua",
        "svelte",
        "tsserver",
        "tailwindcss",
        "vimls",
        "yamlls",
    },

    automatic_installation = true,

    ui = {
        -- Whether to automatically check for outdated servers when opening the UI window.
        check_outdated_servers_on_open = true,

        -- The border to use for the UI window. Accepts same border values as |nvim_open_win()|.
        border = "solid",

        icons = {
            server_installed = "✓",
            server_pending = "➜",
            server_uninstalled = "✗", -- The list icon to use for installed servers.
        },
        keymaps = {
            -- Keymap to expand a server in the UI
            toggle_server_expand = "<CR>",
            -- Keymap to install the server under the current cursor position
            install_server = "i",
            -- Keymap to reinstall/update the server under the current cursor position
            update_server = "u",
            -- Keymap to check for new version for the server under the current cursor position
            check_server_version = "c",
            -- Keymap to update all installed servers
            update_all_servers = "U",
            -- Keymap to check which installed servers are outdated
            check_outdated_servers = "C",
            -- Keymap to uninstall a server
            uninstall_server = "X",
        },
    },

    -- Controls to which degree logs are written to the log file. It's useful to set this to vim.log.levels.DEBUG when
    -- debugging issues with server installations.
    log_level = vim.log.levels.INFO,

    max_concurrent_installers = 4,
})

nvim_lsp.ansiblels.setup({
    on_attach = make_config().on_attach,
    capabilities = make_config().capabilities,
})

nvim_lsp.awk_ls.setup({
    on_attach = make_config().on_attach,
    capabilities = make_config().capabilities,
})

nvim_lsp.bashls.setup({
    on_attach = make_config().on_attach,
    capabilities = make_config().capabilities,
})

nvim_lsp.cmake.setup({
    on_attach = make_config().on_attach,
    capabilities = make_config().capabilities,
})

nvim_lsp.cssls.setup({
    on_attach = make_config().on_attach,
    capabilities = make_config().capabilities,
})

nvim_lsp.dockerls.setup({
    on_attach = make_config().on_attach,
    capabilities = make_config().capabilities,
})

nvim_lsp.emmet_ls.setup({
    filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less" },
})

nvim_lsp.gopls.setup({
    on_attach = make_config().on_attach,
    capabilities = make_config().capabilities,
    cmd = { "gopls", "serve" },
    filetypes = { "go", "gomod" },
    root_dir = util.root_pattern("go.work", "go.mod", ".git"),
    settings = {
        gopls = {
            analyses = {
                unusedparams = true,
            },
            staticcheck = true,
        },
    },
})

nvim_lsp.html.setup({
    on_attach = make_config().on_attach,
    capabilities = make_config().capabilities,
})

nvim_lsp.kotlin_language_server.setup({})

nvim_lsp.lemminx.setup({
    on_attach = make_config().on_attach,
    capabilities = make_config().capabilities,
})

nvim_lsp.marksman.setup({
    on_attach = make_config().on_attach,
    capabilities = make_config().capabilities,
})

-- nvim_lsp.rust_analyzer.setup({
--     on_attach = make_config().on_attach,
--     capabilities = make_config().capabilities,
--     settings = {
--         -- to enable rust-analyzer settings visit:
--         -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
--         ["rust-analyzer"] = {
--             -- enable clippy diagnostics on save
--             checkOnSave = {
--                 command = "clippy",
--             },
--         },
--     },
-- })

nvim_lsp.sqlls.setup({
    on_attach = make_config().on_attach,
    capabilities = make_config().capabilities,
})

nvim_lsp.sumneko_lua.setup({
    on_attach = make_config().on_attach,
    capabilities = make_config().capabilities,
    settings = {
        Lua = {
            diagnostics = {
                globals = { "vim" },
            },
        },
    },
})

nvim_lsp.svelte.setup({
    on_attach = make_config().on_attach,
    capabilities = make_config().capabilities,
})

nvim_lsp.tsserver.setup({
    on_attach = make_config().on_attach,
    capabilities = make_config().capabilities,
})

-- nvim_lsp.tailwindcss.setup({})

nvim_lsp.vimls.setup({
    on_attach = make_config().on_attach,
    capabilities = make_config().capabilities,
})

nvim_lsp.yamlls.setup({
    on_attach = make_config().on_attach,
    capabilities = make_config().capabilities,
})

-- set up custom symbols for LSP errors
local signs = {
    Error = icons.error,
    Warning = icons.warning,
    Warn = icons.warning,
    Hint = icons.hint,
    Info = icons.info,
}
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl })
end

lsp_format.setup({
    -- not necessary with prettier workflow
    -- typescript = { tab_width = 2 },
    -- javascript = { tab_width = 2 },
    yaml = { tab_width = 2 },
})
-- may not need prettier
local prettier = {
    formatCommand = [[prettier --stdin-filepath ${INPUT} ${--tab-width:tab_width}]],
    formatStdin = true,
}

-- Set colors for completion items
cmd("highlight! CmpItemAbbrMatch guibg=NONE guifg=" .. colors.lightblue)
cmd("highlight! CmpItemAbbrMatchFuzzy guibg=NONE guifg=" .. colors.lightblue)
cmd("highlight! CmpItemKindFunction guibg=NONE guifg=" .. colors.magenta)
cmd("highlight! CmpItemKindMethod guibg=NONE guifg=" .. colors.magenta)
cmd("highlight! CmpItemKindVariable guibg=NONE guifg=" .. colors.blue)
cmd("highlight! CmpItemKindKeyword guibg=NONE guifg=" .. colors.fg)
