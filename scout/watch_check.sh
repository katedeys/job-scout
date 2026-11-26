#!/bin/bash
# Hourly: checks watchlist companies for NEW product / payments roles and sends an instant Telegram alert.
cd "$(dirname "$0")" || exit 1
touch data/watch_seen.txt
RE='(product (manager|owner|lead|director)|head of product|chief product|cpo|group product|principal product|staff product|\bpm\b|\bpo\b)'
NOT='(designer|design|marketing|analyst|analytics|support|operations specialist|intern)'
while IFS=$'\t' read -r slug name ats; do
  [[ -z "$slug" || "$slug" == \#* ]] && continue
  case $ats in
    ab) curl -s -m 30 "https://api.ashbyhq.com/posting-api/job-board/$slug" | jq -r --arg n "$name" '.jobs[]? | "ab-\(.id)\t\($n)\t\(.title)\t\(.location // "")\t\(.jobUrl)"' ;;
    gh) curl -s -m 30 "https://boards-api.greenhouse.io/v1/boards/$slug/jobs" | jq -r --arg n "$name" '.jobs[]? | "gh-\(.id)\t\($n)\t\(.title)\t\(.location.name // "")\t\(.absolute_url)"' ;;
    lv) curl -s -m 30 "https://api.lever.co/v0/postings/$slug?mode=json" | jq -r --arg n "$name" '.[]? | "lv-\(.id)\t\($n)\t\(.text)\t\(.categories.location // "")\t\(.hostedUrl)"' ;;
  esac
done < watchlist.tsv > data/watch_now.tsv
[ -s data/watch_now.tsv ] || exit 0
# Fundraise Up: track whether "Senior PM, API & Billing" is open (closed = likely hired; reopened = finalist fell through)
if grep -q $'\tFundraise Up\t' data/watch_now.tsv; then
  if grep -qi $'\tFundraise Up\t[^\t]*API & Billing' data/watch_now.tsv; then fu=open; else fu=closed; fi
  prev=$(cat data/fu_api_state.txt 2>/dev/null)
  if [ -n "$prev" ] && [ "$prev" != "$fu" ]; then
    if [ "$fu" = closed ]; then msg="🔒 <b>Fundraise Up</b>: роль Senior PM, API &amp; Billing закрыта — похоже, взяли финалиста."
    else msg="🔓 <b>Fundraise Up</b>: роль Senior PM, API &amp; Billing снова открыта! Возможно, финалист отвалился — пиши напрямую."; fi
    printf '%s' "$msg" > data/out/watch_alert.html && ./send_tg.sh data/out/watch_alert.html >/dev/null
  fi
  echo "$fu" > data/fu_api_state.txt
fi
if [ "$1" = "--init" ]; then cut -f1 data/watch_now.tsv >> data/watch_seen.txt; sort -u -o data/watch_seen.txt data/watch_seen.txt; echo "initialized $(wc -l < data/watch_seen.txt)"; exit 0; fi
while IFS=$'\t' read -r id name title loc url; do
  grep -qxF "$id" data/watch_seen.txt && continue
  echo "$id" >> data/watch_seen.txt
  echo "$title" | grep -qiE "$RE" || continue
  echo "$title" | grep -qiE "$NOT" && continue
  printf '%b' "🚨 <b>$name</b>: новая вакансия\n<a href=\"$url\">$title</a>\n📍 $loc\nОткликайся сегодня — ты в числе первых." > data/out/watch_alert.html
  ./send_tg.sh data/out/watch_alert.html >/dev/null
done < data/watch_now.tsv
echo "$(date "+%d.%m %H:%M") checked $(wc -l < data/watch_now.tsv | tr -d " ") roles (Salmon, Plata, Fundraise Up)" > data/watch_status.txt
