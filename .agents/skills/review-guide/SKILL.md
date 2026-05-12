---
name: review-guide
description: Create a human-oriented PR/change review guide with chapters, context, and key code checkpoints
---

# review-guide - Human Review Walkthrough

Create a supplementary review guide that helps a human reviewer understand a PR or local change before/during code review. This is **not** the same as agent code review: do not primarily hunt for defects or produce approval/rejection. Instead, orient the reviewer with context, scope, narrative chapters, and curated key code checkpoints.

## Usage

```
/review-guide [revset|PR number|PR URL]
```

Examples:
- `/review-guide`
- `/review-guide twx::@`
- `/review-guide twx`
- `/review-guide 123`
- `/review-guide https://github.com/org/repo/pull/123`

## Goal

Answer: **"How should a human understand and review this change?"**

The output should combine:
- original task/spec context,
- user-facing behavior,
- scope bookends,
- diff size/shape,
- dependency/order of the change,
- curated code excerpts,
- reviewer prompts and decision points,
- test/validation map.

Prefer a clear guided walkthrough over an exhaustive file-by-file summary.

## Output

Default to writing a local Markdown artifact and return a brief chat summary with the file path. Use a path like:

- `.review-guides/review-guide.md`
- `.review-guides/pr-<number>-review-guide.md`
- `.review-guides/<YYYYMMDD>-<short-topic>.md`

If the user explicitly asks for chat-only output, provide Markdown in chat instead of writing a file.

Do **not** post to GitHub by default. If the user asks to post, produce a condensed PR-comment version and ask for confirmation before calling `gh`.

## Workflow

### 1. Determine target change

Prefer Jujutsu when available.

If an argument is a PR number or URL:
```bash
gh pr view <number-or-url> --json number,title,body,author,baseRefName,headRefName,additions,deletions,changedFiles,url,isDraft,state,mergeable
 gh pr diff <number-or-url> --patch --color never
```
Also fetch file list if useful:
```bash
gh pr diff <number-or-url> --name-only
```
When reviewing an existing PR, also inspect existing discussion/review feedback so the guide does not rediscover already-known points or contradict resolved context:
```bash
gh pr view <number-or-url> --json comments,reviews,reviewDecision
```
Summarize relevant existing feedback as “Known PR feedback/context” in the guide, especially when a failing test, launch flag, or contract concern is already explained.

If an argument looks like a JJ revset:
```bash
jj log -r '<revset>' --color never --no-graph -T 'change_id.short() ++ " " ++ commit_id.short() ++ " " ++ description.first_line() ++ "\n"'
jj diff -r '<revset>' --stat --color never
jj diff -r '<revset>' --summary --color never
```

If no argument is provided, orient on the current change/stack:
```bash
jj status
jj log -r 'ancestors(@, 8)' --color never --no-graph -T 'change_id.short() ++ " " ++ commit_id.short() ++ " " ++ description.first_line() ++ "\n"'
jj diff -r @ --stat --color never
jj diff -r @ --summary --color never
```

If the change appears to be a stack of multiple PRs/feature slices, do **not** automatically review the whole stack. Identify the likely PR boundaries from bookmarks/commit messages and either:
- use the explicit user-provided revset/bookmark/PR number, or
- ask which slice to target before producing the guide.

When targeting one PR in a stack, make the selected revset/bookmark explicit in the guide and exclude later stack changes.

If `jj` is unavailable or fails, fall back to git:
```bash
git status -sb
git log --oneline --decorate -n 12
git diff --stat --color=never
git diff --name-status --color=never
```

### 2. Find task/spec context

Look for explicit task references and existing review context before summarizing implementation.

Search commit messages, changed docs, PR body/comments/reviews, and user-provided notes for:
- `[spec:<id>]`
- `docs/specs/<id>*`
- PR body links/tickets
- feature names in changed spec files

Commands that may help:
```bash
jj log -r '<revset>' --no-graph --color never -T 'description ++ "\n"'
rg -n "spec:[0-9]{8}-[a-z0-9]+|specId:|featureName:|Goal|Scope" docs/specs .github docs 2>/dev/null
```

If a spec is found, read it. Extract:
- goal / user problem,
- in scope,
- out of scope,
- affected surfaces,
- launch state,
- analytics/tracking requirements,
- loader/action/data contracts,
- testing/validation expectations.

If no spec exists, state that context is inferred from PR title, commits, diff, and any existing PR feedback.

If prior PR feedback or user-provided review context explains an apparent issue, preserve that context in the guide. For example: “Known PR feedback says this experiment is intentionally unpublished; reviewers should adjust the test expectation rather than publish early.”

### 3. Build the diff map

Classify changed files by surface:
- spec/docs
- routes/loaders/actions
- services/domain logic
- components/UI
- experiments/analytics
- cart/checkout/data contracts
- tests/harness
- generated assets/data/config

Estimate size:
- commits/changes,
- files changed,
- additions/deletions,
- large generated/data files to skim rather than line-review.

### 4. Create chapters

Prefer semantic chapters. Use commit boundaries when they are meaningful, but reorganize if semantic order is clearer.

Good chapter types:
1. context/spec/launch primitives
2. domain/data model/contracts
3. user-facing surface
4. mutation/persistence flow
5. analytics/tracking
6. tests/validation
7. generated assets/data

