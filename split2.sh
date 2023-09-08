#!/bin/bash

# Check the number of parameters
if [ "$#" -ne 2 ]; then
    exit 1
fi

# Extract parameters
source_file="$1"
lines_per_file="$2"

# Check if the source file exists
if [ ! -f "$source_file" ]; then
    echo "Source file '$source_file' does not exist."
    exit 1
fi

# Get the base name of the source file (without extension)
base_name=$(basename "$source_file" | cut -d. -f1)

# Create the directory for split files
output_dir="${base_name}_split"
if [ ! -d "$output_dir" ]; then
    mkdir "$output_dir"
else
    rm -r "$output_dir"/*
fi

# Count the total number of lines in the source file
total_lines=$(wc -l < "$source_file")

# Check if total lines is greater than lines_per_file
if [ "$total_lines" -le "$lines_per_file" ]; then
    echo "Number of lines in source file is not greater than lines per file."
    exit 1
fi

# Split the source file into multiple files with custom names
split -l "$lines_per_file" "$source_file" "$output_dir/${base_name}_%d.txt"

# Rename the split files to the desired format
count=1
for file in "$output_dir"/*; do
    new_name="${base_name}_${count}.txt"
    mv "$file" "$output_dir/$new_name"
    ((count++))
done

echo "File split completed. Split files are located in '$output_dir' directory."
