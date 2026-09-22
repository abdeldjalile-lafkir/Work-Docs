#!/usr/bin/env bash
# ══════════════════════════════════════════════════════════════════════════════
#  build.sh — بناء دروس المعلوماتية ونشرها
#
#  البنية:
#    source files/lessons/<الدرس>/{note,lesson,presentation,practical}.tex
#        ↓ تُصرَّف بـ XeLaTeX في مكانها
#    source files/lessons/<الدرس>/{note,lesson,presentation,practical}.pdf
#        ↓ تُنسخ
#    2026-2027/Lesson Documents/<الدرس>/{note,lesson,presentation,practical}.pdf
#
#  الاستعمال:
#    ./build.sh                 # يبني كل الدروس
#    ./build.sh "01 - تقنية المعلومات"   # يبني درسًا واحدًا
# ══════════════════════════════════════════════════════════════════════════════
set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$HERE/../.." && pwd)"
PUB="$ROOT/2026-2027/Lesson Documents"
PARTS=(note lesson presentation practical)

build_one() {
  local dir="$1" name part
  name="$(basename "$dir")"
  echo "── $name"
  for part in "${PARTS[@]}"; do
    [[ -f "$dir/$part.tex" ]] || continue
    if (cd "$dir" && xelatex -interaction=nonstopmode -halt-on-error "$part.tex" >/dev/null 2>&1); then
      local miss
      miss="$(grep -c 'Missing character' "$dir/$part.log" 2>/dev/null || true)"
      miss="${miss:-0}"
      printf '   %-14s ✔  (%s صفحة، رموز ناقصة: %s)\n' \
        "$part.tex" "$(pdfinfo "$dir/$part.pdf" 2>/dev/null | awk '/^Pages/{print $2}')" "$miss"
    else
      printf '   %-14s ✘  فشل — راجع %s\n' "$part.tex" "$dir/$part.log"
    fi
  done
  # تنظيف الملفات الوسيطة
  rm -f "$dir"/*.aux "$dir"/*.log "$dir"/*.out "$dir"/*.toc "$dir"/*.xdv \
    "$dir"/*.synctex.gz "$dir"/*.nav "$dir"/*.snm "$dir"/*.vrb \
    "$dir"/*.fdb_latexmk "$dir"/*.fls
  # النشر
  mkdir -p "$PUB/$name"
  for part in "${PARTS[@]}"; do
    [[ -f "$dir/$part.pdf" ]] && cp "$dir/$part.pdf" "$PUB/$name/$part.pdf"
  done
}

if [[ $# -gt 0 ]]; then
  build_one "$HERE/$1"
else
  for d in "$HERE"/*/; do
    [[ "$(basename "$d")" == "_common" ]] && continue
    [[ -f "$d/note.tex" ]] || continue
    build_one "${d%/}"
  done
fi

echo "تمّ. النشر إلى: $PUB"
