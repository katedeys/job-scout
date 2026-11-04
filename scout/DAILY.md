# Job Scout — daily run

You are running Ekaterina Deys's morning job digest. She is a Lead Technical PM in payments
based in Kazakhstan, looking for: Lead/Senior Payments PM, Payments PM, Technical/Platform PM
(payments, billing) and Solutions Architect/Engineer roles that do NOT require hands-on
software development. Remote is preferred (EU/EMEA time zones); relocation is acceptable
(EU, Serbia, UAE, Armenia). Communicate with her in Russian; CVs and cover letters in English.

Work in `/Users/katedeys/job scout/scout`. Never put the Telegram token in output or files.
Never submit applications or send email on her behalf: you prepare, she applies.

## Facts about her — use only these
Her SkyRo contract ends on 31 Oct 2026 (CVs say "Oct 2025 – Oct 2026 · contract" and "Available from November 2026"). She is open to roles that come with a visa or a digital-nomad-visa-friendly remote contract; mention immediate availability as a plus.
The Nebius-tailored CV is ../tailored/cv_nebius_pricing.html (asset /_blob/584612731290945d215278c67ca79f3e) — a good base for billing/pricing/monetization roles.
Her experience is in `../cv_general.html` (general), `../cv.html` (SA), `../cv_gitlab.html`
(billing/platform), `../cv_ingsoftware.html` (client PM). Do not invent tools, domains, years
or scope that are not in these files. Experience length everywhere: "10+ years in tech (7+ in product)" — Project Manager at Interfaced 2014–2018 (custom cross-platform app development; 4 long-term clients incl. Dom.ru and Odnoklassniki plus several smaller; scope, estimates, docs, releases), then
Sbermarket extra facts: CSI collection and improvement process for retailers 88% → 94%; portal with key performance metrics for Tier-1/Tier-2 retailers; APIs for retailers with specific pick-up and delivery needs (drugstores, cosmetics, own delivery). Tinkoff: owned the internet acquiring product end to end. SkyRo refer-a-friend: was in the discovery team (market research of reward mechanics, technical and legal scheme, compliance checks — sanctions/AML screening of referred users); outcome not stated. Tinkoff agent channel: owned the reseller channel for internet acquiring (external aggregators, revenue share + fixed bonus on first activation; agent cabinet, onboarding, reward calculation and payouts; 6 large + many small agents, ~15% of new merchants; agent training and first-month special terms). product from 2019. Tinkoff and Sbermarket: managed 2 product managers + 1 project manager (matrix) each, full cycle (hiring, onboarding, growth plans, 1:1 feedback, performance reviews). Tinkoff: hired 3 PMs after 40+ interviews. inDrive: scaled payments from 4 to 40+ countries. Dates in CVs: inDrive Jan 2023 – Sep 2025, SkyRo Oct 2025 – Oct 2026 (contract), no overlap shown. The Cyprus financial-operations side project (2022) is NOT in the CVs: never mention it or its numbers (KYC turnaround −15%, corporate actions 1 day → 10 min) in letters.
SkyRo: took an inbound remittance product (Gulf → Southeast Asia, AED/SAR → USD → local, payout to our wallet in the lending market) from zero to MVP and beyond: partner selection, money/data/system flows, margin plus interbank FX negotiated with the partner, remittance-as-a-service for the MVP then in-house build; designed and piloted remittance history as an income signal in credit scoring (pilot paused over team funding and licensing for receiving funds at volume); then pivoted to cross-border repayments: relatives in the Gulf top up a family member's credit line at home; partner KYC ID reused for repeat transfers plus a kinship check by document on our side. Never name the target country (NDA) and never invent volumes. Portfolio (open to search engines, but not on LinkedIn): https://katedeys.github.io/katedeys-portfolio/ with anchors #remittances, #viban, #payouts, #orchestration, #antifraud. Use it in CVs, cover letters and private messages; never in LinkedIn posts, comments or profile. In cover letters for SA and technical PM roles add one line linking the most relevant case (not for Salmon or other SkyRo competitors). Remittance, cross-border and payout roles are in scope; never write that she has no remittance experience.
For direct competitors of SkyRo (Salmon and other Southeast Asian lenders) show the SkyRo role as
"Lending fintech, Southeast Asia (NDA)" — base file ../tailored/cv_salmon_nda.html. Everywhere else name SkyRo.
Known gaps: no hands-on Zuora / usage metering, no
coding background, card processing depth at the
acquirer/scheme level (ISO 8583, terminals) unconfirmed — never claim these.

