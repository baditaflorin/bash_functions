#!/bin/bash

# Function to check if a command exists
command_exists() {
    type "$1" &> /dev/null 
}

# Function to check the PID holding the lock
check_lock_pid() {
    local lockfile="/var/lib/dpkg/lock-frontend"

    # Check if the lock file exists
    if [ -f "$lockfile" ]; then
        if command_exists fuser; then
            # Use fuser to get the PID holding the lock
            local lock_pid=$(sudo fuser "$lockfile" 2>/dev/null)

            if [ -n "$lock_pid" ]; then
                echo "The PID holding the lock on $lockfile is: $lock_pid"
                check_lock_output "$lock_pid"
            else
                echo "No process is currently holding the lock on $lockfile."
            fi
        else
            echo "fuser command not found. Please install it to use this script."
        fi
    else
        echo "The lock file $lockfile does not exist."
    fi
}

# Function to check the terminal output of a given PID
check_lock_output() {
    local pid="$1"

    if command_exists strace; then
        echo "Checking terminal output for PID $pid:"
        sudo strace -e write -p "$pid"
    else
        echo "strace command not found. Please install it to use this function."
    fi
}

# Check if the script is being sourced or run as a standalone script
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    # If run as a script, call the check_lock_pid function
    check_lock_pid
else
    # If sourced into a shell session, provide a usage message
    echo "To use this as a function, run 'check_lock_pid' in your shell."
fi