Each chapter must include:
- **Intent**: why this chapter exists.
- **What changed**: concise factual summary.
- **Why it matters**: user/business/contract impact.
- **Key files**: paths.
- **Key code checkpoints**: curated excerpts with line numbers.
- **Reviewer prompts**: questions a human should answer.

### 5. Add key code checkpoints

A key code checkpoint is a small guided excerpt where a reviewer should pause and inspect an important part of the change. Use the clear heading **Key code checkpoints** instead of jargon like “code stations”. Checkpoints should be selective, not exhaustive.

For each checkpoint include:
- title,
- why the reviewer is looking at it,
- exact file path and line range,
- excerpt in a code fence,
- reviewer prompts.

When the checkpoint is about code that changed in the PR, prefer a short fenced `diff` excerpt over a plain current-state code sample, especially when the before/after contrast helps the reviewer. Keep diff excerpts small and focused, and pair them with links to the relevant file/line range when posting to GitHub.

Use `read` to fetch line ranges from files. Prefer current working tree for local changes; for historical JJ revs use `jj file show -r <rev> <path> | nl -ba` via bash when needed.

Keep excerpts short: usually 10-40 lines for normal code fences, and even shorter for `diff` fences when possible. If a file is huge or generated, summarize and link to the path instead of pasting large blocks.

### 6. Separate facts from prompts

Use language like:
- "This establishes..."
- "This is the handoff point..."
- "Reviewer should verify..."
- "Decision point..."

Avoid making the guide a defect report. If you notice a likely issue, include it as a **review prompt** unless it is clearly blocking and directly affects how to review the change.

Examples:
- Good: "Reviewer should confirm `published: false` is intentional for this pre-launch phase."
- Avoid: "Bug: experiment is unpublished."

### 7. Include review paths

Add two actionable checkbox paths near the top or bottom:

#### Fast path for reviewers with 10 minutes
A short checklist of the most important checkpoints using `- [ ]` items.

#### Deep path for domain owners
A more thorough checklist through chapters and tests using `- [ ]` items.

Any section named “checklist”, “review path”, “reviewer prompts”, or “validation commands” must use actual Markdown checkbox items (`- [ ] ...`) when it contains actions for a human reviewer.

### 8. Include validation map

Summarize tests added/changed and what behavior they prove. If command results are present in the repo/PR description, cite them. Do not invent validation results. If unknown, say "Validation evidence not checked by this guide."

## Recommended Markdown Template

```md
# Review Guide: <title/topic>

## Orientation

- User-facing goal:
- Task/spec context:
- Scope bookends:
- Launch state:
- PR/change size:
- Risk profile:

## Suggested review path

### Fast path for reviewers with 10 minutes
- [ ] ...

### Deep path for domain owners
- [ ] ...

## Data / behavior flow

1. ...
2. ...
3. ...

## Chapters

### Chapter 1: <title>

**Intent:** ...

**What changed:** ...

**Why it matters:** ...

**Key files:**
- `path/to/file.ts`

#### Key code checkpoint 1.1: <title>

Why this matters: ...

`path/to/file.ts:10-30`

```ts
...
```

Reviewer prompts:
- [ ] ...
- [ ] ...

### Chapter 2: <title>

...

## Test / validation map

- [ ] `path/to/test.ts`: proves ...
- [ ] Validation evidence: not checked / command results ...

## Reviewer checklist

- [ ] Matches the spec/task goal.
- [ ] Scope boundaries are respected.
- [ ] Data contracts are backward-compatible.
- [ ] Launch flags are intentional.
- [ ] Analytics/tracking is reachable and not over-fired.
- [ ] Tests cover critical behavior and edge cases.
```

## PR comment mode

If a local review-guide artifact has already been created and the user asks to post it, post the same guide content by default (aside from required posting prefixes such as `:robot:` from the PR-feedback skill). To avoid flooding the PR page, collapse each major section in its own `<details>` block when posting long guides, and avoid large top-level Markdown headers in PR comments (prefer a short bold title or small heading). When posting to GitHub, link file paths and line references to the relevant blob/diff whenever practical instead of leaving them as plain path text. Do not silently summarize, condense, remove code excerpts, or otherwise materially change the guide unless the user explicitly asks for a condensed version or confirms a proposed condensed version.

If the user asks for a condensed PR-comment version before a local artifact is posted, use collapsible sections and keep code excerpts selective.

Example:

```md
## Review guide

This PR is best reviewed in 4 chapters:

1. **Primitives** — experiment, eligibility, attributes.
2. **PDP** — loader state, messaging, modal, viewed tracking.
3. **Cart** — opt-in UI, action validation, persistence.
4. **Tests** — component, route, loader, service coverage.

<details>
<summary>Chapter 1: Primitives</summary>

Key files:
- `app/lib/foo.ts`

Reviewer prompts:
- Confirm launch state.
- Confirm data contract.

</details>
```

Ask before posting when producing a new condensed version:
> Post this condensed review guide as a PR comment?

Then use `gh pr comment` only after confirmation. If posting an already-created local guide verbatim at the user's request, no extra condensation confirmation is needed.

## Style

- Be concise but useful.
- Do not include every changed file.
- Prefer reviewer prompts over conclusions.
- Include exact paths and line numbers for key code checkpoints.
- When the output will be posted to GitHub, prefer Markdown links for file paths and line references whenever practical.
- Call out generated/large data files as skim-only when appropriate.
- Make the guide useful even to a reviewer who has not read the ticket yet.
