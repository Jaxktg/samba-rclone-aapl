#!/bin/bash
set -e  # Exit immediately if a command exits with a non-zero status

# Function to execute mount scripts
execute_mount_scripts() {
    local scripts_found=false
    for script in /app/mount-*.sh; do
        if [ -f "$script" ]; then
            scripts_found=true
            echo "Executing $script..."
            bash "$script" &
        fi
    done

    if [ "$scripts_found" = false ]; then
        echo "No matching mount scripts found in /app."
    fi
}

# Execute all mount scripts
execute_mount_scripts

# Start the Samba daemon in the foreground
echo "Starting Samba SMB/CIFS daemon: smbd..."
exec smbd &
tail -f /dev/null
