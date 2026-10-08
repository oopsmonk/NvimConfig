# Neovim Configuration

A single-file Lua configuration for **Neovim 0.12.0+ with LuaJIT**. See [init.lua](init.lua) for the active configuration.

## Requirements

- Tree-sitter CLI **0.26.1 or newer**, a C compiler, `curl`, and `gzip` for the configured Treesitter `main` branch.
- `ripgrep` (`rg`) for Telescope live grep and string search.
- Python 3 with virtual-environment support for `pylsp`.
- Node.js and npm for the JSON and YAML language servers.
- Universal Ctags for Tagbar; a clipboard provider for system clipboard integration.
- A Nerd Font for the configured glyph icons.

## Setup and maintenance

On startup, the configuration bootstraps lazy.nvim, installs plugins, requests the configured LSP servers through `Mason`, and installs formaters through `mason-tool-installer`.

| Command | Purpose |
| --- | --- |
| `:Lazy` | Inspect, install, or update plugins |
| `:Mason` | Inspect installed language servers and tools |
| `:MasonToolsInstall` | Install missing tools from `mason_tools` |
| `:TSUpdate` | Update Treesitter parsers |
| `:checkhealth nvim-treesitter` | Check parser tooling and dependencies |
| `:checkhealth vim.lsp` | Inspect LSP configuration and active clients |
| `:Neoformat` | Format the current buffer |

There is no format-on-save autocmd. [.stylua.toml](.stylua.toml) uses two-space indentation, prefers double quotes, and sets a 120-column width.

## Language servers and parsers

To see servers attached to the current file:

```vim
:lua vim.print(vim.tbl_map(function(c) return c.name end, vim.lsp.get_clients({ bufnr = 0 })))
```

## Keybindings

The leader key is **`,`**.

### Files and buffers

| Keys | Action |
| --- | --- |
| `,nf` | Find the current file in NERDTree |
| `,nt` | Toggle NERDTree |
| `,ng` | Open NERDTree at the version-control root |
| `,bd` | Delete buffer |
| `,bs` | Selete buffer |
| `,bn` / `,bp` | Next / previous buffer |
| `,bh` | LSP hover information |
| `,br` | LSP rename |
| `,rm` | Toggle Markdown rendering |
| `,H` | Toggle inlay hints |

### Diagnostics and code actions

| Keys | Action |
| --- | --- |
| `,da` | LSP code action |
| `,dd` / `,de` | Disable / enable diagnostics globally |
| `,dl` | List diagnostics with Telescope |
| `,dn` / `,dp` | Next / previous diagnostic, with a floating message |

Disabling diagnostics leaves language servers running.

### Git signs

| Keys | Action |
| --- | --- |
| `,gd` | Preview hunk |
| `,gn` / `,gp` | Next / previous hunk |
| `,gr` | Reset hunk |
| `,gt` | Toggle gutter signs |

### Telescope

| Keys | Picker |
| --- | --- |
| `,tb` | Buffers |
| `,td` | LSP definitions |
| `,tf` | Files, without preview |
| `,ti` | LSP implementations |
| `,tl` | Live grep |
| `,tm` | Marks |
| `,tr` | LSP references |
| `,ts` | Search the string under the cursor |
| `,tt` | LSP type definitions |

### Flash navigation

| Keys | Modes | Action |
| --- | --- | --- |
| `s` | Normal, Visual, Operator-pending | Jump with Flash |
| `S` | Normal, Visual, Operator-pending | Treesitter selection |
| `r` | Operator-pending | Remote Flash operation |
| `R` | Visual, Operator-pending | Treesitter search |
| `Ctrl-s` | Command-line | Toggle Flash search |

### Completion and snippets

In Insert mode:

| Keys | Action |
| --- | --- |
| `Tab` / `Shift-Tab` | Next / previous item when the completion menu is visible; otherwise pass the key through |
| `Ctrl-n` / `Ctrl-p` | Next / previous completion item |
| `Ctrl-y` | Accept completion |
| `Ctrl-e` | Cancel completion |
| `Ctrl-j` | Expand a mini.snippets snippet |
| `Ctrl-l` / `Ctrl-h` | Next / previous mini.snippets tabstop |

mini.snippets is enabled with default options; no snippet collection is configured.

### Built-in navigation and windows

| Keys | Action |
| --- | --- |
| `Ctrl-o` / `Ctrl-i` | Older / newer jumplist position |
| `gcc` | Comment / uncomment the current line |
| `Ctrl-w s` / `Ctrl-w v` | Horizontal / vertical split |
| `Ctrl-w H` | Move the current window to the far left |
| `Ctrl-w r` | Rotate windows |
| `Ctrl-w o` | Close other windows |

## Plugins

Only active plugins and their dependencies are listed below.

| Plugin | Purpose |
| --- | --- |
| [lazy.nvim](https://github.com/folke/lazy.nvim) | Plugin manager |
| [mason.nvim](https://github.com/mason-org/mason.nvim) | External tool manager |
| [mason-lspconfig.nvim](https://github.com/mason-org/mason-lspconfig.nvim) | LSP installation and integration |
| [mason-tool-installer.nvim](https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim) | Automatic StyLua installation |
| [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) | LSP server configurations |
| [mini.pairs](https://github.com/nvim-mini/mini.pairs) | Automatic character pairing |
| [mini.completion](https://github.com/nvim-mini/mini.completion) | Completion |
| [mini.notify](https://github.com/nvim-mini/mini.notify) | Notifications |
| [mini.snippets](https://github.com/nvim-mini/mini.snippets) | Snippet expansion and navigation |
| [mini.icons](https://github.com/nvim-mini/mini.icons) | Glyph icons |
| [which-key.nvim](https://github.com/folke/which-key.nvim) | Mapping hints |
| [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) | Git gutter signs and hunk actions |
| [onedark.nvim](https://github.com/navarasu/onedark.nvim) | Colorscheme |
| [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) | Statusline |
| [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) | Search and navigation pickers |
| [plenary.nvim](https://github.com/nvim-lua/plenary.nvim) | Telescope dependency |
| [telescope-fzf-native.nvim](https://github.com/nvim-telescope/telescope-fzf-native.nvim) | Optional native fuzzy sorter |
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | Parser installation and queries, using the `main` branch |
| [nvim-treesitter-textobjects](https://github.com/nvim-treesitter/nvim-treesitter-textobjects) | Treesitter dependency; no custom mappings configured |
| [flash.nvim](https://github.com/folke/flash.nvim) | Label-based navigation and Treesitter selection |
| [nerdtree](https://github.com/preservim/nerdtree) | File explorer |
| [tagbar](https://github.com/preservim/tagbar) | Symbol outline |
| [zig.vim](https://codeberg.org/ziglang/zig.vim) | Zig file detection and syntax |
| [neoformat](https://github.com/sbdchd/neoformat) | Buffer formatting |
| [render-markdown.nvim](https://github.com/MeanderingProgrammer/render-markdown.nvim) | Markdown rendering |
| [bufferline.nvim](https://github.com/akinsho/bufferline.nvim) | A snazzy bufferline |
