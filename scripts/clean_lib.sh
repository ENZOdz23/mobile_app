#!/bin/bash

# clean_lib.sh
# Utility script to safely delete subfolders from the lib directory
# while preserving .dart files at the root level

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Get the project root directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
LIB_DIR="$PROJECT_ROOT/lib"

echo -e "${GREEN}=== Flutter lib Directory Cleaner ===${NC}"
echo ""

# Check if lib directory exists
if [ ! -d "$LIB_DIR" ]; then
    echo -e "${RED}Error: lib directory not found at $LIB_DIR${NC}"
    exit 1
fi

# Find all subdirectories in lib
SUBDIRS=$(find "$LIB_DIR" -mindepth 1 -maxdepth 1 -type d)

if [ -z "$SUBDIRS" ]; then
    echo -e "${YELLOW}No subfolders found in lib directory.${NC}"
    echo "Current state: lib directory is already clean."
    exit 0
fi

echo "Found the following subfolders in lib directory:"
echo "$SUBDIRS" | sed 's|.*/||'
echo ""

# Show what will be deleted
echo -e "${YELLOW}The following directories will be DELETED:${NC}"
echo "$SUBDIRS" | while read -r dir; do
    echo "  - $(basename "$dir")"
    # Count files in each directory
    file_count=$(find "$dir" -type f | wc -l)
    echo "    (contains $file_count files)"
done
echo ""

# Confirm deletion
read -p "Do you want to proceed with deletion? (yes/no): " confirm
if [ "$confirm" != "yes" ]; then
    echo -e "${RED}Deletion cancelled.${NC}"
    exit 0
fi

# Create backup option
read -p "Create a backup before deletion? (yes/no): " backup
if [ "$backup" = "yes" ]; then
    BACKUP_DIR="$PROJECT_ROOT/lib_backup_$(date +%Y%m%d_%H%M%S)"
    echo "Creating backup at $BACKUP_DIR..."
    cp -r "$LIB_DIR" "$BACKUP_DIR"
    echo -e "${GREEN}Backup created successfully.${NC}"
fi

# Delete subdirectories
echo ""
echo "Deleting subdirectories..."
echo "$SUBDIRS" | while read -r dir; do
    echo "  Deleting $(basename "$dir")..."
    rm -rf "$dir"
done

echo ""
echo -e "${GREEN}=== Cleanup Complete ===${NC}"
echo "All subfolders have been removed from lib directory."
echo ""
echo "Remaining files in lib:"
ls -la "$LIB_DIR"

echo ""
echo -e "${YELLOW}Recommended next steps:${NC}"
echo "1. Run: flutter clean"
echo "2. Run: flutter pub get"
echo "3. Test your application to ensure nothing is broken"
echo "4. Commit changes: git add lib && git commit -m 'Clean lib directory'"
