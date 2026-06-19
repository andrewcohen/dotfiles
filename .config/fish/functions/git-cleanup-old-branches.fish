function git-cleanup-old-branches --description "Clean up old Git branches that have been deleted on remote"
    git fetch --prune
    and git branch --delete (git for-each-ref --format '%(if:equals=gone)%(upstream:track,nobracket)%(then)%(refname:short)%(end)' refs/heads/ | string split ' ')
end