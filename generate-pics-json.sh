#!/bin/bash

# Check if input directory is provided
if [ "$#" -lt 1 ]; then
    echo "Usage: $0 <input_directory> [output_file]"
    echo "Example: $0 ./still ./pics.json"
    exit 1
fi

# Set input directory from first argument
STILL_DIR="$1"

# Set output file from second argument or use default
OUTPUT_FILE="${2:-pics.json}"

# Check if input directory exists
if [ ! -d "$STILL_DIR" ]; then
    echo "Error: Input directory '$STILL_DIR' not found!"
    exit 1
fi

# Create output directory if it doesn't exist
OUTPUT_DIR=$(dirname "$OUTPUT_FILE")
if [ ! -d "$OUTPUT_DIR" ] && [ "$OUTPUT_DIR" != "." ]; then
    mkdir -p "$OUTPUT_DIR"
fi

# Generate JSON file
echo "{" > "$OUTPUT_FILE"
echo "    \"pics\": [" >> "$OUTPUT_FILE"

first=true
find "$STILL_DIR" -type f -name "*" | sort | while read -r file; do
    filename=$(basename "$file")
    
    if [ "$first" = true ]; then
        first=false
    else
        echo "," >> "$OUTPUT_FILE"
    fi
    
    echo -n "        \"$filename\"" >> "$OUTPUT_FILE"
done

echo "" >> "$OUTPUT_FILE"
echo "    ]" >> "$OUTPUT_FILE"
echo "}" >> "$OUTPUT_FILE"

echo "JSON file generated successfully at '$OUTPUT_FILE'" 