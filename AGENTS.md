# AGENTS.md — LaTeX Document Project Rules

This file tells any AI agent (or human) how to add, edit, and build the LaTeX
documents in this repository. **Follow these rules exactly** — they encode hard-won
fixes for Arabic/RTL LaTeX.

---

## 1. Project Identity

**Source of truth is [`README.md`](./README.md).** Always read it before writing a
document; never hardcode identity data that may be stale.

| Field       | Value                                                |
| ----------- | ---------------------------------------------------- |
| Country     | الجمهورية الجزائرية الديمقراطية الشعبية              |
| Ministry    | وزارة التربية الوطنية                                |
| Direction   | مديرية التربية لولاية أدرار                          |
| School      | ثانوية الشهيد حكومي العيد أدرار — أدرار              |
| Teacher     | لفقير عبدالجليل                                      |
| Rank        | أستاذ التعليم الثانوي                                |
| Subject     | المعلوماتية                                          |
| Classes     | السنة الأولى جذع مشترك علوم وتكنولوجيا / آداب وفلسفة |
| School year | 2026 – 2027                                          |

---

## 2. Repository Layout

```
.
├── README.md                          # Identity data + document index (source of truth)
├── AGENTS.md                          # This file
├── RULES.md                           # Short rule summary
├── main.tex                           # Entry / identity document
├── source files/                      # ⭐ all .tex sources live here
│   ├── shared/                        # ⭐ SINGLE SOURCE OF TRUTH — the shared layer
│   │   ├── identity.tex               #   language + Amiri fonts + color palette
│   │   ├── core.tex                   #   article core (packages + identity + header/footer + design + macros)
│   │   ├── common.tex                 #   default article doc = geometry + page border + core
│   │   ├── presentation.tex           #   beamer core (packages + identity + header + theme)
│   │   ├── header.tex                 #   \officialheader
│   │   ├── footer.tex                 #   article footer (page x/y)
│   │   ├── design.tex                 #   design layer (boxes, icons, \pageborder, section dividers)
│   │   └── lesson-macros.tex          #   document macros (cards, stage tables, \thd, …)
│   ├── documents/                     # admin documents — one .tex per document
│   ├── lessons/<اسم الدرس>/           # lesson docs (note / TP / sheet / summary / presentation)
│   └── templates/                     # copy-me skeletons for new lessons
├── build/                             # scratch artifacts only — never commit
├── resources/                         # source assets
└── 2026-2027/                         # ⭐ PRODUCTION — generated PDFs land here, Arabic names
    ├── Official Documents/            # Final, submittable PDFs (Arabic folders + Arabic names)
    │   ├── التدرج السنوي/             # Externally-sourced progression (no source .tex)
    │   ├── القانون التوجيهي/          # Externally-sourced
    │   ├── الكتاب المدرسي/            # Externally-sourced
    │   └── منهاج المادة/              # Externally-sourced
    ├── Support Documents/             # Working/staging PDFs (regenerated from our .tex)
    │   ├── البرنامج السنوي/           # Annual program — one PDF per stream
    │   ├── التوزيع السنوي/            # Annual distribution — one PDF per stream
    │   ├── العقد الديداكتيكي/         # Didactic contract
    │   └── التقويم التشخيصي/          # Diagnostic assessment
    ├── Lesson Documents/              # Lesson PDFs (note / TP / sheet / summary / presentation)
    ├── Lab Documents/                 # Lab/practical PDFs
    └── Record Documents/              # Record / registry PDFs
```

**Rules:**

1. `2026-2027/` is the **production directory**. Every compiled PDF is copied
   **here** (never committed to the repo root) under the sub-folder that matches
   its category, with an **Arabic filename** (see §4.1).
2. `build/` holds **working artifacts only** — never commit those.
3. Each sub-folder (`Official Documents/`, `Support Documents/`, `Lesson Documents/`,
   `Lab Documents/`, `Record Documents/`) holds the finished PDFs for its category.

---

## 3. Toolchain — Non-Negotiable

| Requirement  | Value                                                                          |
| ------------ | ------------------------------------------------------------------------------ |
| Engine       | **XeLaTeX** (or LuaLaTeX) — **NEVER `pdflatex`**                               |
| Why          | Arabic shaping + RTL require `fontspec`/`polyglossia`; `pdflatex` cannot do it |
| Main font    | **Amiri** (installed at `/usr/share/fonts/TTF/Amiri-*.ttf`)                    |
| Language pkg | `polyglossia` (not `babel`)                                                    |

