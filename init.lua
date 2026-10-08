--
-- A simple lua config for nvim
-- Neovim 0.12.0+ with LuaJIT
--

-- set ',' as the leader key
vim.g.mapleader = ","

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- lsp server list for mason-lspconfig
local lsp_list = {
  "zls", -- zig lsp
  "ruff", -- python linter and formatter
  "pylsp", -- python lsp
  "tinymist", -- typst lsp
  "lua_ls",
  "jsonls",
  "yamlls",
  -- "cmake",
  -- "gopls",
  -- "clangd",
  -- frontend dev
  -- "ts_ls",
  -- "tailwindcss",
  -- "svelte",
}

local mason_tools = {
  "stylua", -- lua formatter
  "prettier", -- general formatter for code
  "mdformat", -- Markdown formatter
}
-- setup lazy.nvim install plugins
require("lazy").setup({
  -- NOTE: This is where your plugins related to LSP can be installed.
  --  The configuration is done below. Search for lspconfig to find it below.
  { -- LSP Configuration & Plugins
    "mason-org/mason-lspconfig.nvim",
    opts = {
      ensure_installed = lsp_list,
    },
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
    },
  },

  -- automatically install Mason tools
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "mason-org/mason.nvim" },
    opts = { ensure_installed = mason_tools },
  },

  -- nvim-mini
  { "nvim-mini/mini.pairs", version = "*", opts = {} },
  { "nvim-mini/mini.completion", version = "*", opts = {} },
  { "nvim-mini/mini.notify", version = "*", opts = {} },
  { "nvim-mini/mini.snippets", version = "*", opts = {} },
  { "nvim-mini/mini.icons", version = "*", opts = { style = "glyph" } },

  -- Useful plugin to show you pending keybinds.
  { "folke/which-key.nvim", opts = { icons = { mappings = false } } },

  { -- Adds git releated signs to the gutter, as well as utilities for managing changes
    "lewis6991/gitsigns.nvim",
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
    },
  },

  { -- Theme inspired by Atom
    "navarasu/onedark.nvim",
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("onedark")
    end,
  },

  { -- Set lualine as statusline
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    -- See `:help lualine.txt`
    opts = {
      options = {
        icons_enabled = false,
        theme = "onedark",
        component_separators = "|",
        section_separators = "",
      },
    },
  },

  -- Fuzzy Finder (files, lsp, etc)
  {
    "nvim-telescope/telescope.nvim",
    version = "*",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = function()
          return vim.fn.executable("make") == 1
        end,
      },
    },
    config = function()
      require("telescope").setup({
        extensions = {
          fzf = {
            fuzzy = true, -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true, -- override the file sorter
            case_mode = "smart_case", -- or "ignore_case" or "respect_case"
            -- the default case_mode is "smart_case"
          },
        },
      })
      -- Keep Telescope usable when the optional native extension is unavailable.
      pcall(require("telescope").load_extension, "fzf")
    end,
  },

  { -- Highlight, edit, and navigate code
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    branch = "main",
    build = ":TSUpdate",
    config = function()
      -- stylua: ignore
      require("nvim-treesitter").install({
        "bash", "c", "cmake", "cpp", "css", "devicetree", "dockerfile", "go",
        "gomod", "gowork", "html", "javascript", "json", "make", "ninja",
        "python", "rust", "toml", "typescript", "vim", "yaml", "zig",
      })

      -- Parser installation does not enable highlighting on the main branch.
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("TreesitterHighlight", { clear = true }),
        callback = function(event)
          local lang = vim.treesitter.language.get_lang(vim.bo[event.buf].filetype)
          if lang and vim.treesitter.get_parser(event.buf, lang) then
            vim.treesitter.start(event.buf, lang)
          end
        end,
      })
    end,
  },
  { -- flash.nvim
    "folke/flash.nvim",
    event = "VeryLazy",
    ---@type Flash.Config
    opts = {},
    -- stylua: ignore
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
  },
  -- buffer as tabs
  { "akinsho/bufferline.nvim", version = "*", dependencies = "nvim-tree/nvim-web-devicons", opts = {} },
  -- file explorer
  "preservim/nerdtree",
  -- display tags in a window
  "preservim/tagbar",
  -- zig language
  { "ziglang/zig.vim", url = "https://codeberg.org/ziglang/zig.vim.git" },
  -- A (Neo)vim plugin for formatting code.
  "sbdchd/neoformat",
  -- -- The fastest Neovim colorizer.
  -- 'catgoose/nvim-colorizer.lua',

  -- render markdown
  {
    "MeanderingProgrammer/render-markdown.nvim",
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.nvim' }, -- if you use the mini.nvim suite
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.icons" }, -- if you use standalone mini plugins
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
  },
}, {
  -- lazy configuration
  -- if not use the Nerd Font
  -- ui = {
  --   icons = {
  --     cmd = "⌘",
  --     config = "🛠",
  --     event = "📅",
  --     ft = "📂",
  --     init = "⚙",
  --     keys = "🗝",
  --     plugin = "🔌",
  --     runtime = "💻",
  --     source = "📄",
  --     start = "🚀",
  --     task = "📌",
  --     lazy = "💤 ",
  --   },
  -- },
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
vim.opt.history = 3000

-- use relative line number
vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

-- enable system clipboard
vim.opt.clipboard = "unnamedplus"

-- enable mouse support
vim.o.mouse = "nv"

-- wild ignore
vim.opt.wildignore = { "*.o", "*.a", "*.obj" }

-- enable cursor line highlight
vim.opt.cursorline = true

-- go to last location
vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local line = mark[1]

    if line > 1 and line <= vim.api.nvim_buf_line_count(0) then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- popup menu
vim.opt.completeopt = {
  "menu",
  "menuone",
  "noselect",
  "popup",
}

-- disable providers
-- vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0

-- ========formatter configs for Neoformat========
vim.g.neoformat_enabled_python = { "ruff" }
vim.g.neoformat_enabled_lua = { "stylua" }
vim.g.neoformat_enabled_markdown = { "mdformat" }
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
  { "<leader>bh", vim.lsp.buf.hover, desc = "[H]over in Buffer" },
  { "<leader>bn", "<cmd>bn<CR>", desc = "[N]ext Buffer" },
  { "<leader>bp", "<cmd>bp<CR>", desc = "[P]revious Buffer" },
  { "<leader>br", vim.lsp.buf.rename, desc = "[R]ename in Buffer" },
  { "<leader>bs", "<cmd>BufferLinePick<CR>", desc = "[S]elect buffer tab" },
  -- diagnostics
  { "<leader>d", group = "[D]iagnostics" },
  { "<leader>da", vim.lsp.buf.code_action, desc = "Code [A]ction" },
  {
    "<leader>dd",
    function()
      vim.diagnostic.enable(false)
    end,
    desc = "[D]isable Diagnostic",
  },
  {
    "<leader>de",
    function()
      vim.diagnostic.enable(true)
    end,
    desc = "[E]nable Diagnostic",
  },
  { "<leader>dl", "<cmd>Telescope diagnostics<CR>", desc = "[L]ist Diagnostic" },
  { "<leader>dn", "<cmd>lua vim.diagnostic.jump({ count = 1, float = true })<CR>", desc = "[N]ext Diagnostic" },
  { "<leader>dp", "<cmd>lua vim.diagnostic.jump({ count = -1, float = true })<CR>", desc = "[P]rev Diagnostic" },
  -- git
  { "<leader>g", group = "[G]it signs" },
  { "<leader>gd", "<cmd>Gitsigns preview_hunk<CR>", desc = "[D]iff Hunk" },
  { "<leader>gn", "<cmd>Gitsigns nav_hunk next<CR>", desc = "[N]ext Hunk" },
  { "<leader>gp", "<cmd>Gitsigns nav_hunk prev<CR>", desc = "[P]rev Hunk" },
  { "<leader>gr", "<cmd>Gitsigns reset_hunk<CR>", desc = "[R]eset Hunk" },
  { "<leader>gt", "<cmd>Gitsigns toggle_signs<CR>", desc = "[T]oggle Signs" },
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
  -- others
  { "<leader>rm", "<cmd>RenderMarkdown toggle<CR>", desc = "[R]ender[M]arkdown toggle" },
})

