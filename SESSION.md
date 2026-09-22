# Session Notes — LaTeX Document Project

Session date: 2026-09-22 · Project: Work Docs (Arabic/RTL LaTeX — المعلوماتية, أدرار)

---

## What was accomplished

### 1. Design system (blue / black / white)
- New shared layer under `source files/shared/`:
  - `common.tex` — unified preamble (packages, Amiri font, polyglossia RTL, page border, header/footer).
  - `design.tex` — palette (blue `#0D47A1` / black / white only), grid tables, badges, TikZ icons, boxes.
  - `lesson-macros.tex` — card / stage / task / spec / summary / domain / units macros.
  - `header.tex` (`\officialheader`), `footer.tex` («الصفحة س / ص» via `lastpage`).
- Rules: **tables use a full grid with vertical lines** (no booktabs), blue header rows (`\rowcolor{primary}` + white text), zebra striping, `\sectionbreak` (new page + blue banner) before each section, tables centered.
- Palette: `primary #0D47A1`, `secondary #1976D2`, `blue #42A5F5`, `darktext #111111`, `lightbg #E8F0FE`, `zebra #F2F6FC`, `rulegray #9E9E9E`. **No gold/other colours.**

### 2. Templates (`source files/templates/`)
- `lesson-note-template.tex`, `lesson-tp-template.tex`, `student-sheet-template.tex`, `lesson-summary-template.tex`, `lesson-presentation-template.tex` (beamer 16:9).

### 3. Lesson 01 — تقنية المعلومات (`source files/lessons/01 - تقنية المعلومات/`)
- `lesson-note.tex` (4 pp), `tp-note.tex` (3 pp), `student-sheet.tex` (5 pp), `lesson-summary.tex` (5 pp), `lesson-presentation.tex` (17 slides).

### 4. Official documents (`source files/documents/`)
- `didactic-contract.tex`, `diagnostic-assessment.tex`, `annual-distribution-{science,letters}.tex`, and new `annual-program-{science,letters}.tex`.

### 5. Production directory `2026-2027/`
- Marked as the **production directory** in `AGENTS.md` + `RULES.md`: compiled PDFs are copied here (Arabic names, sub-folder by category):
  - `Official Documents/` (final) · `Support Documents/` (staging) · `Lesson Documents/` · `Lab Documents/` · `Record Documents/`.
- Naming: `<اسم الوثيقة>[ - <الشعبة>].pdf` (no year; folder = bare document name).

---

## Hard-won fixes (this session)

- `fancyhdr` before `polyglossia` (bidi patch order).
- `\parbox[t]`/`minipage[t]` in `c` columns instead of `p{}` beside `X` — `p{}`+`X` misalign vertically by `\ht\strutbox`.
- `\raggedleft` (not `\raggedright`) for Arabic cells; label columns must be `\raggedleft`.
- `tcolorbox` body text colour via `coltext=` (inline `\color{white}` is dropped) → section banner titles are white.
- `\thead` uses `\textcolor{white}{...}` + requires `\rowcolor{primary}` in the header row.
- `@{}` at both ends of grid column specs + `\arrayrulewidth 0.4pt` → horizontal rules end flush with vertical borders.
- `tabularx` cannot be opened in one macro and closed in another.
- `\sectionbreak` = `\clearpage` + blue banner; `\nopagefooter`/`\pagestyle{empty}` for header-only docs.
- `\hypersetup{hidelinks}` removes the link box on the page number.

---

## Build

```bash
# from each document's directory (3 passes for \pageref{LastPage})
xelatex -interaction=nonstopmode -halt-on-error -output-directory=build FILE.tex   # ×3
grep -i "^!" build/FILE.log          # must be empty
grep -c "Missing character" build/FILE.log   # must be 0
```
