return {
    {--Collection of various small independant plugins/modules
        'echasnovski/mini.nvim',
        config = function()
            --Better Around/Inside textobjects
            --
            --Examples:
            -- - va)  - [V]isually select [A]round [)]parenthen
            -- - yinq - [Y]ank [I]nside [N]ext [']quote
            -- - ci'  - [C]hange [I]nside [']quote
            require('mini.ai').setup { n_lines = 500 }

            -- Add/delete/replace surroundings (brackets, quotes, etc)
            --
            -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
            -- - sd'   - [S]urround [D]elete [']quotes
            -- - sr)'  - [S]urround [R]eplace [)] [']
            require('mini.surround').setup()

            -- Simple easy statusline
            local statusline = require 'mini.statusline'
            statusline.setup()

            -- You can configure sections in the statusline by overriding their
            -- default behavior. For example, here we disable the section for
            -- cursor information because line numbers are already enabled
            ---@diagnostic disable-next-line: duplicate-set-field
            statusline.section_location = function()
                return ''
            end

            -- For commenting out blocks of text
            -- 
            -- - gc  - toggle comment(follow with text obj, eg: gcip to toggle "[I]n [P]aragraph")
            -- - gcc - toggle comment on current line
            -- can add functions to modify behavior before or after commenting
            require('mini.comment').setup()

            -- ... and there is more!
            -- Check out: https://github.com/echasnovsky/mini.nvim

            require('mini.files').setup()
        end,
    },
}
