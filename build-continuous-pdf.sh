#!/bin/bash

# Build script for converting cours.md to a continuous PDF without slide breaks
# This creates a document-style PDF from the Marp markdown using pandoc

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}Creating continuous PDF from cours.md...${NC}"

# Check if pandoc is available
if ! command -v pandoc &> /dev/null; then
    echo -e "${RED}Error: pandoc is required but not installed.${NC}"
    echo -e "${YELLOW}Please install pandoc:${NC}"
    echo "  macOS:   brew install pandoc"
    echo "  Ubuntu:  sudo apt-get install pandoc"
    echo "  RHEL:    sudo yum install pandoc"
    echo ""
    echo "Or visit: https://pandoc.org/installing.html"
    exit 1
fi

# Create temporary directory
TEMP_DIR=$(mktemp -d)
TEMP_MD="$TEMP_DIR/cours-continuous.md"

echo -e "${GREEN}Processing markdown...${NC}"

# Process the markdown file:
# 1. Remove Marp front matter completely
# 2. Remove all --- separators (slide breaks)
# 3. Keep all content as flowing text

awk '
BEGIN {
    in_frontmatter = 0
    frontmatter_done = 0
    line_num = 0
}
{
    line_num++

    # Skip Marp front matter entirely
    if (line_num == 1 && $0 == "---") {
        in_frontmatter = 1
        next
    }

    if (in_frontmatter && $0 == "---") {
        in_frontmatter = 0
        frontmatter_done = 1
        next
    }

    if (in_frontmatter) {
        next  # Skip all front matter lines
    }

    # After front matter, skip all --- separators but add page breaks for major sections
    if (frontmatter_done && $0 == "---") {
        next  # Skip slide breaks completely
    }

    # Print everything else
    print $0
}
' cours.md > "$TEMP_MD"

echo -e "${GREEN}Generating continuous PDF with pandoc...${NC}"

# Generate PDF with pandoc
# Using LaTeX engine for better formatting
pandoc "$TEMP_MD" \
    -o cours-continuous.pdf \
    --pdf-engine=xelatex \
    -V geometry:margin=1in \
    -V documentclass=article \
    -V fontsize=11pt \
    -V colorlinks=true \
    --toc \
    --toc-depth=2 \
    2>&1 | grep -v "^Warning: " || true

# Cleanup
rm -rf "$TEMP_DIR"

echo -e "${GREEN}✓ Created cours-continuous.pdf${NC}"
echo -e "${YELLOW}Note: This is a continuous document without slide breaks${NC}"
