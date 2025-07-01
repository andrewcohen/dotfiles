function tat --description "Tmux attach or create session based on directory name"
    set name (basename (pwd) | sed -e 's/\.//g')
    
    if tmux ls 2>&1 | grep -q "$name"
        tmux attach -t "$name"
    else if test -f .envrc
        direnv exec / tmux new-session -s "$name"
    else
        tmux new-session -s "$name"
    end
end