if vim.lsp.inlay_hint then
  wk.add({
    {
      "<leader>H",
      "<cmd>lua vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())<CR>",
      desc = "Toggle Inlay Hints",
    },
  })
end

-- Native completion menu:
--
--   <C-n>    next item
--   <C-p>    previous item
--   <C-y>    accept selected item
--   <C-e>    cancel completion
--   <C-l>    snippets next item
--   <C-h>    snippets previous item
--
-- These are built into Neovim.

-- To use `<Tab>` and `<S-Tab>` for navigation through completion list
local imap_expr = function(lhs, rhs)
  vim.keymap.set("i", lhs, rhs, { expr = true })
end
imap_expr("<Tab>", [[pumvisible() ? "\<C-n>" : "\<Tab>"]])
imap_expr("<S-Tab>", [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]])

-- ========LSP and Autocomplition config========

-- `zig` LSP to use local lsp engine
local zls_path = vim.env.HOME .. "/bin/zls"
if vim.fn.executable(zls_path) == 1 then
  vim.lsp.config("zls", {
    cmd = { zls_path },
  })
end

-- Lua / Neovim development.
-- fixed "Undefined global vim"
vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
      },

      workspace = {
        -- Don't ask about configuring third-party libraries.
        checkThirdParty = false,

        library = {
          vim.env.VIMRUNTIME,
        },
      },
    },
  },
})

vim.lsp.enable(lsp_list)
