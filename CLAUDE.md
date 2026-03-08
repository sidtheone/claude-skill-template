# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This directory is a registry and template for Claude Code skills. Skills are extensions that teach Claude domain knowledge and reusable workflows through SKILL.md files following the [Agent Skills](https://agentskills.io) open standard.

## Repository Structure

```
skills/
├── README.md              # Meta-registry listing all published skills
├── CLAUDE.md              # This file
├── scripts/
│   └── new-skill.sh       # Lean skill scaffolding script
├── skill-builder/         # Meta-skill for building conversational skills
│   ├── SKILL.md
│   ├── README.md
│   └── LICENSE
├── template/              # Full starter template for new skills
│   ├── SKILL.md
│   ├── reference.md
│   ├── examples.md
│   ├── scripts/
│   └── TEMPLATE_GUIDE.md
└── examples/              # Example skills showcasing patterns
    ├── explain-code/
    ├── fix-issue/
    ├── analyze-architecture/
    ├── pr-summary/
    └── coding-standards/
```

Individual skills are published as separate GitHub repositories. This repository provides templates and examples only.

## What Are Claude Code Skills?

Skills extend Claude Code with:
- **Domain knowledge**: Teaching Claude project-specific conventions, patterns, standards
- **Workflows**: Automating multi-step tasks like deployments, issue fixing, code reviews
- **Specialized tools**: Creating focused /slash commands for specific operations

### Key Characteristics

- Skills are `SKILL.md` files with YAML frontmatter + markdown instructions
- Can be invoked manually (`/skill-name`) or auto-loaded by Claude when relevant
- Support dynamic context (arguments, session IDs, live command output)
- Can include supporting files (reference.md, scripts/) for complex functionality
- Context-efficient: descriptions load automatically, full content only loads when needed

## Creating a New Skill

### 1. Start with the Template

```bash
cp -r template/ your-skill-name/
cd your-skill-name/
```

### 2. Customize SKILL.md

Edit the frontmatter:
```yaml
---
name: your-skill-name
description: When this skill should be used (critical for auto-invocation)
argument-hint: [optional-args]
# See TEMPLATE_GUIDE.md for all options
---
```

### 3. Write Instructions

Replace template content with your skill logic:
- Use numbered steps for clarity
- Reference `$ARGUMENTS` for dynamic values
- Include verification steps
- Point to supporting files if needed

### 4. Test Locally

```bash
# Personal skills (all projects)
cp -r your-skill-name/ ~/.claude/skills/

# Project-specific skills
mkdir -p .claude/skills/
cp -r your-skill-name/ .claude/skills/

# Test it
/your-skill-name test-arg
```

## Skill Development Best Practices

### Keep Skills Focused

- **One skill, one purpose**: `/fix-issue` not `/do-everything`
- **Under 500 lines**: Split large skills into supporting files
- **Reference material**: Move to reference.md, examples.md
- **Scripts**: Put complex logic in scripts/ directory

### Write Effective Descriptions

The description determines when Claude auto-loads your skill:

```yaml
# Good - specific keywords
description: Explains code with visual diagrams. Use when user asks "how does this work" or "explain this code"

# Bad - too generic
description: Code help
```

### Control Invocation Behavior

| Skill Type | Frontmatter | Use Case |
|------------|-------------|----------|
| Side effects (deploy, commit) | `disable-model-invocation: true` | Only user can invoke |
| Background knowledge | `user-invocable: false` | Only Claude can auto-load |
| Interactive tools | (defaults) | Both can invoke |

### Organize Supporting Files

```
complex-skill/
├── SKILL.md           # Entry point, navigation
├── reference.md       # Detailed docs (on-demand)
├── examples.md        # Usage examples (on-demand)
├── specs/             # Technical specs (on-demand)
│   └── api.md
└── scripts/           # Executable scripts (not loaded)
    └── process.sh
```

Reference files in SKILL.md:
```markdown
For API details, see [reference.md](reference.md)
```

Claude loads them only when needed.

## String Substitutions

Skills support dynamic variables:

| Variable | Value | Example |
|----------|-------|---------|
| `$ARGUMENTS` | All arguments | "fix bug 123" |
| `$ARGUMENTS[0]` or `$0` | First argument | "fix" |
| `$ARGUMENTS[1]` or `$1` | Second argument | "bug" |
| `${CLAUDE_SESSION_ID}` | Current session ID | For logging |
| `${CLAUDE_SKILL_DIR}` | Skill directory path | For script paths |

Example:
```markdown
Log to logs/${CLAUDE_SESSION_ID}.log:
Processing $ARGUMENTS...
Execute ${CLAUDE_SKILL_DIR}/scripts/validate.sh $0
```

## Dynamic Context Injection

Use `!`command`` to inject live data before Claude sees the skill:

```markdown
## Current Git Status
!`git status --short`

## Failed Tests
!`npm test 2>&1 | grep FAIL`

## PR Details
!`gh pr view $ARGUMENTS --json title,body`
```

Commands execute first, output replaces placeholders, Claude receives rendered result.

## Common Skill Patterns

### Task Automation (Deployment, Commits)

```yaml
---
name: deploy
description: Deploy application to production
disable-model-invocation: true
allowed-tools: [Bash(make *), Bash(git *)]
---

Deploy $ARGUMENTS to production:
1. Run test suite
2. Build artifacts
3. Deploy to environment
4. Verify deployment
5. Notify team
```

### Code Understanding (Explanations, Analysis)

```yaml
---
name: explain-code
description: Explain code with diagrams. Use when user asks "how does this work"
---

Explain the code with:
1. Analogy from everyday life
2. ASCII diagram showing flow
3. Step-by-step walkthrough
4. Common gotchas
5. Concrete example
```

