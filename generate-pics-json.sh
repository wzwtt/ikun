#!/bin/bash

OUTPUT_FILE="pics.json"
STILL_DIR="./still"

if [ ! -d "$STILL_DIR" ]; then
    echo "Error: $STILL_DIR directory not found!"
    exit 1
fi

echo "{" > "$OUTPUT_FILE"
echo "    \"pics\": [" >> "$OUTPUT_FILE"

first=true
find "$STILL_DIR" -type f -name "*" | while read -r file; do
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

echo "JSON file generated successfully at $OUTPUT_FILE" 