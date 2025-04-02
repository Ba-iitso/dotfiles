return {
	"saghen/blink.cmp",
	--optional: provides snippets for the snippet source
	dependencies = { "L3MON4D3/LuaSnip", version = "v2.*" },

	-- use a reliease tag to download pre-built binaries
	version = "1.*",


	---@module "blink.cmp"
	---@type blink.cmp.Config
	opts = {
		-- 'default' = C-y to accept
		-- 'super-tab' = tab to accept
		-- 'enter' = enter to accept
		-- 'none' = no mappings
		-- All use:
		-- C-space: open menu or open docs if already open
		-- C-n/C-p or Up/Down: Select next/previous item
		-- C-e: Hide menu
		-- C-k: Toggle signature help (if signature.enabled = true)
		--
		-- See :h blink-cmp-config-keymap for defining your own keymap
		keymap = {
			preset = "default",

			["C-l"] = { "snippet_forward", "fallback" },
			["C-h"] = { "snippet_backward", "fallback" },
		},

		appearance = {
			nerd_font_variant = "mono"
		},

		completion = { documentation = { auto_show = true } },

		snippets = { preset = "luasnip" },

		sources = {
			default = { "lsp", "path", "snippets", "buffer" },
		},

		fuzzy = { implementation = "prefer_rust_with_warning" }
	},

	opts_extend = { "sources.default" },

	config = function(_, opts)
		require("luasnip").setup({
			enable_autosnippets = true,
		})

		require("luasnip.loaders.from_lua").lazy_load()
		require("luasnip.loaders.from_lua").lazy_load({ paths = { vim.fn.stdpath("config") .. "/snippets/"} })

		require("blink.cmp").setup(opts)
	end,
}
