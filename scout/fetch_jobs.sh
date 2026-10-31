#!/bin/bash
# Pulls open jobs from every company in companies.tsv, keeps relevant titles,
# and writes data/jobs_today.json plus data/new_jobs.json (not seen before).
cd "$(dirname "$0")" || exit 1
mkdir -p data
tmp=$(mktemp -d)

PM='(product (manager|lead|owner|director)|head of product|director of product|vp,? product|tpm|technical program manager|program manager)'
# Adjacent domains where her money-movement / integrations experience transfers (track "PM-adjacent")
ADJ='(reconcil|settlement|disburse|remittance|cross-border|\bfx\b|stablecoin|crypto|money|financ|fin ?ops|risk|kyc|identity|compliance|trust|integration|partner|\bapi\b|marketplace|payroll|invoic|expense|tax|subscription|revenue|commerce|seller|driver|courier|supplier|expansion|launch|platform|onboarding|agentic)'
# Market launch / expansion roles (track "Expansion")
EXP='((launch|expansion|market entry|new markets?|international) (manager|lead|director|head)|head of (expansion|international|new markets))'
PAY='(payment|billing|pricing|fraud|checkout|acquir|orchestrat|payout|money movement|treasury|ledger|monetiz|card|issuing|lending|credit|wallet|merchant|fintech|transaction|psp)'
SA='(solutions? (architect|engineer|consultant)|sales engineer|pre-?sales|integration (architect|manager|lead)|technical account manager|implementation (manager|lead|consultant)|solutions? (lead|manager)|partner (solutions|integrations?|engineering) (manager|lead)|merchant onboarding)'
GEO='(europe|israel|tel aviv|tel-aviv|herzliya|jerusalem|haifa|ramat gan|petah tikva|austria|wien|graz|linz|emea|eu\b|uk\b|united kingdom|london|ireland|dublin|netherlands|amsterdam|germany|berlin|munich|france|paris|spain|madrid|barcelona|portugal|lisbon|porto|italy|milan|rome|poland|warsaw|krakow|czech|prague|austria|vienna|switzerland|zurich|belgium|brussels|luxembourg|sweden|stockholm|denmark|copenhagen|norway|oslo|finland|helsinki|estonia|tallinn|latvia|riga|lithuania|vilnius|greece|athens|cyprus|limassol|malta|bulgaria|sofia|romania|bucharest|hungary|budapest|croatia|zagreb|serbia|belgrade|novi sad|armenia|yerevan|georgia|tbilisi|uae|dubai|abu dhabi|united arab emirates|kazakhstan|almaty|astana)'
NONGEO='(sydney|au - |buenos aires|chicago|americas|colombia|bogota|san francisco|new york|nyc|seattle|toronto|\bus\b|usa|united states|canada|us-remote|remote-us|india|singapore|australia|brazil|mexico|argentina|latam|apac|ontario|vancouver|seoul|korea|vietnam|ho chi minh|miami|tokyo|japan|kuala lumpur|malaysia|thailand|philippines|manila|indonesia|jakarta)'

