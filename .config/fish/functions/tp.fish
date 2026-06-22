function tp --description "Tee stdin to the terminal and copy it to the clipboard (tee /dev/tty | pbcopy)"
    tee /dev/tty | pbcopy
end