Verify availability:

```bash
which xelatex lualatex
fc-list | grep -i amiri
```

---

## 4. Build

Always compile into `build/`:

```bash
# Single document (run twice when it uses \label/\ref or TOC)
xelatex -interaction=nonstopmode -halt-on-error -output-directory=build FILE.tex
xelatex -interaction=nonstopmode -halt-on-error -output-directory=build FILE.tex
```

**Clean build (when something looks stale):**

```bash
rm -f build/FILE.aux build/FILE.out build/FILE.toc build/FILE.xdv build/FILE.fdb_latexmk
xelatex -interaction=nonstopmode -halt-on-error -output-directory=build FILE.tex
```

> If the repo directory is read-only, enable writing first:
> `chmod u+w .`

### 4.1 Publishing the compiled PDF

`build/` is scratch space. After a clean build, **copy** the finished PDF into the
**production directory `2026-2027/`** — into the sub-folder that matches the
document's category, with the **Arabic name** below:

- Final/submittable → `2026-2027/Official Documents/<التصنيف>/`
- Working/staging (regenerated) → `2026-2027/Support Documents/<التصنيف>/`

Never rename the source `.tex`, and keep the two in sync.

**File-naming pattern:**

```
<اسم الوثيقة>[ - <الشعبة>].pdf
```

The school year is **not** repeated in the filename — the `2026-2027/` directory
already carries it. Place a single space around the hyphen, and add the stream
suffix only for documents that exist per-stream (e.g. التوزيع السنوي، البرنامج
السنوي). Folder name = bare document name (no stream).

| Source `.tex`                    | Published folder                | Published filename                                  |
| -------------------------------- | ------------------------------- | --------------------------------------------------- |
| `didactic-contract.tex`          | `العقد الديداكتيكي/`            | `العقد الديداكتيكي.pdf`                             |
| `diagnostic-assessment.tex`      | `التقويم التشخيصي/`             | `التقويم التشخيصي.pdf`                              |
| `annual-distribution-science.tex`| `التوزيع السنوي/`               | `التوزيع السنوي - جذع مشترك علوم وتكنولوجيا.pdf`    |
| `annual-distribution-letters.tex`| `التوزيع السنوي/`               | `التوزيع السنوي - جذع مشترك آداب وفلسفة.pdf`        |
| `annual-program-science.tex`     | `البرنامج السنوي/`              | `البرنامج السنوي - جذع مشترك علوم وتكنولوجيا.pdf`   |
| `annual-program-letters.tex`     | `البرنامج السنوي/`              | `البرنامج السنوي - جذع مشترك آداب وفلسفة.pdf`       |

**Publish command (after the build in §4):**

```bash
cp build/didactic-contract.pdf           "2026-2027/Official Documents/العقد الديداكتيكي/العقد الديداكتيكي.pdf"
cp build/diagnostic-assessment.pdf       "2026-2027/Official Documents/التقويم التشخيصي/التقويم التشخيصي.pdf"
cp build/annual-distribution-science.pdf "2026-2027/Official Documents/التوزيع السنوي/التوزيع السنوي - جذع مشترك علوم وتكنولوجيا.pdf"
cp build/annual-distribution-letters.pdf "2026-2027/Official Documents/التوزيع السنوي/التوزيع السنوي - جذع مشترك آداب وفلسفة.pdf"
cp build/annual-program-science.pdf      "2026-2027/Official Documents/البرنامج السنوي/البرنامج السنوي - جذع مشترك علوم وتكنولوجيا.pdf"
cp build/annual-program-letters.pdf      "2026-2027/Official Documents/البرنامج السنوي/البرنامج السنوي - جذع مشترك آداب وفلسفة.pdf"
```

> For staging (before final sign-off) put the same files under
> `2026-2027/Support Documents/<التصنيف>/` instead of `Official Documents/`.

**Rules:**

- Quote every path — the names contain spaces and Arabic.
- Overwrite the existing published PDF; it is a derived copy, not a source.
- Keep older years in their own `20XX-20XX/` tree and never overwrite them.
- The same `<اسم الوثيقة>[ - <الشعبة>].pdf` pattern applies to **externally
  sourced** official documents filed under `Official Documents/` (e.g.
  `التدرج السنوي - جذع مشترك آداب وفلسفة.pdf`) even when they have no source
  `.tex`. Spell out the stream; never keep ministry abbreviations such as
  `ج م ا ف` / `ج م ع ت`.

