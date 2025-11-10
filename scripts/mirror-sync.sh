#!/bin/bash
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
MIRROR_REPO_URL="${MIRROR_REPO_URL:-}"
MIRROR_BRANCH="${MIRROR_BRANCH:-master}"
SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WORK_DIR="/tmp/terraform-mirror-$$"
MIRROR_DIR="${WORK_DIR}/mirror"

# Functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

cleanup() {
    log_info "Cleaning up temporary directory..."
    rm -rf "${WORK_DIR}"
}

# Trap cleanup on exit
trap cleanup EXIT

# Validate environment
if [ -z "${MIRROR_REPO_URL}" ]; then
    log_error "MIRROR_REPO_URL environment variable is not set"
    echo "Usage: MIRROR_REPO_URL=<url> $0"
    echo "Example: MIRROR_REPO_URL=git@github.com:user/repo-student.git $0"
    exit 1
fi

log_info "Starting mirror synchronization..."
log_info "Source: ${SOURCE_DIR}"
log_info "Mirror: ${MIRROR_REPO_URL}"
log_info "Branch: ${MIRROR_BRANCH}"

# Create work directory
mkdir -p "${WORK_DIR}"

# Clone mirror repository
log_info "Cloning mirror repository..."
if ! git clone --depth 1 --branch "${MIRROR_BRANCH}" "${MIRROR_REPO_URL}" "${MIRROR_DIR}" 2>/dev/null; then
    log_warning "Branch ${MIRROR_BRANCH} doesn't exist, cloning default branch..."
    git clone --depth 1 "${MIRROR_REPO_URL}" "${MIRROR_DIR}"
fi

# Build rsync exclude patterns from .gitignore and .mirrorignore
log_info "Building exclude patterns..."
EXCLUDE_FILE="${WORK_DIR}/exclude-patterns.txt"

# Start with common excludes
cat > "${EXCLUDE_FILE}" << 'EOF'
.git/
EOF

# Add patterns from .gitignore
if [ -f "${SOURCE_DIR}/.gitignore" ]; then
    log_info "Reading patterns from .gitignore..."
    # Convert .gitignore patterns to rsync format
    grep -v '^#' "${SOURCE_DIR}/.gitignore" | grep -v '^$' | while read -r pattern; do
        # Remove leading slash
        pattern="${pattern#/}"
        echo "${pattern}"
    done >> "${EXCLUDE_FILE}"
fi

# Add patterns from .mirrorignore
if [ -f "${SOURCE_DIR}/.mirrorignore" ]; then
    log_info "Reading patterns from .mirrorignore..."
    # Convert .mirrorignore patterns to rsync format
    grep -v '^#' "${SOURCE_DIR}/.mirrorignore" | grep -v '^$' | while read -r pattern; do
        # Remove leading slash
        pattern="${pattern#/}"
        echo "${pattern}"
    done >> "${EXCLUDE_FILE}"
fi

log_info "Exclude patterns:"
cat "${EXCLUDE_FILE}"

# Sync files using rsync
log_info "Synchronizing files..."
rsync -av --delete \
    --exclude-from="${EXCLUDE_FILE}" \
    "${SOURCE_DIR}/" \
    "${MIRROR_DIR}/"

# Check if there are changes
cd "${MIRROR_DIR}"
if [ -z "$(git status --porcelain)" ]; then
    log_info "No changes to sync"
    exit 0
fi

# Configure git
git config user.name "Mirror Bot"
git config user.email "mirror-bot@noreply.github.com"

# Commit and push changes
log_info "Committing changes..."
git add -A

# Get the source commit hash
SOURCE_COMMIT=$(cd "${SOURCE_DIR}" && git rev-parse HEAD)
SOURCE_COMMIT_SHORT=$(cd "${SOURCE_DIR}" && git rev-parse --short HEAD)

git commit -m "Mirror sync from ${SOURCE_COMMIT_SHORT}

Synchronized from source repository at commit ${SOURCE_COMMIT}
Excluded: solution directories, build artifacts, and sensitive files

This is an automated mirror sync - do not commit directly to this repository."

log_info "Pushing changes to mirror repository..."
git push origin "${MIRROR_BRANCH}"

log_success "Mirror synchronization completed successfully!"
log_info "Mirror repository is up to date with source (excluding solutions)"
