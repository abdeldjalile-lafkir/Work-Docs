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
7. **Publish to `2026-2027/Official Documents/`** with the Arabic name
   `<اسم الوثيقة>[ - <الشعبة>].pdf` (no year in the filename).

## Build

```bash
xelatex -interaction=nonstopmode -halt-on-error -output-directory=build FILE.tex
```

## Publish

`build/` is scratch space. Copy the finished PDF into its Arabic folder with the
Arabic name (quote paths — they contain spaces and Arabic). The school year is
carried by the `2026-2027/` directory, so it is **not** repeated in the filename:

```bash
cp build/didactic-contract.pdf           "2026-2027/Official Documents/العقد الديداكتيكي/العقد الديداكتيكي.pdf"
cp build/diagnostic-assessment.pdf       "2026-2027/Official Documents/التقويم التشخيصي/التقويم التشخيصي.pdf"
cp build/annual-distribution-science.pdf "2026-2027/Official Documents/التوزيع السنوي/التوزيع السنوي - جذع مشترك علوم وتكنولوجيا.pdf"
cp build/annual-distribution-letters.pdf "2026-2027/Official Documents/التوزيع السنوي/التوزيع السنوي - جذع مشترك آداب وفلسفة.pdf"
```

See [`AGENTS.md`](./AGENTS.md) §4.1 for the full table and rules.