---

## 5. Shared Layer (Single Source of Truth)

Every document composes from the shared layer in `source files/shared/` — do **not**
copy a preamble. Set `\shareddir` (the path from the document to `shared/`), then
`\input` the entry point that matches the document type.

### 5.1 Entry points

| Document type | Preamble |
| --- | --- |
| Default article (lessons, programs, logbook, lab register) | `\def\shareddir{…}` then `\input{"…/common.tex"}` — geometry + `\pageborder` + core |
| Special-layout article (landscape distribution, two-per-page form, contract) | set geometry yourself, then `\def\shareddir{…}` + `\input{"…/core.tex"}` (call `\pageborder` if wanted) |
| Presentation | `\documentclass[aspectratio=169,11pt]{beamer}` then `\def\shareddir{…}` + `\input{"…/presentation.tex"}` |

### 5.2 What the shared files own

| File | Owns |
| --- | --- |
| `identity.tex` | language (`polyglossia`, western numerals), Amiri fonts, color palette |
| `core.tex` | article packages (fancyhdr-before-polyglossia), then `identity` + `header` + `footer` + `design` + `lesson-macros` |
| `common.tex` | default article geometry + `\pageborder` + `core.tex` |
| `presentation.tex` | beamer packages, theme, frametitle, `\sectionframe`, `\hl`/`\key` |
| `header.tex` | `\officialheader` |
| `footer.tex` | footer (teacher / year / page x-of-y) |
| `design.tex` | boxes, icons, badges, `\pageborder`, section dividers |
| `lesson-macros.tex` | cards, stage tables, `\thead`/`\thd`, `\answerline`, `\cb`, `\blank`, … |

### 5.3 What stays per-document

Only document-specific layout and constructs: geometry/page size, whether the page
border is drawn, page style (e.g. `\pagestyle{empty}`), and document-specific boxes
(`contractbox`, `formbox`, `\cutline`, …). Everything else comes from the shared
layer.

The color palette lives in `identity.tex` (see §7).

---

## 6. Non-Negotiable Rules (each one caused a real failure)

1. **Load order:** `fancyhdr` (and `titlesec`, `enumitem`, …) **must be loaded
   before `polyglossia`**. `polyglossia` loads `bidi`, which patches `fancyhdr`
   internals at load time. If `fancyhdr` is loaded after, you get:
   `Package bidi Warning: Oops! patching \f@nch@hfbox@... failed.`

2. **`\headheight`:** set `headheight=26pt` (or ≥25.6pt) in `geometry`, otherwise:
   `Package fancyhdr Warning: \headheight is too small (12.0pt): Make it at least 25.57045pt`.

3. **Numerals:** use `\setmainlanguage[numerals=western]{arabic}` so lists/numbers
   render `1, 2, 3` instead of Arabic-Indic `١, ٢, ٣`.

4. **`\rowcolor` needs `colortbl`:** loading only `xcolor` is not enough.

5. **No bare underscores in text.** `_` starts math mode and produces a flood of
   `Missing $ inserted` + `Missing character: There is no ... in font cmmi6!`.
   Use `\underline{\hspace{2cm}}` or `\rule{2cm}{0.4pt}` instead of `______`.

6. **No emoji / unsupported glyphs.** Amiri lacks `✗`, `🚩`, etc. → `Missing character`.
   Use ASCII/Latin equivalents (`X`, or words).

7. **Answer dots need a box.** `\dotfill` alone after `\\` renders nothing; use
   `\makebox[\linewidth]{\dotfill}` (see `\answerline` helper).

8. **Page border must contain the header.** The border is drawn from the page
   coordinates in `AddToShipoutPictureBG`. To keep the header _inside_ the frame,
   the top border edge must sit above the header — with `top=3.2cm` and
   `yshift=-1cm` this works. If the border lands on the header, increase `top`.

9. **`build/` output only.** Always pass `-output-directory=build`.

10. **Compile with XeLaTeX**, never `pdflatex`.

---

## 7. Design System

