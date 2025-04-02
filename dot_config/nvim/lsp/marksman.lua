---@type vim.lsp.Config
return {
	cmd = { "marksman" },
	root_markers = { ".git", vim.fn.getcwd() },
	filetypes = { "md" },
}
