# Uninstall Guide for AI Agents

This document provides instructions for AI agents (Claude, Cursor, Windsurf, Gemini, etc.) to help users uninstall Agent Rules Sync.

## Uninstallation Steps

When a user asks to uninstall Agent Rules Sync, follow these steps:

### Step 1: Remove the command symlink

```bash
rm -f ~/.local/bin/sync-agent-rules
```

### Step 2: Remove the installation directory

Ask the user for confirmation before removing:

```bash
rm -rf ~/.agent-rules
```

**Important**: This directory contains the user's `AGENTS.md` file. Warn the user that this file will be deleted and ask if they want to back it up first.

### Step 3: Clean up PATH configuration (optional)

Check if the installer added PATH configuration to shell config files:

```bash
grep -l "Added by agent-rules-sync installer" ~/.zshrc ~/.bashrc ~/.bash_profile 2>/dev/null
```

If found, ask the user if they want to remove these lines:
- The comment line: `# Added by agent-rules-sync installer`
- The export line: `export PATH="$HOME/.local/bin:$PATH"`

## What NOT to Remove

**Do NOT remove** the synced configuration files in AI tool directories:
- `~/.claude/CLAUDE.md`
- `~/.codeium/windsurf/memories/global_rules.md`
- `~/.gemini/GEMINI.md`
- `~/.gemini/antigravity/AGENTS.md`
- `~/.codex/AGENTS.md`

These are the user's AI agent rules and should be preserved.

## Summary Message

After uninstallation, inform the user:

```
Agent Rules Sync has been uninstalled:
✓ Removed command: ~/.local/bin/sync-agent-rules
✓ Removed directory: ~/.agent-rules
ℹ Your AI tool configurations (e.g., ~/.claude/CLAUDE.md) were preserved
```

## Troubleshooting

### Command not found after partial uninstall

If only the symlink was removed but the directory still exists:

```bash
# Re-run the uninstall script
~/.agent-rules/uninstall.sh
```

### Manual cleanup

If the uninstall script is not available:

```bash
# Remove symlink
rm -f ~/.local/bin/sync-agent-rules

# Remove installation directory (after backing up AGENTS.md if needed)
rm -rf ~/.agent-rules

# Optional: Remove PATH configuration from shell config
# Edit ~/.zshrc or ~/.bashrc and remove lines containing "agent-rules-sync"
```
