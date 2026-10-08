# Install on macOS

This configuration requires **Neovim 0.12.0+ with LuaJIT** and **Tree-sitter CLI 0.26.1+**. For Ubuntu / Debian, use [INSTALL.md](INSTALL.md).

## Install dependencies

Install [Homebrew](https://brew.sh/) if needed, then install the Command Line Tools and dependencies:

```bash
# Skip this if the Command Line Tools are already installed.
xcode-select --install
```

Complete the Command Line Tools installation before continuing:

```bash
brew update
brew install neovim tree-sitter-cli git ripgrep universal-ctags node python
```

Homebrew's [Neovim formula](https://formulae.brew.sh/formula/neovim) supplies the editor, and [tree-sitter-cli](https://formulae.brew.sh/formula/tree-sitter-cli) supplies the parser-generation executable. The Command Line Tools provide the compiler and `make` needed by Treesitter and Telescope's optional native sorter.

Verify versions and Python virtual-environment support:

```bash
nvim --version
tree-sitter --version
node --version
npm --version
python3 -m venv /tmp/nvim-pylsp-check
/tmp/nvim-pylsp-check/bin/python -m pip --version
ctags --version
```

Neovim must be at least 0.12, Tree-sitter CLI at least 0.26.1, and `ctags` should report Universal Ctags. If installed versions are older:

```bash
brew upgrade neovim tree-sitter-cli
```

If Homebrew commands are missing from PATH, follow the `brew shellenv` instructions printed by the Homebrew installer. Check for old executables in `~/bin` if a version remains outdated.

Use a Nerd Font in your terminal for glyph icons. macOS clipboard integration uses the built-in `pbcopy` and `pbpaste` tools, as documented in [Neovim's clipboard provider reference](https://neovim.io/doc/user/provider/). `fd` is optional for Telescope. The native FZF extension builds itself; a separate `fzf` installation is not required by this configuration.

Mason manages the configured LSP servers and StyLua. There is no need to globally install Pyright, rust-analyzer, or `pynvim` for the active configuration.

## Configure Neovim

Clone the repository into a permanent location:

```bash
git clone https://github.com/oopsmonk/NvimConfig.git "$HOME/NvimConfig"
mkdir -p "${XDG_CONFIG_HOME:-$HOME/.config}"
```

If that checkout already exists, use it instead of cloning again. Before linking, move any existing `nvim` configuration to an unused backup location. For example, run this only if `nvim-backup` does not already exist:

```bash
mv "${XDG_CONFIG_HOME:-$HOME/.config}/nvim" "${XDG_CONFIG_HOME:-$HOME/.config}/nvim-backup"
```

Skip the move if there is no existing configuration. Then create the symlink:

```bash
ln -s "$HOME/NvimConfig" "${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
nvim
```

Keep Neovim open while initial downloads finish. `init.lua` bootstraps lazy.nvim and requests:

- LSP servers through mason-lspconfig: `zls`, `ruff`, `pylsp`, `tinymist`, `lua_ls`, `jsonls`, and `yamlls`.
- StyLua through mason-tool-installer.
- Treesitter parsers listed in the plugin configuration.

Mason installs these tools under Neovim's data directory and adds its executable directory to Neovim's PATH. If `~/bin/zls` is executable, the configuration uses it instead of Mason's ZLS command.

Parser installation is asynchronous. Reopen a file after its parser finishes installing if highlighting is not yet active. Git and network access are needed for installation.

## Verify installation

Run these inside Neovim:

```vim
:Lazy
:Mason
:checkhealth vim.lsp
:checkhealth nvim-treesitter
:checkhealth vim.provider
```

Open a source file to check server attachment:

```vim
:lua vim.print(vim.tbl_map(function(c) return c.name end, vim.lsp.get_clients({ bufnr = 0 })))
```

An empty list means no server is attached to that buffer. Attachment depends on the filetype and the server's workspace rules.

Use `:Neoformat` to format Lua with StyLua or Python with Ruff. Formatting is manual. Repository StyLua settings are in [.stylua.toml](.stylua.toml).

## Troubleshooting

### Tree-sitter CLI version error

The configured `nvim-treesitter` `main` branch requires Tree-sitter CLI **0.26.1 or newer**. Check both the version and the executable Neovim resolves:

```vim
:!tree-sitter --version
:lua print(vim.fn.exepath("tree-sitter"))
```

An older copy in `~/bin` can take precedence over a newer installation. Correct PATH ordering or replace that executable, restart Neovim, and run:

```vim
:checkhealth nvim-treesitter
:TSUpdate
```

### Parser or highlighting errors

Check the CLI and compiler with `:checkhealth nvim-treesitter`, then run `:TSUpdate`. To install an individual missing parser, use `:TSInstall lua`, replacing `lua` with the required language. Reopen the affected file afterward.

### Mason installation failures

Inspect `:Mason` and `:MasonLog` for the failing package. Ensure Python virtual environments work for `pylsp`, and that Node.js and npm are available for JSON/YAML servers. Retry with:

```vim
:MasonInstall python-lsp-server
:MasonToolsInstall
```

Do not routinely delete `~/.local/share/nvim`, `~/.local/state/nvim`, or `~/.cache/nvim`: these contain installed tools, plugins, logs, and editor state. Diagnose the failing component first.

See [README.md](README.md) for all active plugins and keybindings.
