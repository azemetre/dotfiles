#!/usr/bin/env bash

selected=$(cat ~/.local/bin/.tmux-cht-languages ~/.local/bin/.tmux-cht-command | fzf)
if [[ -z $selected ]]; then
    exit 0
fi

read -p "What'cha need handsome: " query

if grep -qs "$selected" ~/.local/bin/.tmux-cht-languages; then
    query=$(echo "$query" | tr ' ' '+')
    tmux neww bash -c "echo \"curl cht.sh/$selected/$query/\" & curl cht.sh/$selected/$query & while [ : ]; do sleep 1; done"
else
    tmux neww bash -c "curl -s cht.sh/$selected~$query | less -R"
fi
