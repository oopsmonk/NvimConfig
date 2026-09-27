#!/usr/bin/env bash
set -Eeuo pipefail

DATA_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/nvim"
STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/nvim"
CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/nvim"

echo "Neovim cleanup targets:"
echo "  Data : $DATA_DIR"
echo "  State: $STATE_DIR"
echo "  Cache: $CACHE_DIR"
echo
echo "Config will NOT be removed:"
echo "  ${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
echo

read -r -p "Remove Neovim plugins/data/state/cache? [y/N] " answer

case "$answer" in
    y|Y|yes|YES)
        rm -rf -- "$DATA_DIR"
        rm -rf -- "$STATE_DIR"
        rm -rf -- "$CACHE_DIR"

        echo
        echo "Neovim plugins/data/state/cache removed."
        ;;
    *)
        echo "Cancelled."
        ;;
esac

