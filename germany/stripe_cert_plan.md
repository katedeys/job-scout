# Stripe-сертификация: что это и план подготовки (26.11)

Источники: stripe.training (каталог, страницы экзаменов, FAQ), docs.stripe.com/partners/training-and-certification.

## Факты

- Уровни: Fundamentals → Associate → Professional. Роли: Architect (тест с вариантами ответов) и Developer (задание на код через GitHub).
- Professional Architect теперь разделён на три: **Payments**, Billing, Platform.
- Architect-экзамен: 90 минут, 45–50 вопросов с вариантами ответов, онлайн с прокторингом (Certiverse), английский/японский.
- Бейдж выдают через Accredible, его можно повесить в LinkedIn.
- **Доступ:** для тех, кто не партнёр, обучение и сертификация «invite-only»: регистрироваться могут только одобренные организации. Партнёры заходят через Partner Portal (stripe.partners) → Training and certification, через SSO.
  → Путь: подать заявку в Stripe Partners (текст готов в partner_applications.md) → после одобрения сдавать из портала. Альтернатива: написать на partner-support@stripe.com и попросить гостевой доступ.
- **Цена:** на официальных страницах не указана. Сторонние сайты пишут «бесплатно»; судя по тому, что доступ идёт через Partner Portal, для партнёров это, скорее всего, входит в программу. Не подтверждено.
- **Партнёрский уровень Services:** нужны минимум двое сертифицированных *людей* (associate + professional или два professional). Одна она уровень Partner не закроет, но сертификат сам по себе: бейдж, доверие мерчантов, плюс в заявке и в откликах (например, Stripe Payment Methods EMEA).

## Associate Architect: темы и веса (официально)

| Тема | Вес | Что у неё уже есть | Что доучить в Stripe |
|---|---|---|---|
| Payments | 20% | оркестрация, статусы, PSP-интеграции | PaymentIntents, ручной/автоматический capture, Checkout vs Elements vs Payment Links |
| Connect | 15% | маркетплейсы (Sbermarket, Drom), выплаты (SkyRo) | типы аккаунтов (Standard/Express/Custom), destination charges vs separate charges & transfers |
| Billing | 10% | регулярные списания, ретраи | Subscriptions, invoices, proration, dunning, test clocks |
| Payment Methods | 10% | локальные методы в 40+ странах | как методы включаются в Dashboard/API, SEPA DD, iDEAL, Klarna, Wero |
| Declines, Disputes & Refunds | 10% | soft/hard declines, failover | коды отказов Stripe, процесс диспутов и evidence |
| Radar & Fraud | 10% | антифрод-интеграции | правила Radar, risk score, 3DS через Radar |
| Business Use Cases | 10% | e-com, SaaS, маркетплейсы | какой продукт Stripe под какую модель |
| API Patterns | 5% | идемпотентность, вебхуки, ретраи | идемпотентные ключи, подпись вебхуков, порядок событий |
| Reporting & Reconciliation | 5% | сверка (SkyRo, Sbermarket) | balance transactions, payout reconciliation, Sigma |
| Global Business & Compliance | 5% | PCI DSS SP, KYC/AML | SCA/PSD2, уровни PCI для мерчанта, Stripe Tax |

## План (≈2 недели по вечерам, после доступа)

1. **Неделя 1:** Payments + Connect + Payment Methods (45% экзамена). Docs: Payments → PaymentIntents, Connect → account types and charge types. Свести в шпаргалку «как это было в inDrive → как это в Stripe».
2. **Неделя 2:** Billing, Radar, disputes, API patterns, reporting. Практический тест на stripe.training (20 вопросов по Fundamentals) → затем экзамен.
3. **Потом:** Professional Payments Architect (темы: integration path, Connect, local methods, IC+ vs blended pricing, SCA/3DS, Terminal, migrations). Это прямо её профиль, плюс сильный аргумент для фриланса в DACH.

Без доступа можно начать уже сейчас: всё содержание тем есть в публичных docs.stripe.com.

## Вход в Stripe Partners (проверено 26.11, docs.stripe.com/partners)

- Требований по обороту, размеру компании или числу клиентов нет.
- Но с апреля 2026 базового уровня нет: все входят сразу в tier «Partner», а для Services там нужны **2 сертифицированных человека**. Сертификация для не-партнёров invite-only → замкнутый круг для соло.
- Форма требует: work email (gmail отклоняет), сайт компании, Stripe Account ID (нужен активированный аккаунт Stripe; Армения и Казахстан, насколько мне известно, не входят в страны Stripe — проверить).
- Вывод: Stripe Partners сейчас — низкий шанс. Приоритет: Mollie, Primer, Gr4vy. К Stripe вернуться через агентство-партнёра или когда будет команда.
