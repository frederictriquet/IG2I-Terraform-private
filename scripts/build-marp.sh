#!/bin/bash

# Build script for converting cours.md to HTML using Marp
# Usage: ./build.sh [options]
#   --watch    Watch for changes and rebuild automatically
#   --serve    Start a local server with live reload
#   --preview  Open in browser with live reload
#   --dir      Build into build/ directory (like CI workflow)

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if npx is available
if ! command -v npx &> /dev/null; then
    echo -e "${YELLOW}npx not found. Please install Node.js and npm first.${NC}"
    echo "Visit: https://nodejs.org/"
    exit 1
fi

# Parse command line arguments
WATCH=false
SERVE=false
PREVIEW=false
BUILD_DIR=false

for arg in "$@"; do
    case $arg in
        --watch)
            WATCH=true
            ;;
        --serve)
            SERVE=true
            ;;
        --preview)
            PREVIEW=true
            ;;
        --dir)
            BUILD_DIR=true
            ;;
        --help|-h)
            echo "Usage: ./scripts/build-marp.sh [options]"
            echo ""
            echo "Options:"
            echo "  --watch    Watch for changes and rebuild automatically"
            echo "  --serve    Start a local server with live reload"
            echo "  --preview  Open in browser with live reload"
            echo "  --dir      Build into build/ directory (like CI workflow)"
            echo "  --help     Show this help message"
            exit 0
            ;;
        *)
            echo -e "${YELLOW}Unknown option: $arg${NC}"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

# Install marp-cli if not already installed
if ! npx @marp-team/marp-cli --version &> /dev/null; then
    echo -e "${YELLOW}Installing @marp-team/marp-cli...${NC}"
    npm install
fi

echo -e "${GREEN}Building Marp presentation from cours.md...${NC}"

# Execute based on flags
if [ "$SERVE" = true ]; then
    echo -e "${GREEN}Starting local server with live reload...${NC}"
    npx @marp-team/marp-cli cours.md -s
elif [ "$PREVIEW" = true ]; then
    echo -e "${GREEN}Opening preview in browser...${NC}"
    npx @marp-team/marp-cli cours.md -o cours.html --preview
elif [ "$WATCH" = true ]; then
    echo -e "${GREEN}Watching for changes...${NC}"
    npx @marp-team/marp-cli cours.md -o cours.html --watch
elif [ "$BUILD_DIR" = true ]; then
    echo -e "${GREEN}Building to build/ directory (CI-like)...${NC}"
    mkdir -p build
    npx @marp-team/marp-cli cours.md -o build/index.html
    touch build/.nojekyll
    echo -e "${GREEN}✓ Built to build/index.html${NC}"
else
    npx @marp-team/marp-cli cours.md -o cours.html
    echo -e "${GREEN}✓ Built cours.html${NC}"
fi
