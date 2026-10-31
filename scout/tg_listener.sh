#!/bin/bash
# Long-polls the Get Rich bot. On the "Ещё 10 вакансий" button or /more from Ekaterina's chat,
# sends the next prepared batch. Runs as a LaunchAgent (com.katedeys.getrich).
cd "$(dirname "$0")" || exit 1
source ../secrets/telegram.env
API="https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN"
off=$(cat data/tg_offset 2>/dev/null || echo 0)
last_watch=0
while true; do
  now=$(date +%s); if [ $((now - last_watch)) -ge 3600 ]; then ./watch_check.sh >> data/listener.log 2>&1; last_watch=$now; fi
  resp=$(curl -s -m 70 "$API/getUpdates?timeout=50&offset=$off")
  if ! jq -e '.ok' >/dev/null 2>&1 <<<"$resp"; then sleep 15; continue; fi
  while IFS= read -r u; do
    [ -z "$u" ] && continue
    off=$(( $(jq -r .update_id <<<"$u") + 1 )); echo "$off" > data/tg_offset
    chat=$(jq -r '(.callback_query.message.chat.id // .message.chat.id // "") | tostring' <<<"$u")
    [ "$chat" != "$TELEGRAM_CHAT_ID" ] && continue
    cb=$(jq -r '.callback_query.id // empty' <<<"$u")
    data=$(jq -r '.callback_query.data // empty' <<<"$u")
    text=$(jq -r '.message.text // empty' <<<"$u")
    if [[ "$data" == sal:* ]]; then
      jid=${data#sal:}
      [ -n "$cb" ] && curl -s "$API/answerCallbackQuery" --data-urlencode "callback_query_id=$cb" >/dev/null
      m=$(jq -c --arg id "$jid" '.[$id] // empty' data/jobs_meta.json 2>/dev/null)
      if [ -n "$m" ]; then
        jq -r '"💶 <b>\(.company)</b> — \(.title)\n" + (if .salary then "В вакансии: \(.salary)" else "≈ \(.salary_estimate // "нет оценки")" end) + (if .salary_basis then "\nНа чём основано: \(.salary_basis)" else "" end) + (if .salary_ask then "\nЧто указать в анкете: \(.salary_ask)" else "" end)' <<<"$m" > data/out/sal_reply.html
      else
        printf '%s\n' "💶 Для этой вакансии оценки ещё нет — посчитаю в утреннем прогоне (или напиши Claude «посчитай зарплаты»)." > data/out/sal_reply.html
        jq -cn --arg id "$jid" --arg ts "$(date -u +%FT%TZ)" '{type:"sal", id:$id, ts:$ts}' >> data/ondemand.jsonl
      fi
      ./send_tg.sh data/out/sal_reply.html >/dev/null
      continue
    fi
    if [[ "$data" == ap:* ]]; then
      jid=${data#ap:}
      mid=$(jq -r '.callback_query.message.message_id // empty' <<<"$u")
      jq -cn --arg id "$jid" --arg ts "$(date -u +%FT%TZ)" '{type:"applied", id:$id, ts:$ts}' >> data/ondemand.jsonl
      [ -n "$cb" ] && curl -s "$API/answerCallbackQuery" --data-urlencode "callback_query_id=$cb" --data-urlencode "text=✅ Отметила: в трекере обновится утром" >/dev/null
      if [ -n "$mid" ]; then
        kb=$(jq -cn --arg id "$jid" --arg d "$(date +%d.%m)" '{inline_keyboard:[[{text:"✍️ Письмо",callback_data:("cv:"+$id)},{text:"💶 Зарплата",callback_data:("sal:"+$id)}],[{text:("✅ Откликнулась "+$d),callback_data:"noop"}]]}')
        curl -s "$API/editMessageReplyMarkup" --data-urlencode "chat_id=$TELEGRAM_CHAT_ID" --data-urlencode "message_id=$mid" --data-urlencode "reply_markup=$kb" >/dev/null
      fi
      continue
    fi
    if [ "$data" = "noop" ]; then
      [ -n "$cb" ] && curl -s "$API/answerCallbackQuery" --data-urlencode "callback_query_id=$cb" --data-urlencode "text=Уже отмечено ✅" >/dev/null
      continue
    fi
    if [[ "$data" == cv:* ]]; then
      jid=${data#cv:}
      jq -cn --arg id "$jid" --arg ts "$(date -u +%FT%TZ)" '{type:"cv", id:$id, ts:$ts}' >> data/ondemand.jsonl
      [ -n "$cb" ] && curl -s "$API/answerCallbackQuery" --data-urlencode "callback_query_id=$cb" --data-urlencode "text=✍️ В очереди: письмо придёт в утреннем дайджесте. Срочно? Напиши Claude «сделай письма»" --data-urlencode "show_alert=true" >/dev/null
      continue
    fi
    if [[ "$data" == c:* ]]; then
      [ -n "$cb" ] && curl -s "$API/answerCallbackQuery" --data-urlencode "callback_query_id=$cb" --data-urlencode "text=Собираю вакансии…" >/dev/null
      ./send_country.sh "${data#c:}" >> data/listener.log 2>&1
      continue
    fi
    if [ "$data" = "more" ] || [[ "$text" == /more* ]] || [[ "$text" == "ещё"* ]] || [[ "$text" == "еще"* ]]; then
      [ -n "$cb" ] && curl -s "$API/answerCallbackQuery" --data-urlencode "callback_query_id=$cb" --data-urlencode "text=Собираю ещё вакансии…" >/dev/null
      ./send_more.sh >> data/listener.log 2>&1
      continue
    fi
    # A vacancy sent by Ekaterina: a link, /vac <link or text>, or a long pasted description
    if [ -n "$text" ] && [[ "$text" != /* || "$text" == /vac* ]]; then
      body=${text#/vac}
      url=$(grep -oE 'https?://[^[:space:]]+' <<<"$body" | head -1)
      if [ -n "$url" ] || [ ${#body} -ge 200 ]; then
        jq -cn --arg url "$url" --arg text "$body" --arg ts "$(date -u +%FT%TZ)" '{type:"vacancy", id:("tg-"+($ts|gsub("[^0-9]";""))), url:$url, text:$text, ts:$ts}' >> data/ondemand.jsonl
        printf '%s\n' "📥 Вакансию приняла. Оценю, посчитаю зарплату и сделаю CV с письмом в ближайший прогон. Срочно — напиши Claude «разбери вакансии из бота»." > data/out/vac_ack.html
        [[ "$url" == *linkedin.com* ]] && printf '%s\n' "LinkedIn я сама не открываю: если ссылка на LinkedIn, пришли ещё и текст вакансии одним сообщением." >> data/out/vac_ack.html
        ./send_tg.sh data/out/vac_ack.html >/dev/null
      fi
    fi
  done < <(jq -c '.result[]' <<<"$resp")
done
