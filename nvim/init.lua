-- git clone --depth=1 https://github.com/savq/paq-nvim.git ~/.local/share/nvim/site/pack/paqs/start/paq-nvim
require "paq" {
    "savq/paq-nvim",

    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
        },
    },
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",

    { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },

    {
        'nvim-lualine/lualine.nvim',
        requires = { 'nvim-tree/nvim-web-devicons', opt = true }
    },

    "echasnovski/mini.files",
    'nvim-tree/nvim-web-devicons',
    'm4xshen/autoclose.nvim',
    "pocco81/auto-save.nvim",
    "MeanderingProgrammer/render-markdown.nvim",

    -- Colorschemes
    'xiantang/darcula-dark.nvim',
    "cpea2506/one_monokai.nvim",
    'sainnhe/sonokai',
    "ribru17/bamboo.nvim",
    'aliqyan-21/darkvoid.nvim',

    "f-person/git-blame.nvim",
    "bluz71/vim-moonfly-colors",
    "savq/melange-nvim",
    "Mofiqul/vscode.nvim",
    "nvim-lua/plenary.nvim",

    {
        "ibhagwan/fzf-lua",
        requires = { "nvim-tree/nvim-web-devicons" },
    },

    'alexghergh/nvim-tmux-navigation',

    "stevearc/resession.nvim",

    "ThePrimeagen/harpoon"
}


-- require('darkvoid').setup({
--     transparent = false,
-- })
----------------vim.cmd.colorscheme "sonokai"
-- vim.cmd.colorscheme "darcula-dark"
require("bamboo").load()
-- require("one_monokai").setup({
--     transparent = true,
--     colors = {},
--     highlights = function(colors)
--         return {}
--     end,
--     italics = true,
-- })

require("autoclose").setup()
require("mini.files").setup({
    options = {
        permanent_delete = true,
        use_as_default_explorer = false,
    },
})
require("render-markdown").enable()
require("nvim-tmux-navigation").setup {
    disable_when_zoomed = true
}

require("fzf-lua").setup({
    winopts = {
        width = .95,
        preview = {
            layout = "vertical",
        }
    },
})
-------------------- Resession ------------------
local resession = require("resession")
resession.setup({
    autosave = {
        enabled = true,
        interval = 60,
        notify = true,
    },
})

vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        vim.g.using_stdin = vim.g.using_stdin or false
        if vim.g.using_stdin then
            return
        end
        local argc = vim.fn.argc()
        local should_load = argc == 0
        local session_name = vim.fn.getcwd()
        if argc == 1 then
            local arg = vim.fn.argv()[1]
            if vim.fn.isdirectory(arg) == 1 then
                should_load = true
                if arg == "." then
                    session_name = vim.fn.getcwd()
                else
                    session_name = arg
                end
            end
        end
        if not should_load then
            return
        end
        vim.notify("Opening session: " .. session_name)
        resession.load(session_name, { dir = "dirsession", silence_errors = true })
    end,
    nested = true,
})

vim.api.nvim_create_autocmd("VimLeavePre", {
    callback = function()
        resession.save(vim.fn.getcwd(), { dir = "dirsession", notify = false })
    end,
})

vim.api.nvim_create_autocmd('StdinReadPre', {
    callback = function()
        vim.g.using_stdin = true
    end,
})

-------------------- LSP ------------------------
vim.lsp.set_log_level("WARN")

local lspconfig = require("lspconfig")
require("mason").setup()
require("mason-lspconfig").setup {
    ensure_installed = { "lua_ls", "rust_analyzer", "buf_ls" },
    handlers = {
        function(server_name)
            if server_name ~= "gopls" and server_name ~= "omnisharp" then
                lspconfig[server_name].setup({})
            end
        end,
    }
}

-- Using manually installed LSPs -> Move setup outside of mason-lspconfig setup
lspconfig.omnisharp.setup {
    cmd = { vim.fn.expand("~/omnisharp/OmniSharp") },
    enable_roslyn_analyzers = true, enable_import_completion = true,
    organize_imports_on_format = true,
    filetypes = { "cs", "csx", "cake" },
    root_dir = lspconfig.util.root_pattern("*.sln", "*.csproj", "omnisharp.json", ".git"),
}

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
                "-bazel-",
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

-------------------- PARSING ------------------------

require 'nvim-treesitter.configs'.setup {
    ensure_installed = { "c_sharp", "rust", "lua", "vim", "vimdoc", "python", "go", "javascript", "css", "html", "markdown", "markdown_inline", "json" },
    sync_install = false,
    auto_install = true,
    highlight = {
        enable = true,

        disable = function(lang, buf)
            local max_filesize = 100 * 1024 -- 100 KB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
                return true
            end
        end,

        additional_vim_regex_highlighting = false,
    },
}

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

local window = function()
    return vim.api.nvim_win_get_number(0)
end

-------------------- LUALINE ------------------------

require('lualine').setup {
    options = {
        icons_enabled = true,
        theme = 'dracula',
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
    winbar = {
        lualine_a = {
            {
                'filename',
                draw_empty = true,
                type = nil,
                padding = 1,
                fmt = nil,
                color = nil,
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
    inactive_winbar = {
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
    sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {}
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {}
    },
    extensions = {}
}

----------------- Harpoon ------------------
require("harpoon").setup({
    menu = {
        width = 200, -- Or any fixed value; you can make it wider
    }
})

-- Autocmd for dynamic resizing: Update width and redraw menu on resize events
vim.api.nvim_create_autocmd({ 'VimResized', 'WinResized' }, {
    pattern = '*',
    callback = function()
        -- local harpoon = require('harpoon')
        -- harpoon.setup({
        --     menu = {
        --         width = vim.o.columns - 10,  -- Use total columns for consistency
        --     }
        -- })
        -- -- Force Harpoon UI refresh if open (optional, if menu is visible)
        -- if harpoon.ui.nav_is_open() then
        --     harpoon.ui:close_menu()
        --     harpoon.ui:toggle_quick_menu()
        -- end
        vim.cmd('wincmd =') -- Equalize windows
    end,
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

-------------------- IMPORTS ------------------------

require("mappings")
require("options")
