# RULES.md

**The single source of truth for this repository is [`AGENTS.md`](./AGENTS.md).**
Read it before creating or editing any LaTeX document.

## TL;DR — the 7 rules that matter most

1. **Compile with XeLaTeX** (or LuaLaTeX). Never `pdflatex` (Arabic needs it).
2. **Load `fancyhdr` (and other packages) BEFORE `polyglossia`.**
3. **`\setmainlanguage[numerals=western]{arabic}`** for `1,2,3` instead of `١,٢,٣`.
4. **Never use bare `_`** in text → use `\underline{\hspace{2cm}}`.
5. **No emoji / unsupported glyphs** (Amiri lacks them).
6. **Build to `build/`** with `-output-directory=build`.
7. **Publish to the production directory `2026-2027/`** (sub-folder by category)
   with the Arabic name `<اسم الوثيقة>[ - <الشعبة>].pdf` (no year in the filename).

## Build

```bash
xelatex -interaction=nonstopmode -halt-on-error -output-directory=build FILE.tex
```

## Publish

**`2026-2027/` is the production directory** — every generated PDF is copied there,
into the sub-folder that matches its category, with its **Arabic name**:

| Category           | Destination folder                  |
| ------------------ | ----------------------------------- |
| Final/submittable  | `2026-2027/Official Documents/…`    |
| Staging/working    | `2026-2027/Support Documents/…`     |
| Lessons            | `2026-2027/Lesson Documents/…`      |
| Lab / practical    | `2026-2027/Lab Documents/…`         |
| Records            | `2026-2027/Record Documents/…`      |

`build/` is scratch space. Copy the finished PDF into its Arabic sub-folder with
the Arabic name (quote paths — they contain spaces and Arabic). The school year is
carried by the `2026-2027/` directory, so it is **not** repeated in the filename:

```bash
cp build/didactic-contract.pdf           "2026-2027/Official Documents/العقد الديداكتيكي/العقد الديداكتيكي.pdf"
cp build/diagnostic-assessment.pdf       "2026-2027/Official Documents/التقويم التشخيصي/التقويم التشخيصي.pdf"
cp build/annual-distribution-science.pdf "2026-2027/Official Documents/التوزيع السنوي/التوزيع السنوي - جذع مشترك علوم وتكنولوجيا.pdf"
cp build/annual-distribution-letters.pdf "2026-2027/Official Documents/التوزيع السنوي/التوزيع السنوي - جذع مشترك آداب وفلسفة.pdf"
cp build/annual-program-science.pdf      "2026-2027/Official Documents/البرنامج السنوي/البرنامج السنوي - جذع مشترك علوم وتكنولوجيا.pdf"
cp build/annual-program-letters.pdf      "2026-2027/Official Documents/البرنامج السنوي/البرنامج السنوي - جذع مشترك آداب وفلسفة.pdf"
```

See [`AGENTS.md`](./AGENTS.md) §4.1 for the full table and rules.

---

## PDF naming pattern (Arabic)

Finished PDFs are renamed to Arabic using one fixed pattern:

```
<اسم الوثيقة>[ - <الشعبة>].pdf
```

- The school year is **not** in the filename (the `2026-2027/` directory carries it).
- A **single space around the hyphen** ` - `.
- The stream suffix (`- <الشعبة>`) is added **only** for per-stream documents.
- The folder name = the bare document name (no stream).

| Source `.tex`                        | Arabic filename                                                    |
| ------------------------------------ | ------------------------------------------------------------------ |
| `didactic-contract.tex`              | `العقد الديداكتيكي.pdf`                                            |
| `diagnostic-assessment.tex`          | `التقويم التشخيصي.pdf`                                             |
| `annual-distribution-science.tex`    | `التوزيع السنوي - جذع مشترك علوم وتكنولوجيا.pdf`                   |
| `annual-distribution-letters.tex`    | `التوزيع السنوي - جذع مشترك آداب وفلسفة.pdf`                       |
| `annual-program-science.tex`         | `البرنامج السنوي - جذع مشترك علوم وتكنولوجيا.pdf`                  |
| `annual-program-letters.tex`         | `البرنامج السنوي - جذع مشترك آداب وفلسفة.pdf`                      |

Support/staging PDFs (not yet in `Official Documents/`) live in
`2026-2027/Support Documents/`, each under a sub-folder named after the bare
document (same layout as `Official Documents/`), using the **same** Arabic pattern.

---

## Repository layout (current)

```
source files/
├── shared/          ← الطبقة المشتركة: common.tex، design.tex، lesson-macros.tex، header.tex، footer.tex
├── templates/       ← قوالب الدروس: note / tp / student-sheet / summary / presentation
├── documents/       ← الوثائق الرسمية: العقد، التقويم، التوزيع، البرنامج السنوي
└── lessons/<الدرس>/ ← مخرجات درس واحد: lesson-note، tp-note، student-sheet، lesson-summary، lesson-presentation
```

Every `.tex` compiles to `build/`. Build from the file's own directory
(`cd "source files/..."`), not from the repo root.

---

## Shared design layer — `source files/shared/common.tex`

One preamble serves all lesson documents. It loads `design.tex` (palette, grid
tables, boxes, badges, icons) and `lesson-macros.tex` (card/stage/task/spec/
summary/domain macros), then the header/footer. Reuse it — do **not** copy its
preamble into new documents:

```latex
\def\shareddir{../shared/}        % from source files/documents/  (../shared/)
\input{"../shared/common.tex"}    % from source files/lessons/<الدرس>/  the default ../../shared/ applies
```

