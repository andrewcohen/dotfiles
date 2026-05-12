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

2. **Pull down existing comments**
   - Fetch the conversation so you can see what reviewers (human or bot) have already raised, and avoid repeating it:
     ```bash
     # Top-level review/issue comments
     gh pr view <pr-number> --json comments,reviews \
       --jq '{comments: [.comments[] | {author: .author.login, body}], reviews: [.reviews[] | {author: .author.login, state, body}]}'
     # Inline review comments (anchored to file/line)
     gh api repos/OWNER/REPO/pulls/<pr-number>/comments \
       --jq '.[] | {author: .user.login, path, line, body}'
     ```
   - Build a mental list of points already covered. When forming your own findings:
     - **Do not restate** a point an existing comment already makes — it's noise.
     - You are free to **agree or disagree** with existing comments. If you disagree with one, say so explicitly and explain why; the user wants your independent judgment, not deference.
     - If an existing comment is partially right but misses something, add only the incremental insight, and reference the comment you're building on.
   - In your summary, briefly note which existing comments you concur with vs. push back on, so the user sees your stance on the whole conversation.

3. **Ensure the PR diff is available locally**
   - Do not blindly run `gh pr checkout` if the user provided enough context and the workspace already appears to be on the PR change.
   - Signals that the PR is already available locally:
     - The user provides a diff range such as `main..@`, `@-..@`, or similar.
     - The current workspace/branch name includes the PR number or head branch.
     - `jj status` / `git status` shows the expected PR change.
     - `jj diff -r <provided-range>` or `git diff <provided-range>` works and matches the PR description.
   - If the PR diff is unavailable, stale, or does not match the requested PR, check it out:
     ```bash
     gh pr checkout <pr-number>
     ```

4. **Review the change**
   - If the user provided a diff range, use that range first.
   - Prefer Jujutsu:
     ```bash
     jj status
     jj diff -r <provided-range-or-@-> --color never
     ```
   - If `jj` is unavailable or fails, fall back to git:
     ```bash
     git status -sb
     git diff <provided-range-if-any> --color=never
     ```
   - Use the PR description as context, but verify behavior against the actual diff.
   - Walk through the diff in the response so the user can follow the changes.

5. **Provide review summary**
   - Provide a concise summary and list issues by severity (blocker, major, minor, nit).
   - Exclude anything already covered by an existing comment (see step 2); only surface new findings or explicit (dis)agreement.
   - If no issues, state that explicitly.
   - Write each finding to be skimmed: lead with the problem or the ask in the first sentence, justify only if it changes the decision, use bullets for anything that's a list (don't chain clauses with semicolons), keep one idea per sentence, and don't re-explain code the author wrote. If a finding runs past ~3 sentences with no line break, it's probably a buried lead — restructure. (If you go on to post via `share-pr-feedback`, that skill has the full version.)
   - **Important:** The final review decision is the user's. Provide guidance, but do not make the decision or submit a review unless explicitly asked.

6. **Leave a review comment (optional, only if requested)**
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
