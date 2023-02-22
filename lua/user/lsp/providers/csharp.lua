-- this is for c_sharp
util = require("lspconfig/util")
local M = {}
M.omnisharp = {
	cmd = { "dotnet", "/path/to/omnisharp/OmniSharp.dll" },
	enable_editorconfig_support = true,
	enable_ms_build_load_projects_on_demand = false,
	enable_roslyn_analyzers = false,
	organize_imports_on_format = false,
	enable_import_completion = false,
	sdk_include_prereleases = true,
	analyze_open_documents_only = false,
	root_dir = util.root_pattern(".git", ".sln", ".csproj", "Makefile", "configure.ac"),
	filetypes = { "cs", "vb" },
	single_file_support = true,
}

return M
