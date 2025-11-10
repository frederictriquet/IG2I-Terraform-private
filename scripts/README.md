# Scripts Directory

This directory contains automation scripts for the repository.

## Available Scripts

### test-mirror.sh

Tests the mirror synchronization in dry-run mode without actually syncing.

**Purpose**: Preview what files will be synchronized and what will be excluded.

**Usage**:
```bash
./scripts/test-mirror.sh
```

**What it does**:
1. Builds exclusion patterns from `.gitignore` and `.mirrorignore`
2. Runs `rsync` in dry-run mode (`-n` flag)
3. Shows what files would be synchronized
4. Verifies that solutions and build artifacts are excluded

**When to use**:
- Before pushing changes that might affect mirroring
- To verify `.mirrorignore` patterns are working correctly
- To debug mirroring issues

---

### mirror-sync.sh

Synchronizes this repository to a mirror repository while excluding exercise solutions.

**Purpose**: Create a student-facing version of the repository without solutions.

**Usage**:
```bash
MIRROR_REPO_URL="git@github.com:org/repo-students.git" \
MIRROR_BRANCH="master" \
./scripts/mirror-sync.sh
```

**Environment Variables**:
- `MIRROR_REPO_URL` (required): SSH URL of the mirror repository
- `MIRROR_BRANCH` (optional): Target branch in mirror repo (default: master)

**What it does**:
1. Clones the mirror repository
2. Reads exclusion patterns from `.gitignore` and `.mirrorignore`
3. Syncs files using `rsync` with exclusions applied
4. Commits and pushes changes to the mirror

**Automated Execution**:
This script is automatically run by GitHub Actions on every push to `master`.
See `.github/workflows/mirror-sync.yml` for the workflow configuration.

**Complete Documentation**:
See [MIRROR.md](../MIRROR.md) for full setup and configuration instructions.

## Local Testing

Before pushing changes, you can test the mirroring locally:

```bash
# Set environment variables
export MIRROR_REPO_URL="git@github.com:YOUR_ORG/terraform-training-students.git"
export MIRROR_BRANCH="master"

# Run the script
./scripts/mirror-sync.sh
```

This will show you exactly what files will be synchronized and what will be excluded.
