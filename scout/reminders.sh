#!/bin/bash
# Called from tg_listener.sh every loop (~1 min). Sends each reminder from reminders.tsv once per day,
# within 30 minutes after its time (Asia/Almaty), so a sleeping laptop that wakes a bit late still reminds.
cd "$(dirname "$0")" || exit 1
dow=$(TZ=Asia/Almaty date +%u); today=$(TZ=Asia/Almaty date +%F); nowm=$(( 10#$(TZ=Asia/Almaty date +%H) * 60 + 10#$(TZ=Asia/Almaty date +%M) ))
touch data/reminders_sent.txt
while IFS=$'\t' read -r days hm msg files; do
  [[ -z "$days" || "$days" == \#* ]] && continue
  if [[ "$days" == 20??-??-?? ]]; then [[ "$days" == "$today" ]] || continue; else [[ ",$days," == *",$dow,"* ]] || continue; fi
  tm=$(( 10#${hm%%:*} * 60 + 10#${hm##*:} ))
  (( nowm >= tm && nowm < tm + 30 )) || continue
  key="$today $hm $days"
  grep -qxF "$key" data/reminders_sent.txt && continue
  printf '%s' "$msg" > data/out/reminder.html && ./send_tg.sh data/out/reminder.html >/dev/null && echo "$key" >> data/reminders_sent.txt || continue
  # Optional 4th column: comma-separated files (paths relative to the repo root) sent as documents after the message
  [ -n "$files" ] && ( source ../secrets/telegram.env; IFS=','; for f in $files; do
    curl -s "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendDocument" --form-string "chat_id=$TELEGRAM_CHAT_ID" -F "document=@../$f" >/dev/null
  done )
done < reminders.tsv
