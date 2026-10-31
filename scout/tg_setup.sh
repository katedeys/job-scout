#!/bin/bash
# Finds the chat id of whoever sent /start to the bot and saves it into secrets/telegram.env.
cd "$(dirname "$0")/.." || exit 1
source secrets/telegram.env
[ -z "$TELEGRAM_BOT_TOKEN" ] && { echo "Token is empty in secrets/telegram.env"; exit 1; }
chat=$(curl -s "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/getUpdates" | jq -r '[.result[]?.message.chat.id] | last // empty')
[ -z "$chat" ] && { echo "No /start found. Send /start to the bot in Telegram and rerun."; exit 1; }
sed -i '' "s/^TELEGRAM_CHAT_ID=.*/TELEGRAM_CHAT_ID=$chat/" secrets/telegram.env
curl -s "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" --data-urlencode "chat_id=$chat" --data-urlencode "text=Привет! Job scout на связи 🚀 Буду присылать вакансии каждое утро." | jq -r 'if .ok then "Test message sent" else .description end'
