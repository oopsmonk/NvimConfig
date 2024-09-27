--
-- A simple lua config for nvim
-- Neovim 0.10.0+ with LuaJIT
--

-- set ',' as the leader key
vim.g.mapleader = ","

-- Install package manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Install plugins
require('lazy').setup({
  -- NOTE: First, some plugins that don't require any configuration

  -- Git related plugins
  'tpope/vim-fugitive',
  -- If fugitive.vim is the Git, rhubarb.vim is the Hub.
  'tpope/vim-rhubarb',

  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  -- NOTE: This is where your plugins related to LSP can be installed.
  --  The configuration is done below. Search for lspconfig to find it below.
  { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim', opts = {} },

      -- completion for the nvim lua API
      -- Additional lua configuration, makes nvim stuff amazing!
      'folke/neodev.nvim',
    },
  },

  { -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = {
      -- for neovim's built-in language server client
      'hrsh7th/cmp-nvim-lsp',
      -- path autocomplition
      'hrsh7th/cmp-path',
      -- buffer autocomplition
      'hrsh7th/cmp-buffer',
      -- tags autocomplition
      'quangnguyen30192/cmp-nvim-tags',
      -- Snippet Engine for Neovim
      'L3MON4D3/LuaSnip',
      -- luasnip completion source for nvim-cmp
      'saadparwaiz1/cmp_luasnip' },
  },

  -- Useful plugin to show you pending keybinds.
  { 'folke/which-key.nvim', opts = { icons = { mappings = false }}},

  { -- Adds git releated signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },

  { -- Theme inspired by Atom
    'navarasu/onedark.nvim',
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'onedark'
    end,
  },

  { -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
    opts = {
      options = {
        icons_enabled = false,
        theme = 'onedark',
        component_separators = '|',
        section_separators = '',
      },
    },
  },

  -- { -- Add indentation guides even on blank lines
  --   'lukas-reineke/indent-blankline.nvim',
  --   -- Enable `lukas-reineke/indent-blankline.nvim`
  --   -- See `:help indent_blankline.txt`
  --   opts = {
  --     char = '┊',
  --     show_trailing_blankline_indent = false,
  --   },
  -- },

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {} },

  -- Fuzzy Finder (files, lsp, etc)
  { 'nvim-telescope/telescope.nvim', version = '*', dependencies = { 'nvim-lua/plenary.nvim' } },

  -- Fuzzy Finder Algorithm which requires local dependencies to be built.
  -- Only load if `make` is available. Make sure you have the system
  -- requirements installed.
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    -- NOTE: If you are having trouble with this installation,
    --       refer to the README for telescope-fzf-native for more instructions.
    build = 'make',
    cond = function()
      return vim.fn.executable 'make' == 1
    end,
  },

  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ":TSUpdate",
  },

  -- hop lines and words in the buffer
  -- NOTE: `opts = {}` is the same as calling `require('hop').setup({})`
  { 'phaazon/hop.nvim', opts = {}},
  -- autopairs
  { 'windwp/nvim-autopairs', opts = {}},
  -- buffer as tabs
  'akinsho/bufferline.nvim',
  -- file explorer
  'preservim/nerdtree',
  -- display tags in a windown
  'preservim/tagbar',
  -- zig language
  'ziglang/zig.vim',
  -- A (Neo)vim plugin for formatting code.
  'sbdchd/neoformat',
  -- The fastest Neovim colorizer.
  'NvChad/nvim-colorizer.lua'

}, {
  -- lazy configuration
  -- don't want to use a Nerd Font
  ui = {
    icons = {
      cmd = "⌘",
      config = "🛠",
      event = "📅",
      ft = "📂",
      init = "⚙",
      keys = "🗝",
      plugin = "🔌",
      runtime = "💻",
      source = "📄",
      start = "🚀",
      task = "📌",
      lazy = "💤 ",
    },
  },
  pkg = {
    -- the first package source that is found for a plugin will be used.
    sources = {
      "lazy",
      -- don't use lua package manager
      -- "rockspec",
      -- "packspec",
    },
  },
})

-- ========Global Settings========

-- decrease update time
vim.opt.updatetime = 300

-- increase cmd history
vim.opt.history = 1000

-- use relative line number
vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2

-- enable system clipboard
vim.opt.clipboard = 'unnamedplus'

-- enable mouse support
vim.o.mouse = 'nv'

-- wild ignore
vim.opt.wildignore = { '*.o', '*.a', '*.obj' }

-- enable cursor line highlight
vim.opt.cursorline = true

