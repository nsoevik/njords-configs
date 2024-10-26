require('core.mappings')
require('core.options')
require('core.plugins')

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
  lsp_zero.default_keymaps({buffer = bufnr})
end)

require('mason').setup({})
require('mason-lspconfig').setup({
  -- Replace the language servers listed here 
  -- with the ones you want to install
  -- https://github.com/williamboman/mason-lspconfig.nvim/blob/main/doc/server-mapping.md
  ensure_installed = { 'lua-language-server', 'omnisharp', 'html', 'ts_ls', 'cssls', 'dockerls', 'pylsp' },
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
                          pyflakes = { enabled = true },  -- For linting
                          pylint = { enabled = true },    -- Optionally, enable pylint
                          pycodestyle = { enabled = true, maxLineLength = 100 },
                          pylsp_mypy = { enabled = true },  -- Optionally, enable MyPy
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
                          GOPACKAGESDRIVER_BAZEL_BUILD_FLAGS = "--strategy=GoStdlibList=local --linkopt=-Wl,--strip-all --config=armv7l",
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
        ['<Tab>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
        ['<S-Tab>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
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
vim.o.background = "light"  -- Change to "light" if you want the lighter theme

vim.cmd('highlight Normal guibg=none')
vim.o.background = "dark"
vim.cmd[[colorscheme eldritch]]

-------------------- Barbar ------------------------
require'barbar'.setup {
  icons = {
    modified = { button = '●' },
    filetype = { enabled = true },
    buffer_index = true,
  },
  auto_hide = 0,
  focus_on_close = 'right',
  insert_at_end = true,
}

-------------------- Ripgrep Telescope ------------------------
local telescope = require("telescope")
local lga_actions = require("telescope-live-grep-args.actions")
local actions = require("telescope.actions")

telescope.setup {
  extensions = {
    live_grep_args = {
      auto_quoting = false, -- enable/disable auto-quoting
      -- define mappings, e.g.
      mappings = { -- extend mappings
        i = {
          ["<C-k>"] = lga_actions.quote_prompt(),
          ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
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
