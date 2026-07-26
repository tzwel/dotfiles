#!/usr/bin/env bash
# Dotfiles sync script.
#
# Usage: add one line per dotfile below, explicitly saying what you want:
#   save ~/.zshrc       # push live file -> repo copy (overwrites repo copy)
#   load ~/.gitconfig   # push repo copy -> live file (backs up live file as .bak)
#   loadAll             # load every file in the repo dir back into ~/<filename>
#                       # (skips this script itself; doesn't handle nested paths)

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"

save() {
    local full_path="${1/#\~/$HOME}"
    local filename
    filename="$(basename "$full_path")"
    local local_path="$DOTFILES_DIR/$filename"

    if [ -f "$full_path" ]; then
        cp "$full_path" "$local_path"
        echo "Saved: $full_path -> $local_path"
    else
        echo "Skipped (not found): $full_path"
    fi
}

load() {
    local full_path="${1/#\~/$HOME}"
    local filename
    filename="$(basename "$full_path")"
    local local_path="$DOTFILES_DIR/$filename"

    if [ ! -f "$local_path" ]; then
        echo "Skipped (no repo copy): $local_path"
        return
    fi

    if [ -f "$full_path" ]; then
        cp "$full_path" "${full_path}.bak"
        echo "Backed up existing $full_path -> ${full_path}.bak"
    fi
    mkdir -p "$(dirname "$full_path")"
    cp "$local_path" "$full_path"
    echo "Loaded: $local_path -> $full_path"
}

# Loads every dotfile currently sitting in the repo dir back to $HOME/<filename>.
# Only safe for files whose full path is just ~/<filename> (no nested dirs like
# ~/.config/foo/bar) — use explicit load calls for those instead.
loadAll() {
    local f name
    for f in "$DOTFILES_DIR"/.*; do
        name="$(basename "$f")"
        [ -f "$f" ] || continue
        [ "$name" = "." ] && continue
        [ "$name" = ".." ] && continue
        [ "$name" = "$(basename "${BASH_SOURCE[0]:-$0}")" ] && continue
        load "$HOME/$name"
    done
}

# --- list your dotfiles here ---
save ~/.zshrc
save ~/.config/hypr/hyprland.lua
save ~/.nanorc
save ~/.config/micro/settings.json
save ~/.config/starship.toml

# load ~/.gitconfig
# loadAll

