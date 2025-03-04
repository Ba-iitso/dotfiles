-- [[ Basic Keymaps ]]


-- center cursor on pg up/down
vim.keymap.set("n", "<C-u>", "<C-u>zz", { noremap = true} )
vim.keymap.set("n", "<C-d>", "<C-d>zz", { noremap = true} )

--highlight on yank
--See ":help vim.highlight.on_yank()"
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
	vim.highlight.on_yank()
    end,
    group = highlight_group,
    pattern = "*",
})

-- Move highlighted text in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '>-2<CR>gv=gv")

-- Diagnostics
vim.diagnostic.config({
    virtual_text = true,
    update_in_insert = true,
    float = {
	focusable = false,
	style = "minimal",
	border = "rounded",
	source = "always",
	header = "",
	prefix = "",
    },
})
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous [D]iagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next [D]iagnostic message" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Execute current file if executable for linux
vim.keymap.set("n", "<leader>f.", function()
  local line = vim.api.nvim_buf_get_lines(0, 0, -1, false)[0]
  if not string.find(line, "^#!") then
    return
  else
    local file = vim.fn.expand("%") -- Get the current file name
    local escaped_file = vim.fn.shellescape(file)
    vim.cmd("!chmod +x " .. escaped_file)
    vim.cmd("vsplit") -- Split the window vertically
    vim.cmd("terminal " .. escaped_file) 
    vim.api.nvim_feedkeys("i", "n", false)
  end
end, { desc = "Execute current file in terminal" })

-- Open parent directory in oil nvim
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- Yank to system clipboard
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]], { desc = "[Y]ank to system clipboard" })
vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "[Y]ank to system clipboard" })

-- Open mini file explorer
vim.keymap.set("n", "<leader>e",function () MiniFiles.open() end, { desc = "mini file [e]xplorer" })
