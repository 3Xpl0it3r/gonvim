local M = {}
local g_utils_shell = require("utils.shell")
local g_utils_notify = require("utils.notify")

local MOD_KUBERNETES = "k8s.io/kubernetes"

---@param version string
local get_all_modes = function(version)
	local home_dir = vim.fn.expand("$HOME")

	local cache_dir = home_dir .. "/.config/nvim/rplugin/python/cache/k8s/" .. version

	local f = io.popen("cd " .. cache_dir .. " && pwd")
	local dir_exists = false
	if f ~= nil then
		dir_exists = f:read("*a") ~= ""
		f:close()
	end

	if not dir_exists then
		os.execute("mkdir -pv " .. cache_dir)
	end

	local mod_abs_dir = cache_dir .. "/go.mod"

	local _mod_fp, err = io.open(mod_abs_dir, "r")

	if _mod_fp == nil then
		local url = "https://raw.githubusercontent.com/kubernetes/kubernetes/v" .. version .. "/go.mod"
		local cmd = "curl -sS -XGET " .. url .. " -o " .. mod_abs_dir
		if vim.fn.system(cmd) == vim.NIL then
			return {}
		end
	else
		_mod_fp:close()
	end

	local readgomod = "cat " .. mod_abs_dir .. "| sed  -n 's|.*k8s.io/\\(.*\\) => ./staging/src/k8s.io/.*|k8s.io/\\1|p'"
	local gomod = vim.fn.system(readgomod)

	local mods = {}

	for mod in string.gmatch(gomod, "(.-)\n") do
		table.insert(mods, mod)
	end

	table.insert(mods, MOD_KUBERNETES)

	return mods
end

local download_single = function(modname, version)
	local versiond = modname .. "@" .. "kubernetes-" .. version
	local cmd = 'echo "Ready Download:\n' .. versiond .. '" && go get ' .. versiond
	g_utils_notify.notify(cmd, "info", "k8s")
	g_utils_shell.execute(cmd, "vertical")
end

local download_totalk8s = function(version)
	local all_modes = get_all_modes(version)
	local mods_str = ""
	local echo = 'echo "Ready Download:\n'
	for _, mod in ipairs(all_modes) do
		if mod ~= MOD_KUBERNETES then
			local versiond = mod .. "@" .. "kubernetes-" .. version .. "  "
			mods_str = mods_str .. versiond
			echo = echo .. versiond .. "\n"
		end
	end
	local versiond = MOD_KUBERNETES .. "@v" .. version

	mods_str = mods_str .. versiond
	echo = echo .. versiond .. '\n"'

	local cmd = echo .. "&& go get " .. mods_str
	g_utils_shell.execute(cmd, "vertical")
end

M.all_modes = function(version)
	return get_all_modes(version)
end

M.download = function(modname, version)
	if modname ~= MOD_KUBERNETES then
		download_single(modname, version)
		return
	end
	download_totalk8s(version)
end

return M
