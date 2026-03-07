---
# Name of your skill (lowercase, max 64 chars)
# This becomes the slash command: /skill-name
name: skill-name

# When should this skill be used? (Required for auto-invocation)
# Claude uses this description to decide when to automatically load your skill
# Include keywords users would naturally say
# Example: "Explain code with visual diagrams and analogies. Use when explaining how code works or when the user asks 'how does this work?'"
description: Brief description of when to use this skill

# Shown in autocomplete menu to guide users on what arguments to provide
# Example: [issue-number], [file-path], [description]
argument-hint: [optional-arguments]

# Set to true if skill has side effects (deployments, commits, etc.)
# Prevents Claude from automatically invoking - only user can trigger with /skill-name
# Default: false
disable-model-invocation: false

# Set to false to hide from /slash command menu (background knowledge skills)
# Claude can still auto-invoke, but users can't trigger manually
# Default: true
user-invocable: true

# Tools Claude can use without asking permission when this skill is active
# Example: ["Bash(git *)", "Bash(npm *)", "Read", "Write"]
# Default: Claude asks for permission for all tools
allowed-tools: []

# Which model to use when this skill runs
# Options: sonnet, opus, haiku
# Default: inherits from current session
# model: sonnet

# Set to 'fork' to run this skill in an isolated subagent
# Useful for research/exploration that shouldn't clutter main context
# Default: runs in current context
# context: fork

# Which subagent type to use (requires context: fork)
# Options: Explore, Plan, general-purpose
# agent: Explore

# Hooks scoped to this skill's lifecycle
# hooks:
#   on-skill-start: echo "Skill started"
#   on-skill-end: echo "Skill finished"
---

# Skill Name

Brief overview of what this skill does and when to use it.

## Instructions

When this skill is invoked, follow these steps:

1. **First step**: Describe what Claude should do first
   - Use $ARGUMENTS to access all arguments passed to the skill
   - Use $ARGUMENTS[0] or $0 for the first argument
   - Use ${CLAUDE_SESSION_ID} for logging/session-specific work
   - Use ${CLAUDE_SKILL_DIR} for paths relative to this skill directory

2. **Second step**: Next action to take
   - Be specific about what to do
   - Include verification steps
   - Reference patterns from the codebase

3. **Final step**: Complete the task
   - Ensure quality checks pass
   - Provide feedback to the user

## Examples

Provide usage examples:

```bash
# Example 1: Basic usage
/skill-name argument1

# Example 2: Multiple arguments
/skill-name arg1 arg2 arg3
```

## Additional Resources

Reference supporting files so Claude knows when to load them:

- For complete reference documentation, see [reference.md](reference.md)
- For detailed examples, see [examples.md](examples.md)
- For technical specifications, see [specs/](specs/)

## Notes

- Add important caveats or gotchas
- Mention prerequisites or dependencies
- Link to related skills if applicable
