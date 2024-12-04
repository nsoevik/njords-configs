local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'
    ---------- My plugins here ------------

    --- Telescope ---
    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.6',
        -- or                            , branch = '0.1.x',
        requires = { { 'nvim-lua/plenary.nvim' }, { 'nvim-telescope/telescope-live-grep-args.nvim' } },
    }
    --
    use 'nvim-tree/nvim-web-devicons'
    use 'lewis6991/gitsigns.nvim'

    --- Colorscheme ---
    use { "catppuccin/nvim", name = "catppuccin", priority = 1000 }
    use { "marko-cerovac/material.nvim" }
    use { "navarasu/onedark.nvim" }
    use { "eldritch-theme/eldritch.nvim", priority = 1000 }
    use {
        'maxmx03/fluoromachine.nvim',
        lazy = false,
        priority = 1000,
        config = function()
            local fm = require 'fluoromachine'

            fm.setup {
                glow = true,
                theme = 'fluoromachine',
                transparent = false,
            }

            vim.cmd.colorscheme 'fluoromachine'
        end
    }

    use {
        'ThePrimeagen/harpoon',
        requires = { 'nvim-lua/plenary.nvim' }, -- Harpoon depends on plenary.nvim
        config = function()
            require("harpoon").setup({})
        end
    }

    --- Treesitter ----
    use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }

    --- Nvim Tree -----
    use {
        'nvim-tree/nvim-tree.lua',
        requires = {
            'nvim-tree/nvim-web-devicons', -- optional
        },
    }

    use 'ConradIrwin/vim-bracketed-paste'

    --- LSP Zero ------
    use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v3.x',
        requires = {
            --- Uncomment the two plugins below if you want to manage the language servers from neovim
            { 'williamboman/mason.nvim' },
            { 'williamboman/mason-lspconfig.nvim' },
            { 'neovim/nvim-lspconfig' },
            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'L3MON4D3/LuaSnip' },
       }
    }

    --- Auto close braces, quotes, etc ------
    use 'm4xshen/autoclose.nvim'

    ---------------------------------------
    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    -- Issues when I use packer_bootstrap here
    if packer_bootstrap then
        require('packer').sync()
    end
end)

----------- NVIM-TREE -----------
-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- optionally enable 24-bit colour
vim.opt.termguicolors = true

require("nvim-tree").setup({
    sort = {
        sorter = "case_sensitive",
    },
    renderer = {
        group_empty = true,
    },
    filters = {
        dotfiles = false,
    },
    view = {
        width = 58,
        relativenumber = true,
        number = true,
    },
    update_focused_file = {
        enable = true,
    }
})

-------------------- LSP --------------------
local lsp_zero = require('lsp-zero')
local lsp = require('lspconfig')

lsp_zero.on_attach(function(client, bufnr)
    -- see :help lsp-zero-keybindings
    -- to learn the available actions
    lsp_zero.default_keymaps({ buffer = bufnr })
end)

require('mason').setup({})
require('mason-lspconfig').setup({
    -- Replace the language servers listed here
    -- with the ones you want to install
    -- https://github.com/williamboman/mason-lspconfig.nvim/blob/main/doc/server-mapping.md
    ensure_installed = { 'lua_ls', 'omnisharp', 'html', 'ts_ls', 'cssls', 'dockerls', 'pylsp' },
    handlers = {
        function(server_name)
            lsp[server_name].setup({})
        end,

        -- python
        pylsp = function()
            lsp.pylsp.setup({
                settings = {
                    pylsp = {
                        plugins = {
                            pyflakes = { enabled = true },   -- For linting
                            pylint = { enabled = true },     -- Optionally, enable pylint
                            pycodestyle = { enabled = true, maxLineLength = 100 },
                            pylsp_mypy = { enabled = true }, -- Optionally, enable MyPy
                        },
                    },
                },
            })
        end,

        -- custom handler for gopls
        gopls = function()
            lsp.gopls.setup({
                root_dir = lsp.util.root_pattern("go.work", "go.mod", "WORKSPACE"),
                settings = {
                    gopls = {
                        env = {
                            GOPACKAGESDRIVER = "/home/nsoevik/repos/satcode/payload/tools/gopackagesdriver.sh",
                            GOPACKAGESDRIVER_BAZEL_BUILD_FLAGS =
                            "--strategy=GoStdlibList=local --linkopt=-Wl,--strip-all --config=armv7l",
                            BAZEL_NOTIFY_THRESH = "999999999",
                        },
                        directoryFilters = {
                            "-bazel-bin",
                            "-bazel-out",
                            "-bazel-testlogs",
                            "-bazel-payload",
                        },
                        analyses = {
                            unusedparams = false,
                            simplifycompositelit = false,
                            simplifyrange = false,
                            infertypeargs = false,
                        },
                        staticcheck = true,
                        gofumpt = true,
                    },
                },
            })
        end,
    },
})


local lsp = require('lsp-zero').preset({})
local cmp = require('cmp')
cmp.setup({
    mapping = {
        ['<C-j>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
        ['<C-k>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
        ['<Tab>'] = cmp.mapping.confirm({ select = true }),
    },
    sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
    },
})

lsp.setup()

-------------------- Auto close --------------------
require("autoclose").setup()

-------------------- Colorscheme -------------------
vim.cmd('highlight Normal guibg=none')
vim.cmd [[colorscheme eldritch]]

-------------------- Ripgrep Telescope ------------------------
local telescope = require("telescope")
local lga_actions = require("telescope-live-grep-args.actions")
local actions = require("telescope.actions")

telescope.setup {
    extensions = {
        live_grep_args = {
            auto_quoting = false, -- enable/disable auto-quoting
            -- define mappings, e.g.
            mappings = {          -- extend mappings
                i = {
                    ["<C-q>"] = lga_actions.quote_prompt(),
                    ["<C-g>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
                    -- freeze the current list and start a fuzzy search in the frozen list
                    ["<C-space>"] = actions.to_fuzzy_refine,
                },
            },
            -- ... also accepts theme settings, for example:
            -- theme = "dropdown", -- use dropdown theme
            -- theme = { }, -- use own theme spec
            -- layout_config = { mirror=true }, -- mirror preview pane
        }
    }
}

-- don't forget to load the extension
telescope.load_extension("live_grep_args")




require 'nvim-treesitter.configs'.setup {
    -- A list of parser names, or "all" (the five listed parsers should always be installed)
    ensure_installed = { "lua", "vim", "vimdoc", "python", "go", "javascript", "css", "html", "markdown", "markdown_inline" },

    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,

    -- Automatically install missing parsers when entering buffer
    -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
    auto_install = true,

    ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
    -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

    highlight = {
        enable = true,

        -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
        -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
        -- the name of the parser)
        -- list of language that will be disabled
        disable = { "c", "rust" },
        -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
        disable = function(lang, buf)
            local max_filesize = 100 * 1024 -- 100 KB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
                return true
            end
        end,

        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = false,
    },
}

vim.g.mapleader = " " -- easy to reach leader key
require('core.mappings')
require('core.options')

