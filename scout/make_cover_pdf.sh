#!/bin/bash
# Usage: make_cover_pdf.sh <cover.txt> <out.pdf> "<Company — Role>" ["<headline under the name>"]
# Renders a plain-text cover letter (paragraphs separated by blank lines) as a one-page PDF in the CV style.
abs() { case "$1" in /*) echo "$1";; *) echo "$PWD/$1";; esac; }
txt=$(abs "$1"); out=$(abs "$2"); re="$3"
head="${4:-Lead Technical Product Manager | Payments, Orchestration &amp; Fintech Platforms}"
cd "$(dirname "$0")" || exit 1
html=$(mktemp -t cover).html
{
  sed -n '1,/<\/style>/p' ../cover_gitlab.html | sed '/^<\/style>$/d'
  echo '</style></head><body>'
  echo '<h1>EKATERINA DEYS</h1>'
  printf '<div class="title">%s</div>\n' "$head"
  echo '<div class="contact">Kazakhstan · Available from November 2026 · Open to relocation · katedeys@gmail.com · linkedin.com/in/kate-deys</div>'
  printf '<div class="meta">Re: %s</div>\n<div class="letter">\n' "$(printf '%s' "$re" | sed 's/&/\&amp;/g; s/</\&lt;/g')"
  perl -0pe 's/&/&amp;/g; s/</&lt;/g; s/>/&gt;/g; s/\r//g; s/\n{2,}/\n\n/g; $_ = join("", map { s/\n/<br>/g; "<p>$_<\/p>\n" } grep { /\S/ } split(/\n\n/, $_))' "$txt"
  echo '</div></body></html>'
} > "$html"
"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" --headless=new --disable-gpu --no-pdf-header-footer --user-data-dir="$TMPDIR/chrome-cv" --print-to-pdf="$out" "file://$html" >/dev/null 2>&1
rm -f "$html"
[ -s "$out" ] && echo "ok $out" || { echo "failed"; exit 1; }
