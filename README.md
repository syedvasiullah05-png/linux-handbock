#!/bin/bash

# Path to your README.md
README="README.md"

# Clear old links if any
echo "# linux-handbook" > $README
echo "" >> $README
echo "## Files" >> $README
echo "" >> $README

# Loop through level files and create markdown links
for file in level* linuxbasic; do
    if [ -f "$file" ]; then
        echo "- [$file]($file)" >> $README
    fi
done

echo "README.md updated with links!"
