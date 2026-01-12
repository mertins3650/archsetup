#!/bin/bash

proceedssh=$(gum choose --limit 1 --height 4 --header "Generate new ssh key" "Yes" "No")

if [ "$proceedssh" = "Yes" ]; then
    EMAIL=$(gum input --placeholder "Enter your email address" \
        --prompt "Email address: ")
    ssh-keygen -t ed25519 -C "${EMAIL//[[:space:]]/}"
    eval "$(ssh-agent -s)"
    ssh-add ~/.ssh/id_ed25519
fi
