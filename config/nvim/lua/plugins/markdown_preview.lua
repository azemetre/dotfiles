-- #ui #docs #markdown #notes #documentation
-- cross platform markdown server, also supports: KaTeX, PlantUML, Mermaid,
-- Chart.js, js-sequence-diagrams, Flowchart, viz-js
---@type Utils.Pack.Spec
return {
	src = "https://github.com/iamcco/markdown-preview.nvim",
	defer = true,
	config = function()
		if vim.fn.executable("markdown-preview-nvim") == 0 then
			vim.fn["mkdp#util#install"]()
		end
	end,
}
