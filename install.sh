#!/usr/bin/env bash

# Agent Rules Sync - Installation Script
# This script supports two installation modes:
# 1. Running from cloned repository
# 2. Running from curl | bash (direct download)

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
GITHUB_REPO_BASE_URL="https://raw.githubusercontent.com/syuurio/agent-rules-sync/main"
INSTALL_DIR="$HOME/.agent-rules"
SCRIPT_NAME="sync-agent-rules"
BIN_DIR="$HOME/.local/bin"
SYMLINK_PATH="$BIN_DIR/$SCRIPT_NAME"

# Display header
echo ""
color_bold "Agent Rules Sync - Installation"
echo ""

# Check system requirements
check_requirements() {
    info "Checking system requirements..."

    # Check bash version
    bash_version=$(bash --version | head -1 | grep -oE '[0-9]+\.[0-9]+' | head -1)
    bash_major=$(echo "$bash_version" | cut -d. -f1)

    if [[ $bash_major -lt 3 ]]; then
        error "Bash 3.0 or higher is required"
        error "Your version: $bash_version"
        exit 1
    fi

    success "Bash version: $bash_version"

    # Check required commands
    for cmd in curl mkdir ln chmod; do
        if ! command -v "$cmd" &> /dev/null; then
            error "Required command not found: $cmd"
            exit 1
        fi
    done

    success "All required commands available"
}

# Detect installation mode
detect_mode() {
    if [[ -f "bin/$SCRIPT_NAME" ]] && [[ -f "AGENTS.md" ]]; then
        echo "repo"
    else
        echo "direct"
    fi
}

# Download files from GitHub
download_files() {
    info "Downloading files from GitHub..."

    mkdir -p "$INSTALL_DIR/bin"

    # Download main script
    if curl -fsSL "${GITHUB_REPO_BASE_URL}/bin/${SCRIPT_NAME}" -o "$INSTALL_DIR/bin/$SCRIPT_NAME"; then
        success "Downloaded sync script"
    else
        error "Failed to download sync script"
        error "Please check your internet connection or the repository URL"
        exit 1
    fi

    # Download AGENTS.md template (optional, don't fail if it doesn't exist)
    if curl -fsSL "${GITHUB_REPO_BASE_URL}/AGENTS.md" -o "$INSTALL_DIR/AGENTS.md" 2>/dev/null; then
        success "Downloaded AGENTS.md template"
    else
        warning "Could not download AGENTS.md template (you can create your own)"
    fi

    # Download README (optional)
    if curl -fsSL "${GITHUB_REPO_BASE_URL}/README.md" -o "$INSTALL_DIR/README.md" 2>/dev/null; then
        success "Downloaded README.md"
    fi
}

# Install from cloned repository
install_from_repo() {
    info "Installing from cloned repository..."

    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    SCRIPT_PATH="$SCRIPT_DIR/bin/$SCRIPT_NAME"

    if [[ ! -f "$SCRIPT_PATH" ]]; then
        error "Script not found: $SCRIPT_PATH"
        exit 1
    fi

    # Create symlink
    mkdir -p "$BIN_DIR"
    ln -sf "$SCRIPT_PATH" "$SYMLINK_PATH"
    success "Created symlink: $SYMLINK_PATH -> $SCRIPT_PATH"
}

# Install from direct download
install_from_direct() {
    info "Installing via direct download..."

    # Download files
    download_files

    # Create symlink
    SCRIPT_PATH="$INSTALL_DIR/bin/$SCRIPT_NAME"
    mkdir -p "$BIN_DIR"
    ln -sf "$SCRIPT_PATH" "$SYMLINK_PATH"
    success "Created symlink: $SYMLINK_PATH -> $SCRIPT_PATH"
}

# Set executable permissions
set_permissions() {
    if [[ -L "$SYMLINK_PATH" ]]; then
        # Get the actual script path from symlink
        ACTUAL_SCRIPT=$(readlink "$SYMLINK_PATH")
        chmod +x "$ACTUAL_SCRIPT"
        success "Set executable permissions"
    fi
}

