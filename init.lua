--
-- A simple lua config for nvim
-- Neovim 0.12+
--

-- ============================================================================
-- Global Settings
-- ============================================================================

vim.g.mapleader = ","

local map = vim.keymap.set

-- use relative line number
vim.opt.number = true
vim.opt.relativenumber = true

-- default indentation
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2

-- enable system clipboard
vim.opt.clipboard = "unnamedplus"

-- enable mouse support
vim.opt.mouse = "nv"

-- enable cursor line highlight
vim.opt.cursorline = true

-- enable true color
vim.opt.termguicolors = true
vim.opt.background = "dark"

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

-- ============================================================================
-- Plugins
-- ============================================================================

-- Neovim 0.12 built-in package manager.
vim.pack.add({
  "https://github.com/nvim-mini/mini.nvim",
  "https://github.com/neovim/nvim-lspconfig",
})

-- ============================================================================
-- Colorscheme: mini.hues
-- ============================================================================

-- bundled mini.hues colorscheme
vim.cmd.colorscheme("miniwinter")

-- ============================================================================
-- mini.icons
-- ============================================================================

-- Icons used by mini.files, mini.pick, mini.tabline, etc.
require("mini.icons").setup({
  style = "glyph",
})

-- ============================================================================
-- mini.clue
-- ============================================================================

-- Show available key mappings after pressing prefix keys.
local clue = require("mini.clue")

clue.setup({
  triggers = {
    -- Leader mappings
    { mode = "n", keys = "<Leader>" },
    { mode = "x", keys = "<Leader>" },

    -- Built-in mappings
    { mode = "n", keys = "[" },
    { mode = "n", keys = "]" },

    { mode = "n", keys = "g" },
    { mode = "x", keys = "g" },

    { mode = "n", keys = "'" },
    { mode = "n", keys = "`" },

    { mode = "n", keys = '"' },
    { mode = "x", keys = '"' },

    { mode = "n", keys = "<C-w>" },

    -- Insert mode completion
    { mode = "i", keys = "<C-x>" },
  },

  clues = {
    clue.gen_clues.builtin_completion(),
    clue.gen_clues.g(),
    clue.gen_clues.marks(),
    clue.gen_clues.registers(),
    clue.gen_clues.windows(),
    clue.gen_clues.z(),

    -- Leader groups
    { mode = "n", keys = "<Leader>b", desc = "+Buffer" },
    { mode = "n", keys = "<Leader>d", desc = "+Diagnostic" },
    { mode = "n", keys = "<Leader>n", desc = "+Files" },
    { mode = "n", keys = "<Leader>t", desc = "+Pick" },
  },
})

-- ============================================================================
-- mini.comment
-- ============================================================================

-- gcc      comment/uncomment current line
-- gc       comment visual selection
-- gc{motion}
require("mini.comment").setup()

-- ============================================================================
-- mini.pairs
-- ============================================================================

-- Automatic (), [], {}, "", '', etc.
require("mini.pairs").setup()

-- ============================================================================
-- mini.diff
-- ============================================================================

