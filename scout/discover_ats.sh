#!/bin/bash
# Usage: discover_ats.sh <file with one company name per line>
# Tries slug variants of each company on every supported ATS. Companies found with open jobs are appended
# to companies.tsv (type O, region "auto") and logged to data/discovered.log. Already-known names are skipped.
cd "$(dirname "$0")" || exit 1
while IFS= read -r name; do
  [ -z "$name" ] && continue
  grep -qiF "	$name	" companies.tsv && continue
  grep -qixF "$name" data/discover_misses.txt 2>/dev/null && continue
  base=$(echo "$name" | iconv -f utf-8 -t ascii//TRANSLIT 2>/dev/null | tr '[:upper:]' '[:lower:]' | sed -E 's/\(.*\)//; s/[|].*//; s/\b(ltd|limited|inc|group|gmbh|plc|llc|s\.a\.|bv|b\.v\.|technologies|technology|holding|holdings)\b//g; s/&/and/g')
  cands=$(printf '%s\n' "$(echo "$base" | tr -cd 'a-z0-9')" "$(echo "$base" | sed -E 's/[^a-z0-9]+/-/g; s/^-|-$//g')" | sort -u)
  found=""
  for s in $cands; do
    [ ${#s} -lt 3 ] && continue
    line=$(./probe.sh "$s")
    # Pinpoint serves a demo board ("Head of DEI") for unknown subdomains: never accept it
    if echo "$line" | grep -q "pp=[1-9]"; then curl -s -m 15 "https://$s.pinpointhq.com/postings.json" | grep -q "Head of DEI" && line=$(echo "$line" | sed -E "s/pp=[0-9]+/pp=/"); fi
    best=$(echo "$line" | tr ' ' '\n' | grep -E '^[a-z]+=[1-9][0-9]*$' | sort -t= -k2 -nr | head -1)
    [ -n "$best" ] && { found="$s	${best%%=*}	${best#*=}"; break; }
  done
  if [ -n "$found" ]; then
    IFS=$'\t' read -r slug ats n <<<"$found"
    printf '%s\t%s\tauto\t%s\tO\n' "$slug" "$name" "$ats" >> companies.tsv
    echo "$(date +%F) added $name -> $ats:$slug ($n jobs)" | tee -a data/discovered.log
  else
    echo "$name" >> data/discover_misses.txt
  fi
done < "$1"
