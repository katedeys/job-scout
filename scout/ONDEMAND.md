# Get Rich — on-demand requests (✍️ / 💶 / ✅ button presses)

Processed at the start of the morning run, or whenever Ekaterina asks in chat ("сделай письма", "посчитай зарплаты").

Work in `/Users/katedeys/job scout/scout`. FIRST run `test -s data/ondemand.jsonl && cat data/ondemand.jsonl`.
If the file is missing or empty, STOP immediately: reply "no requests" and do nothing else.

Otherwise move it aside (`mv data/ondemand.jsonl data/ondemand_processing.jsonl`) so new button presses are not lost,
and handle each line `{type, id, ts}` (skip duplicates of the same type+id). `id` is a doc id in the `jobs` collection
of the tracker (`tracker_url` in config.json); read it with the ArtifactData tool (`get`).

- `type: "cv"` — write a cover letter for that vacancy (English, 150–220 words, honest about one gap if it matters),
  using ONLY facts from `../cv_general.html` and the other `../cv_*.html` / `../tailored/*.html` files. Open the job URL
  (never linkedin.com) for the description when possible. Save it to the doc's `cover` (ArtifactData `update` with the
  version you read), render `./make_cover_pdf.sh <txt> data/out/pdf/Ekaterina_Deys_Cover_Letter_<Company>_<id>.pdf "<Company> — <Title>"`,
  and send `./send_job_docs.sh <caption.html> <cv.pdf> <cover.pdf>` with caption "✍️ Письмо готово: <b>Company</b> — Title".
  CV file: the doc's `cv_name` mapped through `config.json` cv_versions (or the tailored PDF), default general_pm.
- `type: "sal"` — estimate the salary range for that vacancy exactly as DAILY.md step 5b describes (company's own
  published ranges, public pay data you can open, location; never present an estimate as the company's number), and the
  figure to put in an application form, never below the floor for that format in `config.json` → `salary_floor`.
  Save `salary_estimate` and `salary_ask` to the doc and send a short Telegram message with `./send_tg.sh <file>`:
  "💶 <b>Company</b> — Title\n≈ range (уверенность: низкая/средняя/высокая)\nНа чём основано: one line\nЧто указать в анкете: …".

- `type: "applied"` — she pressed ✅ Откликнулась. Update the doc: `status: "applied"`, `applied_at` = the line's `ts`,
  and append "DD.MM — откликнулась (кнопка в Telegram)" to `notes`. Only if the current status is "new" (never move a
  doc backwards from replied/interview/offer/rejected). No Telegram message per item; DAILY.md mentions the count in
  the digest ("✅ Отмечено откликов из Telegram: N").

When done, delete `data/ondemand_processing.jsonl`. If one request fails, send a one-line Telegram note about it and
continue with the rest. Never print or write the Telegram token. Never send email or submit applications.

## Cover letter style (applies to every letter)
- Open with a HOOK in the first sentence: a specific link between this role and her experience, even when the
  experience is from a different context ("Your new motorcycle and MSME loans mean new repayment flows; I spent
  the last year building exactly those."). Never open with "I'm writing to apply" or "I'm excited".
- Sound like a person, not like AI: short sentences, plain words, one concrete story with a number. No "passionate",
  "thrilled", "leverage", "synergy", "dynamic", "proven track record", "I believe I would be a great fit", no
  em-dash chains, no lists of adjectives, no restating the job description back.
- One honest line about the main gap, framed as what she would learn first.
- 120–200 words. End with a simple ask ("Happy to talk"), not a flourish.
