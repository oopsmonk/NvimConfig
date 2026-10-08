# Install on Ubuntu / Debian

This configuration requires **Neovim 0.12.0+ with LuaJIT** and **Tree-sitter CLI 0.26.1+**. For macOS, use [INSTALL_darwin.md](INSTALL_darwin.md).

## Install system dependencies

```bash
sudo apt-get update
sudo apt-get install git curl tar gzip build-essential ripgrep universal-ctags python3 python3-venv python3-pip nodejs npm
```

`build-essential` supplies a C compiler and `make` for parsers and Telescope's optional FZF extension. JSON and YAML servers need Node.js/npm; if Mason reports an unsupported Node version, upgrade Node.js to a version accepted by that package.

For clipboard access, install the tool matching your desktop session:

```bash
# Wayland
sudo apt-get install wl-clipboard
# X11
sudo apt-get install xclip
```

Use a Nerd Font in your terminal for glyph icons. `fd-find` is optional for Telescope; `ripgrep` is needed for grep pickers.

The existing `install-deps.sh` uses legacy dependencies and is not the setup path for the current configuration. Use the commands in this guide.

## Install Neovim

Check an existing installation first:

```bash
nvim --version
```

If your distribution's package is older than 0.12, use an [official Neovim release](https://github.com/neovim/neovim/releases). The following installs the current stable Linux archive locally, following the [official installation guide](https://neovim.io/doc/install/):

```bash
case "$(uname -m)" in
  x86_64) nvim_arch=x86_64 ;;
  aarch64|arm64) nvim_arch=arm64 ;;
  *) echo "Choose a supported build from the release page"; exit 1 ;;
esac
curl -fL "https://github.com/neovim/neovim/releases/latest/download/nvim-linux-${nvim_arch}.tar.gz" -o /tmp/nvim-linux.tar.gz
mkdir -p "$HOME/.local/opt"
tar -xzf /tmp/nvim-linux.tar.gz -C "$HOME/.local/opt"
export PATH="$HOME/.local/opt/nvim-linux-${nvim_arch}/bin:$HOME/.local/bin:$PATH"
nvim --version
```

Verify the version is at least 0.12. Add the corresponding PATH line, with the actual architecture, to your shell configuration to persist it.

## Install Tree-sitter CLI

Use a package manager if it provides version 0.26.1 or newer. Otherwise, install the [official 0.26.1 binary](https://github.com/tree-sitter/tree-sitter/releases/tag/v0.26.1):

```bash
case "$(uname -m)" in
  x86_64) treesitter_arch=x64 ;;
  aarch64|arm64) treesitter_arch=arm64 ;;
  *) echo "Choose a supported build from the release page"; exit 1 ;;
esac
curl -fL "https://github.com/tree-sitter/tree-sitter/releases/download/v0.26.1/tree-sitter-linux-${treesitter_arch}.gz" -o /tmp/tree-sitter-0.26.1.gz
gzip -dc /tmp/tree-sitter-0.26.1.gz > /tmp/tree-sitter-0.26.1
chmod +x /tmp/tree-sitter-0.26.1
/tmp/tree-sitter-0.26.1 --version
mkdir -p "$HOME/.local/bin"
install -m 755 /tmp/tree-sitter-0.26.1 "$HOME/.local/bin/tree-sitter"
export PATH="$HOME/.local/bin:$PATH"
tree-sitter --version
```

Persist the PATH line in your shell configuration. If you already use `~/bin/tree-sitter`, replace that copy or ensure the new directory comes first in PATH.

## Check Python virtual environments

```bash
python3 -m venv /tmp/nvim-pylsp-check
/tmp/nvim-pylsp-check/bin/python -m pip --version
```

If Python 3.12 reports missing `ensurepip`, install the matching package and repeat the check:

```bash
sudo apt-get install python3.12-venv
```

Mason installs `pylsp` into its own virtual environment; no global `pip install` is needed.

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