while IFS=$'\t' read -r slug name region ats type; do
  [[ -z "$slug" || "$slug" == \#* ]] && continue
  case $ats in
    gh) curl -s -m 60 --retry 2 "https://boards-api.greenhouse.io/v1/boards/$slug/jobs" | jq -c --arg c "$name" --arg r "$region" --arg t "$type" \
          '[.jobs[]? | {id:("gh-"+(.id|tostring)), company:$c, region:$r, ctype:$t, title, location:(.location.name // ""), url:.absolute_url, updated:.updated_at, source:"company site"}]' ;;
    lv) curl -s -m 60 --retry 2 "https://api.lever.co/v0/postings/$slug?mode=json" | jq -c --arg c "$name" --arg r "$region" --arg t "$type" \
          '[.[]? | {id:("lv-"+.id), company:$c, region:$r, ctype:$t, title:.text, location:((.categories.location // "")+" "+(.workplaceType // "")), url:.hostedUrl, updated:((.createdAt/1000)|todate)}]' ;;
    ab) curl -s -m 60 --retry 2 "https://api.ashbyhq.com/posting-api/job-board/$slug" | jq -c --arg c "$name" --arg r "$region" --arg t "$type" \
          '[.jobs[]? | {id:("ab-"+.id), company:$c, region:$r, ctype:$t, title, location:((.location // "")+(if .isRemote then " (Remote)" else "" end)), url:.jobUrl, updated:.publishedAt}]' ;;
    wk) curl -s -m 60 --retry 2 "https://apply.workable.com/api/v1/widget/accounts/$slug" | jq -c --arg c "$name" --arg r "$region" --arg t "$type" \
          '[.jobs[]? | {id:("wk-"+.shortcode), company:$c, region:$r, ctype:$t, title, location:((.country // "")+" "+(.city // "")+(if .telecommuting then " (Remote)" else "" end)), url, updated:.published_on}]' ;;
    sr) curl -s -m 60 --retry 2 "https://api.smartrecruiters.com/v1/companies/$slug/postings?limit=100" | jq -c --arg c "$name" --arg r "$region" --arg t "$type" --arg s "$slug" \
          '[.content[]? | {id:("sr-"+.id), company:$c, region:$r, ctype:$t, title:.name, location:((.location.city // "")+", "+(.location.country // "")+(if .location.remote then " (Remote)" else "" end)), url:("https://jobs.smartrecruiters.com/"+$s+"/"+.id), updated:.releasedDate}]' ;;
    rc) curl -s -m 60 --retry 2 "https://$slug.recruitee.com/api/offers/" | jq -c --arg c "$name" --arg r "$region" --arg t "$type" \
          '[.offers[]? | {id:("rc-"+(.id|tostring)), company:$c, region:$r, ctype:$t, title, location:((.location // "")+(if .remote then " (Remote)" else "" end)), url:.careers_url, updated:.published_at, source:"company site"}]' ;;
    pp) curl -s -m 60 --retry 2 "https://$slug.pinpointhq.com/postings.json" | jq -c --arg c "$name" --arg r "$region" --arg t "$type" \
          '[.data[]? | {id:("pp-"+(.id|tostring)), company:$c, region:$r, ctype:$t, title, location:(((.location.city // "")+", "+(.location.name // ""))+(if .workplace_type=="remote" then " (Remote)" else "" end)), url, updated:null, source:"company site", salary:(if .compensation_visible then "\(.compensation_minimum)–\(.compensation_maximum) \(.compensation_currency) /\(.compensation_frequency)" else null end)}]' ;;
    ps) curl -s -m 60 --retry 2 "https://$slug.jobs.personio.de/xml" | perl -0ne 'while (/<position>(.*?)<\/position>/sg) { my $p=$1; my ($id)=$p=~/<id>(\d+)<\/id>/; my ($n)=$p=~/<name>([^<]*)<\/name>/; my ($o)=$p=~/<office>([^<]*)<\/office>/; print "$id\t$n\t$o\n" }' | \
          jq -R -s -c --arg c "$name" --arg r "$region" --arg t "$type" --arg s "$slug" '[split("\n")[] | select(length>0) | split("\t") | {id:("ps-"+.[0]), company:$c, region:$r, ctype:$t, title:.[1], location:.[2], url:("https://"+$s+".jobs.personio.de/job/"+.[0]), updated:null, source:"company site"}]' ;;
    bh) curl -s -m 60 --retry 2 "https://$slug.bamboohr.com/careers/list" | jq -c --arg c "$name" --arg r "$region" --arg t "$type" --arg s "$slug" \
          '[.result[]? | {id:("bh-"+$s+"-"+.id), company:$c, region:$r, ctype:$t, title:.jobOpeningName, location:(((.atsLocation.city // .location.city // "")+", "+(.atsLocation.country // ""))+(if .isRemote==true or .locationType=="1" then " (Remote)" else "" end)), url:("https://"+$s+".bamboohr.com/careers/"+.id), updated:null, source:"company site"}]' ;;
    tt) curl -sL -m 60 --retry 2 "https://$slug.teamtailor.com/jobs.rss" | perl -0ne 'while (/<item>(.*?)<\/item>/sg) { my $i=$1; my ($t)=$i=~/<title>(?:<!\[CDATA\[)?(.*?)(?:\]\]>)?<\/title>/s; my ($l)=$i=~/<link>(.*?)<\/link>/s; my ($d)=$i=~/<pubDate>(.*?)<\/pubDate>/s; my ($c)=$i=~/<tt:city>(.*?)<\/tt:city>/s; my ($r)=$i=~/<remoteStatus>(.*?)<\/remoteStatus>/s; $c||=""; $r||=""; $c.=" (Remote)" if $r=~/fully|remote/i; ($c)=$t=~/ - ([^-]+)$/ if !$c; $c||=""; for ($t,$l,$d,$c){ s/\t/ /g; s/\n/ /g } print "$t\t$l\t$d\t$c\n" }' | \
          jq -R -s -c --arg c "$name" --arg r "$region" --arg t "$type" '[split("\n")[] | select(length>0) | split("\t") | {id:("tt-"+(.[1]|capture("jobs/(?<n>[0-9]+)").n)), company:$c, region:$r, ctype:$t, title:.[0], location:.[3], url:.[1], updated:.[2], source:"company site"}]' ;;
  esac > "$tmp/$slug.json" &
