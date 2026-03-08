# skill-builder

Build Claude skills that feel like conversations, not reports.

skill-builder is a meta-skill that guides you through designing, testing, and iterating on Claude skills. It encodes hard-won lessons from building real skills — the mistakes that produce robotic output, and the patterns that produce great ones.

## What it does

- Walks you through building a new skill from idea to tested output
- Reviews existing skills and flags anti-patterns (format templates, quality checklists, one-shot mega-responses)
- Runs a structured review process: user personas → adversarial attack → dry run → output critique → iterate
- Teaches conversational skill design — the difference between a skill that lectures and one that guides

## Key Principles

**Conversation first, format never.** The moment you add summary blocks, label systems, or output quality checklists, the skill produces robot reports.

**Ask, don't dump.** Use AskUserQuestion for every choice point. Break analysis into conversational turns.

**Tables + short paragraphs.** Scannable output beats walls of text. Mix tables for data with 2-3 sentence paragraphs for narrative.

**Lean SKILL.md, separate references.** Keep the core file under 150 lines. Move detailed reference material to `references/`.

**Test with real personas.** Create 4-6 user types, walk through each, find the gaps before users do.

## The Process

```
1. Define the problem → who, what, when
2. Draft SKILL.md → identity, triggers, flow, tone, anti-patterns
3. Persona review → 4-6 user types, walk through each
4. Adversarial review → skeptic, edge cases, output critic
5. Dry run → test against a real scenario
6. Critique the output → how does it feel, not just is it correct
7. Iterate → usually 2-3 rounds
```

## Installation

### Personal (all projects)

```bash
git clone https://github.com/sidtheone/skill-builder ~/.claude/skills/skill-builder
```

### Project-specific

```bash
git clone https://github.com/sidtheone/skill-builder .claude/skills/skill-builder
```

## Usage

```
/skill-builder I want to build a skill that helps with code reviews
/skill-builder review my existing deployment skill
/skill-builder make this skill more conversational
```

## What's inside

```
skill-builder/
├── SKILL.md    # The skill — all learnings and the build process
└── README.md   # This file
```

## License

MIT
