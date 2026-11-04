# CV и письма

## Базовые версии

| Ключ в config.json | Исходник | PDF | Для чего |
|---|---|---|---|
| `general_pm` | `cv_general.html` | `Ekaterina_Deys_Lead_Technical_PM_Payments_CV.pdf` | Lead / Senior / Technical PM в платежах, по умолчанию |
| `solutions_architect` | `cv.html` | `Ekaterina_Deys_Payments_Solutions_Architect_CV.pdf` | SA, Solutions / Implementation / Integration, TAM |
| `billing_platform_pm` | `cv_gitlab.html` | `Ekaterina_Deys_Senior_PM_Billing_GitLab.pdf` | Billing, монетизация, platform PM |
| `client_pm` | `cv_ingsoftware.html` | `Ekaterina_Deys_Product_Manager_Ingsoftware.pdf` | Клиентский PM, требования, аутсорс |
| `salmon_nda` | `tailored/cv_salmon_nda.html` | `tailored/Ekaterina_Deys_Senior_PM_Billing_Monetization_Payments.pdf` | Конкуренты SkyRo: SkyRo скрыт как «Lending fintech, Southeast Asia (NDA)», без ссылки на портфолио |
| `pricing_monetization` | `tailored/cv_nebius_pricing.html` | `tailored/Ekaterina_Deys_PM_Pricing_Monetization_Nebius.pdf` | Pricing / monetization |

Под конкретную компанию: `tailored/cv_<company>_<role>.html` и PDF рядом. Факты те же, меняются акцент и формулировки.

## Единые факты (во всех версиях)

- Project Manager в Interfaced 2014–2018 (заказная мультиплатформенная разработка, 4 крупных клиента вроде Dom.ru и Одноклассников), продукт с 2019. Блока «Additional experience» (Кипр, 2022) в CV нет и в письмах его не упоминаем.
- **SkyRo**, Oct 2025 – Oct 2026, контракт: платёжная платформа под кредитные продукты, ремитансы с нуля до MVP и пивот в трансграничное погашение, история ремитансов как сигнал дохода в скоринге (пилот), асинхронные выплаты, Virtual IBAN со 100% автосверкой, интеграции партнёров за стабильные 2,5 недели.
- **inDrive**, Technical PM — Payments, Jan 2023 – Sep 2025 (в CV заканчивается до SkyRo, без пересечения): оркестрация с 4 до 40+ стран, ~$100K/мес экономии, SLA 96.4%, PCI DSS.
- **Tinkoff**: наняла 3 PM после 40+ интервью, менторская программа. Также Sbermarket, Drom.ru.
- В шапке: «Kazakhstan · Remote or relocation», email, LinkedIn, портфолио. Телефона нет.

Нельзя придумывать: объёмы ремитансов, страну проекта (NDA), опыт с Zuora или метерингом, написание продакшен-кода.

## Как пересобрать PDF

```bash
cd "/Users/katedeys/job scout"
"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" --headless=new --disable-gpu \
  --no-pdf-header-footer --user-data-dir="$TMPDIR/chrome-cv" \
  --print-to-pdf="$PWD/Ekaterina_Deys_Lead_Technical_PM_Payments_CV.pdf" "file://$PWD/cv_general.html"
grep -a -o "/Count [0-9]*" Ekaterina_Deys_Lead_Technical_PM_Payments_CV.pdf   # должно быть 2 страницы
```

После пересборки PDF нужно заново загрузить в хранилище трекера и обновить `asset_url` в `config.json`. Это делает Claude.

## Письма

- Английский, 120–200 слов, обычный текст с абзацами.
- **Первая фраза — зацепка:** конкретная связь роли с опытом. Не «I'm writing to apply» и не «I'm excited».
- **Человеческий тон,** без ИИ-клише: «thrilled», «leverage», «synergy», «proven track record» и т.п.
- **Одна честная строка про пробел** и что будешь учить первым.
- Для SA и технических PM — строка со ссылкой на подходящий кейс портфолио: `#orchestration`, `#remittances`, `#viban`.
- Письма пишутся только для глубоких 🎯 вакансий (⭐8+ или тёплый контакт) и по кнопке ✍️. Быстрые ⚡ — базовое CV и готовые ответы из `apply_pack.md`.
- В конце: доступна сразу, готовность к переезду в город вакансии, «Happy to talk».

PDF письма: `scout/make_cover_pdf.sh <txt> <out.pdf> "Company — Role" ["заголовок под именем"]`.
