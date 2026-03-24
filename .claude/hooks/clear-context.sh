#!/bin/bash
# Hook: intercepts "clear context" messages and sends /clear to the tmux pane
# Used by UserPromptSubmit hook to allow Discord users to clear context remotely

# Read the prompt from stdin (JSON with .prompt field)
INPUT=$(cat)
PROMPT=$(echo "$INPUT" | jq -r '.prompt // empty')

# Check if the message is a clear context request (case-insensitive)
if echo "$PROMPT" | grep -iqE '^(clear context|clear session|/clear|reset context|new session)$'; then
  # Send /clear to the tmux pane in the background after a short delay
  # The delay allows Claude to return to prompt state after blocking
  (sleep 1 && tmux send-keys -t claude "/clear" Enter) &

  # Block this prompt from being processed
  echo "Clearing context via remote command..." >&2
  exit 2
fi

# Allow all other prompts through
exit 0
