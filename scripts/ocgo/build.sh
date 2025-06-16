#!/usr/bin/env bash
set -euo pipefail

# Check for changes in the specified directory
if git diff --name-only "$BITBUCKET_COMMIT_RANGE" | grep -q "^scripts/ocgo/"; then
    echo "Changes detected in scripts/ocgo/, proceeding with build..."
    # Build the package
    cd scripts/ocgo || exit
    go build -o ocgo main.go
else
    echo "No changes in scripts/ocgo/, skipping build step."
fi
