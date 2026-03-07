---
name: pr-summary
description: Summarize changes and discussion in a pull request
argument-hint: [pr-number]
context: fork
agent: Explore
allowed-tools:
  - Bash(gh *)
---

# Pull Request Summary

Generate a comprehensive summary of pull request $ARGUMENTS.

## Pull Request Context

The following information is loaded dynamically before Claude sees this skill:

### PR Details
!`gh pr view $ARGUMENTS --json title,body,author,createdAt,state,isDraft,labels | jq -r '.title, .body, .author.login, .createdAt, .state, .isDraft, (.labels[].name // empty)'`

### Changed Files
!`gh pr diff $ARGUMENTS --name-only`

### Code Changes
!`gh pr diff $ARGUMENTS`

### Review Comments
!`gh pr view $ARGUMENTS --json comments --jq '.comments[] | "\(.author.login) (\(.createdAt)): \(.body)"'`

### Review Status
!`gh pr view $ARGUMENTS --json reviews --jq '.reviews[] | "\(.author.login) - \(.state): \(.body // "No comment")"'`

### CI Status
!`gh pr checks $ARGUMENTS`

## Your Task

Analyze all the above information and provide a comprehensive summary:

### 1. Overview
- **What does this PR do?** (In one sentence)
- **Why is this change needed?** (The problem being solved)
- **Who authored it?** Author and when it was created
- **Current status?** (Open/Draft/Merged, CI status)

### 2. Key Changes

List the most important changes:
- **File X**: What changed and why
- **File Y**: What changed and why

Focus on the "why" and impact, not just listing files.

### 3. Review Discussion

Summarize meaningful discussion points:
- **Concerns raised**: Any issues reviewers pointed out
- **Questions asked**: Unresolved questions
- **Decisions made**: Agreements reached in discussion

Skip trivial comments like "LGTM" unless they're the only reviews.

### 4. Assessment

Provide an objective assessment:

**Strengths**:
- What's done well
- Good practices followed

**Concerns** (if any):
- Potential issues you notice
- Missing tests or documentation
- Breaking changes
- Performance implications

**CI/Test Status**:
- Are checks passing?
- Any failing tests to address?

### 5. Recommendation

Based on the above analysis:
- [ ] **Ready to merge**: All checks pass, no concerns
- [ ] **Needs work**: Specific items to address before merging
- [ ] **Needs discussion**: Questions that need answering

## Output Format

Keep the summary concise but thorough:
- Use bullet points for scanability
- Reference specific files and line numbers when discussing concerns
- Highlight breaking changes prominently
- Call out missing test coverage if applicable

## Notes

- The `!`command`` syntax executes commands BEFORE Claude sees this prompt
- The output replaces the placeholder, giving Claude fresh context
- This skill runs in a fork so the full diff doesn't clutter your main conversation
- Perfect for reviewing complex PRs without manually gathering all the context
