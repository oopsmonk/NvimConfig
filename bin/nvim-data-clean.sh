#!/usr/bin/env bash
set -Eeuo pipefail

fail() {
  printf 'Error: %s\n' "$*" >&2
  exit 1
}

# Limit cleanup to a single profile directory, never a traversing path.
app_name="${NVIM_APPNAME-nvim}"
case "$app_name" in
  ""|.|..|*/*|*\\*) fail "NVIM_APPNAME must be a nonempty directory name without path separators." ;;
esac

command -v python3 >/dev/null || fail "python3 is required to validate cleanup paths."

canonical_path() {
  python3 -c 'import os, sys; print(os.path.realpath(sys.argv[1]))' "$1"
}

home_dir="${HOME:?HOME must be set}"
data_base="${XDG_DATA_HOME:-$home_dir/.local/share}"
state_base="${XDG_STATE_HOME:-$home_dir/.local/state}"
cache_base="${XDG_CACHE_HOME:-$home_dir/.cache}"
config_base="${XDG_CONFIG_HOME:-$home_dir/.config}"

for base in "$home_dir" "$data_base" "$state_base" "$cache_base" "$config_base"; do
  case "$base" in
    /*) ;;
    *) fail "HOME and XDG directory paths must be absolute: $base" ;;
  esac
done

home_dir="$(canonical_path "$home_dir")"
config_dir="$(canonical_path "$config_base/$app_name")"
DATA_DIR="$(canonical_path "$data_base/$app_name")"
STATE_DIR="$(canonical_path "$state_base/$app_name")"
CACHE_DIR="$(canonical_path "$cache_base/$app_name")"

# Resolve symlinks and '..' before checking every target, before any deletion.
for target in "$DATA_DIR" "$STATE_DIR" "$CACHE_DIR"; do
  case "$target" in
    /|"$home_dir") fail "Refusing to remove an unsafe directory: $target" ;;
  esac
  case "$home_dir/" in
    "$target/"*) fail "Cleanup target contains HOME: $target" ;;
  esac
  case "$config_dir/" in
    "$target/"*) fail "Cleanup target contains the config directory: $target" ;;
  esac
  case "$target/" in
    "$config_dir/"*) fail "Cleanup target is inside the config directory: $target" ;;
  esac
done

printf 'Neovim cleanup targets (profile: %s):\n' "$app_name"
printf '  Data : %s\n  State: %s\n  Cache: %s\n\n' "$DATA_DIR" "$STATE_DIR" "$CACHE_DIR"
printf 'Config will be preserved:\n  %s\n\n' "$config_dir"
printf 'This removes plugins, Mason tools, Treesitter parsers, and recovery/history state.\n'
printf 'Close Neovim before continuing.\n\n'

if ! read -r -p "Remove this profile's data/state/cache? [y/N] " answer; then
  echo "Cancelled."
  exit 0
fi

case "$answer" in
  y|Y|yes|YES)
    rm -rf -- "$DATA_DIR" "$STATE_DIR" "$CACHE_DIR"
    echo "Neovim profile data/state/cache removed."
    ;;
  *)
    echo "Cancelled."
    ;;
esac
