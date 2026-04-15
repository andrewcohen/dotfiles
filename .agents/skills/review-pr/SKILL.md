---
name: review-pr
description: Review a GitHub pull request and optionally leave comments
---

# review-pr - Review GitHub Pull Request

Review a GitHub pull request using the GitHub CLI and optionally leave a review or inline comments.

## Usage

```
/review-pr <pr-number>
```

## Workflow

1. **Fetch PR metadata**
   - Use `gh pr view` to confirm title, base, and head:
     ```bash
     gh pr view <pr-number> --json title,headRefName,baseRefName,number
     ```

2. **Check out the PR**
   - Use GitHub CLI to check out the PR branch:
     ```bash
     gh pr checkout <pr-number>
     ```

3. **Review the change**
   - Prefer Jujutsu:
     ```bash
     jj status
     jj diff -r @- --color never
     ```
   - If `jj` is unavailable or fails, fall back to git:
     ```bash
     git status -sb
     git diff --color=never
     ```
   - Walk through the diff in the response so the user can follow the changes.

4. **Provide review summary**
   - Provide a concise summary and list issues by severity (blocker, major, minor, nit).
   - If no issues, state that explicitly.
   - **Important:** The final review decision is the user's. Provide guidance, but do not make the decision or submit a review unless explicitly asked.

5. **Leave a review comment (optional, only if requested)**
   - For a top-level review:
     ```bash
     gh pr review <pr-number> --approve -b "<summary>"
     ```
   - For inline comments, use the GitHub API:
     ```bash
     gh api repos/OWNER/REPO/pulls/<pr-number>/comments \
       -f commit_id=<sha> \
       -f path=<file-path> \
       -f line=<line-number> \
       -f side=RIGHT \
       -f body="<comment>"
     ```

## Focus Areas

Correctness, edge cases, security, performance, and maintainability.
