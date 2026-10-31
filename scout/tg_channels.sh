#!/bin/bash
# Collects posts from public Telegram channels (t.me/s web preview) from the last 2 days that look relevant
# (product / payments / fintech / solutions roles). Writes data/tg_posts.md for the daily web step.
cd "$(dirname "$0")" || exit 1
CHANNELS="product_jobs forproducts fintech_vacancy evacuatejobs remocate relocateme remotejobss whynotremote"
since=$(date -u -v-2d +%Y-%m-%d 2>/dev/null || date -u -d '2 days ago' +%Y-%m-%d)
out=data/tg_posts.md
for ch in $CHANNELS; do
  curl -sL -m 30 "https://t.me/s/$ch" | SINCE="$since" perl -0ne '
    my $since = $ENV{SINCE};
    for my $b (split /(?=data-post=")/, $_) {
      my ($post) = $b =~ /^data-post="([^"]+)"/ or next;
      my ($t) = $b =~ /tgme_widget_message_text[^>]*>(.*?)<\/div>/s; next unless defined $t;
      my ($d) = $b =~ /datetime="([0-9-]{10})/; next unless $d && $d ge $since;
      $t =~ s/<br\s*\/?>/ /g; $t =~ s/<[^>]+>//g; $t =~ s/&amp;/&/g; $t =~ s/&quot;/"/g; $t =~ s/&#39;/\x27/g; $t =~ s/&lt;/</g; $t =~ s/&gt;/>/g; $t =~ s/\s+/ /g;
      next unless $t =~ /(product\s*(manager|owner|lead)|продакт|владелец продукта|менеджер продукт|\bTPM\b|payment|платеж|платёж|fintech|финтех|billing|биллинг|solutions?\s+(architect|engineer)|pre-?sales|integration manager)/i;
      next if $t =~ /(junior|джун|стаж[её]р|intern\b|developer|разработчик|поток|курс|вебинар)/i;
      printf "- [%s] https://t.me/%s — %s\n", $d, $post, substr($t,0,600);
    }'
done | sort -t' ' -k3,3 -u | sort > "$out"
echo "tg_posts=$(grep -c '^- ' "$out")"
