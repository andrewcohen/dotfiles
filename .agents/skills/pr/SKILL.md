---
name: pr
description: Create a GitHub pull request with gh using Jujutsu workflows
---

# pr - Create a GitHub Pull Request

Create a GitHub PR using `gh`, defaulting to Jujutsu workflows. This covers pushing a bookmark, creating the PR, and formatting the PR body without literal `\n` characters.

## Usage

```
/pr [base-branch]
```

Examples:
- `/pr main`
- "open a PR" (defaults to repo conventions; ask for base if missing)

## Workflow

1. **Determine repo root**
   - Use current working directory or the repo containing recent file edits.

2. **Review current change (align with review prompt)**
   ```bash
   jj status
   jj diff -r @ --color never
   ```
   - If `jj` fails, fall back to:
     ```bash
     git status -sb
     git diff --color=never
     ```

3. **Update change description with a Conventional Commit (align with commit prompt)**
   - Check recent commit messages to detect scope usage:
     ```bash
     jj log -n 20 --no-graph --template 'description ++ "\n"'
     ```
   - Draft a message (include scope if used), ask for confirmation, then apply:
     ```bash
     jj describe -m "<message>"
     ```
   - If `jj` fails, fall back to `git commit -m "<message>"`.

4. **Create or reuse a bookmark (branch)**
   - If none exists, create one for `@`:
     ```bash
     jj bookmark create <name> -r @
     ```
   - If pushing a new bookmark, track it before pushing:
     ```bash
     jj bookmark track <name> --remote origin
     ```

5. **Push the bookmark**
   ```bash
   jj git push --bookmark <name>
   ```

6. **Check for a pull request template**
   - Look for common locations:
     - `.github/pull_request_template.md`
     - `.github/PULL_REQUEST_TEMPLATE.md`
     - `.github/PULL_REQUEST_TEMPLATE/`
     - `PULL_REQUEST_TEMPLATE.md`
   - If none are found, search more broadly for repo-specific templates, for example:
     - `docs/pull_request_template.md`
     - `docs/PULL_REQUEST_TEMPLATE.md`
     - `**/*pull*request*template*.md`
     - `**/pr_template*.md`
   - If a template exists, follow its structure in the PR body.

7. **Create the PR with `gh`**
   - Ask for the base branch if not provided.
   - Use a well-formed title/body.
   - **Avoid literal `\n` in the PR body** by using ANSI-C quoting or a here-doc:
     ```bash
     gh pr create --base <base> --head <name> \
       --title "<title>" \
       --body $'## Summary\n- item\n\n## Testing\n- command'
     ```
     or:
     ```bash
     gh pr create --base <base> --head <name> --title "<title>" --body "$(cat <<'EOF'
     ## Summary
     - item

     ## Testing
     - command
     EOF
     )"
     ```

8. **If the PR body renders incorrectly**
   - Update it in-place:
     ```bash
     gh pr edit <number> --body $'...'
     ```

## Notes / Learned Behavior

- `gh pr create --body "text\nmore"` can produce literal `\n` on GitHub if not using ANSI-C quotes or a here-doc.
- When including code examples in the PR body, wrap them in triple backticks so GitHub renders them correctly.
- Prefer Jujutsu for VCS operations (create bookmark, track, push).
- Ask for base branch if not specified; default to `main` only when appropriate.
- Some repos keep PR templates outside standard GitHub locations, such as `docs/pull_request_template.md`; do a broader search before assuming no template exists.
