#!/usr/bin/env bash
set -euo pipefail

# Check for changes in the specified directory
if git diff --name-only "$BITBUCKET_COMMIT_RANGE" | grep -q "^script/ocgo/"; then
    echo "Changes detected in script/ocgo/, proceeding with build..."
    # Build the package
    cd script/ocgo || exit
    go build -o ocgo main.go
else
    echo "No changes in script/ocgo/, skipping build step."
fi
