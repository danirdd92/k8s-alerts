#!/bin/bash

INPUT_FILE=$1

# Temporary variables
current_file=""

# Read the file line by line
while IFS= read -r line; do
    # Check if the line contains a file name followed by ": |"
    if [[ $line =~ ^(.+)\.yaml:\ \|$ ]]; then
        # Close the current file if it was open
        if [[ -n $current_file ]]; then
            exec 3>&-
        fi

        # Extract the filename and open it for writing
        current_file="${BASH_REMATCH[1]}.yaml"
        echo "Creating file: $current_file"
        exec 3>"$current_file"
    else
        # Write the line to the current file (if a file is open)
        if [[ -n $current_file ]]; then
            echo "$line" >&3
        fi
    fi
done < "$INPUT_FILE"

# Close the last file
if [[ -n $current_file ]]; then
    exec 3>&-
fi

echo "All files created successfully."