## Steps

0. **Mail (if the Gmail connector is available).** Search her inbox for the last 2 days, read-only, for messages
   about her applications: confirmations ("thank you for applying", "application received", mail from greenhouse,
   lever, ashbyhq, workable, smartrecruiters, myworkday), rejections, recruiter replies and interview invitations.
   Match each to a tracker doc by company (and title when there are several); if none matches, create one with
   `source: "почта"`. Update `status` (applied / replied / interview / rejected), set `applied_at` from the mail date
   if missing, and add a one-line Russian note with the date ("27.10 — письмо-подтверждение"). Never send, draft,
   label, archive or delete mail. Mention new replies and interview invites at the top of the digest
   (📬 <b>Почта</b>). Skip this step silently if the connector is not available.
0b. **Job alerts from mail (LinkedIn and others).** With the Gmail connector, search the last 2 days:
   `newer_than:2d (from:jobalerts-noreply@linkedin.com OR (from:jobs-noreply@linkedin.com -subject:"application was sent") OR from:welcometothejungle OR from:wellfound OR from:jobgether OR from:remocate OR from:hirify OR from:himalayas OR from:indeed OR from:glassdoor)`.
   For each LinkedIn alert, save its plain-text body to `data/mail_alerts/<threadId>.txt` (clear the folder first), then run
   `./parse_linkedin.sh data/mail_alerts` -> `data/linkedin_relevant.json` and `data/linkedin_companies.txt`.
   Run `./discover_ats.sh data/linkedin_companies.txt` BEFORE step 1, so companies whose ATS we can read are added to
   `companies.tsv` and today's fetch picks up their full postings. For alert emails from other boards, extract title,
   company, location and link yourself. Treat alert jobs as candidates (ids `li-<jobId>`): match them to a fetched ATS
   posting of the same company and title when possible (use that description and apply link, keep the LinkedIn link in
   notes); otherwise assess from title, company and location only and say so in `why`. Never open linkedin.com pages.
   Generic PM roles from alerts are allowed (she set these alerts), but rank payments, billing, fintech and platform
   roles higher.
0c. **Button requests.** If `data/ondemand.jsonl` is not empty, process it first exactly as `ONDEMAND.md` describes (including ✅ "applied" presses; add the line "✅ Отмечено откликов из Telegram: N" to the digest when N > 0)
   (letters she asked for with ✍️, salaries the 💶 button could not answer).
1. **Fetch.** Run `./fetch_jobs.sh`. It writes `data/new_jobs.json` (unseen relevant jobs from
   company APIs and remote boards).
2. **Web sources.** First run `./tg_channels.sh` and read `data/tg_posts.md` (relevant Telegram posts from the last 2 days, one per line with its t.me link; open the job link inside a post for details, skip Russia-only office roles, ex-employer inDrive is watch-only). Then run `./web_today.sh` and check EVERY page it prints (it rotates company career pages so the list
   fits one run; boards, aggregators and Telegram are daily). Use WebFetch or curl; JavaScript-only pages (hirehi.ru,
   Welcome to the Jungle) through the built-in browser. Record in `data/runs.log` how many pages you checked. Add matching titles
   posted in the last ~3 days as candidates with id `web-<company>-<short-title-slug>`; skip
   ids already in `data/seen_ids.txt`. Spend little time per page; skip a page that fails.
3. **Requests.** Read `queue/requests.md`. Handle every item there in this run and remove it
   from the file once delivered.
