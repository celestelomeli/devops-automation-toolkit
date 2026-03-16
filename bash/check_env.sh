#!/usr/bin/env bash

set -euo pipefail

# ${1:-} means "use $1 if provided, otherwise default to empty string" 
if [ "${1:-}" = "--help" ]; then
    echo "Usage: check_env.sh [--help]"
    echo "Checks if required DevOps tools are installed."
    exit 0
fi

echo "=== Environment Validation ==="

missing=0

# Function to check if a tool is installed 
check_tool() {
    local tool="$1"        # local variable to hold tool name
    if command -v "$tool" > /dev/null 2>&1; then
        echo "$tool found: $("$tool" --version 2>&1 | head -n 1)"
    else
        echo "$tool not found. Please install $tool."
        missing=1
    fi
}

# For loop to loop through the list 
for item in git docker terraform python3 aws; do
    check_tool "$item"
done

# If statement to check if any tools are missing 
if [ "$missing" -eq 1 ]; then
    echo ""
    echo "Some tools are missing. Please install them before continuing."
    exit 1
fi

echo ""
echo "All tools found."
