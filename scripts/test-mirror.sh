#!/bin/bash
set -e

# Test script for mirror synchronization
# This script performs a dry-run to show what would be synchronized

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEST_OUTPUT="/tmp/mirror-test-$$"

echo -e "${BLUE}=== Mirror Sync Test (Dry Run) ===${NC}"
echo ""
echo "Source directory: ${SOURCE_DIR}"
echo "Test output directory: ${TEST_OUTPUT}"
echo ""

# Build exclude patterns
EXCLUDE_FILE="/tmp/mirror-exclude-$$"

cat > "${EXCLUDE_FILE}" << 'EOF'
.git/
EOF

# Add patterns from .gitignore
if [ -f "${SOURCE_DIR}/.gitignore" ]; then
    grep -v '^#' "${SOURCE_DIR}/.gitignore" | grep -v '^$' | while read -r pattern; do
        pattern="${pattern#/}"
        echo "${pattern}"
    done >> "${EXCLUDE_FILE}"
fi

# Add patterns from .mirrorignore
if [ -f "${SOURCE_DIR}/.mirrorignore" ]; then
    grep -v '^#' "${SOURCE_DIR}/.mirrorignore" | grep -v '^$' | while read -r pattern; do
        pattern="${pattern#/}"
        echo "${pattern}"
    done >> "${EXCLUDE_FILE}"
fi

echo -e "${YELLOW}Exclusion patterns:${NC}"
cat "${EXCLUDE_FILE}"
echo ""

# Dry run with rsync
echo -e "${YELLOW}Files that would be synchronized:${NC}"
rsync -avn --delete \
    --exclude-from="${EXCLUDE_FILE}" \
    "${SOURCE_DIR}/" \
    "${TEST_OUTPUT}/" | grep -E "^(sending|deleting|[^/]+$)" | head -50

echo ""
echo -e "${GREEN}✓ Test completed${NC}"
echo ""
echo -e "${BLUE}Summary:${NC}"
echo "- Solutions in exercise-*/solution/ should NOT appear above"
echo "- Build artifacts (build/, node_modules/, cours.html) should NOT appear"
echo "- mirror.md and .mirrorignore should NOT appear"
echo "- All other course files should appear"
echo ""
echo -e "${YELLOW}To perform actual sync:${NC}"
echo "MIRROR_REPO_URL=git@github.com:org/repo.git ./scripts/mirror-sync.sh"

# Cleanup
rm -f "${EXCLUDE_FILE}"