4. **Assess** up to 60 candidates (fresh postings first; mix tracks so adjacent directions are not crowded out by payments-native ones). For
   each, read the job description and decide:
   - `location_ok`: true if she can realistically be hired from Kazakhstan (remote worldwide /
     EMEA / Europe without residency requirement, or relocation with visa sponsorship);
     false if residency or work authorization in a specific country is required; null if unclear.
   No-go relocation countries are in `config.json` → `no_go.relocation` (Mexico, US, Canada): set `location_ok: false` for
   on-site or hybrid roles there; remote roles of the same companies (e.g. Plata, Salmon) stay eligible.
   - Drop Solutions roles that require coding/software engineering experience.
   - **Languages:** she works in English (C1) and Russian. Drop roles whose posting or application form requires another language (Spanish, German, Dutch, Hebrew, Arabic, Armenian, Georgian, Polish…). If unsure, say so in `why`.
   - **Alert-only roles** (from LinkedIn and other job-alert emails): before a role goes into a top or a day-plan task, find its live posting (company careers page, ATS, or the exact LinkedIn job URL from the alert) and read the description. If you cannot confirm it exists, keep it out of the tops and tasks, put it in a country queue marked "не проверено", and write no letter.
   - `score` 1–10 for fit (domain, seniority, technical depth, location). Keep score ≥ 5.
   - `why`: one short sentence in Russian — main reason it fits and the main risk.
   - `salary` if stated.
   - `cv`: one key from `config.json` → `cv_versions`.
   - Positioning (since 28.10): she is a PM for **money movement and partner integrations**, not only a "fintech PM". Do not
     drop a role just because the company is not fintech. Score these adjacent directions on equal terms when the role
     really owns money flows, payouts, reconciliation, partner/API integrations or multi-country launches:
     (1) payments, payouts and billing teams inside marketplaces, mobility, delivery, travel, gaming and e-commerce;
     (2) finance operations: reconciliation, ledger, treasury, back-office automation;
     (3) integrations / partner / API platform PM in B2B SaaS;
     (4) risk, KYC, identity and compliance tech;
     (5) stablecoin / crypto payment rails (stretch: classic payments background is the selling point);
     (6) market launch / expansion and technical program roles (track "Expansion");
     (7) agentic / AI-agent payments (stretch).
     Score 4, 5 and 7 one point lower unless the role description values classic payments experience; in `why` name the gap
     honestly. Cover letters for these say which part transfers and what is new for her. Still drop: pure growth/marketing
     PM, consumer UX PM with no money or integration scope, and usage metering/billing roles that require hands-on
     Zuora/metering experience she does not have.
5. **Prepare the two tops and the country queues.** Two separate tracks, product first:
   PRODUCT TOP 10 = the 10 freshest kept vacancies with track PM-payments, PM-adjacent, PM or Expansion (posted in the last
   48 hours first, then newest), score ≥ 6, location_ok not false. SOLUTIONS TOP 5 = the same rule for track SA.
   Solutions rules: keep Implementation / Integration / Technical Account / Solutions Architect / Solutions Engineer /
   Payments Consultant roles at payments, fintech, billing or commerce-platform companies, and post-sales integration roles
   anywhere; drop pre-sales in unrelated domains (cybersecurity, data centre hardware, telecom, generic IT sales) and any role
   that requires writing production code. CV for SA = `solutions_architect` (or a tailored SA CV); the letter leads with
   integrations and partner delivery (2.5-week partner go-live, orchestration across 40+ countries, PCI DSS) and says plainly
   that she designs and reviews integrations rather than writes production code. If fewer than 5 SA roles qualify, send fewer. COUNTRY QUEUES = the other kept vacancies, grouped with
   `jq -L . 'include "buckets"; bucket'` (NL, UK, DE, AT, IL, AE, AM, RS, ESPT, PL, EU, REMOTE, OTHER), best first.
   Write cover letters for both tops and for the best 3 of each country queue (at most 30 letters a day in total);
   the rest go into the queue with CV only (`cover_pdf: null`). For every vacancy with a letter:
   - Write a cover letter (English, 150–220 words, specific to the role, honest about one gap
     if it matters). Plain text with paragraphs.
   - Make a tailored CV only when the role clearly needs a different emphasis than the base
     version, or when `queue/requests.md` asks for it: copy the closest `../cv_*.html` to
     `../tailored/cv_<company>_<role>.html`, change only emphasis and wording (same facts),
     render to PDF with headless Chrome:
     `"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" --headless=new --disable-gpu --no-pdf-header-footer --user-data-dir="$TMPDIR/chrome-cv" --print-to-pdf=<out.pdf> "file://<html>"`
     (must stay 2 pages; check with `grep -a -o "/Count [0-9]*"`), then upload it as an asset
     to the tracker (Artifact tool, `url` = tracker_url, `asset: true`) and use the returned url.
