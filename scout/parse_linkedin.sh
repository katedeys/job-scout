#!/bin/bash
# Usage: parse_linkedin.sh <dir with plain-text bodies of LinkedIn job-alert emails>
# Extracts every job card (title / company / location / "View job:" link) into data/linkedin_today.json.
# We never fetch linkedin.com pages: descriptions come from the company's own ATS when we can find it.
cd "$(dirname "$0")" || exit 1
perl -0ne '
  for my $blk (split /\n-{10,}\n/) {
    next unless $blk =~ m{View job: https://www\.linkedin\.com/comm/jobs/view/(\d+)};
    my $id = $1;
    my @l = grep { /\S/ && !/^(View job:|This company is actively hiring|Apply with resume|Your job alert for|Actively recruiting|\d+ connections?|Be an early applicant)/ } split /\n/, $blk;
    s/^\s+|\s+$//g for @l;
    my ($t,$c,$loc) = @l[0,1,2];
    next unless $t && $c;
    $loc //= "";
    for ($t,$c,$loc) { s/\\/\\\\/g; s/"/\\"/g; s/\t/ /g; }
    print qq({"id":"li-$id","company":"$c","title":"$t","location":"$loc","url":"https://www.linkedin.com/jobs/view/$id/","source":"LinkedIn alert","ctype":"O","region":"LinkedIn"}\n);
  }' "$1"/*.txt 2>/dev/null | jq -s 'unique_by(.id)' > data/linkedin_today.json
PM='(product (manager|lead|owner|director)|head of product|director of product|vp,? product|tpm|technical product|platform product)'
SA='(solutions? (architect|engineer|consultant)|pre-?sales|integration (architect|manager|lead)|implementation (manager|lead))'
jq --arg pm "$PM" --arg sa "$SA" '[.[] | (.title|ascii_downcase) as $t | select(($t|test($pm)) or ($t|test($sa))) | select(($t|test("intern|junior|associate product|marketing|designer"))|not)]' data/linkedin_today.json > data/linkedin_relevant.json
jq -r '.[].company' data/linkedin_relevant.json | sort -u > data/linkedin_companies.txt
echo "linkedin cards=$(jq length data/linkedin_today.json) relevant=$(jq length data/linkedin_relevant.json) companies=$(wc -l < data/linkedin_companies.txt | tr -d ' ')"
