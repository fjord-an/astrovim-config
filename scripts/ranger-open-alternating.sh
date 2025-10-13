#!/usr/bin/env bash
# Alternating split opener for ranger + Neovim integration
# Opens files alternating between vertical and horizontal splits

# State file to track split direction
STATE_FILE="/tmp/nvim_ranger_split_state_$$"

# Get the current Neovim server address
NVIM_SERVER="${NVIM:-$NVIM_LISTEN_ADDRESS}"

if [ -z "$NVIM_SERVER" ]; then
    # Fallback: open in regular nvim if not running from within nvim
    nvim "$@"
    exit 0
fi

# Determine split direction by checking state file
if [ -f "$STATE_FILE" ]; then
    LAST_SPLIT=$(cat "$STATE_FILE")
    if [ "$LAST_SPLIT" = "vsplit" ]; then
        SPLIT_CMD="split"
    else
        SPLIT_CMD="vsplit"
    fi
else
    # First file: open in vsplit
    SPLIT_CMD="vsplit"
fi

# Save the current split command for next iteration
echo "$SPLIT_CMD" > "$STATE_FILE"

# Open file in Neovim using remote command
for file in "$@"; do
    nvim --server "$NVIM_SERVER" --remote-send "<Esc>:${SPLIT_CMD} ${file}<CR>"
done
