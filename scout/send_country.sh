#!/bin/bash
# Usage: send_country.sh <bucket>   (NL, UK, DE, AT, IL, AE, AM, RS, GE, ESPT, PL, EU, REMOTE, OTHER)
# Sends up to 5 prepared vacancies for that country (CV + cover where prepared), removes them from the queue,
# then re-sends the country keyboard with updated counts.
cd "$(dirname "$0")" || exit 1
b="$1"; q=data/country_queue.json
items=$(jq -c --arg b "$b" '.[$b] // [] | .[0:5][]' "$q")
if [ -z "$items" ]; then printf '%s\n' "По этой стране на сегодня всё 🙌" > data/out/c_empty.html; ./send_tg.sh data/out/c_empty.html >/dev/null; exit 0; fi
while IFS= read -r j; do
  id=$(jq -r .id <<<"$j")
  jq -r '"<b>\(.company)</b> — <a href=\"\(.url)\">\(.title)</a>\n📍 \(.location) · ⭐ \(.score // "–")/10" + (if .salary then "\n💶 \(.salary)" elif .salary_estimate then "\n💶 ≈ \(.salary_estimate)" else "" end) + "\n\(.why // "")"' <<<"$j" > "data/out/cap_$id.html"
  ./send_job_docs.sh "data/out/cap_$id.html" "$(jq -r .cv_pdf <<<"$j")" "$(jq -r '.cover_pdf // ""' <<<"$j")" "$id" >/dev/null
  sleep 1
done <<<"$items"
jq --arg b "$b" '.[$b] = ((.[$b] // [])[5:])' "$q" > "$q.tmp" && mv "$q.tmp" "$q"
./make_keyboard.sh >/dev/null
left=$(jq --arg b "$b" '.[$b] | length' "$q")
printf '%s\n' "$( [ "$left" -gt 0 ] && echo "В этой стране ещё $left. Куда дальше?" || echo "Куда дальше?" )" > data/out/c_next.html
./send_tg.sh data/out/c_next.html kb >/dev/null
