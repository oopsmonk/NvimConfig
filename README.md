# Neovim Configuration

A single-file Lua configuration for **Neovim 0.12.0+ with LuaJIT**. See [init.lua](init.lua) for the active configuration.

## Requirements

- Git and network access for plugin and tool installation.
- Tree-sitter CLI **0.26.1 or newer**, a C compiler, `curl`, and `tar` for the configured Treesitter `main` branch.
- `make` and a C compiler for the optional Telescope FZF native extension. Telescope remains usable when the extension is unavailable.
- `ripgrep` (`rg`) for Telescope live grep and string search.
- Python 3 with virtual-environment support for `pylsp`. On Ubuntu with Python 3.12, install `python3.12-venv` if installation reports missing `ensurepip`.
- Node.js and npm for the JSON and YAML language servers.
- Universal Ctags for Tagbar; a clipboard provider for system clipboard integration.
- A Nerd Font for the configured glyph icons.

## Setup and maintenance

Place this repository's `init.lua` in Neovim's configuration directory, normally `~/.config/nvim/init.lua`. Keep `.stylua.toml` in the project when formatting this repository.

On startup, the configuration bootstraps lazy.nvim, installs plugins, requests the configured LSP servers through Mason, and installs StyLua through mason-tool-installer. Treesitter requests missing parsers asynchronously; reopen a file after its first parser installation if highlighting is not yet active.

| Command | Purpose |
| --- | --- |
| `:Lazy` | Inspect, install, or update plugins |
| `:Mason` | Inspect installed language servers and tools |
| `:MasonToolsInstall` | Install missing tools from `mason_tools` |
| `:TSUpdate` | Update Treesitter parsers |
| `:checkhealth nvim-treesitter` | Check parser tooling and dependencies |
| `:checkhealth vim.lsp` | Inspect LSP configuration and active clients |
| `:Neoformat` | Format the current buffer |
| `:TagbarToggle` | Toggle the symbol outline |

Formatting uses **Ruff for Python** and **StyLua for Lua**. Formatting is manual; there is no format-on-save autocmd. [.stylua.toml](.stylua.toml) uses two-space indentation, prefers double quotes, and sets a 120-column width.

## Language servers and parsers

The `lsp_list` in `init.lua` requests installation and enables these servers:

| Server | Language / purpose |
| --- | --- |
| `zls` | Zig |
| `ruff` | Python linting and formatting |
| `pylsp` | Python language features |
| `tinymist` | Typst |
| `lua_ls` | Lua, with LuaJIT and Neovim runtime settings |
| `jsonls` | JSON |
| `yamlls` | YAML |

If executable, `~/bin/zls` overrides the default ZLS command. Installing a server does not guarantee attachment: the filetype and server's workspace rules must also match.

To see servers attached to the current file:

```vim
:lua vim.print(vim.tbl_map(function(c) return c.name end, vim.lsp.get_clients({ bufnr = 0 })))
```

Treesitter installs parsers for Bash, C, CMake, C++, CSS, Devicetree, Dockerfile, Go, Go modules/workspaces, HTML, JavaScript, JSON, Make, Ninja, Python, Rust, TOML, TypeScript, Vim, YAML, and Zig. A `FileType` autocmd enables highlighting when a parser is available. Parser support and LSP support are configured separately.

## Keybindings

The leader key is **`,`**. Pause after a mapping prefix to see which-key hints. Unless a mode is specified, the mappings below use Normal mode.

### Files and buffers

| Keys | Action |
| --- | --- |
| `,nf` | Find the current file in NERDTree |
| `,nt` | Toggle NERDTree |
| `,ng` | Open NERDTree at the version-control root |
| `,bd` | Delete buffer |
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

## Editor settings

- Absolute and relative line numbers, plus cursor-line highlighting.
- Tab width and shift width of two; `expandtab` is not explicitly enabled.
- System clipboard via `unnamedplus`; mouse enabled in Normal and Visual modes.
- Restore the saved cursor position when reading a file.
- Update interval of 300 ms and command history of 3000 entries.
- Completion menu with popup information and no preselected item.
- Ignore `*.o`, `*.a`, and `*.obj` during wildcard expansion.
- Disable the Perl provider.

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
| [mini.tabline](https://github.com/nvim-mini/mini.tabline) | Buffer tabline |
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
