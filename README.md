# Agent Rules Sync

A unified configuration management tool for AI agent rules across multiple platforms.

## Overview

Managing AI agent rules across different tools can be tedious. Each tool has its own configuration location, and keeping them in sync manually is error-prone. Agent Rules Sync solves this by allowing you to maintain a single `AGENTS.md` file and sync it to all your AI tools with one command.

## Features

- 🔄 **One-Command Sync** - Sync rules to multiple AI tools instantly
- 🛠️ **Easy to Extend** - Add new tools by editing a simple configuration
- 💾 **Automatic Backups** - Your existing configurations are backed up before changes
- 🎨 **User-Friendly CLI** - Color-coded output and clear status messages
- 📦 **Simple Installation** - Install via curl or git clone
- 🔍 **Dry-Run Mode** - Preview changes before applying them
- ⚙️ **Flexible Options** - Sync all tools or target specific ones

## Supported Tools

| Tool | Status | Configuration Path |
|------|--------|-------------------|
| Claude Code | ✓ Supported | `~/.claude/CLAUDE.md` |
| Windsurf | ✓ Supported | `~/.codeium/windsurf/memories/global_rules.md` |
| Gemini | ✓ Supported | `~/.gemini/GEMINI.md` |
| Antigravity | ✓ Supported | `~/.gemini/antigravity/AGENTS.md` |
| Codex | ✓ Supported | `~/.codex/AGENTS.md` |
| Cursor | ⚠️ Partial | Manual update via UI (SQLite database) |

## Installation

### For Humans

Run the interactive install script:

```bash
curl -fsSL https://raw.githubusercontent.com/syuurio/agent-rules-sync/main/scripts/install.sh | bash
```

This will:
- Download and install the sync script
- Create a command you can run from anywhere
- Optionally add the command to your PATH
- Offer an interactive menu to run initial sync (with dry-run option)

### For LLM Agents

You can ask your AI assistant (Claude, Cursor, Windsurf, etc.) to help you install:

```
"Help me install agent-rules-sync, refer to `https://raw.githubusercontent.com/syuurio/agent-rules-sync/main/docs/install.md` for instructions"
```

Or if you already have the repository cloned:

```
"Help me install agent-rules-sync, refer to `~/.agent-rules/docs/install.md` for instructions"
```

See [`docs/install.md`](docs/install.md) for detailed instructions for AI agents.

## Usage

### Basic Usage

Sync your `AGENTS.md` to all configured AI tools:

```bash
agent-rules-sync
```

### Preview Changes (Dry Run)

See what would be synced without making changes:

```bash
agent-rules-sync --dry-run
```

### Sync to Specific Tool

Sync to only one tool:

```bash
agent-rules-sync --tool claude
```

### Verbose Output

Show detailed information during sync:

```bash
agent-rules-sync --verbose
```

### List Supported Tools

See all supported tools and their installation status:

```bash
agent-rules-sync --list-tools
```

### Use Custom Source File

Sync from a different rules file:

```bash
agent-rules-sync --source /path/to/custom-rules.md
```

### Skip Backups

Disable automatic backups (not recommended):

```bash
agent-rules-sync --no-backup
```

### Get Help

View all available options:

```bash
agent-rules-sync --help
```

## Your AGENTS.md File

Create an `AGENTS.md` file in `~/.agent-rules/` (or the repository root if you cloned it) with your AI agent rules. Here's a simple example:

```markdown
# General Rules for All Agents

## Project Context Bootstrapping

If the agent does not already have explicit project-specific context, it must first scan the repository to establish context before performing any task.

## Documentation Priority

Whenever code generation or library documentation is required, the agent must use Context7 as the primary source of truth.

## Language & Localization Rules

- If user input is in Chinese, respond in Traditional Chinese (Taiwan usage)
- If user input is in English, respond entirely in English
- Do not mix languages unless explicitly requested

## Code Style, Linting & Formatting

The agent must detect and follow the project's existing lint, formatter, and style configurations.
```

## Adding New Tools

To add support for a new AI tool:

1. Edit `bin/agent-rules-sync`
2. Add a new case to the `get_tool_path` function:

```bash
get_tool_path() {
    case "$1" in
        # ... existing tools ...
        your-new-tool)
            echo "$HOME/.your-tool/config.md"
            ;;
        *)
            return 1
            ;;
    esac
}
```

3. Add the tool name to `ALL_TOOLS` array:

```bash
ALL_TOOLS=("claude" "windsurf" "gemini" "antigravity" "codex" "your-new-tool")
```

4. Submit a PR if you'd like to contribute back to the project!

## Uninstallation

### For Humans

To uninstall Agent Rules Sync, run the interactive uninstall script:

```bash
~/.agent-rules/scripts/uninstall.sh
```

Or if you installed via direct download:

```bash
rm ~/.local/bin/agent-rules-sync
rm -rf ~/.agent-rules
```

The uninstallation script will:
- Remove the command symlink (`~/.local/bin/agent-rules-sync`)
- Ask if you want to remove the installation directory (`~/.agent-rules`)
- Ask if you want to clean up PATH configuration from shell config files

**Note**: Synced configuration files (e.g., `~/.claude/CLAUDE.md`) are preserved and will not be removed.

### For LLM Agents

You can ask your AI assistant (Claude, Cursor, Windsurf, etc.) to help you uninstall:

```
"Help me uninstall agent-rules-sync, refer to `~/.agent-rules/docs/uninstall.md` for instructions"
```

The AI will follow the documented steps to safely uninstall the tool while preserving your AI configurations.

See [`docs/uninstall.md`](docs/uninstall.md) for detailed instructions for AI agents.

## Troubleshooting

### Command not found

If `agent-rules-sync` command is not found after installation:

1. Check if `~/.local/bin` is in your PATH:
   ```bash
   echo $PATH | grep ".local/bin"
   ```

2. If not, add it to your shell config:
   ```bash
   echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc  # for zsh
   # or
   echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc  # for bash
   ```

3. Restart your shell or run:
   ```bash
   source ~/.zshrc  # or ~/.bashrc
   ```

### Permission Denied

If you get permission errors:

```bash
chmod +x ~/.local/bin/agent-rules-sync
```

### Tool-Specific Issues

**Cursor**: Cursor stores global rules in a SQLite database, so automatic sync is not supported. Follow the manual update instructions provided by the tool.

## Requirements

- Bash 3.0 or higher
- Standard Unix tools: `curl`, `mkdir`, `ln`, `chmod`
- macOS, Linux, or WSL on Windows

## License

MIT License - see [LICENSE](LICENSE) file for details

## Contributing

Contributions are welcome! Here's how you can help:

1. **Report Issues** - Found a bug or have a feature request? Open an issue
2. **Submit PRs** - Want to add a new tool or fix something? PRs are appreciated
3. **Share Feedback** - Let us know how you're using the tool

### Development

```bash
git clone https://github.com/syuurio/agent-rules-sync.git
cd agent-rules-sync
# Make your changes
./install.sh  # Test your changes
```

## Acknowledgments

- Inspired by the need to manage multiple AI coding assistants
- Built for the AI developer community

## Links

- **Repository**: https://github.com/syuurio/agent-rules-sync
- **Issues**: https://github.com/syuurio/agent-rules-sync/issues
- **Discussions**: https://github.com/syuurio/agent-rules-sync/discussions

---

Made with ❤️ for the AI developer community
