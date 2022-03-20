# NVIM Config in Lua

Replace local nvim config

```
mv ~/.config/nvim ~/.config/nvim-backup
ln -s nvimconfig ${HOME}/.config/nvim
```

Install requirments

```
./install-deps.sh
```

Install plugins

```
nvim +PackerInstall
```

Check plugin

```
nvim +checkhealth
```

