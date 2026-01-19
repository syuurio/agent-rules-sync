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

# Tool configuration paths (same as in sync script)
TOOL_PATHS=(
    "$HOME/.claude/CLAUDE.md"
    "$HOME/.codeium/windsurf/memories/global_rules.md"
    "$HOME/.gemini/GEMINI.md"
    "$HOME/.gemini/antigravity/AGENTS.md"
    "$HOME/.codex/AGENTS.md"
)

# Display header
echo ""
color_bold "Agent Rules Sync - Uninstallation"
echo ""

# Remove symlink
remove_symlink() {
    if [[ -L "$SYMLINK_PATH" ]]; then
        rm "$SYMLINK_PATH"
        success "Removed symlink: $SYMLINK_PATH"
        return 0
    elif [[ -f "$SYMLINK_PATH" ]]; then
        warning "File exists but is not a symlink: $SYMLINK_PATH"
        echo "Would you like to remove it anyway? [y/N]"
        read -p "> " -n 1 -r
        echo ""
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            rm "$SYMLINK_PATH"
            success "Removed file: $SYMLINK_PATH"
        fi
        return 0
    else
        info "Symlink not found (already removed?)"
        return 1
    fi
}

# Remove synced files
remove_synced_files() {
    echo ""
    echo "Would you like to remove synced configuration files from AI tools?"
    warning "This will delete files like ~/.claude/CLAUDE.md, ~/.gemini/GEMINI.md, etc."
    echo ""
    read -p "Remove synced files? [y/N] " -n 1 -r
    echo ""

    if [[ $REPLY =~ ^[Yy]$ ]]; then
        local removed_count=0
        for config_path in "${TOOL_PATHS[@]}"; do
            if [[ -f "$config_path" ]]; then
                rm "$config_path"
                success "Removed: $config_path"
                ((removed_count++))
            fi
        done

        if [[ $removed_count -eq 0 ]]; then
            info "No synced files found"
        else
            success "Removed $removed_count synced file(s)"
        fi
    else
        info "Kept synced files"
    fi
}

# Remove installation directory
remove_install_dir() {
    if [[ -d "$INSTALL_DIR" ]]; then
        echo ""
        echo "Would you like to remove the installation directory?"
        info "Directory: $INSTALL_DIR"
        warning "This will delete the sync script and any templates"
        echo ""
        read -p "Remove directory? [y/N] " -n 1 -r
        echo ""

        if [[ $REPLY =~ ^[Yy]$ ]]; then
            rm -rf "$INSTALL_DIR"
            success "Removed directory: $INSTALL_DIR"
        else
            info "Kept directory: $INSTALL_DIR"
        fi
    else
        info "Installation directory not found (already removed?)"
    fi
}

# Remove PATH configuration
remove_path_config() {
    # Detect shell config files
    local shell_configs=()
    [[ -f "$HOME/.zshrc" ]] && shell_configs+=("$HOME/.zshrc")
    [[ -f "$HOME/.bashrc" ]] && shell_configs+=("$HOME/.bashrc")
    [[ -f "$HOME/.bash_profile" ]] && shell_configs+=("$HOME/.bash_profile")

    local found_config=false
    for config_file in "${shell_configs[@]}"; do
        if grep -q "Added by agent-rules-sync installer" "$config_file" 2>/dev/null; then
            found_config=true
            echo ""
            echo "Found PATH configuration in: $config_file"
            echo "Would you like to remove it? [y/N]"
            read -p "> " -n 1 -r
            echo ""

            if [[ $REPLY =~ ^[Yy]$ ]]; then
                # Remove the line and the comment before it
                sed -i.bak '/# Added by agent-rules-sync installer/,+1d' "$config_file"
                success "Removed PATH configuration from: $config_file"
                info "Backup saved as: ${config_file}.bak"
            else
                info "Kept PATH configuration in: $config_file"
            fi
        fi
    done

    if [[ "$found_config" == false ]]; then
        info "No PATH configuration found in shell configs"
    fi
}

# Display summary
show_summary() {
    echo ""
    color_bold "Uninstallation Summary:"
    echo ""

    # Check what's left
    [[ -L "$SYMLINK_PATH" ]] || [[ -f "$SYMLINK_PATH" ]] && warning "Command still exists: $SYMLINK_PATH" || success "Command removed"
    [[ -d "$INSTALL_DIR" ]] && warning "Directory still exists: $INSTALL_DIR" || success "Directory removed"

    local remaining_files=0
    for config_path in "${TOOL_PATHS[@]}"; do
        [[ -f "$config_path" ]] && ((remaining_files++))
    done

    if [[ $remaining_files -gt 0 ]]; then
        warning "$remaining_files synced configuration file(s) still exist"
    else
        success "All synced configuration files removed"
    fi

    echo ""
    info "Uninstallation complete"
    echo ""
}

# Main uninstallation flow
main() {
    info "Starting uninstallation process..."

    remove_symlink
    remove_synced_files
    remove_install_dir
    remove_path_config

    show_summary

    info "Thank you for using Agent Rules Sync!"
    echo ""
}

# Run main function
main "$@"
