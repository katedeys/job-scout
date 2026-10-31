#!/bin/bash
# Usage: send_tg.sh <message.html> [more]
# Sends Telegram-HTML text (<=4000 chars). With "more", adds the "Ещё 10 вакансий" button.
abs() { case "$1" in /*) echo "$1";; *) echo "$PWD/$1";; esac; }
msg=$(abs "$1")
cd "$(dirname "$0")/.." || exit 1
source secrets/telegram.env
[ -z "$TELEGRAM_BOT_TOKEN" ] || [ -z "$TELEGRAM_CHAT_ID" ] && { echo "Telegram is not configured"; exit 1; }
markup=""
if [ "$2" = "kb" ] && [ -s scout/data/keyboard.json ]; then markup=$(cat scout/data/keyboard.json)
elif [ "$2" = "more" ] || [ "$2" = "kb" ]; then markup='{"inline_keyboard":[[{"text":"➕ Ещё 10 вакансий","callback_data":"more"}]]}'; fi
curl -s "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" \
  --data-urlencode "chat_id=$TELEGRAM_CHAT_ID" --data-urlencode "parse_mode=HTML" \
  --data-urlencode "disable_web_page_preview=true" --data-urlencode "text@$msg" \
  ${markup:+--data-urlencode "reply_markup=$markup"} | jq -r 'if .ok then "sent" else "error: "+.description end'