| Token       | Hex       | Use                                           |
| ----------- | --------- | --------------------------------------------- |
| `primary`   | `#0D47A1` | Page border, section titles, table headers    |
| `secondary` | `#1976D2` | Sub-headings, box frames                      |
| `blue`      | `#42A5F5` | Badges, icons, light touches                  |
| `darktext`  | `#111111` | Body text                                     |
| `lightbg`   | `#E8F0FE` | Box fill                                      |
| `zebra`     | `#F2F6FC` | Alternating table row shading                 |
| `rulegray`  | `#9E9E9E` | Rules, footer, hints, signature rules         |

- **Header:** `\officialheader` (republic / ministry / direction / school).
- **Footer:** teacher (left) + year `2027/2026` (right) + page `الصفحة س/ص` (center).
- **Page border:** 1cm from all edges, `primary`, 1.1pt (`\pageborder`).
- **Signature blocks:** three `minipage`s of `0.30\textwidth` separated by `\hfill`
  with a `\hrulefill` line above each label.

---

## 8. Conventions for New Documents

1. Read `README.md` for identity data.
2. Compose from the shared layer per §5 (`common.tex` / `core.tex` / `presentation.tex`); set geometry yourself only for special layouts.
3. Name the file descriptively in kebab-case: `didactic-contract.tex`,
   `diagnostic-assessment.tex`.
4. Set the header title, `\hypersetup` title, and footer consistently.
5. Keep content inside the 1cm page border.
6. Build to `build/` and verify (see §9).
7. Publish the PDF to `2026-2027/Official Documents/` using the naming convention
   in §4.1.
8. Add the document to the index table in `README.md` (§الوثائق), linking the
   published PDF and the source `.tex`.
9. Do not modify unrelated `.tex` files.

---

## 9. Verification Workflow (always do this after building)

```bash
# 1. Build (twice for references)
xelatex -interaction=nonstopmode -halt-on-error -output-directory=build FILE.tex
xelatex -interaction=nonstopmode -halt-on-error -output-directory=build FILE.tex

# 2. Check for hard errors (should print nothing)
grep -i "^!" build/FILE.log

# 3. Check for missing glyphs (should print 0)
grep -c "Missing character" build/FILE.log

# 4. Confirm page count / size
pdfinfo build/FILE.pdf | grep -E "Pages|Page size"

# 5. Render previews and inspect visually
pdftoppm -png -r 90 build/FILE.pdf build/preview
# then open build/preview-1.png, etc.
```

**Definition of done:** exit code `0`, no `!` errors, `Missing character` count is
`0`, page count is as intended, and the rendered preview looks correct.

---

## 10. Pitfall Reference

| Symptom                                   | Cause                                 | Fix                                 |
| ----------------------------------------- | ------------------------------------- | ----------------------------------- |
| `Missing $ inserted` flood                | bare `_` in text                      | `\underline{\hspace{..}}`           |
| `Missing character ... in font cmmi6`     | text typeset in math mode             | remove `_`, `^`, `$` from text      |
| `Missing character ... in font Amiri`     | emoji / symbol absent                 | replace with Latin/word             |
| `bidi Warning: Oops! patching \f@nch@...` | `fancyhdr` loaded after `polyglossia` | move `fancyhdr` above `polyglossia` |
| `\headheight is too small`                | default 12pt header                   | `headheight=26pt` in geometry       |
| `Undefined control sequence \rowcolor`    | `colortbl` not loaded                 | `\usepackage{colortbl}`             |
| Numbers show as ١،٢،٣                     | default numerals                      | `numerals=western`                  |
| `\dotfill` line invisible                 | leaders on empty line                 | `\makebox[\linewidth]{\dotfill}`    |
| Border crosses the header                 | border top edge too low               | increase `top=` or adjust `yshift`  |
| `Argument of \addvspace has an extra }`   | defined a macro named `\sectionbreak` (titlesec reserves `\<secname>break`) | rename it (e.g. `\lessonbreak`) |
| `Permission denied` writing `.tex`        | read-only directory                   | `chmod u+w .`                       |

---

## 11. Quick Command Cheatsheet

```bash
# Build all documents in the repo
for f in *.tex; do
  xelatex -interaction=nonstopmode -halt-on-error -output-directory=build "$f"
done

# Build one document (twice)
xelatex -interaction=nonstopmode -halt-on-error -output-directory=build diagnostic-assessment.tex
xelatex -interaction=nonstopmode -halt-on-error -output-directory=build diagnostic-assessment.tex

# Clean artifacts for one document
rm -f build/FILE.{aux,out,toc,xdv,log,fdb_latexmk,fls,synctex.gz}
```
