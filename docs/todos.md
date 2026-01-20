# TODOs

> This document tracks project tasks using a structured format for AI agent understanding and execution.

## 📋 Task List

### Task Format

Each task contains the following structured information:
- **ID**: Unique identifier
- **Title**: Brief description
- **Status**: `TODO` | `IN_PROGRESS` | `BLOCKED` | `DONE` | `CANCELLED`
- **Priority**: `P0 (Critical)` | `P1 (High)` | `P2 (Medium)` | `P3 (Low)`
- **Tags**: Related domains or categories
- **Description**: Detailed explanation
- **Acceptance Criteria**: Completion conditions
- **Related Files**: Affected file paths
- **Notes**: Additional information or blockers

---

## 🚀 In Progress (IN_PROGRESS)

> Tasks currently being executed

---

## 📌 Todo (TODO)

> No pending tasks

---

## ✅ Done (DONE)

> Completed task records

### [TASK-001] Add interactive menu to sync agent rules

- **Status**: `DONE`
- **Priority**: `P1 (High)`
- **Tags**: `#enhancement` `#cli` `#ux`
- **Completed**: 2026-01-20

#### 📝 Description
Add interactive menu functionality to the `agent-rules-sync` CLI tool, allowing users to select tools to sync through a friendly interface (supporting single or multiple selection).

#### ✅ Acceptance Criteria
- [x] Users can select a single tool using arrow keys
- [x] Users can toggle multiple tool selections using the spacebar
- [x] Menu displays currently selected tools
- [x] Sync operation executes after confirming selection
- [x] Users can cancel operation by pressing ESC or Ctrl+C

#### 📁 Related Files
- `bin/agent-rules-sync`

#### 💡 Notes
- Default behavior changed from sync-all to interactive
- Added `--all` flag to preserve original behavior

---

## 🚫 Cancelled (CANCELLED)

> Tasks that are no longer needed

---

## 🔄 Recurring Tasks

> Tasks that need to be executed or checked periodically

---

## 💡 Ideas & Proposals

> Ideas or proposals not yet confirmed for execution

---

## 📚 Reference Information

### Status Definitions
- **TODO**: Not yet started
- **IN_PROGRESS**: Currently in progress
- **BLOCKED**: Blocked, requires resolution of dependencies
- **DONE**: Completed
- **CANCELLED**: Cancelled

### Priority Definitions
- **P0**: Critical, requires immediate attention
- **P1**: High priority, needs to be completed soon
- **P2**: Medium priority, planned
- **P3**: Low priority, can be deferred

### Tag Reference
- `#bug`: Bug fix
- `#enhancement`: Feature enhancement
- `#feature`: New feature
- `#refactor`: Refactoring
- `#docs`: Documentation update
- `#cli`: Command-line interface
- `#ux`: User experience
- `#performance`: Performance optimization
- `#security`: Security-related