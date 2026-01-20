# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Agent Rules Sync is a CLI tool that synchronizes AI agent configuration rules from a single `AGENTS.md` source file to multiple AI tools (Claude Code, Windsurf, Gemini, Antigravity, Codex). Written entirely in Bash.

## Commands

```bash
# Run the sync tool directly
./bin/agent-rules-sync              # Sync to all tools
./bin/agent-rules-sync --dry-run    # Preview without changes
./bin/agent-rules-sync --tool claude # Sync to specific tool
./bin/agent-rules-sync --verbose    # Detailed output
./bin/agent-rules-sync --list-tools # Show tool status

# Installation/uninstallation
./scripts/install.sh                # Install (creates symlink to ~/.local/bin/)
./scripts/uninstall.sh              # Uninstall
```

No build, lint, or test commands - this is a pure Bash project.

## Architecture

```
bin/agent-rules-sync     # Main CLI script (~350 lines)
├── resolve_script_dir() # Handles symlink resolution for correct path finding
├── get_tool_path()      # Maps tool names → config file paths
├── backup_file()        # Creates timestamped backups (keeps 5 most recent)
├── sync_to_tool()       # Performs file copy with directory creation
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
