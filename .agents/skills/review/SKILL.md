---
name: review
description: Review the current change using Jujutsu or git
---

# review - Review Current Change

Review the current Jujutsu commit (@) in this repository.

## Usage

```
/review
```

## Workflow

1. **Determine repo root**
   - Use the current working directory.

2. **Review current change**
   - Prefer Jujutsu:
     ```bash
     jj status
     jj diff -r @ --color never
     ```
   - If `jj` is unavailable or fails, fall back to git:
     ```bash
     git status -sb
     git diff --color=never
     ```

3. **Provide review summary**
   - Provide a concise summary and list issues by severity (blocker, major, minor, nit).
   - If no issues, state that explicitly.

## Focus Areas

Correctness, edge cases, security, performance, and maintainability.
