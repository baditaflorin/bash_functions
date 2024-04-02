#!/bin/bash

input_file="saved.csv"

# Create directories to save files
mkdir -p 17 18

# Process the input file
while IFS= read -r line; do
    count=$(awk -F '^' '{print NF-1}' <<< "$line")
    
    # Determine the directory to save the file
    if [[ $count -eq 17 ]]; then
        directory="17"
    elif [[ $count -eq 18 ]]; then
        directory="18"
    else
        continue
    fi
    
    # Save the line to the appropriate file
    echo "$line" >> "$directory/$input_file"
done < "$input_file"