# Check if directory is in PATH
check_path() {
    if [[ ":$PATH:" == *":$BIN_DIR:"* ]]; then
        success "$BIN_DIR is in your PATH"
        return 0
    else
        warning "$BIN_DIR is not in your PATH"
        return 1
    fi
}

# Add directory to PATH
add_to_path() {
    info "Adding $BIN_DIR to PATH..."

    # Detect shell
    SHELL_NAME=$(basename "$SHELL")
    case "$SHELL_NAME" in
        zsh)
            SHELL_RC="$HOME/.zshrc"
            ;;
        bash)
            if [[ -f "$HOME/.bashrc" ]]; then
                SHELL_RC="$HOME/.bashrc"
            else
                SHELL_RC="$HOME/.bash_profile"
            fi
            ;;
        *)
            warning "Unknown shell: $SHELL_NAME"
            echo ""
            echo "Please manually add the following line to your shell configuration:"
            echo ""
            echo "  export PATH=\"\$HOME/.local/bin:\$PATH\""
            echo ""
            return
            ;;
    esac

    # Check if already in config
    if grep -q "export PATH=.*\.local/bin" "$SHELL_RC" 2>/dev/null; then
        info "PATH configuration already exists in $SHELL_RC"
        return
    fi

    # Ask user for permission
    echo ""
    echo "Would you like to add $BIN_DIR to your PATH?"
    echo "This will add the following line to $SHELL_RC:"
    echo ""
    echo "  export PATH=\"\$HOME/.local/bin:\$PATH\""
    echo ""
    read -p "Continue? [Y/n] " -n 1 -r
    echo ""

    if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]; then
        echo "" >> "$SHELL_RC"
        echo "# Added by agent-rules-sync installer" >> "$SHELL_RC"
        echo "export PATH=\"\$HOME/.local/bin:\$PATH\"" >> "$SHELL_RC"
        success "Added to $SHELL_RC"
        info "Please restart your shell or run: source $SHELL_RC"
    else
        info "Skipped PATH configuration"
    fi
}

# Offer to run initial sync
offer_initial_sync() {
    echo ""
    echo "Would you like to run an initial sync now?"
    echo "This will sync your AGENTS.md to all configured AI tools."
    echo ""
    read -p "Run sync? [Y/n] " -n 1 -r
    echo ""

    if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]; then
        echo ""
        "$SYMLINK_PATH" --verbose
    else
        info "Skipped initial sync"
        info "You can run it later with: $SCRIPT_NAME"
    fi
}

# Main installation flow
main() {
    check_requirements

    MODE=$(detect_mode)
    echo ""

    if [[ "$MODE" == "repo" ]]; then
        info "Installation mode: Cloned repository"
        install_from_repo
    else
        info "Installation mode: Direct download"
        install_from_direct
    fi

    set_permissions

    echo ""
    if ! check_path; then
        add_to_path
    fi

    echo ""
    success "Installation complete!"

    # Verify installation
    echo ""
    if command -v "$SCRIPT_NAME" &> /dev/null; then
        success "Command '$SCRIPT_NAME' is available"
        info "Try running: $SCRIPT_NAME --help"
    else
        warning "Command '$SCRIPT_NAME' not found in PATH"
        info "You can run it directly with: $SYMLINK_PATH"
        info "Or restart your shell and try again"
    fi

    # Offer initial sync
    if [[ -f "$INSTALL_DIR/AGENTS.md" ]] || [[ -f "AGENTS.md" ]]; then
        offer_initial_sync
    else
        echo ""
        warning "No AGENTS.md file found"
        info "Create an AGENTS.md file with your AI agent rules and run: $SCRIPT_NAME"
    fi

    echo ""
    info "For more information, visit: https://github.com/syuurio/agent-rules-sync"
    echo ""
}

# Run main function
main "$@"
