---@type vim.lsp.Config
return {
	cmd = { "nixd" },
	root_markers = { ".git", vim.fn.getcwd() },
	filetypes = { "nix" },
}