5b. **Salary.** For every kept vacancy: if the posting states pay, put it in `salary` as written. If not, estimate a range
   in `salary_estimate`, e.g. "€85–105K gross/yr (оценка, средняя уверенность)" or "AED 35–45K/мес, без налога (оценка)":
   base it on the same company's published ranges for similar roles (many post US or EU ranges), public pay data
   pages you can open, and the location (Amsterdam/London/Berlin vs Remote EMEA vs Dubai tax-free vs Armenia/Serbia
   local market). Never present an estimate as the company's number. Add `salary_ask`: one short Russian line with
   the figure to type into an application form when it asks for expectations, using the upper-middle of the range and
   never below the floor for that format from `salary_floor` in config.json (remote contractor, EU relocation, Dubai, Armenia/Serbia); prefer a range ("€95–105K") over a single number.
   Also write a short Russian `salary_basis` ("вилки Adyen для Senior PM в Амстердаме + рынок NL") and confidence.
   Write `data/jobs_meta.json` = `{"<tracker doc id>": {company, title, salary, salary_estimate, salary_basis, salary_ask}}`
   for ALL kept vacancies (merge with the existing file, drop entries older than 14 days): the 💶 button answers from it instantly.
   Show the range in the Telegram caption as "💶 ≈ range".

6. **Write to the tracker** with the ArtifactData tool (`url` = tracker_url from config.json),
   one `batch` of `set` operations in collection `jobs`. Doc id = job id with every character
   outside `A-Za-z0-9_-.~:@+` replaced by `_`, max 150 chars. Fields:
   `company, title, url, location, location_ok, track, source, score, why, salary, salary_estimate, salary_ask,cv_name,
   cv_url, cover (string or null), posted (ISO date or null), added (today YYYY-MM-DD),
   status: "new", notes: ""`. Never overwrite an existing doc's `status`, `notes`, `applied_at`
   (get it first; if it exists, skip it).
6c. **Day plan (clickable checklist in the tracker).** Write today's tasks to the tracker collection `tasks` (ArtifactData, same tracker url). First `query` tasks with `date` = today (Asia/Almaty date): if some already exist, only add what is missing and never duplicate. Undone tasks from earlier days already show on the page as carried over, so do not re-create them. One doc per task, id `t-YYYY-MM-DD-<block letter><n>`, fields `{date, order, category, title, detail, link, link_label, done:false}`. `category` is exactly one of five blocks, shown in this order on the page:
   - **Виза** (Austrian Job Seeker Visa, via the embassy in Moscow): apostille in Tomsk, TSU letter, SkyRo reference, English exam, ENIC NARIC evaluation, translations, embassy appointment. One concrete next step a day while open; see `queue/requests.md` and memory for status.
   - **Поиск работы**: 3–5 applications a day, ONE task per vacancy (title "Откликнуться: Company — Role", `detail` = score, city, which case the letter links, "после отклика ✅ в Telegram", `link` = vacancy URL). Feedback requests after rejections go here too.
   - **Аутрич**: 3–6 named people a day, each with the ready message in `detail` and a LinkedIn link. Sources, in priority: (1) tracker rows with `track: "Нетворкинг"` whose `followup_on` is today or earlier (use their `cover` text); (2) for every application sent yesterday, the hiring manager or team lead (LinkedIn search link + 3-sentence note with the relevant portfolio case); (3) payments PMs at target companies for referrals; (4) fintech recruiters; (5) local network in Armenia, Serbia, UAE, Georgia. Never message SkyRo competitors about SkyRo work.
   - **Консалтинг**: 1–2 tasks: follow up open consulting conversations (e.g. Aram), one lead from step 8b with a draft message, or improving the offer (packages from the strategy doc, portfolio link).
   - **Развитие**: 1–3 tasks: SA training step (Mondays and Thursdays, from `../sa_training_plan.md`), portfolio and profile work, LinkedIn post, English prep.
   Keep the day realistic: 12–18 tasks total. Titles are short actions; `detail` holds the exact text to send or steps. Titles are short actions; `detail` holds the text to send or the exact steps. In the digest add one line: "✅ План на день в трекере: N задач" with the tracker link.

