#!/bin/bash
# Builds portfolio/site/index.html (full HTML for GitHub Pages) from portfolio/index.html (artifact format)
# and pushes it to the katedeys-portfolio repo clone in portfolio/site-repo.
cd "$(dirname "$0")" || exit 1
{ printf '<!doctype html>\n<html lang="en">\n<head>\n<meta charset="utf-8">\n<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">\n<meta name="description" content="Ekaterina Deys: payments, money movement and partner integrations case studies with architecture and sequence diagrams.">\n<meta name="robots" content="noindex, nofollow, noarchive">\n'
  grep -v 'claude:viewport-fit-sides' index.html | awk '/^<style>/{print; print "  :root { padding-top: env(safe-area-inset-top, 0px); padding-bottom: env(safe-area-inset-bottom, 0px); }"; next} {print}' | perl -0pe 's|(</style>\n)|$1</head>\n<body>\n|'
  printf '</body>\n</html>\n'; } > site/index.html
[ "$1" = "--push" ] || exit 0
cp site/index.html site-repo/index.html
cd site-repo && git add index.html && git commit -q -m "${2:-Portfolio update}" && git push -q && echo "portfolio pushed"
