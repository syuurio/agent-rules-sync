# General Rules for All Agents

0. Project Context Bootstrapping (Mandatory)
	•	If the agent does not already have explicit project-specific context in the current session, it must first scan the repository to establish context before performing any task.
	•	The scan must be limited to the repository root and standard configuration locations, unless the task explicitly requires deeper inspection.
	•	During this scan, the agent must locate, read, and understand any of the following files if present:
	•	AGENTS.md
	•	CONTRIBUTING.md
	•	Agent- or tool-specific configuration files
(e.g. CLAUDE.md, .cursorrules, .ai-rules)
	•	These files define authoritative rules for agent behavior and must be followed when executing tasks.

Priority & Conflict Resolution

If multiple rule files exist, apply them in the following order:
	1.	AGENTS.md (highest priority)
	2.	Tool-specific agent configuration files
	3.	CONTRIBUTING.md (applies to all contributors)

In case of conflicts, higher-priority rules override lower-priority ones.

Fallback Behavior
	•	If no agent-specific or contribution guidelines are found:
	•	Follow the rules defined in this document.
	•	Adhere to the existing project structure, conventions, and tooling.
	•	If ambiguity remains:
	•	Choose the least disruptive behavior.
	•	Clearly state any assumptions made.

⸻

1. Documentation & Tooling Priority
	•	Whenever code generation, environment setup, or library / framework documentation is required, the agent must use Context7 as the primary source of truth.
	•	The agent must automatically invoke Context7 MCP tools when relevant and must not wait for explicit user instructions.
	•	Assume Context7 provides the latest and most accurate documentation, unless explicitly stated otherwise.

⸻

2. Language & Localization Rules
	•	If the user input is in Chinese, all responses and generated files must be in Traditional Chinese (Taiwan usage).
	•	Use Taiwanese terminology and conventions.
	•	If the user input is in English, respond entirely in English.
	•	Do not mix languages unless explicitly requested.

⸻

3. Code Style, Linting & Formatting
	•	The agent must detect and follow the project’s existing lint, formatter, and style configurations.
	•	Configuration files (including but not limited to):
	•	.eslintrc, pyproject.toml, .prettierrc, .editorconfig
	•	These files are authoritative and must be respected.
	•	Generated code must pass linting and formatting checks without requiring manual fixes.
	•	The agent must not introduce new formatting tools or rules unless explicitly instructed.

Fallback Rules
	•	If no lint or formatter configuration is found:
	•	Follow official language or framework-recommended defaults.
	•	Maintain consistency with the existing codebase.
	•	If conflicts exist:
	•	Project-specific configuration overrides all defaults.

⸻

4. Assumptions & Safety Defaults
	•	Avoid unnecessary changes outside the scope of the task.
	•	Prefer minimal, reversible changes.
	•	When uncertain, document assumptions clearly and proceed conservatively.
