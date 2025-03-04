return {
    {
        -- Highlight, edit, and navigate code
        'nvim-treesitter/nvim-treesitter',
        dependencies = {
            'nvim-treesitter/nvim-treesitter-textobjects'
        },
        build = ':TSUpdate',
        config = function()
            -- [[ Configure Treesitter ]] See ':help nvim-treesitter'

            require('nvim-treesitter.configs').setup{
                ensure_installed = { 'lua', 'python' },
                --autoinstall languages that are not installed
                auto_install = true,
                highlight = {enable = true},
                indent = {enable = false},
            }
        end,
    },
}
