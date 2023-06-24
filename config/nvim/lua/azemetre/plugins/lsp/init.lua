return {
	-- lspconfig
	{
		"neovim/nvim-lspconfig",
		event = "BufReadPre",
		dependencies = {
			{ "folke/neoconf.nvim", cmd = "Neoconf", config = true },
			{ "folke/neodev.nvim", config = true },
			"mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"hrsh7th/cmp-nvim-lsp",
		},
		---@class PluginLspOpts
		opts = {
			---@type lspconfig.options
			servers = {
				jsonls = {},
				lua_ls = {
					settings = {
						Lua = {
							diagnostics = {
								globals = { "vim" },
							},
							workspace = {
								checkThirdParty = false,
							},
							completion = {
								callSnippet = "Replace",
							},
						},
					},
				},
				stylelint_lsp = {
					filetypes = { "css", "less", "scss" },
				},
				gopls = {
					settings = {
						gopls = {
							staticcheck = true,
						},
					},
				},
			},
			-- you can do any additional lsp server setup here
			-- return true if you don't want this server to be setup with lspconfig
			---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
			setup = {
				-- example to setup with typescript.nvim
				-- tsserver = function(_, opts)
				--   require("typescript").setup({ server = opts })
				--   return true
				-- end,
				-- Specify * to use this function as a fallback for any server
				-- ["*"] = function(server, opts) end,
			},
		},
		---@param opts PluginLspOpts
		config = function(plugin, opts)
			local _border = "rounded"

			vim.lsp.handlers["textDocument/hover"] =
				vim.lsp.with(vim.lsp.handlers.hover, {
					border = _border,
				})

			vim.lsp.handlers["textDocument/signatureHelp"] =
				vim.lsp.with(vim.lsp.handlers.signature_help, {
					border = _border,
				})

			vim.diagnostic.config({
				float = { border = _border },
			})

			if plugin.servers then
				require("azemetre.util").deprecate(
					"lspconfig.servers",
					"lspconfig.opts.servers"
				)
			end
			if plugin.setup_server then
				require("azemetre.util").deprecate(
					"lspconfig.setup_server",
					"lspconfig.opts.setup[SERVER]"
				)
			end

			-- setup formatting and keymaps
			require("azemetre.util").on_attach(function(client, buffer)
				require("azemetre.plugins.lsp.format").on_attach(client, buffer)
				require("azemetre.plugins.lsp.keymaps").on_attach(client, buffer)
			end)

			-- diagnostics
			for name, icon in
				pairs(require("azemetre.config.settings").icons.diagnostics)
			do
				name = "DiagnosticSign" .. name
				vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
			end
			vim.diagnostic.config({
				underline = true,
				update_in_insert = false,
				virtual_text = { spacing = 4, prefix = "●" },
				severity_sort = true,
			})

			local servers = opts.servers
			local capabilities = require("cmp_nvim_lsp").default_capabilities(
				vim.lsp.protocol.make_client_capabilities()
			)

			require("mason-lspconfig").setup({
				ensure_installed = vim.tbl_keys(servers),
			})
			require("mason-lspconfig").setup_handlers({
				function(server)
					local server_opts = servers[server] or {}
					server_opts.capabilities = capabilities
					if opts.setup[server] then
						if opts.setup[server](server, server_opts) then
							return
						end
					elseif opts.setup["*"] then
						if opts.setup["*"](server, server_opts) then
							return
						end
					end
					require("lspconfig")[server].setup(server_opts)
				end,
			})
		end,
	},

	-- formatters
	{
		"jose-elias-alvarez/null-ls.nvim",
		event = "BufReadPre",
		dependencies = { "mason.nvim" },
		opts = function()
			local nls = require("null-ls")
			return {
				sources = {
					nls.builtins.formatting.prettier,
					nls.builtins.formatting.stylua,
					nls.builtins.diagnostics.eslint.with({
						condition = function(utils)
							return utils.has_file({ ".eslintrc.*" })
						end,
					}),
				},
			}
		end,
	},

	-- cmdline tools and lsp servers
	{
		"williamboman/mason.nvim",
		cmd = "Mason",
		keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
		ensure_installed = {
			"awk-language-server",
			"angular-language-server",
			"ansible-language-server",
			"astro-language-server",
			"bash-language-server",
			"bash-debug-adapter",
			"chrome-debug-adapter",
			"commitlint",
			"cspell",
			"css-lsp",
			"dockerfile-language-server",
			"editorconfig-checker",
			"elixir-ls",
			"eslint-lsp",
			"firefox-debug-adapter",
			"fixjson",
			"go-debug-adapter",
			"goimports",
			"gopls",
			"gotests",
			"gotestsum",
			"html-lsp",
			"json-lsp",
			"kotlin-debug-adapter",
			"kotlin-language-server",
			"ktlint",
			"ltex-ls",
			"lua-language-server",
			"marksman",
			"nginx-language-server",
			"ocaml-lsp",
			"ocamlformat",
			"php-cs-fixer",
			"php-debug-adapter",
			"prettier",
			"prisma-language-server",
			"proselint",
			"puppet-editor-services",
			"rust-analyzer",
			"rustfmt",
			"shellcheck",
			"sql-formatter",
			"sqlls",
			"staticcheck", -- go linter
			"stylelint-lsp",
			"stylua",
			"svelte-language-server",
			"taplo",
			"terraform-ls",
			"typescript-language-server",
			"vim-language-server",
			"lemminx",
			"yaml-language-server",
			"yamlfmt",
			"yamllint",
		},
		---@param opts MasonSettings
		config = function(self, opts)
			require("mason").setup(opts)
			local mr = require("mason-registry")
			for _, tool in ipairs(self.ensure_installed) do
				local p = mr.get_package(tool)
				if not p:is_installed() then
					p:install()
				end
			end
		end,
	},
}
