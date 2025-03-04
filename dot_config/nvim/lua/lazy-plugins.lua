require('lazy').setup({
    'tpope/vim-rhubarb',
    'tpope/vim-sleuth',
    'nvim-lua/plenary.nvim',
    'folke/zen-mode.nvim',

    {
        'tpope/vim-fugitive',
        keys = {
            { '<leader>Gc', '<cmd>Git commit<cr>', desc = '[G]it [c]ommit' },
        }
    },

    {
        'folke/trouble.nvim',
        config = function()
            require('trouble').setup({
                icons = false,
            })

            vim.keymap.set('n', '<leader>tt', function()
                require('trouble').toggle() 
            end)

            vim.keymap.set('n', ']d', function()
                require('trouble').next({skip_groups = true, jump = true});
            end)

            vim.keymap.set('n', '[d', function()
                require('trouble').previous({skip_groups = true, jump = true}); 
            end)

        end
    },

    {
        -- Color scheme
        'bluz71/vim-moonfly-colors',
        name = 'moonfly',
        lazy = false,
        priority = 1000,
    },


    { -- LSP Configuration & Plugins
        'neovim/nvim-lspconfig',
        dependencies = {
            -- Automatically install LSPs and related tools to stdpath for Neovim
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',
            'WhoIsSethDaniel/mason-tool-installer.nvim',

            -- Useful status updates for LSP.
            -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
            { 'j-hui/fidget.nvim', opts = {} },

            -- `neodev` configures Lua LSP for your Neovim config, runtime and plugins
            -- used for completion, annotations and signatures of Neovim apis
            { 'folke/neodev.nvim', opts = {} },
        },
        config = function()
            -- brief aside: **what is lsp?**
            --
            -- lsp is an initialism you've probably heard, but might not understand what it is.
            --
            -- lsp stands for language server protocol. it's a protocol that helps editors
            -- and language tooling communicate in a standardized fashion.
            --
            -- in general, you have a "server" which is some tool built to understand a particular
            -- language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc.). these language servers
            -- (sometimes called lsp servers, but that's kind of like atm machine) are standalone
            -- processes that communicate with some "client" - in this case, neovim!
            --
            -- lsp provides neovim with features like:
            --  - go to definition
            --  - find references
            --  - autocompletion
            --  - symbol search
            --  - and more!
            --
            -- thus, language servers are external tools that must be installed separately from
            -- neovim. this is where `mason` and related plugins come into play.
            --
            -- if you're wondering about lsp vs treesitter, you can check out the wonderfully
            -- and elegantly composed help section, `:help lsp-vs-treesitter`

            --  this function gets run when an lsp attaches to a particular buffer.
            --    that is to say, every time a new file is opened that is associated with
            --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
            --    function will be executed to configure the current buffer
            vim.api.nvim_create_autocmd('lspattach', {
                group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
                callback = function(event)
                    -- note: remember that lua is a real programming language, and as such it is possible
                    -- to define small helper and utility functions so you don't have to repeat yourself.
                    --
                    -- in this case, we create a function that lets us more easily define mappings specific
                    -- for lsp related items. it sets the mode, buffer and description for us each time.
                    local map = function(keys, func, desc)
                        vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'lsp: ' .. desc })
                    end

                    -- jump to the definition of the word under your cursor.
                    --  this is where a variable was first declared, or where a function is defined, etc.
                    --  to jump back, press <c-t>.
                    map('gd', require('telescope.builtin').lsp_definitions, '[g]oto [d]efinition')

                    -- find references for the word under your cursor.
                    map('gr', require('telescope.builtin').lsp_references, '[g]oto [r]eferences')

                    -- jump to the implementation of the word under your cursor.
                    --  useful when your language has ways of declaring types without an actual implementation.
                    map('gi', require('telescope.builtin').lsp_implementations, '[g]oto [i]mplementation')

                    -- jump to the type of the word under your cursor.
                    --  Useful when you're not sure what type a variable is and you want to see
                    --  the definition of its *type*, not where it was *defined*.
                    map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')

                    -- Fuzzy find all the symbols in your current document.
                    --  Symbols are things like variables, functions, types, etc.
                    map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')

                    -- Fuzzy find all the symbols in your current workspace.
                    --  Similar to document symbols, except searches over your entire project.
                    map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

                    -- Rename the variable under your cursor.
                    --  Most Language Servers support renaming across files, etc.
                    map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

                    -- Execute a code action, usually your cursor needs to be on top of an error
                    -- or a suggestion from your LSP for this to activate.
                    map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

                    -- Opens a popup that displays documentation about the word under your cursor
                    --  See `:help K` for why this keymap.
                    map('K', vim.lsp.buf.hover, 'Hover Documentation')

                    -- WARN: This is not Goto Definition, this is Goto Declaration.
                    --  For example, in C this would take you to the header.
                    map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

                    -- The following two autocommands are used to highlight references of the
                    -- word under your cursor when your cursor rests there for a little while.
                    --    See `:help CursorHold` for information about when this is executed
                    --
                    -- When you move your cursor, the highlights will be cleared (the second autocommand).
                    local client = vim.lsp.get_client_by_id(event.data.client_id)
                    if client and client.server_capabilities.documentHighlightProvider then
                        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                            buffer = event.buf,
                            callback = vim.lsp.buf.document_highlight,
                        })

                        vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                            buffer = event.buf,
                            callback = vim.lsp.buf.clear_references,
                        })
                    end
                end,
            })

            -- LSP servers and clients are able to communicate to each other what features they support.
            --  By default, Neovim doesn't support everything that is in the LSP specification.
            --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
            --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
            -- Enable the following language servers
            --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
            --
            --  Add any additional override configuration in the following tables. Available keys are:
            --  - cmd (table): Override the default command used to start the server
            --  - filetypes (table): Override the default list of associated filetypes for the server
            --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
            --  - settings (table): Override the default settings passed when initializing the server.
            --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
            local servers = {
                clangd = {},
                -- gopls = {},
                -- pyright = {},
                ols = {},
                zls = {},
                -- rust_analyzer = {},
                -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
                --
                -- Some languages (like typescript) have entire language plugins that can be useful:
                --    https://github.com/pmizio/typescript-tools.nvim
                --
                -- But for many setups, the LSP (`tsserver`) will work just fine
                -- tsserver = {},
                --

                lua_ls = {
                    -- cmd = {...},
                    -- filetypes = { ...},
                    -- capabilities = {},
                    settings = {
                        Lua = {
                            completion = {
                                callSnippet = 'Replace',
                            },
                            -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
                            -- diagnostics = { disable = { 'missing-fields' } },
                        },
                    },
                },
            }

            -- Ensure the servers and tools above are installed
            --  To check the current status of installed tools and/or manually install
            --  other tools, you can run
            --    :Mason
            --
            --  You can press `g?` for help in this menu.
            require('mason').setup()

            -- You can add other tools here that you want Mason to install
            -- for you, so that they are available from within Neovim.
            local ensure_installed = vim.tbl_keys(servers or {})
            vim.list_extend(ensure_installed, {
                'stylua', -- Used to format Lua code
            })
            require('mason-tool-installer').setup { ensure_installed = ensure_installed }

            require('mason-lspconfig').setup {
                handlers = {
                    function(server_name)
                        local server = servers[server_name] or {}
                        -- This handles overriding only values explicitly passed
                        -- by the server configuration above. Useful when disabling
                        -- certain features of an LSP (for example, turning off formatting for tsserver)
                        server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
                        require('lspconfig')[server_name].setup(server)
                    end,
                },
            }
        end,
    },

    {
        -- Autocompletion
        'hrsh7th/nvim-cmp',
        dependencies = {
            -- Snippet engine & its associated nvim-cmp source
            'L3MON4D3/LuaSnip',
            'saadparwaiz1/cmp_luasnip',

            -- Adds LSP completion capabilities
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-path',

            'hrsh7th/cmp-buffer',
        },

        config = function()

            local cmp = require'cmp'

            cmp.setup({
                snippet = {
                    -- REQUIRED - you must specify a snippet engine
                    expand = function(args)
                        --vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
                        require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                        -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
                        -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
                    end,
                },
                window = {
                    -- completion = cmp.config.window.bordered(),
                    -- documentation = cmp.config.window.bordered(),
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<C-e>'] = cmp.mapping.abort(),
                    ['<CR>'] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                }),
                sources = cmp.config.sources({
                    { name = 'nvim_lsp' },
                    --{ name = 'vsnip' }, -- For vsnip users.
                    { name = 'luasnip' }, -- For luasnip users.
                    -- { name = 'ultisnips' }, -- For ultisnips users.
                    -- { name = 'snippy' }, -- For snippy users.
                }, {
                        { name = 'buffer' },
                    })
            })
        end
    },


    {
        -- Add indentation guides even on blank lines
        'lukas-reineke/indent-blankline.nvim',
        -- see ':help ibl'
        main = 'ibl',
        opts = {
            indent = { char = "|"},
        },
    },

    {-- Fuzzy Finder (files, lsp, etc)
        'nvim-telescope/telescope.nvim',
        event = 'VimEnter',
        branch = '0.1.x',
        dependencies = {
            'nvim-lua/plenary.nvim',
            { -- If encountering errors, see telescope-fzf-native README for installation instructions
                'nvim-telescope/telescope-fzf-native.nvim',

                -- `build` is used to run some command when the plugin is installed/updated.
                -- This is only run then, not every time Neovim starts up.
                build = 'make',

                -- `cond` is a condition used to determine whether this plugin should be
                -- installed and loaded.
                cond = function()
                    return vim.fn.executable 'make' == 1
                end,
            },
            { 'nvim-telescope/telescope-ui-select.nvim' },

            -- Useful for getting pretty icons, but requires a Nerd Font.
            { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
        },
        config = function()
            -- Telescope is a fuzzy finder that comes with a lot of different things that
            -- it can fuzzy find! It's more than just a "file finder", it can search
            -- many different aspects of Neovim, your workspace, LSP, and more!
            --
            -- The easiest way to use Telescope, is to start by doing something like:
            --  :Telescope help_tags
            --
            -- After running this command, a window will open up and you're able to
            -- type in the prompt window. You'll see a list of `help_tags` options and
            -- a corresponding preview of the help.
            --
            -- Two important keymaps to use while in Telescope are:
            --  - Insert mode: <c-/>
            --  - Normal mode: ?
            --
            -- This opens a window that shows you all of the keymaps for the current
            -- Telescope picker. This is really useful to discover what Telescope can
            -- do as well as how to actually do it!

            -- [[ Configure Telescope ]]
            -- See `:help telescope` and `:help telescope.setup()`
            require('telescope').setup {
                -- You can put your default mappings / updates / etc. in here
                --  All the info you're looking for is in `:help telescope.setup()`
                --
                -- defaults = {
                --   mappings = {
                --     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
                --   },
                -- },
                -- pickers = {}
                extensions = {
                    ['ui-select'] = {
                        require('telescope.themes').get_dropdown(),
                    },
                },
            }

            -- Enable Telescope extensions if they are installed
            pcall(require('telescope').load_extension, 'fzf')
            pcall(require('telescope').load_extension, 'ui-select')

            -- See `:help telescope.builtin`
            local builtin = require 'telescope.builtin'
            vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
            vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
            vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
            vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
            vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
            vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
            vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
            vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
            vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
            vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

            -- Slightly advanced example of overriding default behavior and theme
            vim.keymap.set('n', '<leader>/', function()
                -- You can pass additional configuration to Telescope to change the theme, layout, etc.
                builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
                    winblend = 10,
                    previewer = false,
                })
            end, { desc = '[/] Fuzzily search in current buffer' })

            -- It's also possible to pass additional configuration options.
            --  See `:help telescope.builtin.live_grep()` for information about particular keys
            vim.keymap.set('n', '<leader>s/', function()
                builtin.live_grep {
                    grep_open_files = true,
                    prompt_title = 'Live Grep in Open Files',
                }
            end, { desc = '[S]earch [/] in Open Files' })

            -- Shortcut for searching your Neovim configuration files
            vim.keymap.set('n', '<leader>sn', function()
                builtin.find_files { cwd = vim.fn.stdpath 'config' }
            end, { desc = '[S]earch [N]eovim files' })
        end,
    },

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

    {
        'mbbill/undotree',
        keys = {
            { '<leader>u', vim.cmd.UndotreeToggle, desc = '[u]ndotree toggle' },
        }
    },

    {
        'folke/which-key.nvim',
        event = 'VeryLazy',
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end,
        opts = { -- check git for opts 
            icons = {
                seperator = "-",
            },
        }
    },

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
        end,
    },

    {
        'stevearc/oil.nvim',
        opts = {
            delete_to_trash = true,
        },
    },

    {-- Music notation/engraving 
        'martineausimon/nvim-lilypond-suite',
        config = function()
            require('nvls').setup({
                -- edit config here (see "Customize default settings" in wiki)
                require('nvls').setup({
                    lilypond = {
                        mappings = {
                            player = "<F3>",
                            compile = "<F5>",
                            open_pdf = "<F6>",
                            switch_buffers = "<A-Space>",
                            insert_version = "<F4>",
                            hyphenation = "<F12>",
                            hyphenation_change_lang = "<F11>",
                            insert_hyphen = "<leader>ih",
                            add_hyphen = "<leader>ah",
                            del_next_hyphen = "<leader>dh",
                            del_prev_hyphen = "<leader>dH",
                        },
                        options = {
                            pitches_language = "default",
                            hyphenation_language = "en_DEFAULT",
                            output = "pdf",
                            backend = nil,
                            main_file = "main.ly",
                            main_folder = "%:p:h",
                            include_dir = nil,
                            diagnostics = false,
                            pdf_viewer = nil,
                        },
                    },
                    latex = {
                        mappings = {
                            compile = "<F5>",
                            open_pdf = "<F6>",
                            lilypond_syntax = "<F3>"
                        },
                        options = {
                            lilypond_book_flags = nil,
                            clean_logs = false,
                            main_file = "main.tex",
                            main_folder = "%:p:h",
                            include_dir = nil,
                            lilypond_syntax_au = "BufEnter",
                            pdf_viewer = nil,
                        },
                    },
                    texinfo = {
                        mappings = {
                            compile = "<F5>",
                            open_pdf = "<F6>",
                            lilypond_syntax = "<F3>"
                        },
                        options = {
                            lilypond_book_flags = "--pdf",
                            clean_logs = false,
                            main_file = "main.texi",
                            main_folder = "%:p:h",
                            --include_dir = nil,
                            lilypond_syntax_au = "BufEnter",
                            pdf_viewer = nil,
                        },
                    },
                    player = {
                        mappings = {
                            quit = "q",
                            play_pause = "p",
                            loop = "<A-l>",
                            backward = "h",
                            small_backward = "<S-h>",
                            forward = "l",
                            small_forward = "<S-l>",
                            decrease_speed = "j",
                            increase_speed = "k",
                            halve_speed = "<S-j>",
                            double_speed = "<S-k>"
                        },
                        options = {
                            row = 1,
                            col = "99%",
                            width = "37",
                            height = "1",
                            border_style = "single",
                            winhighlight = "Normal:Normal,FloatBorder:Normal",
                            midi_synth = "fluidsynth",
                            fluidsynth_flags = {
                                "/usr/share/sounds/sf2/OPL-3_FM_128M.sf2"
                            },
                            timidity_flags = nil,
                            audio_format = "mp3",
                            mpv_flags = {
                                "--msg-level=cplayer=no,ffmpeg=no,alsa=no",
                                "--loop",
                                "--config-dir=/dev/null"
                            }
                        },
                    },
                })
            })
        end
    },

    {

    },

}, {})
