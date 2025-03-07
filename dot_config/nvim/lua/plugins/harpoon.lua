return {
	{
		'ThePrimeagen/harpoon',
		branch = 'harpoon2',
		dependencies = { 'nvim-lua/plenary.nvim' },
		opts = {},
		config = function()
			local harpoon = require("harpoon")

			harpoon:setup()

			vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end, {desc = '[a]dd to harpoon list'})
			vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, {desc = 'toggle harpoon list'})

			vim.keymap.set("n", "<C-j>", function() harpoon:list():select(1) end, {desc = 'jump to first item in harpoon list'})
			vim.keymap.set("n", "<C-k>", function() harpoon:list():select(2) end,{desc = 'jump to second item in harpoon list'})
			vim.keymap.set("n", "<C-l>", function() harpoon:list():select(3) end, {desc = 'jump to third item in harpoon list'})
			vim.keymap.set("n", "<C-;>", function() harpoon:list():select(4) end, {desc = 'jump to fourth item in harpoon list'})

			-- Toggle previous & next buffers stored within Harpoon list
			vim.keymap.set("n", "<C-S-P>", function() harpoon:list():prev() end, {desc = 'jump to previous item in harpoon list'})
			vim.keymap.set("n", "<C-S-N>", function() harpoon:list():next() end)
		end
	},
}
