# Install Guide for AI Agents

This document provides instructions for AI agents (Claude, Cursor, Windsurf, Gemini, etc.) to help users install Agent Rules Sync.

## Prerequisites

Before installation, verify the system has:
- Bash 3.0 or higher
- `curl`, `mkdir`, `ln`, `chmod` commands available

```bash
bash --version
command -v curl mkdir ln chmod
```

## Installation Steps

### Step 1: Create installation directory

```bash
mkdir -p ~/.agent-rules/bin ~/.local/bin
```

### Step 2: Download the sync script

```bash
curl -fsSL https://raw.githubusercontent.com/syuurio/agent-rules-sync/main/bin/agent-rules-sync \
  -o ~/.agent-rules/bin/agent-rules-sync
chmod +x ~/.agent-rules/bin/agent-rules-sync
```

### Step 3: Create symlink

```bash
ln -sf ~/.agent-rules/bin/agent-rules-sync ~/.local/bin/agent-rules-sync
```

### Step 4: Verify PATH configuration

Check if `~/.local/bin` is in the user's PATH:

```bash
echo $PATH | tr ':' '\n' | grep -q ".local/bin" && echo "PATH OK" || echo "PATH needs configuration"
```

If not in PATH, add it to the user's shell config:

```bash
# For zsh
echo '' >> ~/.zshrc
echo '# Added by agent-rules-sync installer' >> ~/.zshrc
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc

# For bash
echo '' >> ~/.bashrc
echo '# Added by agent-rules-sync installer' >> ~/.bashrc
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
```

### Step 5: Create AGENTS.md template (optional)

If the user doesn't have an `AGENTS.md` file yet:

```bash
cat > ~/.agent-rules/AGENTS.md << 'EOF'
# General Rules for All Agents

## Documentation Priority

Whenever code generation or library documentation is required, use official documentation as the primary source of truth.

## Code Style

Follow the project's existing lint, formatter, and style configurations.
EOF
```

### Step 6: Verify installation

```bash
~/.local/bin/agent-rules-sync --version
~/.local/bin/agent-rules-sync --list-tools
```

## Post-Installation

After installation, inform the user:

```
Agent Rules Sync has been installed:
✓ Script installed to: ~/.agent-rules/bin/agent-rules-sync
✓ Command available at: ~/.local/bin/agent-rules-sync
ℹ Run 'agent-rules-sync --help' to see available options
ℹ Run 'agent-rules-sync --dry-run' to preview sync operations
```

Remind the user to:
1. Restart their shell or run `source ~/.zshrc` (or `~/.bashrc`)
2. Create/edit `~/.agent-rules/AGENTS.md` with their AI agent rules
3. Run `agent-rules-sync` to sync rules to all AI tools

## Alternative: Clone Repository

For users who want to contribute or track updates with git:

```bash
git clone https://github.com/syuurio/agent-rules-sync.git ~/.agent-rules
cd ~/.agent-rules
./scripts/install.sh
```

## Troubleshooting

### curl fails to download

Check internet connection and verify the URL is accessible:

```bash
curl -I https://raw.githubusercontent.com/syuurio/agent-rules-sync/main/bin/agent-rules-sync
```

### Permission denied

Ensure the script has execute permissions:

```bash
chmod +x ~/.agent-rules/bin/agent-rules-sync
chmod +x ~/.local/bin/agent-rules-sync
```

### Command not found after installation

1. Verify the symlink exists: `ls -la ~/.local/bin/agent-rules-sync`
2. Verify PATH includes `~/.local/bin`: `echo $PATH`
3. Restart the shell or source the config file
