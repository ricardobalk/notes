#!/bin/bash
# Script to update the root README.md with content from subdirectory README.md files.

ROOT_README="README.md"
REPO_ROOT=$(git rev-parse --show-toplevel)  # Ensure the script always runs from the root of the repo

# Check if the dot-README.md template exists before overwriting
DOT_README="$REPO_ROOT/.$ROOT_README"
if [[ ! -f "$DOT_README" ]]; then
    echo "Error: $DOT_README not found. Aborting script."
    exit 1
fi

# Overwrite the root README.md based on the template
cp "$DOT_README" "$REPO_ROOT/$ROOT_README"

# Find all README.md files in subdirectories and append them to the root README
find "$REPO_ROOT" -type f -path "*/README.md" ! -path "$REPO_ROOT/README.md" -print0 | while IFS= read -r -d '' file; do
    relative_path=$(realpath --relative-to="$REPO_ROOT" "$(dirname "$file")")  # Get relative path
    depth=$(awk -F'/' '{print NF}' <<< "$relative_path") # Calculate depth based on number of slashes
    hash_marks=$(printf '#%.0s' $(seq 1 ${depth})) # Generate appropriate header level

    # Append section to the root README
    {
        echo -e "\n$hash_marks [$relative_path](./$relative_path)"
        cat "$file"
        echo -e "\n"
    } >> "$REPO_ROOT/$ROOT_README"
done

# Remove trailing empty lines from the root README (POSIX-compliant)
awk 'NF{p=1} p' "$REPO_ROOT/$ROOT_README" > "$REPO_ROOT/$ROOT_README.tmp" && mv "$REPO_ROOT/$ROOT_README.tmp" "$REPO_ROOT/$ROOT_README"

echo "README updated with content from subdirectories."