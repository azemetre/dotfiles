#!/usr/bin/env bash

# languages to look up
langs="
golang
nodejs
javascript
typescript
cpp
c
lua
rust
python
bash
php
haskell
css
html
"
# CLTs to look up
util="
find
man
tldr
sed
awk
tr
cp
ls
grep
xargs
rg
ps
mv
kill
lsof
less
head
tail
tar
cp
rm
rename
jq
cat
ssh
cargo
git
git-worktree
git-status
git-commit
git-rebase
docker
docker-compose
stow
chmod
chown
"

languages=$(echo $langs | tr " " "\n")
core_utils=$(echo $util | tr " " "\n")
selected=$(echo -e "$languages\n$core_utils" | fzf)
if [[ -z $selected ]]; then
    exit 0
fi

read -p "What'cha need handsome? " query

if grep -qs "$selected" "$languages"; then
    query=`echo $query | tr ' ' '+'`
    tmux neww bash -c "echo \"curl cht.sh/$selected/$query/\" & curl cht.sh/$selected/$query & while [ : ]; do sleep 1; done"
else
    tmux neww bash -c "curl -s cht.sh/$selected~$query | less"
fi

