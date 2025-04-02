---@type vim.lsp.Config
return {
	cmd = { "ols" },
	root_markers = { "main.odin", ".git", vim.fn.getcwd() },
	filetypes = { "odin" },
	settings = {
		Lua = {
			enable_hover = true,
			enable_document_symbols = true,
			enable_snippets = true,
			enable_semantic_tokens = true,
		}
	}
}
