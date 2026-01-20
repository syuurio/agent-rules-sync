# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Agent Rules Sync is a CLI tool that synchronizes AI agent configuration rules from a single `AGENTS.md` source file to multiple AI tools (Claude Code, Windsurf, Gemini, Antigravity, Codex). Written entirely in Bash.

## Commands

```bash
# Sync rules to AI tools
./bin/agent-rules-sync              # Interactive: select tools to sync
./bin/agent-rules-sync --all        # Sync to all tools (non-interactive)
./bin/agent-rules-sync --dry-run    # Preview with interactive selection
./bin/agent-rules-sync --tool claude # Sync to specific tool
./bin/agent-rules-sync --verbose    # Detailed output
./bin/agent-rules-sync --list-tools # Show tool status

# Restore from backups (interactive)
./bin/agent-rules-sync --restore           # Multi-select tools, then select backup
./bin/agent-rules-sync --restore --tool claude  # Restore specific tool
./bin/agent-rules-sync --list-backups      # Show backup status for all tools

# Installation/uninstallation
./scripts/install.sh                # Install (creates symlink to ~/.local/bin/)
./scripts/uninstall.sh              # Uninstall
```

No build, lint, or test commands - this is a pure Bash project.

## Architecture

```
bin/agent-rules-sync     # Main CLI script (~760 lines)
├── resolve_script_dir() # Handles symlink resolution for correct path finding
├── get_tool_path()      # Maps tool names → config file paths
├── backup_file()        # Creates timestamped backups (keeps BACKUP_RETENTION_COUNT most recent)
├── sync_to_tool()       # Performs file copy with directory creation
├── Interactive Menus
│   ├── _menu_*()        # Shared helpers (cursor control, key reading)
│   ├── interactive_menu()    # Single-select with arrow keys
│   └── multi_select_menu()   # Multi-select with Space toggle
├── Restore Functions
│   ├── list_backups_for_tool()  # List backup files for a tool
│   ├── restore_backup()         # Restore a backup file
│   ├── restore_tool()           # Interactive backup selection for one tool
│   └── run_restore()            # Main restore flow with tool selection
├── Sync Functions
│   ├── run_sync_all()           # Sync all tools (--all flag)
│   └── run_interactive_sync()   # Interactive tool selection (default)
└── main()               # Argument parsing and orchestration

scripts/
├── install.sh           # Supports both repo-clone and curl|bash modes
└── uninstall.sh         # Removes symlink, optionally cleans PATH config

AGENTS.md                # Source file synced to all tools
```

**Sync targets** (defined in `get_tool_path()`):
- `claude` → `~/.claude/CLAUDE.md`
- `windsurf` → `~/.codeium/windsurf/memories/global_rules.md`
- `gemini` → `~/.gemini/GEMINI.md`
- `antigravity` → `~/.gemini/antigravity/AGENTS.md`
- `codex` → `~/.codex/AGENTS.md`

Cursor is handled specially (SQLite database - manual sync only).

## Adding New Tools

1. Add case to `get_tool_path()` in `bin/agent-rules-sync`
2. Add tool name to `ALL_TOOLS` array

## Cross-Platform Notes

- Uses `set -euo pipefail` for strict error handling
- Avoids BSD vs GNU incompatibilities (e.g., no `head -n -5`, no `readlink -f`)
- Portable `find` + `sort` + `head` pattern for backup cleanup
