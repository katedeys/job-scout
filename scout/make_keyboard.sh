#!/bin/bash
# Builds data/keyboard.json: one button per country bucket that has prepared vacancies ("🇳🇱 Нидерланды (6)"),
# two per row, plus "➕ Ещё 10" for the mixed reserve. Reads data/country_queue.json and data/more_queue.json.
cd "$(dirname "$0")" || exit 1
[ -s data/country_queue.json ] || echo '{}' > data/country_queue.json
more=$( [ -s data/more_queue.json ] && jq length data/more_queue.json || echo 0 )
jq -c -L . --argjson more "$more" 'include "buckets";
  [to_entries[] | select((.value|length) > 0) | {text: (bucket_label(.key) + " (" + (.value|length|tostring) + ")"), callback_data: ("c:" + .key)}]
  | sort_by(-(.text|capture("\\((?<n>[0-9]+)\\)$").n|tonumber))
  | [range(0; length; 2) as $i | .[$i:$i+2]]
  + (if $more > 0 then [[{text:"➕ Ещё 10 (все страны)", callback_data:"more"}]] else [] end)
  | {inline_keyboard: .}' data/country_queue.json > data/keyboard.json
jq -c '.inline_keyboard | flatten | map(.text)' data/keyboard.json
