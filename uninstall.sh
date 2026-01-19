#!/usr/bin/env bash

# Agent Rules Sync - Uninstallation Script

set -euo pipefail

# Color output functions
color_green() { echo -e "\033[0;32m$*\033[0m"; }
color_red() { echo -e "\033[0;31m$*\033[0m"; }
color_yellow() { echo -e "\033[0;33m$*\033[0m"; }
color_blue() { echo -e "\033[0;34m$*\033[0m"; }
color_bold() { echo -e "\033[1m$*\033[0m"; }

success() { color_green "✓ $*"; }
error() { color_red "✗ $*"; }
warning() { color_yellow "⚠ $*"; }
info() { color_blue "ℹ $*"; }

# Configuration
SCRIPT_NAME="sync-agent-rules"
SYMLINK_PATH="$HOME/.local/bin/$SCRIPT_NAME"
INSTALL_DIR="$HOME/.agent-rules"

# Display header
echo ""
color_bold "Agent Rules Sync - Uninstallation"
echo ""

# Remove symlink
remove_symlink() {
    echo ""
    color_bold "[Step 1/3] Remove command symlink"

    if [[ -L "$SYMLINK_PATH" ]]; then
        rm "$SYMLINK_PATH"
        success "Removed symlink: $SYMLINK_PATH"
    elif [[ -f "$SYMLINK_PATH" ]]; then
        warning "File exists but is not a symlink: $SYMLINK_PATH"
        read -p "Would you like to remove it anyway? [y/N] " -n 1 -r
        echo ""
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            rm "$SYMLINK_PATH"
            success "Removed file: $SYMLINK_PATH"
        else
            info "Kept file: $SYMLINK_PATH"
        fi
    else
        info "Already removed: $SYMLINK_PATH"
    fi
}

# Remove installation directory
remove_install_dir() {
    echo ""
    color_bold "[Step 2/3] Remove installation directory"

    if [[ -d "$INSTALL_DIR" ]]; then
        info "Directory: $INSTALL_DIR"
        warning "This will delete the sync script and any templates"
        read -p "Remove directory? [y/N] " -n 1 -r
        echo ""

        if [[ $REPLY =~ ^[Yy]$ ]]; then
            rm -rf "$INSTALL_DIR"
            success "Removed directory: $INSTALL_DIR"
        else
            info "Kept directory: $INSTALL_DIR"
        fi
    else
        info "Already removed: $INSTALL_DIR"
    fi
}

# Remove PATH configuration
remove_path_config() {
    echo ""
    color_bold "[Step 3/3] Remove PATH configuration"

    # Detect shell config files
    local shell_configs=()
    [[ -f "$HOME/.zshrc" ]] && shell_configs+=("$HOME/.zshrc")
    [[ -f "$HOME/.bashrc" ]] && shell_configs+=("$HOME/.bashrc")
    [[ -f "$HOME/.bash_profile" ]] && shell_configs+=("$HOME/.bash_profile")

    local found_config=false
    for config_file in "${shell_configs[@]}"; do
        if grep -q "Added by agent-rules-sync installer" "$config_file" 2>/dev/null; then
            found_config=true
            info "Found in: $config_file"
            read -p "Remove PATH configuration? [y/N] " -n 1 -r
            echo ""

            if [[ $REPLY =~ ^[Yy]$ ]]; then
                # Remove the comment line and the export line after it.
                # NOTE: Using portable sed approach because:
                # 1. macOS BSD sed requires `-i ''` while GNU sed uses `-i.bak`
                # 2. BSD sed does not support `,+1d` address range syntax
                # We use {N;d;} to read next line and delete both lines together.
                cp "$config_file" "${config_file}.bak"
                if [[ "$(uname)" == "Darwin" ]]; then
                    sed -i '' '/# Added by agent-rules-sync installer/{N;d;}' "$config_file"
                else
                    sed -i '/# Added by agent-rules-sync installer/{N;d;}' "$config_file"
                fi
                success "Removed PATH configuration from: $config_file"
                info "Backup saved as: ${config_file}.bak"
            else
                info "Kept PATH configuration in: $config_file"
            fi
        fi
    done

    if [[ "$found_config" == false ]]; then
        info "No PATH configuration found (nothing to remove)"
    fi
}

# Display summary
show_summary() {
    echo ""
    color_bold "Uninstallation Summary:"
    echo ""

    # Check what's left
    if [[ -L "$SYMLINK_PATH" ]] || [[ -f "$SYMLINK_PATH" ]]; then
        warning "Command still exists: $SYMLINK_PATH"
    else
        success "Command removed"
    fi

    if [[ -d "$INSTALL_DIR" ]]; then
        warning "Directory still exists: $INSTALL_DIR"
    else
        success "Directory removed"
    fi

    echo ""
    info "Synced configuration files (e.g., ~/.claude/CLAUDE.md) were preserved"
    info "Uninstallation complete"
    echo ""
}

# Main uninstallation flow
main() {
    info "Starting uninstallation process..."

    remove_symlink
    remove_install_dir
    remove_path_config

    show_summary

    info "Thank you for using Agent Rules Sync!"
    echo ""
}

# Run main function
main "$@"
