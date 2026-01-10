#!/bin/bash

set -euo pipefail

proceed=$(gum choose --limit 1 --height 4 --header "Setup git config?" "Yes" "No")

if [ "$proceed" = "Yes" ]; then
    # Prompt for Git user name
    USER_NAME="$(gum input \
        --placeholder "Your full name" \
        --prompt "Git user name: ")"

    # Prompt for Git user email
    USER_EMAIL="$(gum input \
        --placeholder "you@example.com" \
        --prompt "Git user email: ")"

    # Trim whitespace check & set Git config
    if [[ -n "${USER_NAME//[[:space:]]/}" ]]; then
        git config --global user.name "$USER_NAME"
        gum style --foreground 212 "✓ Git user.name set to: $USER_NAME"
    else
        gum style --foreground 240 "• Git user.name not set (empty input)"
    fi

    if [[ -n "${USER_EMAIL//[[:space:]]/}" ]]; then
        git config --global user.email "$USER_EMAIL"
        gum style --foreground 212 "✓ Git user.email set to: $USER_EMAIL"
    else
        gum style --foreground 240 "• Git user.email not set (empty input)"
    fi
fi
