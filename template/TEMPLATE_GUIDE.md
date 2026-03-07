# Claude Code Skill Template Guide

This template helps you create professional Claude Code skills following official best practices.

## Quick Start

### 1. Copy the Template

```bash
# Copy template to your skill directory
cp -r template/ your-skill-name/
cd your-skill-name/
```

### 2. Customize SKILL.md

Edit the frontmatter in `SKILL.md`:

```yaml
---
name: your-skill-name        # Lowercase, becomes /your-skill-name
description: When to use this skill  # Critical for auto-invocation
argument-hint: [args]        # Shown in autocomplete
---
```

### 3. Write Instructions

Replace the template instructions with your skill logic:
- Use `$ARGUMENTS` to access arguments
- Use `$0`, `$1`, etc. for specific arguments
- Use `${CLAUDE_SESSION_ID}` for session-specific work
- Use `${CLAUDE_SKILL_DIR}` for relative paths

### 4. Test Your Skill

```bash
# Option 1: Copy to personal skills (available in all projects)
cp -r your-skill-name/ ~/.claude/skills/

# Option 2: Copy to project skills (this project only)
mkdir -p .claude/skills/
cp -r your-skill-name/ .claude/skills/

# Test it
/your-skill-name test-argument
```

## Template Structure

```
template/
├── SKILL.md              # Main skill file (required)
├── reference.md          # Detailed docs (loaded on-demand)
├── examples.md           # Usage examples (loaded on-demand)
├── scripts/
│   └── example.sh        # Executable scripts (not loaded)
└── TEMPLATE_GUIDE.md     # This file
```

## Frontmatter Options Explained

### name (optional)
The slash command name. If omitted, uses directory name.
```yaml
name: fix-bug
# Creates: /fix-bug
```

### description (critical)
Tells Claude when to auto-load your skill. Include keywords users would say.

```yaml
# Good - specific with keywords
description: Explains code with visual diagrams and analogies. Use when explaining how code works or when the user asks "how does this work?"

# Bad - too generic
description: Helps with code
```

### argument-hint (optional)
Shown in autocomplete to guide users:
```yaml
argument-hint: [issue-number]
argument-hint: [file-path]
argument-hint: [search-term]
```

### disable-model-invocation (optional)
Set `true` for skills with side effects (deployments, commits):
```yaml
disable-model-invocation: true
# Claude can't auto-invoke - only user can trigger with /skill-name
```

Use for: deployment scripts, database migrations, git operations

### user-invocable (optional)
Set `false` for background knowledge that shouldn't clutter the `/` menu:
```yaml
user-invocable: false
# Claude can auto-invoke, but users can't manually trigger
```

Use for: coding standards, style guides, reference documentation

### allowed-tools (optional)
Tools Claude can use without asking permission:
```yaml
allowed-tools:
  - Bash(git *)
  - Bash(gh *)
  - Read
  - Write
  - Edit
```

Reduces permission prompts for trusted operations.

### model (optional)
Override default model for this skill:
```yaml
model: haiku    # Fast, cheap for simple tasks
model: sonnet   # Balanced
model: opus     # Most capable
```

### context (advanced)
Run skill in isolated subagent:
```yaml
context: fork
agent: Explore
```

Use for: research tasks that read many files without cluttering main context

### hooks (advanced)
Lifecycle hooks scoped to this skill:
```yaml
hooks:
  on-skill-start: echo "Starting $SKILL_NAME"
  on-skill-end: notify-send "Skill complete"
```

## String Substitutions

Use these variables in your skill content:

| Variable | Value | Example |
|----------|-------|---------|
| `$ARGUMENTS` | All arguments | "fix bug in auth" |
| `$ARGUMENTS[0]` or `$0` | First argument | "fix" |
| `$ARGUMENTS[1]` or `$1` | Second argument | "bug" |
| `${CLAUDE_SESSION_ID}` | Session ID | "abc123..." |
| `${CLAUDE_SKILL_DIR}` | Skill directory | "/path/to/skill" |

Example usage:
```markdown
Log to logs/${CLAUDE_SESSION_ID}.log:
Processing $ARGUMENTS...
Run ${CLAUDE_SKILL_DIR}/scripts/process.sh $0
```

## Supporting Files

### When to Use Them

- **SKILL.md > 500 lines**: Split into supporting files
- **Detailed reference material**: Move to reference.md
- **Many examples**: Move to examples.md
- **Technical specs**: Create specs/ directory

### How Claude Loads Them

- **SKILL.md**: Always loaded when skill is invoked
- **Supporting files**: Loaded only when Claude references them
- **Scripts**: Executed, never loaded into context

### Referencing Supporting Files

Tell Claude about them in SKILL.md:

```markdown
## Additional Resources

For complete API documentation, see [reference.md](reference.md)
For detailed examples, see [examples.md](examples.md)
For technical specifications, see [specs/](specs/)
```

Claude will read these files only when needed.

## Dynamic Context Injection

Use `!`command`` to inject live data before Claude sees the skill:

```markdown
## Current Status
!`git status --short`

## Recent Commits
!`git log --oneline -5`

## Failed Tests
!`npm test 2>&1 | grep FAIL`
```

The commands execute first, output replaces the placeholders, then Claude receives the rendered prompt with fresh data.

## Best Practices

### Keep Skills Focused

Each skill should do one thing well:
- ✅ `/fix-issue` - Fixes a GitHub issue
- ✅ `/explain-code` - Explains code with analogies
- ❌ `/do-everything` - Fixes, explains, tests, deploys

### Write Effective Descriptions

Claude uses descriptions to decide when to auto-load skills:

