#!/bin/bash
# Usage: send_post_at.sh HH:MM <image> <text.html> — waits until HH:MM today, then sends the image and the post text to Telegram.
cd "$(dirname "$0")" || exit 1
target=$(date -j -f "%Y-%m-%d %H:%M" "$(date +%Y-%m-%d) $1" +%s); now=$(date +%s)
[ "$target" -gt "$now" ] && sleep $((target - now))
source ../secrets/telegram.env
curl -s "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendPhoto" -F "chat_id=$TELEGRAM_CHAT_ID" -F "photo=@$2" --form-string "caption=Картинка к посту для LinkedIn" | jq -r 'if .ok then "photo sent" else "error: "+.description end'
./send_tg.sh "$3"
