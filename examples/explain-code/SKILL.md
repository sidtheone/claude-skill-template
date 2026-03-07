---
name: explain-code
description: Explains code with visual diagrams and analogies. Use when explaining how code works, teaching about a codebase, or when the user asks "how does this work?"
---

# Explain Code

When explaining code, always make it visual and relatable.

## Instructions

1. **Start with an analogy**: Compare the code to something from everyday life that captures its essence
   - For algorithms: traffic patterns, assembly lines, kitchen workflows
   - For data structures: filing cabinets, libraries, organizational systems
   - For patterns: real-world systems people understand

2. **Draw a diagram**: Use ASCII art to show structure, flow, or relationships
   ```
   Example:
   ┌─────────┐     ┌─────────┐     ┌─────────┐
   │  Input  │────▶│ Process │────▶│ Output  │
   └─────────┘     └─────────┘     └─────────┘
   ```

3. **Walk through the code**: Explain step-by-step what happens
   - Use line numbers to reference specific code
   - Highlight the "why" not just the "what"
   - Point out clever techniques or important patterns

4. **Highlight a gotcha**: What's a common mistake or misconception?
   - What might trip up a developer reading this?
   - What edge cases exist?
   - What assumptions does the code make?

5. **Provide a concrete example**: Show the code in action
   - Use realistic data
   - Trace through execution step by step
   - Show before/after states

## Style Guidelines

- Keep explanations conversational, not academic
- For complex concepts, use multiple analogies approaching from different angles
- When in doubt, draw a diagram
- Always assume the reader is intelligent but unfamiliar with this specific code

## Example Output Format

### The Analogy
This code works like [everyday analogy]...

### The Diagram
[ASCII diagram showing structure]

### How It Works
1. First, [step 1 explanation with line references]
2. Then, [step 2 explanation]
3. Finally, [step 3 explanation]

### The Gotcha
Watch out for [common mistake or edge case]

### Example Walkthrough
Let's say we call this with [concrete example]...
