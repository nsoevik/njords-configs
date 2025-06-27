-- Recommended to disable by nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- git clone --depth=1 https://github.com/savq/paq-nvim.git ~/.local/share/nvim/site/pack/paqs/start/paq-nvim
require "paq" {
    "savq/paq-nvim",

    "neovim/nvim-lspconfig",

    "nvim-telescope/telescope.nvim",
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope-live-grep-args.nvim",

    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",

    { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },

    {
        'nvim-lualine/lualine.nvim',
        requires = { 'nvim-tree/nvim-web-devicons', opt = true }
    },

    "nvim-tree/nvim-tree.lua",
    'nvim-tree/nvim-web-devicons',
    'm4xshen/autoclose.nvim',
    "pocco81/auto-save.nvim",

    "folke/tokyonight.nvim",

    "f-person/git-blame.nvim",
    "bluz71/vim-moonfly-colors",
    "savq/melange-nvim",

    -- "Isrothy/neominimap.nvim",
    -- "lewis6991/gitsigns.nvim", "robitx/gp.nvim",
    "ThePrimeagen/harpoon"
}

vim.cmd("colorscheme melange") -- Apply changes
require("autoclose").setup()

-------------------- LSP ------------------------

local lspconfig = require("lspconfig")
require("mason").setup()
require("mason-lspconfig").setup {
    ensure_installed = { "lua_ls", "rust_analyzer", "ts_ls", "ast_grep", "buf_ls", "yamlls", },
    handlers = {
        function(server_name)
            if server_name ~= "gopls" and server_name ~= "omnisharp" then -- Prevents gopls from being configured twice
                lspconfig[server_name].setup({})
            end
        end,

        omnisharp = function()
            lspconfig.omnisharp.setup {
                cmd = { "/home/nsoevik/.local/share/nvim/mason/bin/omnisharp" },
                enable_roslyn_analyzers = true,
            }
        end,


        gopls = function()
            lspconfig.gopls.setup({
                root_dir = lspconfig.util.root_pattern("go.work", "go.mod", "WORKSPACE"),
                cmd = { "gopls" },
                filetypes = { "go", "gomod" },
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
    }
}
-------------------- PARSING ------------------------

require 'nvim-treesitter.configs'.setup {
    -- A list of parser names, or "all" (the five listed parsers should always be installed)
    ensure_installed = { "c_sharp", "rust", "lua", "vim", "vimdoc", "python", "go", "javascript", "css", "html", "markdown", "markdown_inline", "json" },

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

-------------------- Ripgrep Telescope ------------------------
local telescope = require("telescope")
local actions = require("telescope.actions")
local lga_actions = require("telescope-live-grep-args.actions")

-- Show file name first in pickers
local path_display = function(opts, path)
    local tail = require("telescope.utils").path_tail(path)
    return string.format("%s (%s)", tail, path), { { { 1, #tail }, "Constant" } }
end

telescope.setup {
    pickers = {
        live_grep = {
            path_display = path_display,
            additional_args = function() return { "--hidden" } end
        },
        find_files = {
            path_display = path_display,
        }
    },
    extensions = {
        live_grep_args = {
            auto_quoting = false, -- enable/disable auto-quoting
            mappings = {          -- extend mappings
                i = {
                    ["<C-q>"] = lga_actions.quote_prompt(),
                    ["<C-g>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
                }
            }
        }
    }
}

telescope.load_extension("live_grep_args")

-------------------- CMP ------------------------
local cmp = require("cmp")

cmp.setup({
    mapping = {
        ["<Tab>"] = cmp.mapping.confirm({ select = true }), -- Select the highlighted item
        ["<Up>"] = cmp.mapping.select_prev_item(),
        ["<Down>"] = cmp.mapping.select_next_item(),
        ["<C-e>"] = cmp.mapping.close(),
    },
    sources = cmp.config.sources({
        { name = "nvim_lsp" }, -- LSP completions
        { name = "buffer" },   -- Buffer words
        { name = "path" },     -- File paths
    }),
})

-------------------- NVIM TREE ------------------------
require("gp").setup({
    openai_api_key =
    ""
})

-------------------- NVIM TREE ------------------------
require("nvim-tree").setup({
    prefer_startup_root = true,
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
        relativenumber = true,
        number = true,
        width = 50,
    },
    update_focused_file = {
        enable = true,
    },
    actions = {
        open_file = {
            quit_on_open = false, -- Prevents NvimTree from closing when opening a file
        },
    }
})

local window = function()
    return vim.api.nvim_win_get_number(0)
end

-------------------- STATUS BAR ------------------------
local function total_lines()
    local count = vim.api.nvim_buf_line_count(0)
    return vim.fn.line('.') .. '/' .. count
end

local function file_path()
    return vim.fn.expand('%:~:.:h')
end

require('lualine').setup {
    options = {
        icons_enabled = true,
        theme = 'melange',
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        disabled_filetypes = {
            statusline = {},
            winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = false,
        always_show_tabline = true,
        globalstatus = false,
        refresh = {
            statusline = 100,
            tabline = 100,
            winbar = 100,
        }
    },
    sections = {
        lualine_a = {
            {
                'filename',
                draw_empty = true,
                type = nil,
                padding = 1,
                fmt = nil,
            }
        },
        lualine_b = {
            {
                'custom',
                draw_empty = true,
                padding = 1,
                fmt = function()
                    return ''
                end,
            }
        },
        lualine_c = {
            {
                'custom',
                draw_empty = true,
                padding = 1,
                fmt = file_path,
            }
        },
        lualine_x = { 'searchcount' },
        lualine_y = {
            {
                'custom',
                icon = '',
                component_separators = '|',
                separator = '|',
                fmt = total_lines,
            }
        },
        lualine_z = { window }
    },
    inactive_sections = {
        lualine_a = {
            {
                'filename',
                draw_empty = true,
                type = nil,
                padding = 1,
                fmt = nil,
            }
        },
        lualine_b = {
            {
                'custom',
                draw_empty = true,
                padding = 1,
                fmt = function()
                    return ''
                end,
            }
        },
        lualine_c = {
            {
                'custom',
                draw_empty = true,
                padding = 1,
                fmt = file_path,
            }
        },
        lualine_x = { 'searchcount' },
        lualine_y = {
            {
                'custom',
                icon = '',
                component_separators = '|',
                separator = '|',
                fmt = total_lines,
            }
        },
        lualine_z = {
            {
                window,
                draw_empty = true,
                type = nil,
                padding = 1,
                fmt = nil,
            }
        },
    },
    tabline = {
    },
    winbar = {},
    inactive_winbar = {},
    extensions = {}
}

----------------- Harpoon ------------------
require("harpoon").setup({
    menu = {
        width = vim.api.nvim_win_get_width(0) - 20,
    }
})

------------------- TABS -------------------
function _G.MyTabline()
    local s = ""
    for i = 1, vim.fn.tabpagenr('$') do
        local winnr = vim.fn.tabpagewinnr(i)
        local buflist = vim.fn.tabpagebuflist(i)
        local bufname = vim.fn.bufname(buflist[winnr])

        -- Extract only the filename from the full path
        local filename = bufname == "" and "[No Name]" or vim.fn.fnamemodify(bufname, ":t")

        -- Highlight the active tab
        if i == vim.fn.tabpagenr() then
            s = s .. "%#TabLineSel# " .. i .. ": " .. filename .. " %#TabLine#"
        else
            s = s .. "%#TabLine# " .. i .. ": " .. filename .. " "
        end
    end
    return s
end

vim.o.tabline = "%!v:lua.MyTabline()"
vim.o.showtabline = 2 -- Always show the tabline

-------------------- MINIMAP ------------------------
vim.g.neominimap = {
    x_multiplier = 1, ---@type integer
    y_multiplier = 1, ---@type integer
    --- Used when `layout` is set to `split`
    split = {
        minimap_width = 10, ---@type integer

        -- Always fix the width of the split window
        fix_width = false, ---@type boolean

        -- split mode:
        -- left is an alias for topleft   - leftmost vertical split, full height
        -- right is an alias for botright - rightmost vertical split, full height
        -- aboveleft -  left split in current window
        -- rightbelow - right split in current window
        ---@alias Neominimap.Config.SplitDirection "left" | "right" |
        ---       "topleft" | "botright" | "aboveleft" | "rightbelow"
        direction = "right", ---@type Neominimap.Config.SplitDirection

        ---Automatically close the split window when it is the last window
        close_if_last_window = false, ---@type boolean
    },

    --- Used when `layout` is set to `float`
    float = {
        minimap_width = 10, ---@type integer
        max_minimap_height = nil,

        margin = {
            right = 0,
            top = 0,
            bottom = 0,
        },
        z_index = 1,

        window_border = "single",
    },

    git = {
        enabled = false,
        mode = "sign",
        priority = 6,
        icon = {
            add = "+ ",
            change = "~ ",
            delete = "- ",
        },
    },

    search = {
        enabled = true,
        mode = "line",
        priority = 20,
        icon = "󰱽 ",
    },

    treesitter = {
        enabled = true,
        priority = 200,
    },

    mark = {
        enabled = true,
        mode = "icon",
        priority = 10,
        key = "m",
        show_builtins = false,
    },
}

-------------------- IMPORTS ------------------------

require("mappings")
require("options")
