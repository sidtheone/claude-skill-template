---
name: coding-standards
description: Project coding standards and conventions. Loaded automatically when writing or reviewing code to ensure consistency.
user-invocable: false
---

# Project Coding Standards

These standards apply automatically when working with code in this project.

## General Principles

1. **Clarity over cleverness**: Code should be obvious, not clever
2. **Consistency over perfection**: Follow existing patterns even if you'd do it differently
3. **Simple over complex**: Choose the simplest solution that works
4. **Tested over documented**: Tests are better than comments for explaining behavior

## Code Style

### Naming Conventions

```typescript
// Classes: PascalCase
class UserRepository {}

// Functions/methods: camelCase
function getUserById(id: string) {}

// Constants: UPPER_SNAKE_CASE
const MAX_RETRY_ATTEMPTS = 3;

// Private properties: _prefixed
class Example {
  private _internalState: string;
}

// Boolean variables: is/has/should prefix
const isValid = true;
const hasPermission = false;
const shouldRetry = true;
```

### File Organization

```
src/
├── components/          # UI components
│   ├── Button/
│   │   ├── Button.tsx
│   │   ├── Button.test.tsx
│   │   └── index.ts     # Re-exports
├── hooks/              # React hooks
├── utils/              # Pure utility functions
├── services/           # API and external services
├── types/              # TypeScript type definitions
└── constants/          # App-wide constants
```

### Import Order

Always order imports:
1. External libraries
2. Internal modules (absolute imports)
3. Relative imports
4. Types (if separate)

```typescript
// External
import React from 'react';
import { format } from 'date-fns';

// Internal
import { Button } from '@/components/Button';
import { useAuth } from '@/hooks/useAuth';

// Relative
import { helper } from './utils';
import styles from './Component.module.css';

// Types
import type { User } from '@/types';
```

## Error Handling

### Always handle errors explicitly

```typescript
// Good
try {
  const result = await riskyOperation();
  return result;
} catch (error) {
  logger.error('Operation failed:', error);
  throw new ApplicationError('Failed to complete operation', { cause: error });
}

// Bad - silent failures
try {
  await riskyOperation();
} catch (error) {
  // Ignored
}
```

### Use custom error types

```typescript
class ValidationError extends Error {
  constructor(message: string, public field: string) {
    super(message);
    this.name = 'ValidationError';
  }
}
```

## Testing

### Test Structure: Arrange-Act-Assert

```typescript
test('should calculate total with tax', () => {
  // Arrange
  const items = [{ price: 100 }, { price: 200 }];
  const taxRate = 0.1;

  // Act
  const total = calculateTotal(items, taxRate);

  // Assert
  assert.strictEqual(total, 330);
});
```

### Test Naming

Use descriptive names that explain the scenario:

```typescript
// Good
test('returns 404 when user does not exist')
test('throws ValidationError when email is invalid')
test('caches result after first successful fetch')

// Bad
test('test user')
test('error case')
test('it works')
```

### What to Test

- **Happy path**: Normal successful flow
- **Edge cases**: Empty arrays, null values, boundary conditions
- **Error cases**: Invalid input, network failures, permission denied
- **Side effects**: Database writes, API calls, events emitted

## TypeScript

### Prefer explicit types over inference for public APIs

```typescript
// Good - clear contract
export function processUser(id: string): Promise<User> {
  // ...
}

// Okay - internal functions can infer
function formatDate(date: Date) {
  return date.toISOString();
}
```

### Use unknown over any

```typescript
// Good
function parseJSON(input: string): unknown {
  return JSON.parse(input);
}

// Bad
function parseJSON(input: string): any {
  return JSON.parse(input);
}
```

### Avoid assertion unless absolutely necessary

```typescript
// Good - type guard
function isUser(obj: unknown): obj is User {
  return typeof obj === 'object' && obj !== null && 'id' in obj;
}

// Bad - assertion
const user = data as User;
```

## Comments

### When to Comment

- **Why**, not what: Explain decisions, not syntax
- **Gotchas**: Warn about non-obvious behavior
- **TODOs**: Technical debt that needs addressing

```typescript
// Good
// Using debounce to prevent excessive API calls during typing
const debouncedSearch = debounce(search, 300);

// Bad
// Set x to 5
const x = 5;
```

### Avoid Comments When Code Can Be Clear

```typescript
// Good - self-documenting
function isEligibleForDiscount(user: User): boolean {
  return user.isPremium && user.purchaseCount > 10;
}

// Bad - needs comment to explain
function check(u: User): boolean {
  // Check if user gets discount
  return u.p && u.c > 10;
}
```

## Git Conventions

### Commit Messages

Follow Conventional Commits:

```
type(scope): subject

body

footer
```

Types:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation only
- `refactor`: Code change that neither fixes nor adds feature
- `test`: Adding or updating tests
- `chore`: Maintenance (dependencies, config)

Examples:
```
feat(auth): add password reset functionality

Implements email-based password reset flow with token expiration.

Closes #123
```

```
fix(api): handle null response from external service

The third-party API occasionally returns null instead of empty array.
Added null check to prevent runtime errors.
```

### Branch Naming

```
feature/short-description
fix/issue-number-description
refactor/component-name
docs/what-is-documented
```

## Performance

### Avoid Premature Optimization

- Profile before optimizing
- Optimize the bottleneck, not everything
- Prefer readability unless performance is measured and critical

### Common Patterns

```typescript
// Memoize expensive computations
const memoized = useMemo(() => expensiveOperation(data), [data]);

// Debounce user input
const debouncedHandler = debounce(handleInput, 300);

// Lazy load heavy components
const HeavyComponent = lazy(() => import('./HeavyComponent'));
```

## Security

### Never trust user input

```typescript
// Good - validate and sanitize
function createUser(input: unknown) {
  const validated = userSchema.parse(input);
  const sanitized = sanitize(validated);
  return db.users.create(sanitized);
}
```

### Use environment variables for secrets

```typescript
// Good
const apiKey = process.env.API_KEY;

// Bad - hardcoded secret
const apiKey = 'sk-abc123...';
```

## Additional Resources

For more detailed specifications:
- [TypeScript Patterns](./patterns/typescript.md)
- [React Best Practices](./patterns/react.md)
- [API Design Guidelines](./patterns/api-design.md)
- [Database Conventions](./patterns/database.md)

## Notes

This is a background knowledge skill that loads automatically when Claude writes or reviews code.
It ensures consistency across the codebase without requiring manual invocation.
