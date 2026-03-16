#!/usr/bin/env bash

set -euo pipefail

echo "=== Environment Validation ==="

missing=0

for item in git docker terraform python3 aws; do
    if command -v "$item" > /dev/null 2>&1; then                  # throw away output 
        echo "$item found: $("$item" --version 2>&1 | head -n 1)"  # trim to one line
    else
        echo "$item not found. Please install $item."
        missing=1
    fi
done

if [ "$missing" -eq 1 ]; then
    echo ""
    echo "Some tools are missing. Please install them before continuing."
    exit 1
fi

echo ""
echo "All tools found."