`common.tex` is **location-agnostic**: it reads `design.tex`/`header.tex`/`footer.tex`
by bare name through `\input@path`, whose base is `\shareddir`. The default
`\shareddir` is `../../shared/` (for `lessons/<درس>/`); `documents/` overrides it
with `\def\shareddir{../shared/}` **before** `\input`.

### Design tokens (palette — أزرق / أسود / أبيض حصراً)

| Token       | Hex       | Use                                  |
| ----------- | --------- | ------------------------------------ |
| `primary`   | `#0D47A1` | titles, headings, table headers, page border |
| `secondary` | `#1976D2` | sub-headings, accents                |
| `blue`      | `#42A5F5` | light highlights, badges, icons      |
| `darktext`  | `#111111` | body text (black)                    |
| `lightbg`   | `#E8F0FE` | box fill                             |
| `zebra`     | `#F2F6FC` | alternating table rows               |
| `rulegray`  | `#9E9E9E` | table lines, footer hints            |

**No gold, green, red, or any other colour** — blue/black/white only.

### Typography & structure

- `\linespread{1.18}`, `\parindent 0pt`, `\arraystretch 1.2`.
- Title `\cardtitle{...}` = `\LARGE\bfseries\color{primary}`.
- **`\sectionbreak{العنوان}`** = `\clearpage` + full-width blue banner. Use it
  **before every section** in all article documents (note / TP / sheet / summary).
- `\badge{n}` (numbered circle), `\iccheck`/`\icstar`/`\icbulb`/`\icmonitor`/
  `\icbook`/`\icpen` (TikZ icons — no emoji).
- Boxes: `goalbox`, `activitybox`, `rememberbox`, `tipbox`, `warnbox`.

---

## Table rules (hard-won)

1. **Tables use a full grid — vertical lines REQUIRED.** Column specs are
   `|…|…|` with `\hline` between rows, a coloured header row (`\thead{…}`),
   and alternating row shading (`\rowcolors` set globally). No `booktabs`.
2. **`tabularx` cannot be opened in one macro and closed in another.**
   Keep `\begin{tabularx}...\end{tabularx}` in the same place (document body).
   Splitting it across two `\newcommand`s → `! Argument of \TX@get@body has an extra }`.
3. **`\\` inside an `X` column breaks `tabularx` scanning.** For multi-line cells use
   a fixed-width `p{...}` column, or wrap content in a `minipage` (`\raggedleft`).
4. **`\answerlines`/`\answerline` must NOT go inside a table cell.** They emit `\par`.
   Use a fixed `p{}` cell with `\dotfill` `\makebox` instead (see `\specdots`).
5. Multi-line content in a cell → `\begin{minipage}[t]{\linewidth}\raggedleft …\end{minipage}`.
6. **Label columns must be `\raggedleft`** (`>{\raggedleft\arraybackslash…}p{…}`) so
   the label sits at the **start** (right) edge, aligned with the value column —
   otherwise the label drifts to the end (left) and the two columns misalign.

---

## RTL rules

- **Arabic cells use `\raggedleft`, never `\raggedright`.** `\raggedright` is
  direction-agnostic and flushes to the *left* — wrong in an RTL document.
- `\centering` for narrow numeric / score columns.
- `\hypersetup{hidelinks}` to prevent the link box around the page number.

---

## Header / footer

- `header.tex` provides `\officialheader` (الجمهورية / الوزارة / المديرية / الثانوية).
- `footer.tex` is self-contained (loads `lastpage`) and defaults to
  **«الصفحة س / ص»** + teacher + school year.
  - `\nopagenum` / `\pagenum` — hide/show the page number.
  - `\nopagefooter` — hide the whole footer on the current page.
- **Header-only document** (no footer): add `\pagestyle{empty}` right after
  `\input{...common.tex}`.

---

## Slides (beamer presentation)

- The presentation has its **own** beamer preamble (not `common.tex`).
- It `\input`s `shared/header.tex` (only — never `footer.tex`, which sets
  `fancyhdr`) to get `\officialheader`.
- **Shared header**: full `\officialheader` on the **title slide**, and a compact
  school/subject strip (`ثانوية … — المعلوماتية`) in the footline of every slide.
- `\sectionframe{الرقم}{العنوان}` renders a big-numbered section divider slide.
- Slide tables also use the full grid (vertical lines).

---

## Program documents (البرنامج السنوي) convention

- Built as a **list, not a table**: each مجال is a `\domain{الترتيب}{الاسم}`
  heading followed by a numbered `units` list.
- **No timing/hours**, **no footer**, **no signature blocks** — header + title + list only.
- Title line matches the distribution docs:
  `البرنامج السنوي لمادة المعلوماتية — السنة الأولى ثانوي  جذع مشترك …`

---

## Build & verify

```bash
# 3 passes when \pageref{LastPage} (footer «س / ص») is active
xelatex -interaction=nonstopmode -halt-on-error -output-directory=build FILE.tex
xelatex -interaction=nonstopmode -halt-on-error -output-directory=build FILE.tex
xelatex -interaction=nonstopmode -halt-on-error -output-directory=build FILE.tex

grep -i "^!" build/FILE.log            # must print nothing
grep -c "Missing character" build/FILE.log   # must be 0
```

The `bidi Warning: Oops! patching \f@nch@hfbox@...` messages are **cosmetic**
(a side effect of loading `fancyhdr` before `polyglossia`, which is required) —
output renders correctly.
