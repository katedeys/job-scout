#!/bin/bash
# Usage: tracker_text.sh <dump_dir> [YYYY-MM-DD]
# <dump_dir> holds jobs/*.json and tasks/*.json saved by ArtifactData (out_dir):
#   jobs  = query status in [applied, replied, interview, offer]
#   tasks = query done == false
# Prints a Telegram HTML message (under 4000 chars) with the day plan and active applications.
d="$1"; today="${2:-$(TZ=Asia/Almaty date +%F)}"
dd=$(date -j -f %F "$today" +%d.%m 2>/dev/null || echo "$today")
echo "📋 <b>Трекер · $dd</b>"
echo
echo "<b>План на сегодня</b>"
jq -s -r --arg t "$today" 'def e: gsub("&";"&amp;") | gsub("<";"&lt;") | gsub(">";"&gt;");
  map(.data // .) | map(select(.date == $t)) as $d
  | ["Виза","Поиск работы","Аутрич","Консалтинг","Развитие"] as $b
  | $b[] as $c | ($d | map(select(.category == $c)) | sort_by(.order)) as $x
  | select($x | length > 0)
  | "\n<i>\($c)</i>", ($x[] | "☐ " + .title + (if .link and .link != "" then " · <a href=\"" + .link + "\">ссылка</a>" else "" end))
' "$d"/tasks/*.json
old=$(jq -s --arg t "$today" 'map(.data // .) | map(select(.date < $t)) | length' "$d"/tasks/*.json)
[ "$old" -gt 0 ] && echo && echo "↪️ Хвосты с прошлых дней: $old (в трекере)"
echo
jq -s -r 'def e: gsub("&";"&amp;") | gsub("<";"&lt;") | gsub(">";"&gt;");
  map(.data // .) | map(select((.track // "") != "Нетворкинг")) as $j
  | ($j | map(select(.status == "interview" or .status == "replied" or .status == "offer"))) as $hot
  | ($j | map(select(.status == "applied"))) as $ap
  | "<b>В работе</b> (интервью/ответ: \($hot|length), ждём ответа: \($ap|length))",
    ($hot[] | "🔥 " + (.company|e) + " — " + ((.title // "")|e) + " · " + .status),
    "",
    "<b>Ждём ответа, свежие</b>",
    ($ap | sort_by(.applied_at // .added) | reverse | .[0:12][] | "· " + (.company|e) + " — " + ((.title // "")[0:45]|e) + " (" + ((.applied_at // .added // "")[5:10] | split("-") | reverse | join(".")) + ")")
' "$d"/jobs/*.json