-- go to last location
vim.api.nvim_create_autocmd("BufReadPost", { command = [[if line("'\"") > 1 && line("'\"") <= line("$") | execute "normal! g`\"" | endif]] })

 -- popup menu
vim.opt.completeopt = {'menu', 'menuone', 'noselect'}

-- disable providers
-- vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0

-- python formatter
vim.g.neoformat_python_black = {
  exe = "black",
  args = {"--line-length", "120", "-q", "-" },
  stdin = 1,
}
vim.g.neoformat_enabled_python = { 'black', 'isort'}

vim.g.neoformat_try_node_exe = 1

-- ========key mapping========
local wk = require("which-key")
wk.add({
  { "<leader>n", group = "[N]erdTree" },
  { "<leader>nf", "<cmd>NERDTreeFind<CR>", desc = "Find the file in NERDTree" },
  { "<leader>nt", "<cmd>NERDTreeToggle<CR>", desc = "Toggle NERDTree" },
  { "<leader>ng", "<cmd>NERDTreeVCS<CR>", desc = "Top of the Git project" },
  -- Buffers
  { "<leader>b", group = "[B]uffer" },
  { "<leader>bd", "<cmd>bdel<CR>", desc = "[D]elete Buffer" },
  { "<leader>bh", "<cmd>lua vim.lsp.buf.hover()<CR>", desc = "[H]over in Buffer" },
  { "<leader>bn", "<cmd>bn<CR>", desc = "[N]ext Buffer" },
  { "<leader>bp", "<cmd>bp<CR>", desc = "[P]revious Buffer" },
  { "<leader>br", "<cmd>lua vim.lsp.buf.rename()<CR>", desc = "[R]ename in Buffer" },
  -- diagnostics
  { "<leader>d", group = "[D]iagnostics" },
  { "<leader>da", "<cmd>lua vim.lsp.buf.code_action()<CR>", desc = "Code [A]ction" },
  { "<leader>dd", "<cmd>LspStop<CR>", desc = "[D]isable Diagnostic" },
  { "<leader>de", "<cmd>LspStart<CR>", desc = "[E]nable Diagnostic" },
  { "<leader>dl", "<cmd>Telescope diagnostics<CR>", desc = "[L]ist Diagnostic" },
  { "<leader>dn", "<cmd>lua vim.diagnostic.goto_next()<CR>", desc = "[N]ext Diagnostic" },
  { "<leader>dp", "<cmd>lua vim.diagnostic.goto_prev()<CR>", desc = "[P]rev Diagnostic" },
  -- git
  { "<leader>g", group = "[G]it signs" },
  { "<leader>gd", "<cmd>Gitsigns preview_hunk<CR>", desc = "[D]iff Hunk" },
  { "<leader>gn", "<cmd>Gitsigns next_hunk<CR>", desc = "[N]ext Hunk" },
  { "<leader>gp", "<cmd>Gitsigns prev_hunk<CR>", desc = "[P]rev Hunk" },
  { "<leader>gr", "<cmd>Gitsigns reset_hunk<CR>", desc = "[R]eset Hunk" },
  { "<leader>gt", "<cmd>Gitsigns toggle_signs<CR>", desc = "[T]oggle Signs" },
  -- moving, hop
  { "<leader>h", group = "[H]op" },
  { "<leader>hc", "<cmd>HopWordCurrentLine<CR>", desc = "[C]urrent Line Hopping" },
  { "<leader>hl", "<cmd>HopLineStart<CR>", desc = "[L]ine Hopping" },
  { "<leader>hw", "<cmd>HopWord<CR>", desc = "[W]rod Hopping" },
  -- file
  { "<leader>t", group = "[T]elescope" },
  { "<leader>tb", "<cmd>Telescope buffers<CR>", desc = "[T]o [B]uffer" },
  { "<leader>td", "<cmd>Telescope lsp_definitions<CR>", desc = "[T]o [D]efinitions" },
  { "<leader>tf", "<cmd>Telescope find_files previewer=false<CR>", desc = "[T]o [F]ile" },
  { "<leader>ti", "<cmd>Telescope lsp_implementations<CR>", desc = "[T] [I]mplementations" },
  { "<leader>tl", "<cmd>Telescope live_grep<CR>", desc = "[T]elescope [L]ive grep" },
  { "<leader>tm", "<cmd>Telescope marks<CR>", desc = "[T]o [M]arks" },
  { "<leader>tr", "<cmd>Telescope lsp_references<CR>", desc = "[T]o [R]eferences" },
  { "<leader>ts", "<cmd>Telescope grep_string<CR>", desc = "[T]o [S]tring" },
  { "<leader>tt", "<cmd>Telescope lsp_type_definitions<CR>", desc = "[T]o [T]ype Definitions" },
})

