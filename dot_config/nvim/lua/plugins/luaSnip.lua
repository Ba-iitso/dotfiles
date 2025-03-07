return {
	{
		"L3MON4D3/LuaSnip",
		-- follow latest release.
		version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
		-- install jsregexp (optional!).
		build = "make install_jsregexp",
		config = function ()
			local ls = require "luasnip"
			local types = require "luasnip.util.types"

			require("luasnip.loaders.from_lua").lazy_load({paths = "~/.config/nvim/LuaSnip/"})

			ls.config.set_config {
				history = true, -- Tells luasnip to remember last snippet so you can jump back to it later
				update_events = "TextChanged,TextChangedI", -- shows rep nodes filling in as you type
				enable_autosnippets = true,
				store_selection_keys = "<Tab>", -- Stores visual mode selection for snippets using LS_SELECT_RAW
			}

			-- jump forward snippet ctl k
			vim.keymap.set({ "i", "s" }, "jk", function()
				if ls.jumpable(1) then
					ls.jump(1)
				end
			end, {silent = true})

			-- jump backward ctl j
			vim.keymap.set({ "i", "s" }, "<c-h>", function()
				if ls.jumpable(-1) then
					ls.jump(-1)
				end
			end, {silent = true})

			-- ctl l for selecting within a list of options, good for choice nodes
			vim.keymap.set("i", "<c-l>", function()
				if ls.choice_active() then
					ls.choice_active(1)
				end
			end)

			-- shortcut to source luasnips file again
			vim.keymap.set('n', '<Leader>L', '<Cmd>lua require("luasnip.loaders.from_lua").load({paths = "~/.config/nvim/LuaSnip/"})<CR>')
		end,
	},
}
