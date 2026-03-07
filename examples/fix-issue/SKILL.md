---
name: fix-issue
description: Fix a GitHub issue by implementing the requested changes
argument-hint: [issue-number]
disable-model-invocation: true
allowed-tools:
  - Bash(gh *)
  - Bash(git *)
  - Read
  - Write
  - Edit
---

# Fix GitHub Issue

Implement a fix for the specified GitHub issue following project standards.

## Instructions

Fix GitHub issue $ARGUMENTS:

### 1. Understand the Issue

Use `gh issue view $ARGUMENTS` to get the full issue details:
- Read the issue description carefully
- Note any reproduction steps
- Check for linked PRs or related issues
- Review any comments for additional context

### 2. Investigate the Codebase

- Use Grep/Glob to find relevant files mentioned in the issue
- Read the current implementation to understand the problem
- Identify the root cause, not just the symptom
- Check if similar issues exist elsewhere in the codebase

### 3. Implement the Fix

- Make minimal, focused changes that address the root cause
- Follow existing code patterns in the file
- Maintain consistency with the project's code style
- Add comments only where the logic isn't self-evident

### 4. Verify the Fix

- Write tests that would have caught this bug
- Run the existing test suite to ensure no regressions
- Test the specific scenario described in the issue
- Check for edge cases related to the fix

### 5. Quality Checks

Before creating a PR, ensure:
- All tests pass
- Linting passes
- Type checking passes (if TypeScript/typed language)
- No unintended changes were made

### 6. Create Pull Request

- Commit changes with a descriptive message:
  ```
  fix: [brief description] (fixes #$ARGUMENTS)

  [Detailed explanation of root cause and fix approach]
  ```

- Create PR linking to the issue:
  ```bash
  gh pr create --title "Fix: [description]" \
    --body "Fixes #$ARGUMENTS

    ## Changes
    - [List key changes]

    ## Testing
    - [How to verify the fix]"
  ```

## Verification Checklist

Before marking as complete:
- [ ] Issue description is fully addressed
- [ ] Tests added for the bug
- [ ] All tests pass
- [ ] No regressions introduced
- [ ] PR created and linked to issue

## Notes

- If the issue is unclear, ask for clarification in issue comments before implementing
- For complex issues, consider breaking into smaller PRs
- If you discover the issue is a duplicate or invalid, comment on the issue rather than implementing
