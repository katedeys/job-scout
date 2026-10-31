# Установка на новом компьютере

## Что нужно

- macOS с Google Chrome (рендер PDF и проверки страниц в headless-режиме).
- Command Line Tools: `xcode-select --install` (git и стандартные утилиты).
- `jq` и `curl`: curl есть в macOS, jq поставляется в macOS 15+ или ставится отдельно.
- Приложение Claude (Code) с коннекторами Gmail и Claude Docs.

## Шаги

1. Клонировать репозиторий в `~/job scout` (пути в скриптах и `getrich.plist` рассчитаны на `/Users/katedeys/job scout`; на другом пользователе поправь их).
2. Создать секреты:
   ```bash
   cp secrets/telegram.env.example secrets/telegram.env
   # вписать TELEGRAM_BOT_TOKEN и TELEGRAM_CHAT_ID
   ```
   Chat id можно узнать скриптом `scout/tg_setup.sh` после того, как написала боту /start.
3. Создать папку данных: `mkdir -p scout/data/out/pdf`.
4. Запустить слушатель: `scout/install_listener.sh`.
5. В приложении Claude создать запланированную задачу `job-scout-daily`, каждый день в 9:05, промпт: «Run the daily job scout: follow /Users/katedeys/job scout/scout/DAILY.md exactly».
6. Проверить сбор: `cd scout && ./fetch_jobs.sh` — в конце строка `fetched_total=… relevant=… new=…`.

## Проверка, что всё работает

- `launchctl list | grep getrich` — слушатель жив.
- Написать боту `/more` — должен ответить.
- На следующее утро в `scout/data/runs.log` появится строка за день.
