#!/bin/bash
# Usage: send_job_docs.sh <caption.html> <cv.pdf> [cover.pdf] [tracker-doc-id]
# With a tracker doc id: sends the caption as a card with "✍️ Письмо" / "💶 Зарплата" buttons, then the files.
# Without it: sends the files with the caption under them. Cover is optional (CV only).
abs() { case "$1" in /*) echo "$1";; *) echo "$PWD/$1";; esac; }
capf=$(abs "$1"); cvf=$(abs "$2"); covf=""; [ -n "$3" ] && covf=$(abs "$3"); id="$4"
cd "$(dirname "$0")/.." || exit 1
source secrets/telegram.env
API="https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN"
cap=$(cat "$capf")
ok() { jq -r 'if .ok then "sent" else "error: "+.description end'; }
if [ -n "$id" ]; then
  kb=$(jq -cn --arg id "$id" '{inline_keyboard:[[{text:"✍️ Письмо",callback_data:("cv:"+$id)},{text:"💶 Зарплата",callback_data:("sal:"+$id)}],[{text:"✅ Откликнулась",callback_data:("ap:"+$id)}]]}')
  curl -s "$API/sendMessage" --form-string "chat_id=$TELEGRAM_CHAT_ID" --form-string "text=$cap" --form-string "parse_mode=HTML" \
    --form-string "disable_web_page_preview=true" --form-string "reply_markup=$kb" | ok
  cap=""
fi
if [ -z "$covf" ] || [ ! -s "$covf" ]; then
  curl -s "$API/sendDocument" --form-string "chat_id=$TELEGRAM_CHAT_ID" ${cap:+--form-string "caption=$cap" --form-string "parse_mode=HTML"} -F "document=@$cvf" | ok
  exit 0
fi
media=$(jq -cn --arg cap "$cap" 'if $cap=="" then [{type:"document",media:"attach://cv"},{type:"document",media:"attach://cover"}] else [{type:"document",media:"attach://cv"},{type:"document",media:"attach://cover",caption:$cap,parse_mode:"HTML"}] end')
curl -s "$API/sendMediaGroup" --form-string "chat_id=$TELEGRAM_CHAT_ID" --form-string "media=$media" -F "cv=@$cvf" -F "cover=@$covf" | ok
