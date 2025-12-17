## Version control

Prefer Jujutsu (`jj`) over `git` for day-to-day VCS operations when possible.

- Use `jj status`, `jj diff`, `jj log`, `jj new`, `jj describe`, `jj split`, `jj squash`, `jj rebase`
- If the repo is a Git-backed workspace, prefer `jj git push` / `jj git fetch`
- Fall back to `git` only when `jj` can’t do it, or when the user explicitly asks for git commands
