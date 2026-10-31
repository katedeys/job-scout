#!/bin/bash
# Armenia: staff.am keyword search (Next.js page data), all pages. Prints one JSON array.
UA="Mozilla/5.0 (Macintosh) AppleWebKit/537.36 Chrome/130 Safari/537.36"
for kw in product payment fintech "solution architect" "business analyst"; do
  q=$(printf %s "$kw" | sed 's/ /+/g')
  for page in 1 2 3 4 5; do
    j=$(curl -sL -m 40 --retry 2 -A "$UA" "https://staff.am/en/jobs?key_word=$q&page=$page" |
        perl -0ne 'print $1 if /<script id="__NEXT_DATA__"[^>]*>(.*?)<\/script>/s')
    n=$(printf %s "$j" | jq '.props.pageProps.jobs | length' 2>/dev/null)
    [ -z "$n" ] || [ "$n" = 0 ] && break
    printf %s "$j" | jq -c '[.props.pageProps.jobs[] | {id:("sam-"+(.id|tostring)), company:((.companiesStruct.title.en // "staff.am")|gsub("^\\s+|\\s+$";"")), region:"Armenia", ctype:"P",
      title:((.title.en // .title.ru // "")|gsub("&amp;";"&")|gsub("^\\s+|\\s+$";"")), location:((.job_city.title.en // "Yerevan")+", Armenia"+(if .is_remote==true then " (Remote)" else "" end)),
      url:("https://staff.am/en/jobs/"+(.category.code // "all")+"/"+(.slug.en // "")), updated:(.activated_at.staffam // null), source:"staff.am"}]'
    [ "$n" -lt 50 ] && break
    sleep 1
  done
done | jq -s 'add // [] | unique_by(.id)'
