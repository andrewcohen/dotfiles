---
name: commit
description: Create a Conventional Commit message and update the change description
---

# commit - Create a Conventional Commit Message

Create a Conventional Commit message for the current change and update the change description.

## Usage

```
/commit
```

## Workflow

1. **Review current change**
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

2. **Detect scope usage**
   - Check recent commit messages:
     ```bash
     jj log -n 20 --no-graph --template 'description ++ "\n"'
     ```
   - If `jj` fails, fall back to git:
     ```bash
     git log -n 20 --pretty=%s
     ```

3. **Draft a Conventional Commit message**
   - If scopes are used, include one: `feat(scope): summary`.
   - If scopes are not used, omit it: `feat: summary`.

4. **Ask for confirmation**
   - Confirm the message before applying.

5. **Commit the current change and create a follow-up changeset**
   - Prefer Jujutsu:
     ```bash
     jj commit -m "<message>"
     ```
   - `jj commit -m` records the current changeset with the message and leaves you on a new working-copy changeset for future work.
   - If `jj commit` is unavailable for some reason, you may instead use:
     ```bash
     jj describe -m "<message>"
     jj new
     ```
   - If `jj` fails, fall back to git:
     ```bash
     git commit -m "<message>"
     ```
