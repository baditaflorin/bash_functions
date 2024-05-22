#!/bin/bash

# Function to list the 10 largest files in a specified directory or the current directory if none is specified
function largest_files {
    # Check if a directory was specified as an argument
    local dir=${1:-.}
    
    # Find all files in the specified directory, print their size and path, sort by size, and display the top 10
    find "$dir" -type f -exec du -h {} + | sort -rh | head -n 10
}

# Call the function with the provided argument, if any
#largest_files "$1"
