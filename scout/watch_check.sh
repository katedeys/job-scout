echo "$(date "+%d.%m %H:%M") checked $(wc -l < data/watch_now.tsv | tr -d " ") roles" > data/watch_status.txt
#!/bin/bash
# Hourly: checks watchlist companies for NEW product / payments roles and sends an instant Telegram alert.
cd "$(dirname "$0")" || exit 1
touch data/watch_seen.txt
RE='(product|payment|billing|lending|credit|repayment|disburs|monetiz|pricing|solution|integration|platform|checkout|treasury|fraud|risk)'
while IFS=$'\t' read -r slug name ats; do
  [[ -z "$slug" || "$slug" == \#* ]] && continue
  case $ats in
    ab) curl -s -m 30 "https://api.ashbyhq.com/posting-api/job-board/$slug" | jq -r --arg n "$name" '.jobs[]? | "ab-\(.id)\t\($n)\t\(.title)\t\(.location // "")\t\(.jobUrl)"' ;;
    gh) curl -s -m 30 "https://boards-api.greenhouse.io/v1/boards/$slug/jobs" | jq -r --arg n "$name" '.jobs[]? | "gh-\(.id)\t\($n)\t\(.title)\t\(.location.name // "")\t\(.absolute_url)"' ;;
    lv) curl -s -m 30 "https://api.lever.co/v0/postings/$slug?mode=json" | jq -r --arg n "$name" '.[]? | "lv-\(.id)\t\($n)\t\(.text)\t\(.categories.location // "")\t\(.hostedUrl)"' ;;
  esac
done < watchlist.tsv > data/watch_now.tsv
[ -s data/watch_now.tsv ] || exit 0
if [ "$1" = "--init" ]; then cut -f1 data/watch_now.tsv >> data/watch_seen.txt; sort -u -o data/watch_seen.txt data/watch_seen.txt; echo "initialized $(wc -l < data/watch_seen.txt)"; exit 0; fi
while IFS=$'\t' read -r id name title loc url; do
  grep -qxF "$id" data/watch_seen.txt && continue
  echo "$id" >> data/watch_seen.txt
  echo "$title" | grep -qiE "$RE" || continue
  printf '%b' "🚨 <b>$name</b>: новая вакансия\n<a href=\"$url\">$title</a>\n📍 $loc\nОткликайся сегодня — ты в числе первых." > data/out/watch_alert.html
  ./send_tg.sh data/out/watch_alert.html >/dev/null
done < data/watch_now.tsv