done < companies.tsv

# Remote job boards with open APIs (company type O: PM roles need a payments keyword)
UA="Mozilla/5.0 job-scout"
curl -s -m 60 --retry 2 -A "$UA" "https://remoteok.com/api" | jq -c '[.[1:][]? | {id:("rok-"+(.id|tostring)), company:.company, region:"Remote", ctype:"O", title:.position, location:((.location // "")+" (Remote)"), url:.url, updated:.date, source:"RemoteOK"}]' > "$tmp/b_remoteok.json" &
for off in 0 100 200; do curl -s -m 60 --retry 2 -A "$UA" "https://himalayas.app/jobs/api?limit=100&offset=$off" | jq -c '[.jobs[]? | {id:("him-"+.guid), company:.companyName, region:"Remote", ctype:"O", title, location:(((.locationRestrictions // [])|join(", "))+" (Remote)"), url:.applicationLink, updated:(.pubDate|tostring), source:"Himalayas"}]' > "$tmp/b_him$off.json" & done
curl -s -m 60 --retry 2 -A "$UA" "https://www.workingnomads.com/api/exposed_jobs/" | jq -c '[.[]? | {id:("wn-"+.url), company:.company_name, region:"Remote", ctype:"O", title, location:((.location // "")+" (Remote)"), url, updated:.pub_date, source:"Working Nomads"}]' > "$tmp/b_wn.json" &
curl -s -m 60 --retry 2 -A "$UA" "https://remotive.com/api/remote-jobs?category=product" | jq -c '[.jobs[]? | {id:("rem-"+(.id|tostring)), company:.company_name, region:"Remote", ctype:"O", title, location:((.candidate_required_location // "")+" (Remote)"), url, updated:.publication_date, source:"Remotive"}]' > "$tmp/b_remotive.json" &
curl -s -m 60 --retry 2 -A "$UA" "https://landing.jobs/api/v1/jobs?limit=100" | jq -c '[.[]? | {id:("lj-"+(.id|tostring)), company:"(landing.jobs)", region:"EU", ctype:"O", title, location:(((.locations // [])|map(.city+", "+.country_code)|join("; "))+(if .remote then " (Remote)" else "" end)+(if .relocation_paid then " relocation paid" else "" end)), url, updated:.published_at, source:"landing.jobs"}]' > "$tmp/b_lj.json" &
"$(dirname "$0")/staff_am.sh" > "$tmp/b_staffam.json" &   # Armenia (staff.am)
wait
# A truncated or failed response must not break the whole run
for f in "$tmp"/*.json; do jq -e 'type=="array"' "$f" >/dev/null 2>&1 || { echo "skip: $(basename "$f" .json)" >&2; echo "[]" > "$f"; }; done

jq -s --arg geo "$GEO" --arg nongeo "$NONGEO" --arg pm "$PM" --arg pay "$PAY" --arg sa "$SA" --arg adj "$ADJ" --arg exp "$EXP" '
  add | map(select(.title != null)) |
  map(. as $j | ($j.title|ascii_downcase) as $t |
      select( ($t|test($sa)) or ($t|test($exp)) or (($t|test($pm)) and (($j.ctype|startswith("P")) or ($t|test($pay)) or ($t|test($adj))) ) ) |
      select( ($t|test("intern|working student|werkstudent|junior|associate product|new grad|product design|product marketing|product sales|designer|marketing")) | not ) |
      select( ($j.location|ascii_downcase) as $l | (($l|test("atlanta|georgia,? ?(us|usa|united states)"))|not) and ($j.ctype=="PA" or
        ($l|test($geo)) or (($l|test("remote|anywhere|worldwide|global")) and (($l|test($nongeo))|not))) ) |
      . + {track: (if ($t|test($sa)) then "SA" elif ($t|test($exp)) then "Expansion" elif ($t|test($pay)) or ($j.ctype|startswith("P")) then "PM-payments" elif ($t|test($adj)) then "PM-adjacent" else "PM" end)})
  | unique_by(.id) | unique_by([(.company|ascii_downcase), (.title|ascii_downcase|gsub("\\s+";" "))])' "$tmp"/*.json > data/jobs_today.json

# Consulting: contract/interim/fractional roles with a payments angle, plus non-payments companies
# hiring payments people (a sign they have a payments problem worth a consulting offer).
CONTRACT='(contract|contractor|freelance|interim|fractional|consultant|advisor|part-time)'
LEADROLE='(payments? (manager|lead|head|operations|specialist|analyst|partnerships)|head of payments|payment operations|psp|acquiring|checkout)'
jq -s --arg pay "$PAY" --arg con "$CONTRACT" --arg lead "$LEADROLE" '
  add | map(select(.title != null)) | map(. as $j | ($j.title|ascii_downcase) as $t |
    if ($t|test($con)) and ($t|test("(payment|billing|pricing|checkout|acquir|orchestrat|psp|product|implementation|integration|solutions?)")) and (($t|test("(recruit|care|sales|sdr|legal|people|office|collections|engineer|designer|marketing|compliance|creator|creative|erp|sap)"))|not) then . + {kind:"contract"}
    elif ($j.ctype=="O") and ($t|test($lead)) then . + {kind:"lead"}
    else empty end) | unique_by(.id)' "$tmp"/*.json > data/consulting_today.json

# Drop blocklisted companies
BLOCK=$(grep -v '^#' blocklist.txt | grep -v '^\s*$' | tr '[:upper:]' '[:lower:]' | jq -R . | jq -s .)
for f in data/jobs_today.json data/consulting_today.json; do jq --argjson b "$BLOCK" '[.[] | select((.company|ascii_downcase) as $c | ($b|index($c))|not)]' "$f" > "$f.tmp" && mv "$f.tmp" "$f"; done

touch data/seen_ids.txt
jq -c --rawfile seen data/seen_ids.txt '[.[] | select(.id as $i | ($seen | split("\n") | index($i)) | not)]' data/jobs_today.json > data/new_jobs.json
echo "fetched_total=$(jq -s 'add|length' "$tmp"/*.json) relevant=$(jq length data/jobs_today.json) new=$(jq length data/new_jobs.json) consulting=$(jq length data/consulting_today.json)"
jq -s 'add | map(select(.title != null))' "$tmp"/*.json > data/all_jobs.json 2>/dev/null
rm -rf "$tmp"
