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
   - When reviewing a GitHub PR, also fetch and consider existing PR comments/review comments so you do not duplicate already-posted feedback and can explicitly note whether you concur with prior findings.

3. **Provide review summary**
   - Provide a concise summary and list issues by severity (blocker, major, minor, nit).
   - When quoting or referring to specific code, always include the exact file path and line number(s) (for example, `app/foo.ts:42` or `app/foo.ts:42-47`).
   - If no issues, state that explicitly.
   - Write each finding to be skimmed: lead with the problem or the ask in the first sentence, justify only if it changes the decision, use bullets for anything that's a list (don't chain clauses with semicolons), keep one idea per sentence, and don't re-explain code the author wrote. If a finding runs past ~3 sentences with no line break, it's probably a buried lead — restructure.

## Focus Areas

Correctness, edge cases, security, performance, and maintainability.
