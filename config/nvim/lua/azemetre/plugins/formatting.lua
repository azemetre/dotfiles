local M = {}

---@param opts conform.setupOpts
function M.setup(_, opts)
	for _, key in ipairs({ "format_on_save", "format_after_save" }) do
		if opts[key] then
			---@diagnostic disable-next-line: no-unknown
			opts[key] = nil
		end
	end
	require("conform").setup(opts)
end

return {
	-- #core #lsp #linting
	{
		"stevearc/conform.nvim",
		lazy = true,
		cmd = "ConformInfo",
		keys = {
			{
				"<leader>cF",
				function()
					require("conform").format({
						formatters = { "injected" },
						timeout_ms = 3000,
					})
				end,
				mode = { "n", "v" },
				desc = "Format Injected Langs",
			},
		},
		init = function()
			-- Set up autocommand for formatting on save
			vim.api.nvim_create_autocmd("User", {
				pattern = "VeryLazy",
				callback = function()
					-- Set up format on save
					vim.api.nvim_create_autocmd("BufWritePre", {
						group = vim.api.nvim_create_augroup(
							"ConformFormat",
							{ clear = true }
						),
						callback = function(args)
							require("conform").format({
								bufnr = args.buf,
								timeout_ms = 3000,
								quiet = false,
								lsp_format = "fallback",
							})
						end,
					})

					-- Create manual format command
					vim.api.nvim_create_user_command("Format", function()
						require("conform").format({
							timeout_ms = 3000,
							quiet = false,
							lsp_format = "fallback",
						})
					end, { desc = "Format current buffer with `conform.nvim`" })
				end,
			})
		end,
		opts = function()
			---@type conform.setupOpts
			local opts = {
				default_format_opts = {
					timeout_ms = 3000,
					async = false, -- not recommended to change
					quiet = false, -- not recommended to change
					lsp_format = "fallback", -- not recommended to change
				},
				formatters_by_ft = {
					javascript = { "biome", "prettier" },
					typescript = { "biome", "prettier" },
					typescriptreact = { "biome", "prettier" },
					lua = { "stylua" },
					sh = { "shfmt" },
				},
				-- The options you set here will be merged with the builtin formatters.
				-- You can also define any custom formatters here.
				---@type table<string, conform.FormatterConfigOverride|fun(bufnr: integer): nil|conform.FormatterConfigOverride>
				formatters = {
					injected = { options = { ignore_errors = true } },
					-- # Example of using dprint only when a dprint.json file is present
					-- dprint = {
					--   condition = function(ctx)
					--     return vim.fs.find({ "dprint.json" }, { path = ctx.filename, upward = true })[1]
					--   end,
					-- },
					--
					-- # Example of using shfmt with extra args
					-- shfmt = {
					--   prepend_args = { "-i", "2", "-ci" },
					-- },
				},
			}
			return opts
		end,
		config = M.setup,
	},
}
