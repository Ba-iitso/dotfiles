-- :h lsp-config

-- lsp conpletion
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspAttach", {clear = true}),
	callback = function(ev)
		vim.lsp.completion.enable(true, ev.data.client_id, ev.buf)
	end,
})

vim.lsp.enable('ccls')
vim.lsp.enable('lua_ls')
vim.lsp.enable('nixd')
vim.lsp.enable('ols')

local ls = require "luasnip"

-- ctl l for selecting within a list of options, good for choice nodes
vim.keymap.set("i", "<c-l>", function()
	if ls.choice_active() then
		ls.choice_active(1)
	end
end)

-- shortcut to source luasnips file again
vim.keymap.set('n', '<Leader>L', '<Cmd>lua require("luasnip.loaders.from_lua").load({paths = "~/.config/nvim/LuaSnip/"})<CR>')
