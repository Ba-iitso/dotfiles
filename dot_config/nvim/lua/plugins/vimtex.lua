return {
    {
        "lervag/vimtex",
        lazy = false,
        -- tag = "v2.15", -- uncomment to pin a specific release
        init = function()
            --VimTeX configuration goes here, e.g.
            vim.g.vimtex_view_method = "zathura_simple"
						vim.g.vimtex_imaps_enabled = 0 --using LuaSnip instead
        end
    }
}
