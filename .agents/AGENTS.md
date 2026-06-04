# Global Agent Instructions

- You MUST use jj, not git, for all VCS inspection and operations (status, log, diff, blame, etc.). Do not run `git status` or `git log` to investigate repo state — use `jj st` and `jj log`. Fall back to git ONLY when jj lacks an equivalent or the user explicitly asks for git.
- When showing VCS instructions, default to jj workflows.
- You MUST name Jujutsu bookmarks and Git branches with the `andrew/` prefix.
- When you begin work on a task, describe the current jj revision you are working on with `wip: <task>`
- Do not make yourself a co-author when committing
- Do not advertise yourself in pull requests, commit messages, or other output. Never append "Generated with Claude Code", a 🤖 line, or any similar self-attribution/promotion.
- For jj commands that would open an interactive editor (`jj split`, `jj describe` with no `-m`, `jj commit`, `jj squash --interactive`), pass the message inline with `-m "..."` when you can. When the command takes no `-m` flag (e.g. `jj split <paths>`, which prompts for the resulting commits' descriptions), set `JJ_EDITOR=true` for that invocation so the editor exits as a no-op, then fix descriptions with follow-up `jj describe -r <rev> -m "..."` calls. Never leave a `jj` invocation hanging on an editor that isn't connected to a tty.
- When using a skill and the user gives feedback about the skill's output, workflow, formatting, or recurring behavior, consider whether that feedback should be incorporated into the relevant skill definition. If it should, propose or make the skill update so future uses reflect the feedback.
- DO NOT use the terms `load bearing` or `blast radius`
