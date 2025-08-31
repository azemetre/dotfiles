---@class Utils.Pack.Spec : vim.pack.Spec
---@field config function?
---@field defer boolean?
---@field dependencies Utils.Pack.Spec[]?

local pack = {
	---@type vim.pack.keyset.add
	add_options = { confirm = false },
	---@type vim.pack.keyset.update
	update_options = { force = true },
}
---@type Utils.Pack.Spec[], string[]
local cached_specs, cached_names
local utils_shared = require("utils.shared")

---@return Utils.Pack.Spec[], string[]
local function get_specs_and_names()
    if cached_specs and cached_names then
        return cached_specs, cached_names
    end

    local plugin_files = vim.fn.glob(utils_shared.config_path .. "/lua/plugins/*.lua", true, true)
    ---@type Utils.Pack.Spec[], string[]
    local specs, names = {}, {}

    for _, file in ipairs(plugin_files) do
        local plugin_name = vim.fn.fnamemodify(file, ":t:r")
        local ok, spec_or_err = pcall(require, "plugins." .. plugin_name)

        if not ok then
            vim.notify("ERROR requiring plugin module '" .. plugin_name .. "': " .. spec_or_err, vim.log.levels.ERROR)
            goto continue
        end

        -- Check if the main spec is valid
        if type(spec_or_err) ~= "table" or not spec_or_err.src then
            vim.notify("ERROR: Plugin '" .. plugin_name .. "' must return a table with an 'src' field.", vim.log.levels.ERROR)
            goto continue
        end

        -- Handle dependencies FIRST
        if spec_or_err.dependencies then
            for i, dep in ipairs(spec_or_err.dependencies) do
                -- Validate the dependency spec
                if type(dep) ~= "table" or not dep.src then
                    vim.notify("ERROR: Dependency #" .. i .. " in plugin '" .. plugin_name .. "' is invalid. It must be a table with an 'src' field.", vim.log.levels.ERROR)
                    goto continue_outer -- This is a severe error in the main plugin spec
                end
                specs[#specs + 1] = dep
                names[#names + 1] = vim.fn.fnamemodify(dep.src, ":t")
            end
        end

        -- Then add the main plugin spec
        specs[#specs + 1] = spec_or_err
        names[#names + 1] = vim.fn.fnamemodify(spec_or_err.src, ":t")

        ::continue_outer::
        ::continue::
    end

    -- DEBUG: Print all specs to verify before returning
    -- print(vim.inspect(specs))
    cached_specs, cached_names = specs, names

    return specs, names
end

---@param spec Utils.Pack.Spec
local function handle_build(spec)
	if not spec.data or spec.data.build:is_null_or_whitespace() then
		return
	end

	local plugin_name = vim.fn.fnamemodify(spec.src, ":t")
	---@type string
	local plugin_path = utils_shared.data_path .. utils_shared.pack_path .. plugin_name

	vim.notify("Building " .. plugin_name .. "...", vim.log.levels.WARN)
	local response = vim.system(vim.split(spec.data.build, " "), { cwd = plugin_path }):wait()
	vim.notify(
		(
			(
				not response.stderr:is_null_or_whitespace() and response.stderr
				or not response.stdout:is_null_or_whitespace() and response.stdout
				or "exit code: " .. string(response.code)
			)
		):trim(),
		response.code ~= 0 and vim.log.levels.ERROR or vim.log.levels.INFO
	)
end

---@class Utils.Pack
local M = {
	---@param specs Utils.Pack.Spec[]?
	build = function(specs)
		if not specs or #specs == 0 then
			specs, _ = get_specs_and_names()
		end

		for _, spec in ipairs(specs) do
			handle_build(spec)
		end
	end,
	load = function()
		local specs, _ = get_specs_and_names()

		vim.pack.add(specs, pack.add_options)
		for _, spec in ipairs(specs) do
			if spec.config then
				if spec.defer then
					vim.schedule(spec.config)
				else
					spec.config()
				end
			end
		end
	end,
	update = function()
		local _, names = get_specs_and_names()

		vim.pack.update(names, pack.update_options)
	end,
}

return M