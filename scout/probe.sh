#!/bin/bash
# Prints how many open jobs a company slug has on each supported ATS (empty = not found).
slug=$1
gh=$(curl -s -m 15 "https://boards-api.greenhouse.io/v1/boards/$slug/jobs" | jq -r '.jobs|length' 2>/dev/null)
lv=$(curl -s -m 15 "https://api.lever.co/v0/postings/$slug?mode=json" | jq -r 'if type=="array" then length else empty end' 2>/dev/null)
ab=$(curl -s -m 15 "https://api.ashbyhq.com/posting-api/job-board/$slug" | jq -r '.jobs|length' 2>/dev/null)
wk=$(curl -s -m 15 "https://apply.workable.com/api/v1/widget/accounts/$slug" | jq -r '.jobs|length' 2>/dev/null)
sr=$(curl -s -m 15 "https://api.smartrecruiters.com/v1/companies/$slug/postings" | jq -r '.totalFound' 2>/dev/null)
rc=$(curl -s -m 15 "https://$slug.recruitee.com/api/offers/" | jq -r '.offers|length' 2>/dev/null)
pp=$(curl -s -m 15 "https://$slug.pinpointhq.com/postings.json" | jq -r '.data|length' 2>/dev/null)
ps=$(curl -s -m 15 "https://$slug.jobs.personio.de/xml" | grep -c "<position>" 2>/dev/null)
bh=$(curl -s -m 15 "https://$slug.bamboohr.com/careers/list" | jq -r '.result|length' 2>/dev/null)
tt=$(curl -sL -m 15 "https://$slug.teamtailor.com/jobs.rss" | grep -c "<item>" 2>/dev/null)
echo "$slug gh=${gh} lv=${lv} ab=${ab} wk=${wk} sr=${sr} rc=${rc} pp=${pp} ps=${ps} bh=${bh} tt=${tt}"
