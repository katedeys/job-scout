#!/bin/bash
# Sends the next 10 prepared vacancies from data/more_queue.json (each: caption + CV + cover),
# removes them from the queue, and offers the button again while more remain.
cd "$(dirname "$0")" || exit 1
q=data/more_queue.json
n=$( [ -s "$q" ] && jq length "$q" || echo 0 )
if [ "$n" -eq 0 ]; then
  printf '%s\n' "Запас на сегодня закончился 🙌 Завтра утром подготовлю больше." > data/out/more_empty.html
  ./send_tg.sh data/out/more_empty.html >/dev/null
  date +%F > data/more_requested   # the morning run prepares a bigger reserve
  exit 0
fi
batch=$(jq -c '.[0:10][]' "$q")
while IFS= read -r j; do
  [ -z "$j" ] && continue
  id=$(jq -r .id <<<"$j")
  jq -r '"<b>\(.company)</b> — <a href=\"\(.url)\">\(.title)</a>\n📍 \(.location) · ⭐ \(.score)/10\n\(.why)"' <<<"$j" > "data/out/cap_$id.html"
  ./send_job_docs.sh "data/out/cap_$id.html" "$(jq -r .cv_pdf <<<"$j")" "$(jq -r .cover_pdf <<<"$j")" "$id" >/dev/null
  echo "$id" >> data/sent_more.txt
  sleep 1
done <<<"$batch"
jq '.[10:]' "$q" > "$q.tmp" && mv "$q.tmp" "$q"
left=$(jq length "$q")
if [ "$left" -gt 0 ]; then printf 'Ещё в запасе: %s\n' "$left" > data/out/more_left.html; ./send_tg.sh data/out/more_left.html more >/dev/null
else date +%F > data/more_requested; fi
