# Command Authoring Guide

Commands are slash commands (`/plan`, `/review`, etc.) that users type in Claude Code to trigger skills.

## File Format

Each command is a markdown file in `commands/`:

```markdown
---
name: my-command
description: What this command does
user-invocable: true
skill: my-skill
---

Invoke the `my-skill` skill to [do something].
```

## Frontmatter Fields

| Field | Required | Description |
|-------|----------|-------------|
| `name` | Yes | The slash command name (without `/`) |
| `description` | Yes | One-line summary shown in help |
| `user-invocable` | Yes | Must be `true` for the command to appear in Claude Code |
| `skill` | Yes | The skill this command triggers |

