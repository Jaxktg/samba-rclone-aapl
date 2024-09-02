#!/bin/bash
set -e  # Exit immediately if a command exits with a non-zero status

# Function to execute mount scripts
chmod +x /mount_script/mount-*.sh
execute_mount_scripts() {
    local scripts_found=false
    for script in /mount_script/mount-*.sh; do
        if [ -f "$script" ]; then
            scripts_found=true
            echo "Executing $script..."
            bash "$script" &
        fi
    done

    if [ "$scripts_found" = false ]; then
        echo "No matching mount scripts found in /mount_script."
    fi
}

# Execute all mount scripts
execute_mount_scripts

#Add smbuser
execute_add_smbuser() {
    source /app/user.conf

    groupadd -f $group

    # Count the number of usernames in the config file
    t=$(grep -c "username" /app/user.conf)

    for i in $(seq 1 $t); do
        # Construct the variable names for the username and password
        s_usr_var="username$i"
        s_pwd_var="password$i"

        # Retrieve the values of the username and password
        s_usr=${!s_usr_var}
        s_pwd=${!s_pwd_var}

        # Add the user with no login shell and the specified group
        useradd -m -s /sbin/nologin -g "$group" "$s_usr"

        # Set the user's password
        echo "$s_usr:$s_pwd" | chpasswd

        # Add the user to the Samba database and enable the user
        (echo "$s_pwd"; echo "$s_pwd") | smbpasswd -s -a "$s_usr"
        smbpasswd -e "$s_usr"
    done
}

execute_add_smbuser

# Start the Samba daemon in the foreground
echo "Starting Samba SMB/CIFS daemon: smbd..."
exec smbd -F --debuglevel=3 --debug-stdout &
tail -f /dev/null
