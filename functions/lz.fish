function lz --description "Open lazygit in tmux window"
    if tmux list-windows | grep -q 'lazygit'
        tmux select-window -t lazygit
    else
        tmux new-window -n lazygit -c "#{pane_current_path}" lazygit
    end
end