### Research (Deep Investigation)

```yaml
---
name: analyze-architecture
description: Deep architectural analysis
context: fork
agent: Explore
---

Analyze $ARGUMENTS architecture:
[Read many files, trace dependencies]
[Return summary without cluttering main context]
```

### Background Knowledge (Auto-loaded)

```yaml
---
name: coding-standards
description: Project coding standards. Loaded when writing/reviewing code.
user-invocable: false
---

Always follow these conventions:
[Style guide, patterns, standards]
```

## Publishing a Skill

### 1. Create Repository

```bash
git init
git add .
git commit -m "Initial release: skill-name v1.0.0"
gh repo create your-org/skill-name --public
git push -u origin main
```

### 2. Tag Release

```bash
git tag v1.0.0 -m "Release v1.0.0"
git push --tags
```

### 3. Create GitHub Release

```bash
gh release create v1.0.0 \
  --title "skill-name v1.0.0" \
  --notes "Initial release with [features]"
```

### 4. Update Registry

Submit PR to this registry updating `README.md`:

```markdown
| skill-name | [your-org/skill-name](https://github.com/your-org/skill-name) | Brief description | v1.0.0 |
```

### 5. Document Installation

Include in your skill's README:

```markdown
## Installation

### Personal (available in all projects)
```bash
git clone https://github.com/your-org/skill-name ~/.claude/skills/skill-name
```

### Project-specific
```bash
git clone https://github.com/your-org/skill-name .claude/skills/skill-name
```

### Update
```bash
cd ~/.claude/skills/skill-name && git pull
```
```

## Skill Locations and Scopes

| Location | Path | Scope |
|----------|------|-------|
| Personal | `~/.claude/skills/skill-name/` | All your projects |
| Project | `.claude/skills/skill-name/` | Current project only |
| Plugin | `<plugin>/skills/skill-name/` | Where plugin enabled |

**Priority when names conflict**: plugin > project > personal

## Testing Checklist

Before publishing:

- [ ] Description accurately reflects when skill should be used
- [ ] Arguments work (`$ARGUMENTS`, `$0`, `$1`, etc.)
- [ ] Supporting files properly referenced in SKILL.md
- [ ] Scripts are executable (`chmod +x scripts/*.sh`)
- [ ] No hardcoded paths (use `${CLAUDE_SKILL_DIR}`)
- [ ] Tested manual invocation: `/skill-name arg`
- [ ] Tested auto-invocation (if applicable)
- [ ] README has installation instructions
- [ ] Examples demonstrate key features

## Frontmatter Reference

All fields are optional:

| Field | Type | Purpose |
|-------|------|---------|
| `name` | string | Slash command name (lowercase, max 64 chars) |
| `description` | string | When to use this skill (for auto-invocation) |
| `argument-hint` | string | Shown in autocomplete, e.g., `[issue-number]` |
| `disable-model-invocation` | boolean | Prevent Claude from auto-invoking (default: false) |
| `user-invocable` | boolean | Hide from `/` menu (default: true) |
| `allowed-tools` | array | Tools Claude can use without permission |
| `model` | string | Model to use: `sonnet`, `opus`, `haiku` |
| `context` | enum | Set to `fork` for isolated subagent context |
| `agent` | string | Subagent type: `Explore`, `Plan`, `general-purpose` |
| `hooks` | object | Lifecycle hooks scoped to skill |

See `template/SKILL.md` for complete documentation.

## Examples

Study the `examples/` directory for working patterns:

- **explain-code**: Code explanation with analogies and diagrams
- **fix-issue**: GitHub issue fixing workflow with validation
- **analyze-architecture**: Deep codebase analysis (forked context)
- **pr-summary**: PR summarization with live data injection
- **coding-standards**: Background knowledge (auto-loaded)

Each example demonstrates different frontmatter options and patterns.

## Troubleshooting

### Skill not appearing in `/` menu
- Verify skill is in `~/.claude/skills/skill-name/SKILL.md`
- Check `user-invocable` is not `false`
- Restart Claude Code or try `/reload`

### Claude not auto-invoking
- Check `disable-model-invocation` is not `true`
- Improve description with keywords users would say
- Test with queries matching the description

### Arguments not working
- Use `$ARGUMENTS` for all args
- Use `$0`, `$1`, etc. for specific arguments
- Quote arguments with spaces: `/skill-name "arg with spaces"`

### Scripts not executing
- Make executable: `chmod +x scripts/*.sh`
- Use full path: `${CLAUDE_SKILL_DIR}/scripts/script.sh`
- Verify shebang: `#!/bin/bash` or `#!/usr/bin/env python3`

### Context too large
- Move content to supporting files (reference.md, examples.md)
- Use `context: fork` for research/exploration skills
- Keep SKILL.md focused (under 500 lines)
- Split into multiple smaller skills

## Resources

- **Official Skills Documentation**: https://code.claude.com/docs/en/skills.md
- **Best Practices**: https://code.claude.com/docs/en/best-practices.md
- **Agent Skills Standard**: https://agentskills.io
- **Subagents**: https://code.claude.com/docs/en/sub-agents.md
- **Hooks**: https://code.claude.com/docs/en/hooks-guide.md
- **Template Guide**: [template/TEMPLATE_GUIDE.md](template/TEMPLATE_GUIDE.md)

## Contributing

To add your skill to the registry:

1. Ensure skill follows best practices
2. Tag a stable release (v1.0.0+)
3. Submit PR updating `README.md` with your skill info
4. Include: name, repo link, description, current version

Quality standards:
- Clear, accurate description
- Comprehensive README with installation
- Working examples
- No hardcoded secrets or paths
- Follows template structure
