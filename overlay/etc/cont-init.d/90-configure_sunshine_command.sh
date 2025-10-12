#!/bin/bash
set -e

# Configure Sunshine
mkdir -p /root/.config/sunshine
CONFIG_FILE="/root/.config/sunshine/sunshine.conf"
if [ ! -f "$CONFIG_FILE" ]; then
    touch "$CONFIG_FILE"
fi

if ! grep -q "global_prep_cmd" "$CONFIG_FILE"; then
    echo 'global_prep_cmd = [{"do":"/usr/local/bin/change_resolution.sh %SUNSHINE_CLIENT_WIDTH% %SUNSHINE_CLIENT_HEIGHT%","undo":"/usr/local/bin/revert_resolution.sh"}]' >> "$CONFIG_FILE"
fi
