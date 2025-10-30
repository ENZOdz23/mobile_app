# Quick Guide: How to Delete Subfolders in lib Directory

## Current State
✓ The `lib` directory is clean - contains only `main.dart` with no subfolders

## When You Need to Delete Subfolders

### Quick Method
Run the utility script from the project root:
```bash
bash scripts/clean_lib.sh
```

### Manual Method
```bash
# Delete a specific subfolder
git rm -r lib/subfolder_name

# Or delete all subfolders (keeping .dart files at root)
find lib -mindepth 1 -maxdepth 1 -type d -exec rm -rf {} +
```

## Full Documentation
See [docs/lib_management.md](docs/lib_management.md) for complete documentation including:
- Detailed instructions
- Safety considerations
- How to restore deleted folders
- Best practices

## Project Structure Reference
See [STRUCTURE.md](STRUCTURE.md) for the planned directory structure.
