# dothatch

Dotfiles hatchery is a place for:

- Everything needed to start a minimal workspace
- Building environments
- Create and maintain everyday tools
- Tools and configurations live

# folder structure

```bash
.
├── bin # export PATH="~/dothatch/bin:$PATH"
│   ├── code-session-mgmt.sh
│   └── nvim-data-clean.sh
├── config
│   ├── tmux.conf       # $XDG_CONFIG_HOME/tmux/tmux.conf
│   └── wezterm.lua     # $XDG_CONFIG_HOME/wezterm/wezterm.lua
├── .gitignore
├── nvim
│   ├── init.lua
│   ├── INSTALL_darwin.md
│   ├── INSTALL.md
│   ├── lazy-lock.json
│   └── README.md
├── .prettierignore
├── .prettierrc.toml
├── README.md
└── .stylua.toml
```
