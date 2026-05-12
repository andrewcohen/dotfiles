---
name: share-pr-feedback
description: Post prepared pull request feedback or replies to existing PR review comments to GitHub, prefixed with :robot: and a category tag (issue/suggestion/note/praise), either as a top-level comment, line-specific inline comments, or review-thread replies
---

# share-pr-feedback - Share PR Feedback as Bot Comment

Post already-prepared PR review feedback to GitHub. Use this when the user asks to share, post, publish, reply to, respond to, or leave feedback/comments on a PR.

Also use this when you have addressed PR feedback and are about to post responses back to GitHub review comments/threads.

## Requirements

- Always prefix posted feedback/replies with `:robot:` followed by a bold category tag and an em dash. See [Comment categories](#comment-categories).
- Post only reviewer-facing feedback. Do not include internal process notes (for example, whether existing comments were fetched/deduplicated, tool usage, or review workflow observations) unless the user explicitly asks to publish them.
- Do not approve, request changes, or submit a formal review unless the user explicitly asks.
- Support:
  - top-level PR comments,
  - line-specific inline PR comments, and
  - replies to existing PR review comments/threads.
- In Jujutsu workspaces or workspaces without a normal `.git` directory, always pass `--repo <owner>/<repo>` to `gh` commands when using `gh pr ...` commands.

## Comment categories

Every posted comment carries one of these four categories — the same set tuicr uses for review drafts. Pick the narrowest category that fits. If it doesn't clearly fit one of these, it's probably a `note`.

- **issue** — a concrete failure mode you can name (bug, security, broken invariant, regression). Don't reach for `issue` to look thorough; if you can't state what specifically goes wrong and when, it's a `suggestion` or `note`.
- **suggestion** — an improvement worth considering. The PR author can take it or explain why not.
- **note** — observation or context with no required action.
- **praise** — explicit positive callout. Use sparingly; one or two per review at most.

Render the category as `:robot: **<category>** — <body>`, e.g.:

```text
:robot: **suggestion** — Negative match passes for unrelated bugs like an empty string or `Arrives undefined`. A positive assertion would lock in the actual copy.
```

For multi-line bodies, keep the `:robot: **<category>** —` opener on the first line; continue normally on subsequent lines.

For **replies to existing review threads**, the category tag is optional — replies are usually informational ("addressed in …", "good catch, fixed") and read fine without one. Add a tag only if the reply itself stands as new feedback (e.g. a follow-up `suggestion` or `issue` on the same thread).

Source-of-category precedence when feedback is being relayed (not authored fresh):
1. If the feedback came from tuicr, use the `comment_type` field on each tuicr comment verbatim.
2. Otherwise, infer from the content using the definitions above.

## Writing legible comments

Each comment is read by someone deciding *act or skip* in one scan — not by a grader checking whether you were thorough. Write for that reader.

- **Lead with the finding or the ask.** First sentence = what's wrong or what to do. Justification follows, and only if it changes the decision. If sentence one is setup ("X is carried through, skipping Y…"), the lead is buried — cut to the conclusion.
- **Lists are lists.** Chaining clauses with semicolons or "and also" means you're prose-formatting a list — use bullets. A set of checks or a verification rundown is never a paragraph.
- **One sentence, one job.** No stacked parentheticals or em-dash asides carrying a claim *and* a qualifier *and* a counterexample at once. Split them.
- **Don't re-explain the code.** Cite the line and trust the author to read it; re-deriving the mechanism to prove you understood it is noise.
- **Length tracks payload.** A one-line ask gets one line. Padding reads as noise, not rigor.

Smell test before posting: can the reader get the point from sentence one and skim the rest? If a comment runs past ~3 sentences with no line break, it's almost always a buried lead or a prose-formatted list — restructure first.

These are about *legibility*, not omission: keep your independent judgment and disagreements, just state them so they can be acted on at a glance.

## Workflow

1. Determine the PR number and repo.
   - If the repo is not explicit, use:
     ```bash
     gh repo view --json nameWithOwner -q .nameWithOwner
     ```
   - If that fails, ask the user for `owner/repo`.

2. Decide comment type from the user's request and available feedback:
   - Top-level summary feedback → use `gh pr comment`.
   - New line-specific feedback → use GitHub PR review comments API.
   - Replying to existing review feedback/comment threads → use the review comment replies API.
   - If unclear whether feedback should be top-level, inline, or a reply, ask a clarifying question.

3. If responding after addressing review feedback:
   - Fetch existing PR review comments first so replies target the right comment IDs:
     ```bash
     gh api repos/<owner>/<repo>/pulls/<pr-number>/comments --paginate
     ```
   - Reply directly to the relevant review comments instead of creating unrelated top-level comments.
   - **If this is the user's own PR (they are the author), re-request review from the original reviewers once the reply is posted.** Posting a reply alone does not put the PR back in the reviewer's queue; GitHub only re-surfaces it when reviewers are re-requested. Use:
     ```bash
     gh api repos/<owner>/<repo>/pulls/<pr-number>/requested_reviewers \
       -X POST \
       -f 'reviewers[]=<login>'
     ```
     If multiple reviewers left feedback, re-request each of them. Skip this step if the user explicitly says not to, or if their reply was clearly informational rather than "this is addressed."

## Top-level PR Comment

Use:

```bash
gh pr comment <pr-number> --repo <owner>/<repo> --body ':robot: **<category>** — <feedback>'
```

For multiline feedback, keep the `:robot: **<category>** —` opener on the first line:

```text
:robot: **note** — <summary>

<details>
```

## Inline PR Comment

Use the GitHub API. First fetch the PR head SHA:

```bash
gh pr view <pr-number> --repo <owner>/<repo> --json headRefOid -q .headRefOid
```

Then post each inline comment:

```bash
gh api repos/<owner>/<repo>/pulls/<pr-number>/comments \
  -f commit_id=<head-sha> \
  -f path=<file-path> \
  -F line=<line-number> \
  -f side=RIGHT \
  -f body=':robot: **<category>** — <comment>'
```

Notes:
- Use `side=RIGHT` for comments on the PR's changed/new side.
- Use `line` for the final line of the diff hunk being commented on.
- For multi-line comments, still start the body with `:robot: **<category>** —`.
- If the target line is not part of the PR diff, fall back to a top-level comment with file/line references.

## Reply to Existing PR Review Comment

Use this for follow-up responses after addressing reviewer feedback.

First fetch review comments and identify the parent comment ID:

```bash
gh api repos/<owner>/<repo>/pulls/<pr-number>/comments --paginate
```

Then reply to the existing review comment:

```bash
gh api repos/<owner>/<repo>/pulls/<pr-number>/comments/<comment-id>/replies \
  -f body=':robot: <reply>'
```

Replies typically omit the category tag (see [Comment categories](#comment-categories)). For multiline replies, keep `:robot:` as the first line:

```text
:robot: Updated this to rethrow after capturing so deferred consumers can use their fallback/error behavior.
```

## Response to User

After posting, reply concisely with links returned by `gh`, for example:

```text
Posted as :robot::
- <comment-url>
```
