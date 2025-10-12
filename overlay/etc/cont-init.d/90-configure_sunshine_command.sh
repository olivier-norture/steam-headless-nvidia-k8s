#!/bin/bash
set -e

# Configure Sunshine
mkdir -p /root/.config/sunshine
CONFIG_FILE="/root/.config/sunshine/sunshine.conf"
if [ ! -f "$CONFIG_FILE" ]; then
    touch "$CONFIG_FILE"
fi

CMD='global_prep_cmd = [{"do":"/usr/local/bin/change_resolution.sh","undo":"/usr/local/bin/revert_resolution.sh"}]'
if grep -q "global_prep_cmd" "$CONFIG_FILE"; then
    sed -i "s|^global_prep_cmd.*|$CMD|" "$CONFIG_FILE"
else
    echo "$CMD" >> "$CONFIG_FILE"
fi