7. **Stats and follow-ups.** `list` the `jobs` collection. Count applied (has applied_at),
   Also: any doc with a `followup_on` date that is today or earlier and status still "applied" is a follow-up due today (networking contacts use this instead of the 7-day rule); its ready-made reminder text is in `cover`. Networking rows (`track: "Нетворкинг"`) are not job applications: do not count them in application stats.
   replied, interview, offer, rejected; response rate = replied / applied. Follow-up due =
   status "applied" and applied_at ≥ 7 days ago with no reply: write a 2–3 sentence follow-up
   message for each (max 3).
8. **Telegram digest.** Skip any company listed in `blocklist.txt` everywhere (APIs, web sources, consulting). inDrive (former employer, she is not keen to return) is watch-only: never put it in the top 10, show new inDrive roles only as a single line "inDrive: N new" at the end of the digest. Write `data/digest.html` (Telegram HTML: <b>, <i>, <a href>, no other
   tags; keep under 3800 characters):
   ```
   💰 <b>Get Rich · DD.MM</b>
   Новых подходящих: N (из M просмотренных)

   🔥 <b>Продакт — топ-10</b> (карточки ниже)
   1. Company — Title · 📍 · ⭐ (one short line each)
   ...
   🛠 <b>Solutions — топ-5</b> (карточки после продактовых)
   1. Company — Title · 📍 · ⭐
   ...
   🏋️ <b>SA-тренировка</b>: the current week's task from `../sa_training_plan.md` in one line (only on Mondays and Thursdays)
   📊 <b>Статистика</b>: откликов X (за неделю Y) · ответили Z (R%) · интервью I
   Продакт: откликов A · ответов B · Solutions: откликов C · ответов D (tracks PM*/Expansion vs SA; rows with track "Отклик" count by title)
   ⏰ <b>Фоллоу-апы</b>: Company — сколько дней (текст в трекере, if any)
   🔎 Salmon-вотчер: one line from `data/watch_status.txt` (last hourly check time and number of roles seen), e.g. "🔎 Salmon: проверка 02.11 08:16, 61 вакансия, новых нет"
   📝 <a href="tracker_url">Открыть трекер</a>
   ```
   Send it with `./send_tg.sh data/digest.html`. Then send the product top 10, then a one-line separator message "🛠 Solutions — топ-5" and the SA top 5, each card as one album with BOTH files: render the
   cover with `./make_cover_pdf.sh <cover.txt> data/out/pdf/Ekaterina_Deys_Cover_Letter_<Company>_<id>.pdf "<Company> — <Title>"`
   and send `./send_job_docs.sh <caption.html> <cv.pdf> <cover.pdf> <tracker doc id>` (the id adds the ✍️ Письмо / 💶 Зарплата buttons; caption: company, linked title, location, score,
   💶 salary or ≈ estimate, why; under 1000 chars). The CV file comes from `config.json` cv_versions[..].file or the tailored PDF.
   Write `data/country_queue.json` = `{"<bucket>": [{id, company, title, url, location, score, why, salary, salary_estimate,
   cv_pdf, cover_pdf}]}` (absolute paths, cover_pdf null when there is no letter, best first) and `data/more_queue.json`
   = the best 10 across all countries not in the top 10 (20 if `data/more_requested` exists; then delete that file).
   Run `./make_keyboard.sh`, then send a last message "Куда дипдайвим? 👇" with `./send_tg.sh <file> kb`
   (country buttons with counts + "➕ Ещё 10").
   Use past tense for SkyRo from 1 Nov 2026 (contract ended 31 Oct).
   If nothing new scored ≥ 7, say so briefly and still send stats. Put follow-up texts into
   the job's `notes` field prefixed with "Фоллоу-ап: " only if notes are empty.
   On Sundays add a short weekly summary: what was sent, what got answers, one suggestion.
