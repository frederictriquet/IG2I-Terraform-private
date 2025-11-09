# Build System Summary

## What was added

### 1. Continuous PDF Build Script (`build-continuous-pdf.sh`)
- **Uses Pandoc** instead of Marp for true continuous documents
- Strips Marp front matter completely
- Removes all slide separators (`---`)
- Generates a flowing document PDF with table of contents
- Better typography and page flow than Marp's single-slide approach

### 2. Updated npm Scripts (`package.json`)
```json
"build:pdf": "marp cours.md --pdf --allow-local-files -o cours-slides.pdf"
"build:continuous": "./build-continuous-pdf.sh"
"build:all": "npm run build && npm run build:pdf && npm run build:continuous"
```

### 3. Updated CI/CD (`.github/workflows/marp-to-pages.yml`)
- Installs Pandoc and LaTeX dependencies
- Builds 3 formats: HTML, slides PDF, and continuous PDF
- All outputs available on GitHub Pages
- Automatic deployment on push to master

### 4. Updated .gitignore
- Excludes generated PDFs from version control
- `cours-slides.pdf` and `cours-continuous.pdf` are build artifacts

### 5. Documentation (`BUILD.md`)
- Complete build instructions with pandoc installation
- Troubleshooting guide
- Usage examples

## Usage

```bash
# Development
npm run serve              # Live preview (slides)
npm run build:watch        # Auto-rebuild on changes

# Production
npm run build              # HTML only
npm run build:pdf          # Slides PDF only (Marp)
npm run build:continuous   # Continuous PDF only (Pandoc - requires pandoc)
npm run build:all          # All formats

# Manual scripts
./build.sh                 # HTML slides
./build-continuous-pdf.sh  # Continuous PDF (requires pandoc)
```

## Output Files

| File | Tool | Purpose | Pages |
|------|------|---------|-------|
| `cours.html` | Marp | Interactive slides with navigation | N/A |
| `cours-slides.pdf` | Marp | PDF with slide breaks | 1 slide = 1 page |
| `cours-continuous.pdf` | Pandoc | Continuous document PDF | Natural page breaks |

## Why Pandoc for Continuous PDF?

Marp is designed for presentations and treats content as slides. Even with `paginate: false`, it still generates a single-page PDF. 

Pandoc converts markdown to proper documents with:
- Natural page breaks
- Table of contents
- Better typography
- Flowing text across pages
- Document-style formatting

## How It Works

The continuous PDF is created by:
1. Reading `cours.md`
2. **Removing Marp front matter completely**
3. Removing all `---` slide separators
4. Converting to PDF with Pandoc using XeLaTeX
5. Adding table of contents and document formatting

## Prerequisites

- **For slides (HTML/PDF)**: Node.js + Marp CLI
- **For continuous PDF**: Pandoc + LaTeX (XeLaTeX)

See BUILD.md for installation instructions.