-- ========LSP and Autocomplition config========

-- nvim-cmp setup
local cmp = require('cmp')
cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
    -- vim.fn["vsnip#anonymous"](args.body) -- For 'vsnip` users
      require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
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
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' }, -- For luasnip users.
  }, {
    { name = 'buffer' },
    { name = 'path' },
    { name = 'tags' },
  })
})

-- Add additional capabilities supported by nvim-cmp
local cmp_capabilities = require('cmp_nvim_lsp').default_capabilities()

-- IMPORTANT: make sure to setup neodev BEFORE lspconfig
require("neodev").setup({
  -- add any options here, or leave empty to use the default settings
})

-- Mason
-- Easily install and manage LSP servers, DAP servers, linters, and formatters.
require("mason").setup()
-- Mason lsp configs
require("mason-lspconfig").setup({
  -- :help lspconfig-all
  ensure_installed = {
    "zls",
    "pyright",
    "lua_ls",
    "jsonls",
    "yamlls",
    -- "cmake",
    -- "gopls",
    -- "clangd",
    -- frontend dev
    -- "tsserver" has been renamed to `ts_ls`
    "ts_ls",
    "tailwindcss",
    "svelte",
    "html",
    "cssls",
  },
})

-- setup lsp with Mason
local home_dir = os.getenv('HOME')
local lspconfig = require('lspconfig')
require("mason-lspconfig").setup_handlers({
  function (server_name)
    require("lspconfig")[server_name].setup{
      -- nvim-cmp
      capabilities = cmp_capabilities,
    }
  end,
  -- mason-lspconfig provides a prebuilt zls which might outdated.
  -- override the path to use the local one
  ["zls"] = function()
    lspconfig.zls.setup{
      cmd = {home_dir .. "/bin/zls"}
    }
  end,
})

-- example to setup lua_ls and enable call snippets
lspconfig.lua_ls.setup({
  settings = {
    Lua = {
      completion = {
        callSnippet = "Replace"
      }
    }
  }
})

-- luasnip setup
-- ref: https://github.com/L3MON4D3/LuaSnip/blob/master/Examples/snippets.lua
local ls = require('luasnip')
ls.config.set_config({
  history = true,
  -- Update more often, :h events for more info.
  update_events = "TextChanged,TextChangedI",
  -- treesitter-hl has 100, use something higher (default is 200).
  ext_base_prio = 300,
  -- minimal increase in priority.
  ext_prio_increase = 1,
  enable_autosnippets = true,
})

-- for snippet to jump between parameters
-- <c-j> is my expansion key
-- this will expand the current item or jump to the next item within the snippet.
vim.keymap.set({ "i", "s" }, "<c-j>", function()
  if ls.expand_or_jumpable() then
    ls.expand_or_jump()
  end
end, { silent = true })
-- <c-k> is my jump backwards key.
-- this always moves to the previous item within the snippet
vim.keymap.set({ "i", "s" }, "<c-k>", function()
  if ls.jumpable(-1) then
    ls.jump(-1)
  end
end, { silent = true })

-- ========plugin config========

-- bufferline.nvim
vim.opt.termguicolors = true
require("bufferline").setup{
  options = {
    indicator = {
      icon = '𝄞',
      style = 'icon',
    },
    buffer_close_icon = '✗',
    modified_icon = '●',
    close_icon = '✗',
    left_trunc_marker = '>',
    right_trunc_marker = '<',
  }
}

-- telescope
require('telescope').setup {
  extensions = {
    fzf = {
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                       -- the default case_mode is "smart_case"
    }
  }
}
-- To get fzf loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
require('telescope').load_extension('fzf')

-- nvim-treesitter
---@diagnostic disable-next-line: missing-fields
require'nvim-treesitter.configs'.setup {
  -- One of "all", "maintained" (parsers with maintainers), or a list of languages
  ensure_installed = {"bash", "c", "cmake", "cpp", "css", "devicetree", "dockerfile",
    "go", "gomod", "gowork", "html", "javascript", "json", "make", "ninja",
    "python", "rust", "toml", "typescript", "vim", "yaml", "zig"},

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  -- Install languages synchronously (only applied to `ensure_installed`)
  sync_install = false,

  highlight = {
    -- `false` will disable the whole extension
    enable = true,

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}

-- colorizer setup
-- ref: https://github.com/NvChad/nvim-colorizer.lua/tree/master?tab=readme-ov-file#customization
require('colorizer').setup {
  filetypes = {
    'css',
    'javascript',
    'typescript',
    'html',
    'svelte',
  },
  user_default_options = {
    tailwind = true,
  }
}