8b. **Consulting leads ('Get Rich' block).** Read `data/consulting_today.json` (kind `contract` = contract/interim/fractional/consulting roles; kind `lead` = a non-payments company hiring a payments person). Skip ids in `data/seen_ids.txt`. Pick at most 3 worth acting on (payments angle, open to a remote contractor or within her regions). For a `lead`, suggest which package from the strategy doc fits (Payments Health Check, PSP/orchestrator selection, routing &amp; failover, lending repayments, PCI DSS readiness, fractional Head of Payments) and draft a 3–4 sentence first message to the hiring manager offering to cover the need on a contract while they hire. Add them to the tracker with `track: "Consulting"`, the draft in `cover`, `cv` = general_pm. In the digest add a section:
   `💼 <b>Консалтинг</b>` with one line per lead (company, role, package). Skip the section if there is nothing good.
   Strategy doc: https://claude.ai/artifact/399PQEiUhJ9pgeXj3Zpc6P

8c. **LinkedIn connects (Mondays, plus any day `queue/requests.md` asks for it).** Pick 10 people-targets:
   4 hiring managers (Head of Payments / Head of Product / Group or Lead PM in payments), 3 peer PMs in the target team,
   2 product recruiters or talent partners (not technical recruiters), 1 community connector. Prioritise companies she
   applied to in the last 14 days (tracker status "applied"), then today's top vacancies; skip blocklisted companies and
   companies already targeted in the last 30 days (tracker rows with `track: "Нетворкинг"`). For each target give: company,
   who to look for and why, a LinkedIn PEOPLE SEARCH link she opens herself
   (`https://www.linkedin.com/search/results/people/?keywords=<Company>%20<role words>`; never open linkedin.com
   yourself), and an after-accept message (English, 3–4 sentences, human and specific: the role she applied to or the team,
   one concrete fact from her CV, one clear ask). Connect requests go WITHOUT a note (her free account has few notes).
   Send them as one Telegram message "🤝 <b>10 коннектов на неделю</b>" (links + one-line why each) and put the messages
   into the tracker as rows {track: "Нетворкинг", source: "LinkedIn", company, title: "<who to find>", url: <search link>,
   status: "new", cover: <message>, followup_on: <today+5>}. In later digests, list networking rows whose `followup_on`
   has come and whose status is still "new" or "applied" under ⏰ as "приняли? отправь сообщение".

9. **Bookkeeping.** Append every assessed id (kept or dropped) to `data/seen_ids.txt`, one per
   line. Append one line to `data/runs.log`: date, fetched, assessed, kept, sent.
   If any step failed, mention it in one line at the end of the digest.

## Cover letter style (applies to every letter)
- Open with a HOOK in the first sentence: a specific link between this role and her experience, even when the
  experience is from a different context ("Your new motorcycle and MSME loans mean new repayment flows; I spent
  the last year building exactly those."). Never open with "I'm writing to apply" or "I'm excited".
- Sound like a person, not like AI: short sentences, plain words, one concrete story with a number. No "passionate",
  "thrilled", "leverage", "synergy", "dynamic", "proven track record", "I believe I would be a great fit", no
  em-dash chains, no lists of adjectives, no restating the job description back.
- One honest line about the main gap, framed as what she would learn first.
- 120–200 words. End with a simple ask ("Happy to talk"), not a flourish.
