---@type vim.lsp.Config
return {
	cmd = { "ccls" },
	root_markers = { ".git", vim.fn.getcwd() },
	filetypes = { "cpp" },
}