-- Git diff signs and hunk operations.
--
-- Useful default mappings:
--   ]h     next hunk
--   [h     previous hunk
--   ]H     last hunk
--   [H     first hunk
--   gh     apply hunk
--   gH     reset hunk
require("mini.diff").setup({
  view = {
    style = "sign",
    signs = {
      add = "+",
      change = "~",
      delete = "_",
    },
  },
})

-- ============================================================================
-- mini.files
-- ============================================================================

-- Miller-column style file explorer.
local files = require("mini.files")

files.setup({
  options = {
    -- Use mini.files when opening a directory:
    --
    --   nvim .
    use_as_default_explorer = true,
  },

  windows = {
    preview = true,
    width_focus = 30,
    width_nofocus = 20,
    width_preview = 50,
  },
})

-- Open current working directory.
map("n", "<Leader>nt", files.open, {
  desc = "[N]avigate files",
})

-- Open explorer focused on current file.
map("n", "<Leader>nf", function()
  local path = vim.api.nvim_buf_get_name(0)
  files.open(path ~= "" and path or nil)
end, {
  desc = "[N]avigate current [F]ile",
})

-- Open Git project root.
map("n", "<Leader>ng", function()
  local git_root = vim.fs.root(0, ".git")
  files.open(git_root or vim.fn.getcwd())
end, {
  desc = "[N]avigate [G]it root",
})

-- ============================================================================
-- mini.pick + mini.extra
-- ============================================================================

-- Fuzzy finder.
--
-- Recommended CLI dependency:
--
--   ripgrep (rg)
--
-- mini.extra provides additional pickers such as diagnostics,
-- LSP locations, marks, history, etc.
local pick = require("mini.pick")
local extra = require("mini.extra")

pick.setup()
extra.setup()

-- Use mini.pick for vim.ui.select().
vim.ui.select = pick.ui_select

-- --------------------------------------------------------------------------
-- Files
-- --------------------------------------------------------------------------

map("n", "<Leader>tf", pick.builtin.files, {
  desc = "[T]o [F]ile",
})

-- --------------------------------------------------------------------------
-- Buffers
-- --------------------------------------------------------------------------

map("n", "<Leader>bs", pick.builtin.buffers, {
  desc = "[B]uffer [S]elect",
})

map("n", "<Leader>bn", "<cmd>bnext<CR>", {
  desc = "[B]uffer [N]ext",
})

map("n", "<Leader>bp", "<cmd>bprevious<CR>", {
  desc = "[B]uffer [P]revious",
})

-- --------------------------------------------------------------------------
-- Grep
-- --------------------------------------------------------------------------

map("n", "<Leader>tl", pick.builtin.grep_live, {
  desc = "[T]o [L]ive grep",
})

map("n", "<Leader>ts", function()
  pick.builtin.grep({
    pattern = vim.fn.expand("<cword>"),
  })
end, {
  desc = "[T]o current [S]tring",
})

-- --------------------------------------------------------------------------
-- Marks
-- --------------------------------------------------------------------------

map("n", "<Leader>tm", extra.pickers.marks, {
  desc = "[T]o [M]arks",
})

-- --------------------------------------------------------------------------
-- Diagnostics
-- --------------------------------------------------------------------------

map("n", "<Leader>dl", function()
  extra.pickers.diagnostic({
    scope = "all",
  })
end, {
  desc = "[D]iagnostic [L]ist",
})

-- --------------------------------------------------------------------------
-- LSP
-- --------------------------------------------------------------------------

local function lsp_pick(scope)
  return function()
    extra.pickers.lsp({
      scope = scope,
    })
  end
end

map("n", "<Leader>td", lsp_pick("definition"), {
  desc = "[T]o [D]efinition",
})

map("n", "<Leader>ti", lsp_pick("implementation"), {
  desc = "[T]o [I]mplementation",
})

map("n", "<Leader>tr", lsp_pick("references"), {
  desc = "[T]o [R]eferences",
})

map("n", "<Leader>tt", lsp_pick("type_definition"), {
  desc = "[T]o [T]ype definition",
})

-- ============================================================================
-- mini.statusline
-- ============================================================================

require("mini.statusline").setup({
  use_icons = false,
})

-- ============================================================================
-- mini.tabline
-- ============================================================================

-- Display open buffers in tabline.
require("mini.tabline").setup({
  show_icons = true,
})

-- ============================================================================
-- LSP configs
-- ============================================================================

-- nvim-lspconfig provides server definitions.
-- Neovim 0.12 handles LSP configuration and lifecycle using:
--
--   vim.lsp.config()
--   vim.lsp.enable()
local lsp_list = {
  "zls",
  "ruff",
  "pylsp",
  "tinymist",
  "lua_ls",
  "jsonls",
  "yamlls",

  -- frontend
  "ts_ls",
  "tailwindcss",
  "svelte",
}

-- ============================================================================
-- Server-specific config
-- ============================================================================

-- Prefer local ZLS if available.
local zls_path = vim.env.HOME .. "/bin/zls"

if vim.fn.executable(zls_path) == 1 then
  vim.lsp.config("zls", {
    cmd = { zls_path },
  })
end

-- Lua / Neovim development.
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

-- ============================================================================
-- Enable LSP servers
-- ============================================================================

vim.lsp.enable(lsp_list)

-- ============================================================================
-- Native LSP completion
-- ============================================================================

-- Neovim native completion menu.
vim.opt.completeopt = {
  "menu",
  "menuone",
  "noselect",
  "popup",
}

-- Enable native LSP completion when an LSP client attaches.
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    if client and client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, args.buf, {
        autotrigger = true,
      })
    end
  end,
})

-- ============================================================================
-- Completion mappings
-- ============================================================================

-- Manually request LSP completion.
map("i", "<C-Space>", vim.lsp.completion.get, {
  desc = "LSP completion",
})

-- Native completion menu:
--
--   <C-n>    next item
--   <C-p>    previous item
--   <C-y>    accept selected item
--   <C-e>    cancel completion
--
-- These are built into Neovim.

-- ============================================================================
-- LSP mappings
-- ============================================================================

map("n", "<Leader>bh", vim.lsp.buf.hover, {
  desc = "[B]uffer [H]over",
})

map("n", "<Leader>br", vim.lsp.buf.rename, {
  desc = "[B]uffer [R]ename",
})

map("n", "<Leader>da", vim.lsp.buf.code_action, {
  desc = "[D]iagnostic code [A]ction",
})

map("n", "<Leader>dn", function()
  vim.diagnostic.jump({
    count = 1,
    float = true,
  })
end, {
  desc = "[D]iagnostic [N]ext",
})

map("n", "<Leader>dp", function()
  vim.diagnostic.jump({
    count = -1,
    float = true,
  })
end, {
  desc = "[D]iagnostic [P]revious",
})

-- ============================================================================
-- Inlay hints
-- ============================================================================

map("n", "<Leader>H", function()
  local enabled = vim.lsp.inlay_hint.is_enabled({
    bufnr = 0,
  })

  vim.lsp.inlay_hint.enable(not enabled, {
    bufnr = 0,
  })
end, {
  desc = "Toggle Inlay Hints",
})

