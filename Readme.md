# dotfiles

Managed with [mise](https://mise.jdx.dev)'s built-in `[dotfiles]` engine (replaced
GNU stow). The mapping lives in [`.config/mise/config.toml`](.config/mise/config.toml)
under `[dotfiles]`; the repo mirrors the home-relative layout, so most entries are
`{}` (source inferred from target).

## New machine

```sh
brew install mise            # needs mise >= 2026.6.6 for [dotfiles]/bootstrap
git clone <this repo> ~/dotfiles
mise trust ~/dotfiles/.config/mise/config.toml
# set this machine's identity (see "Per-machine identity" below), then:
mise bootstrap               # installs [tools] + applies dotfiles
# or just the dotfiles:
mise dotfiles apply          # add --force to replace pre-existing real files
```

Day-to-day:

```sh
mise dotfiles status         # what's linked / drifted
mise dotfiles apply          # re-link after adding entries
mise dotfiles add ~/.foo     # track a new file and add it to [dotfiles]
```

Note: whole-dir `symlink` entries are live-editable in place. `symlink-each`
(e.g. `opencode`, whose dir also holds `node_modules`/runtime state) links each
managed file individually so unmanaged files coexist.

## Per-machine identity (jj email)

No email is committed. The shared jj config ([`.config/jj/config.toml`](.config/jj/config.toml))
defines `mine()` by name (`user(glob-i:"andrew cohen")`) and omits `user.email`.
Each machine supplies its own email in an **untracked** file that jj merges over
the shared config:

```toml
# ~/.config/jj/conf.d/10-identity.toml   (gitignored)
[user]
email = "you@example.com"
```

jj loads `~/.config/jj/conf.d/*.toml` automatically, so this is all that differs
between machines.

## ripgrep

ripgrep reads **no** config unless `RIPGREP_CONFIG_PATH` is set (it does not
auto-read `~/.ripgreprc`). Both shells export `RIPGREP_CONFIG_PATH=~/.ripgreprc`
so [`.ripgreprc`](.ripgreprc) actually applies.

## tmux truecolor

`tmux-256color` ships with modern macOS (`/usr/share/terminfo`) — no manual
`tic` install needed. Truecolor comes from the `terminal-overrides "*:Tc"/"*:RGB"`
lines in [`.tmux.conf`](.tmux.conf). Verify a terminal's 24-bit color:

```sh
awk 'BEGIN{
    s="/\\/\\/\\/\\/\\"; s=s s s s s s s s;
    for (colnum = 0; colnum<77; colnum++) {
        r = 255-(colnum*255/76); g = (colnum*510/76); b = (colnum*255/76);
        if (g>255) g = 510-g;
        printf "\033[48;2;%d;%d;%dm", r,g,b;
        printf "\033[38;2;%d;%d;%dm", 255-r,255-g,255-b;
        printf "%s\033[0m", substr(s,colnum+1,1);
    }
    printf "\n";
}'
```
