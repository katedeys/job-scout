# Источники вакансий

## ATS-платформы (публичные API, без ключей)

| Код в companies.tsv | Платформа | Адрес |
|---|---|---|
| `gh` | Greenhouse | `boards-api.greenhouse.io/v1/boards/{slug}/jobs` |
| `lv` | Lever | `api.lever.co/v0/postings/{slug}?mode=json` |
| `ab` | Ashby | `api.ashbyhq.com/posting-api/job-board/{slug}` |
| `wk` | Workable | `apply.workable.com/api/v1/widget/accounts/{slug}` |
| `sr` | SmartRecruiters | `api.smartrecruiters.com/v1/companies/{slug}/postings` |
| `rc` | Recruitee | `{slug}.recruitee.com/api/offers/` |
| `pp` | Pinpoint | `{slug}.pinpointhq.com/postings.json` |
| `ps` | Personio | `{slug}.jobs.personio.de/xml` |
| `bh` | BambooHR | `{slug}.bamboohr.com/careers/list` |
| `tt` | Teamtailor | `{slug}.teamtailor.com/jobs.rss` |

**Ловушки:**
- Pinpoint отдаёт демо-доску («Head of DEI») для любого несуществующего адреса. В `discover_ats.sh` от этого стоит защита.
- Чужие компании с тем же slug встречаются часто: Kevin, Solaris, Mambu, Uber, Personio, Rippling, Omio, Allegro (тестовые или чужие доски). Перед добавлением смотри, какие вакансии реально приходят.
- SmartRecruiters отвечает «0 вакансий», а не ошибкой, если slug не тот.

## Доски вакансий

- **RemoteOK, Himalayas, Working Nomads, Remotive, landing.jobs** — встроены в `fetch_jobs.sh`.
- **staff.am** (Армения) — `staff_am.sh`, поиск по словам product, payment, fintech, solution architect, business analyst. Данные берутся из `__NEXT_DATA__` страницы.
- **Агрегаторы и сайты компаний** — список в `sources_web.md`, Claude смотрит их во время прогона (`web_today.sh` выдаёт страницы на сегодня).

## Telegram-каналы

`tg_channels.sh` читает публичное превью `t.me/s/<канал>` и берёт посты за 2 дня, где есть product, payments, fintech, billing или solutions, без джунов, разработчиков и рекламы курсов.

Каналы: product_jobs, forproducts, fintech_vacancy, evacuatejobs, remocate, relocateme, remotejobss, whynotremote. Список в начале скрипта.

## Почта

- **LinkedIn Job Alerts:** Белград, Ереван, Тбилиси, Барселона и другие. Разбирает `parse_linkedin.sh`, оценивает Claude.
- **Ответы компаний:** Claude находит их в Gmail и обновляет статусы в трекере.

## Фильтры (в начале fetch_jobs.sh)

| Переменная | Что делает |
|---|---|
| `PM` | Продуктовые названия: product manager / owner / lead / director, head of product, TPM, program manager |
| `PAY` | Платёжные слова, дают трек `PM-payments` |
| `ADJ` | Смежные слова: reconciliation, ledger, integrations, platform, KYC, risk, marketplace… Дают трек `PM-adjacent` |
| `SA` | Solutions, implementation, integration, TAM, pre-sales, partner solutions |
| `EXP` | Запуск и экспансия: launch, expansion, market entry, international |
| `GEO` | Подходящие локации: Европа, Израиль, Сербия, Армения, Грузия, ОАЭ, Казахстан |
| `NONGEO` | Удалёнка с привязкой к США, Канаде, Латинской Америке, Азии отсекается |

Одинаковые роли одной компании (company + title) склеиваются, так что дубли агрегатора Jobgether не размножаются.

## Как добавить компанию

Автоматически (бот сам найдёт ATS):

```bash
cd "/Users/katedeys/job scout/scout"
printf "Company One\nCompany Two\n" > /tmp/new.txt
./discover_ats.sh /tmp/new.txt     # найденные допишутся в companies.tsv с типом O, лог в data/discovered.log
```

Потом проверь новые строки и поставь тип `P` для платёжных компаний.

Вручную: добавь строку в `companies.tsv` через табы: `slug  Name  region  ats  type`.

## Как следить за компанией каждый час

Добавь строку в `watchlist.tsv` (`slug  name  ats`, поддерживаются `ab`, `gh`, `lv`). Слушатель раз в час проверяет эти компании и сразу шлёт 🚨 о новой подходящей роли.
