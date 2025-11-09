# Build Instructions

This repository uses [Marp](https://marp.app/) to convert `cours.md` into presentations and PDFs.

## Prerequisites

- Node.js (v18 or later)
- npm

## Quick Start

```bash
# Install dependencies
npm install

# Build HTML presentation
npm run build

# Build slide-based PDF
npm run build:pdf

# Build everything
npm run build:all
```

## Available Build Scripts

### Development

- `npm run serve` - Start local server with live reload
- `npm run preview` - Open preview in browser
- `npm run build:watch` - Watch for changes and rebuild HTML

### Production

- `npm run build` - Build HTML presentation (`cours.html`)
- `npm run build:pdf` - Build slides PDF (`cours-slides.pdf`)
- `npm run build:all` - Build all formats (HTML + PDF)
- `npm run build:dir` - Build for GitHub Pages deployment

## Output Files

| File | Description |
|------|-------------|
| `cours.html` | Interactive HTML presentation with slide navigation |
| `cours-slides.pdf` | PDF with slide breaks (one slide per page) |

## CI/CD

The GitHub Actions workflow automatically builds HTML and PDF on push to `master` and deploys to GitHub Pages.

See `.github/workflows/marp-to-pages.yml` for details.

## Troubleshooting

### Images not showing in PDF

Add `--allow-local-files` flag:
```bash
npx @marp-team/marp-cli cours.md --pdf --allow-local-files -o output.pdf
```

### SVG images not rendering

Ensure SVG files are:
- Valid SVG format
- Using relative paths
- Located in the repository

### Build fails in CI

Check that:
- All image paths are correct
- No absolute file paths are used
- `images/` directory is committed to git
