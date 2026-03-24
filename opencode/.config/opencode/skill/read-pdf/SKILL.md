---
name: read-pdf
description: Extracts text from PDF files using pdftotext (Poppler). Falls back to OCR via ocrmypdf + tesseract for scanned PDFs. Load when reading, extracting, or searching content from PDF files.
---

# Skill: read-pdf

## FIRST: Verify Installation

```bash
command -v pdftotext
```

If missing, install before proceeding (or ask user to install it permissions are not sufficient).

### Install pdftotext (Poppler)

| Platform      | Command                     |
| ------------- | --------------------------- |
| Arch          | `pacman -S poppler`         |
| macOS         | `brew install poppler`      |
| Ubuntu/Debian | `apt install poppler-utils` |
| Fedora/RHEL   | `dnf install poppler-utils` |

## Extract Text

| Task                              | Command                                   |
| --------------------------------- | ----------------------------------------- |
| Print to stdout                   | `pdftotext "file.pdf" -`                  |
| Preserve layout (tables, columns) | `pdftotext -layout "file.pdf" -`          |
| Save to file                      | `pdftotext -layout "file.pdf" output.txt` |
| Specific page range               | `pdftotext -f 2 -l 4 "file.pdf" -`        |
| First N pages only                | `pdftotext -l 3 "file.pdf" -`             |

Always use `-layout` by default — it preserves table structure and column alignment.

## Scanned PDFs (OCR)

If `pdftotext` output is empty or garbled, the PDF is a scan and requires OCR.

### Install OCR tools

| Platform      | Command                                                |
| ------------- | ------------------------------------------------------ |
| Arch          | `pacman -S ocrmypdf tesseract`                         |
| macOS         | `brew install ocrmypdf tesseract`                      |
| Ubuntu/Debian | `apt install ocrmypdf tesseract-ocr tesseract-ocr-eng` |
| Fedora/RHEL   | `dnf install ocrmypdf tesseract`                       |

> On Debian/Ubuntu, `tesseract-ocr` may ship without language data — install `tesseract-ocr-eng` (or the relevant language pack) explicitly.

### OCR workflow

```bash
# Step 1 — add text layer to the scanned PDF
ocrmypdf "scanned.pdf" "searchable.pdf"

# Step 2 — extract text as usual
pdftotext -layout "searchable.pdf" -
```

For non-English PDFs, specify the language:

```bash
ocrmypdf -l fra "scanned.pdf" "searchable.pdf"   # French
ocrmypdf -l deu "scanned.pdf" "searchable.pdf"   # German
```

## Detecting Scanned vs Text PDFs

Run `pdftotext` first. If the output is blank or contains only whitespace/garbled characters, it's a scan — proceed with the OCR workflow above.
