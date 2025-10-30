# Managing the lib Directory

## Overview
This document explains how to manage the `lib` directory structure in this Flutter project, including how to delete subfolders when needed.

## Current State
The `lib` directory currently contains only `main.dart` with no subfolders.

## Planned Structure (from STRUCTURE.md)
According to the project structure documentation, the `lib` directory should eventually contain:
- `core/` - Reusable configuration and global logic
- `data/` - Data models, services, and repositories
- `presentation/` - UI components (screens, widgets, components)
- `routes/` - Application routes and navigation

## How to Delete Subfolders

### Method 1: Using Git (Recommended for tracked files)
If the subfolders are tracked by git:

```bash
# Delete a specific subfolder
git rm -r lib/subfolder_name

# Commit the deletion
git commit -m "Remove subfolder_name from lib directory"
```

### Method 2: Using Bash Commands
To delete all subfolders in the lib directory while keeping main.dart:

```bash
# Navigate to project root
cd /path/to/mobile_app

# Delete all directories inside lib (keeping files)
find lib -mindepth 1 -maxdepth 1 -type d -exec rm -rf {} +
```

### Method 3: Using the Utility Script
We provide a utility script for safely cleaning the lib directory:

```bash
# From project root
bash scripts/clean_lib.sh
```

This script will:
1. Backup the lib directory
2. Remove all subfolders
3. Keep all .dart files at the root level
4. Prompt for confirmation before deletion

## Safety Considerations

⚠️ **Warning**: Deleting subfolders will remove all code within them. Always:
1. Commit your changes to git first
2. Create a backup if unsure
3. Review what will be deleted before confirming

## Restoring Deleted Subfolders

If you accidentally delete subfolders tracked by git:

```bash
# View git history
git log --oneline -- lib/

# Restore from a specific commit
git checkout <commit-hash> -- lib/subfolder_name

# Or undo the last commit
git reset --soft HEAD~1
```

## Best Practices

1. **Before Deletion**: Always ensure you have committed important changes
2. **After Deletion**: Run `flutter clean` and `flutter pub get` to refresh the project
3. **Testing**: Run tests to ensure no dependencies were broken
4. **Documentation**: Update STRUCTURE.md if permanently changing the directory layout
