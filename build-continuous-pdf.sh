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

# Convert SVG images to PNG if rsvg-convert is available
if command -v rsvg-convert &> /dev/null; then
    echo -e "${GREEN}Converting SVG images to PNG...${NC}"
    mkdir -p "$TEMP_DIR/images"
    for svg in images/*.svg; do
        if [ -f "$svg" ]; then
            png="${svg%.svg}.png"
            rsvg-convert "$svg" -o "$TEMP_DIR/$png" 2>/dev/null || cp "$svg" "$TEMP_DIR/$svg"
        fi
    done
else
    echo -e "${YELLOW}Warning: rsvg-convert not found, copying images as-is${NC}"
    if [ -d "images" ]; then
        cp -r images "$TEMP_DIR/"
    fi
fi

# Process the markdown file:
# 1. Remove Marp front matter completely
# 2. Remove all --- separators (slide breaks)
# 3. Replace .svg extensions with .png in image paths
# 4. Keep all content as flowing text

awk -v temp_dir="$TEMP_DIR" '
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

    # After front matter, skip all --- separators
    if (frontmatter_done && $0 == "---") {
        next  # Skip slide breaks completely
    }

    # Replace .svg with .png in image references if rsvg-convert was used
    if ($0 ~ /!\[.*\]\(.*\.svg\)/) {
        gsub(/\.svg/, ".png")
    }

    # Remove ./ prefix from image paths for pandoc
    if ($0 ~ /!\[.*\]\(\.\// ) {
        gsub(/\(\.\//, "(")
    }

    # Print everything else
    print $0
}
' cours.md > "$TEMP_MD"

echo -e "${GREEN}Generating continuous PDF with pandoc...${NC}"

# Change to temp directory so pandoc can find the images
cd "$TEMP_DIR"

# Create LaTeX header to support emojis
# Use font configuration with proper emoji support
cat > "header.tex" <<'EOF'
\usepackage{fontspec}
\usepackage{newunicodechar}

% Set main font
\setmainfont{Latin Modern Roman}

% Try to set up emoji font, suppress errors if not found
\makeatletter
\@ifpackageloaded{fontspec}{
  \IfFontExistsTF{Noto Color Emoji}{
    \newfontfamily\emojifont[Renderer=HarfBuzz]{Noto Color Emoji}
  }{
    \IfFontExistsTF{Apple Color Emoji}{
      \newfontfamily\emojifont{Apple Color Emoji}
    }{
      \IfFontExistsTF{Segoe UI Emoji}{
        \newfontfamily\emojifont{Segoe UI Emoji}
      }{
        % No emoji font available, define fallback that does nothing
        \newfontfamily\emojifont{Latin Modern Roman}
      }
    }
  }
}{}
\makeatother

% Map common emojis to use emoji font
\newunicodechar{💡}{{\emojifont 💡}}
\newunicodechar{✅}{{\emojifont ✅}}
\newunicodechar{❌}{{\emojifont ❌}}
\newunicodechar{⚠}{{\emojifont ⚠}}
\newunicodechar{🔧}{{\emojifont 🔧}}
\newunicodechar{📝}{{\emojifont 📝}}
\newunicodechar{🚀}{{\emojifont 🚀}}
\newunicodechar{⚡}{{\emojifont ⚡}}
\newunicodechar{🔒}{{\emojifont 🔒}}
\newunicodechar{🌐}{{\emojifont 🌐}}
EOF

# Generate PDF with pandoc
# Using LaTeX engine for better formatting and emoji support
pandoc "cours-continuous.md" \
    -o "cours-continuous.pdf" \
    --pdf-engine=xelatex \
    -H "header.tex" \
    -V geometry:margin=1in \
    -V documentclass=article \
    -V fontsize=11pt \
    -V colorlinks=true \
    --toc \
    --toc-depth=2 \
    2>&1 | grep -v "^Warning: " || true

# Move the PDF back to the original directory
mv "cours-continuous.pdf" "$OLDPWD/"
cd "$OLDPWD"

# Cleanup
rm -rf "$TEMP_DIR"

echo -e "${GREEN}✓ Created cours-continuous.pdf${NC}"
echo -e "${YELLOW}Note: This is a continuous document without slide breaks${NC}"
