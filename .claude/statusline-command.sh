#!/usr/bin/env bash
input=$(cat)

dir=$(echo "$input" | jq -r '.workspace.current_dir')
model=$(echo "$input" | jq -r '.model.display_name')
used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

context_str=""
if [ -n "$used" ]; then
    used_int=$(printf "%.0f" "$used")
    context_str=" | ctx: ${used_int}% used"
fi

printf "\033[34m%s\033[0m [%s]%s" \
    "$dir" "$model" "$context_str"
