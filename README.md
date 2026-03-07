# Claude Code Skills Registry

A curated collection of Claude Code skills that extend Claude with domain knowledge and automated workflows. Skills are SKILL.md files following the [Agent Skills](https://agentskills.io) open standard.

## What Are Claude Code Skills?

Skills teach Claude new capabilities through markdown files with YAML frontmatter:
- **Domain knowledge**: Project conventions, coding standards, patterns
- **Automated workflows**: Deployments, code reviews, issue fixing
- **Interactive tools**: /slash commands for specialized operations

Skills can be invoked manually (`/skill-name`) or automatically loaded by Claude when relevant.

## Available Skills

| Skill | Repository | Description | Version |
|-------|-----------|-------------|---------|
| _No skills published yet_ | | | |

*Submit a PR to add your skill to this registry*

## Quick Start

### Using a Skill

Install skills to your system:

```bash
# Personal (available in all projects)
git clone https://github.com/your-org/skill-name ~/.claude/skills/skill-name

# Project-specific
git clone https://github.com/your-org/skill-name .claude/skills/skill-name

# Test it
/skill-name arguments
```

### Creating a Skill

1. **Start with the template**
   ```bash
   cp -r template/ your-skill-name/
   cd your-skill-name/
   ```

2. **Edit SKILL.md**
   - Customize frontmatter (name, description, options)
   - Write step-by-step instructions
   - Add supporting files if needed

3. **Test locally**
   ```bash
   cp -r your-skill-name/ ~/.claude/skills/
   /your-skill-name test-arg
   ```

4. **Publish to GitHub**
   ```bash
   git init
   git add .
   git commit -m "Initial release v1.0.0"
   gh repo create your-org/skill-name --public
   git push -u origin main
   git tag v1.0.0
   git push --tags
   ```

5. **Add to registry**
   Submit a PR updating this README

See [CLAUDE.md](./CLAUDE.md) for comprehensive development guide.

## Skill Template

The `template/` directory provides a complete starter:

```
template/
├── SKILL.md              # Main skill file with frontmatter
├── reference.md          # Detailed docs (loaded on-demand)
├── examples.md           # Usage examples (loaded on-demand)
├── scripts/
│   └── example.sh        # Executable scripts
└── TEMPLATE_GUIDE.md     # Complete usage guide
```

Key features:
- Full frontmatter documentation with all options
- String substitutions (`$ARGUMENTS`, `${CLAUDE_SESSION_ID}`)
- Dynamic context injection (`!`command``)
- Supporting file structure
- Script integration

## Example Skills

Study the `examples/` directory for working patterns:

### [explain-code](./examples/explain-code/)
Explains code with visual diagrams and analogies. Demonstrates:
- Auto-invocation with good description
- Structured output format
- Teaching Claude how to explain concepts

### [fix-issue](./examples/fix-issue/)
Fixes GitHub issues following a workflow. Demonstrates:
- Side-effect protection (`disable-model-invocation`)
- Allowed tools configuration
- Multi-step workflow with verification
- Argument handling

### [analyze-architecture](./examples/analyze-architecture/)
Deep codebase analysis without cluttering context. Demonstrates:
- Forked context (`context: fork`)
- Research agent (`agent: Explore`)
- Complex investigation workflows
- Comprehensive reporting

### [pr-summary](./examples/pr-summary/)
Summarizes pull requests with live data. Demonstrates:
- Dynamic context injection (`!`command``)
- Integration with `gh` CLI
- Forked context for large diffs
- Structured analysis output

### [coding-standards](./examples/coding-standards/)
Project coding conventions (auto-loaded). Demonstrates:
- Background knowledge (`user-invocable: false`)
- Auto-loading when writing/reviewing code
- Supporting file organization
- Pattern documentation

## Skill Development Best Practices

### Keep Skills Focused
- One skill, one purpose
- Under 500 lines (split large skills)
- Move reference material to supporting files
- Put complex logic in scripts

### Write Effective Descriptions
The description determines when Claude auto-loads your skill:

```yaml
# Good
description: Explain code with visual diagrams. Use when user asks "how does this work" or "explain this code"

# Bad
description: Code helper
```

### Control Invocation

| Skill Type | Frontmatter | Example |
|------------|-------------|---------|
| Side effects | `disable-model-invocation: true` | Deployments, commits |
| Background knowledge | `user-invocable: false` | Coding standards |
| Interactive | (defaults) | Code explanations |

### Organize Supporting Files

```
complex-skill/
├── SKILL.md           # Entry point
├── reference.md       # Detailed docs
├── examples.md        # Usage examples
└── scripts/           # Executables
```

Reference files in SKILL.md so Claude knows when to load them.

## Installation Patterns

### Personal Skills (All Projects)
```bash
cd ~/.claude/skills/
git clone https://github.com/your-org/skill-name
```

### Project Skills (Team-wide)
```bash
cd your-project/
mkdir -p .claude/skills/
git clone https://github.com/your-org/skill-name .claude/skills/skill-name
```

### Update Skills
```bash
cd ~/.claude/skills/skill-name && git pull
```

### Monorepo (Package-specific Skills)
```
monorepo/
├── .claude/skills/global-skill/       # Available in all packages
└── packages/
    ├── frontend/.claude/skills/       # Frontend-specific
    └── backend/.claude/skills/        # Backend-specific
```

Claude discovers skills in nested `.claude/skills/` directories automatically.

## Publishing Guidelines

To add your skill to this registry:

### Requirements
- [ ] Clear, accurate description for auto-invocation
- [ ] Comprehensive README with installation instructions
- [ ] Working examples demonstrating key features
- [ ] No hardcoded secrets or absolute paths
- [ ] Follows template structure
- [ ] Tagged release (v1.0.0+)
- [ ] Tested with manual and auto-invocation

### Submission Process

1. Ensure your skill meets all requirements
2. Create a stable release with git tag
3. Fork this repository
4. Update the skills table in README.md:
   ```markdown
   | skill-name | [your-org/skill-name](https://github.com/your-org/skill-name) | Brief description | v1.0.0 |
   ```
5. Submit a pull request

### README Template

Your skill's README should include:

```markdown
# Skill Name

Brief description of what your skill does.

## Installation

### Personal (all projects)
```bash
git clone https://github.com/your-org/skill-name ~/.claude/skills/skill-name
```

### Project-specific
```bash
git clone https://github.com/your-org/skill-name .claude/skills/skill-name
```

## Usage

Examples of how to use the skill:

```bash
/skill-name argument
```

## Features

- Feature 1
- Feature 2
- Feature 3

## Options

Document frontmatter options and what they do.

## Examples

Provide comprehensive examples.

## License

MIT
```

## Skill Frontmatter Reference

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `name` | string | directory name | Slash command (lowercase, max 64 chars) |
| `description` | string | none | When to use (critical for auto-invocation) |
| `argument-hint` | string | none | Shown in autocomplete menu |
| `disable-model-invocation` | boolean | false | Prevent Claude from auto-invoking |
| `user-invocable` | boolean | true | Show in `/` menu |
| `allowed-tools` | array | [] | Tools Claude can use without permission |
| `model` | string | inherit | Model to use: `sonnet`, `opus`, `haiku` |
| `context` | enum | normal | Set `fork` for isolated subagent |
| `agent` | string | none | Subagent: `Explore`, `Plan`, `general-purpose` |
| `hooks` | object | {} | Lifecycle hooks scoped to skill |

See [template/SKILL.md](./template/SKILL.md) for complete documentation.

## String Substitutions

Skills support dynamic variables:

| Variable | Value |
|----------|-------|
| `$ARGUMENTS` | All arguments passed to skill |
| `$ARGUMENTS[0]` or `$0` | First argument |
| `$ARGUMENTS[1]` or `$1` | Second argument |
| `${CLAUDE_SESSION_ID}` | Current session ID (for logging) |
| `${CLAUDE_SKILL_DIR}` | Skill directory path (for scripts) |

## Dynamic Context Injection

Inject live command output before Claude sees the skill:

```markdown
## Git Status
!`git status --short`

## Test Results
!`npm test 2>&1 | tail -20`
```

Commands execute first, output replaces placeholders.

## Resources

- **Development Guide**: [CLAUDE.md](./CLAUDE.md) - Comprehensive skill development documentation
- **Template Guide**: [template/TEMPLATE_GUIDE.md](./template/TEMPLATE_GUIDE.md) - How to use the template
- **Official Docs**: https://code.claude.com/docs/en/skills.md
- **Best Practices**: https://code.claude.com/docs/en/best-practices.md
- **Agent Skills Standard**: https://agentskills.io

## Contributing

We welcome skill submissions! Follow the publishing guidelines above and submit a PR.

For questions or discussions:
- Open an issue for bugs or suggestions
- Submit a PR to improve templates or documentation
- Share your skills even if they're experimental

## License

This repository (templates and examples) is MIT licensed. Individual skills may have their own licenses.