```yaml
# Good - matches user queries
description: Explain code with visual diagrams. Use when user asks "how does this work" or "explain this code"

# Bad - too vague
description: Code helper
```

### Control Invocation Properly

| Skill Type | Settings | Example |
|------------|----------|---------|
| Side effects (deploys) | `disable-model-invocation: true` | /deploy |
| Background knowledge | `user-invocable: false` | coding-standards |
| Interactive tools | (default) | /explain-code |

### Organize Complex Skills

```
complex-skill/
├── SKILL.md                 # Overview & navigation
├── reference.md             # Detailed docs
├── examples.md              # Usage examples
├── specs/
│   ├── api-spec.md
│   └── data-models.md
└── scripts/
    ├── validate.sh
    └── process.py
```

### Use Scripts for Heavy Logic

Don't put complex bash/python in SKILL.md. Use scripts:

```markdown
# In SKILL.md
Run validation: `${CLAUDE_SKILL_DIR}/scripts/validate.sh $ARGUMENTS`
```

```bash
# In scripts/validate.sh
#!/bin/bash
# Complex logic here
# Keep SKILL.md clean and readable
```

## Common Patterns

### Pattern 1: Task Automation (Side Effects)

```yaml
---
name: deploy
description: Deploy application to production
disable-model-invocation: true
allowed-tools: [Bash(make *), Bash(git *)]
---

Deploy $ARGUMENTS to production:
1. Run tests
2. Build artifacts
3. Deploy to environment
4. Verify deployment
```

### Pattern 2: Code Understanding (No Side Effects)

```yaml
---
name: trace-function
description: Trace how a function is called. Use when understanding call chains or when user asks "where is this function used?"
---

Trace calls to function $ARGUMENTS:
1. Use Grep to find all calls
2. Show call hierarchy
3. Explain the flow
```

### Pattern 3: Research (Forked Context)

```yaml
---
name: investigate
description: Deep investigation of a component
context: fork
agent: Explore
---

Investigate $ARGUMENTS:
[Read many files, analyze thoroughly]
[Return summary without cluttering main context]
```

### Pattern 4: Background Knowledge (Auto-loaded)

```yaml
---
name: api-conventions
description: REST API design conventions for this project. Loaded when working with APIs.
user-invocable: false
---

Always follow these API patterns:
[Conventions that Claude should know]
```

### Pattern 5: Live Data Integration

```yaml
---
name: pr-status
description: Check pull request status
context: fork
allowed-tools: [Bash(gh *)]
---

## PR #$ARGUMENTS Status

### Details
!`gh pr view $ARGUMENTS`

### Checks
!`gh pr checks $ARGUMENTS`

[Analyze the above data...]
```

## Publishing Your Skill

Once your skill is ready:

1. **Create a GitHub repository**
   ```bash
   git init
   git add .
   git commit -m "Initial skill release"
   git remote add origin https://github.com/your-org/skill-name
   git push -u origin main
   ```

2. **Tag a release**
   ```bash
   git tag v1.0.0
   git push --tags
   ```

3. **Add to the registry**
   - Update the skills registry README
   - List your skill with description and repo link

4. **Document installation**
   Include in your README:
   ```bash
   # Personal (all projects)
   git clone https://github.com/your-org/skill-name ~/.claude/skills/skill-name

   # Project-specific
   git clone https://github.com/your-org/skill-name .claude/skills/skill-name
   ```

## Testing Checklist

Before publishing:

- [ ] Skill description accurately reflects when it should be used
- [ ] Arguments work as expected (`$ARGUMENTS`, `$0`, `$1`)
- [ ] Supporting files are properly referenced
- [ ] Scripts are executable (`chmod +x scripts/*.sh`)
- [ ] No hardcoded paths (use `${CLAUDE_SKILL_DIR}`)
- [ ] Tested with manual invocation: `/skill-name arg`
- [ ] Tested auto-invocation (if applicable)
- [ ] README includes installation instructions
- [ ] Examples demonstrate key features

## Troubleshooting

### Skill not appearing in `/` menu
- Check `user-invocable` is not set to `false`
- Verify skill is in `.claude/skills/skill-name/SKILL.md`
- Try `/reload` to refresh skills

### Claude not auto-invoking skill
- Check `disable-model-invocation` is not set to `true`
- Improve description with keywords users would actually say
- Test with queries that match the description

### Arguments not working
- Use `$ARGUMENTS` for all args, `$0`, `$1`, etc. for specific ones
- Check argument-hint matches actual usage
- Verify quoting if arguments contain spaces

### Scripts not executing
- Make scripts executable: `chmod +x scripts/*.sh`
- Use full path: `${CLAUDE_SKILL_DIR}/scripts/script.sh`
- Check script has shebang: `#!/bin/bash`

### Context too large
- Move content to supporting files (reference.md, examples.md)
- Use `context: fork` for research skills
- Keep SKILL.md under 500 lines

## Examples

See the `examples/` directory for complete working skills:

- **explain-code**: Code explanation with diagrams
- **fix-issue**: GitHub issue fixing workflow
- **analyze-architecture**: Deep codebase analysis (forked)
- **pr-summary**: PR summarization with live data
- **coding-standards**: Background knowledge (user-invocable: false)

Study these to learn different patterns and techniques.

## Resources

- **Official Skills Docs**: https://code.claude.com/docs/en/skills.md
- **Best Practices**: https://code.claude.com/docs/en/best-practices.md
- **Agent Skills Standard**: https://agentskills.io
- **Subagents Guide**: https://code.claude.com/docs/en/sub-agents.md

## Next Steps

1. Copy the template
2. Customize for your use case
3. Test locally
4. Refine based on usage
5. Publish to GitHub
6. Add to the registry
7. Share with the community!
