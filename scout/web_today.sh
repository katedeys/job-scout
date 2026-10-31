#!/bin/bash
# Prints today's web sources: all job boards, aggregators and Telegram channels every day, plus one third
# of the company career pages (rotating by day), so every page is checked at least every 3 days.
cd "$(dirname "$0")" || exit 1
day=$(( $(date +%j | sed 's/^0*//') % 3 ))
awk -v day="$day" '
  /^## / { sec=$0; next }
  /https?:\/\// {
    daily = (sec ~ /Job boards|aggregators|Telegram|Remote-first/)
    if (daily) { print "[daily] " $0; next }
    n++; if (n % 3 == day) print "[rotation " day "] " $0
  }' sources_web.md
