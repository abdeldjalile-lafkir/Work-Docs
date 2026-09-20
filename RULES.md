# RULES.md

**The single source of truth for this repository is [`AGENTS.md`](./AGENTS.md).**
Read it before creating or editing any LaTeX document.

## TL;DR — the 6 rules that matter most

1. **Compile with XeLaTeX** (or LuaLaTeX). Never `pdflatex` (Arabic needs it).
2. **Load `fancyhdr` (and other packages) BEFORE `polyglossia`.**
3. **`\setmainlanguage[numerals=western]{arabic}`** for `1,2,3` instead of `١,٢,٣`.
4. **Never use bare `_`** in text → use `\underline{\hspace{2cm}}`.
5. **No emoji / unsupported glyphs** (Amiri lacks them).
6. **Build to `build/`** with `-output-directory=build`.

## Build

```bash
xelatex -interaction=nonstopmode -halt-on-error -output-directory=build FILE.tex
```

See [`AGENTS.md`](./AGENTS.md) for the full preamble, design system, and pitfalls.
