# Git и GitHub

Репозиторий: `katedeys/job-scout` (**приватный**). Локальная папка `/Users/katedeys/job scout` и есть рабочая копия.

## Что не попадает в git (.gitignore)

- `secrets/` кроме `telegram.env.example` — токен бота.
- `scout/data/` кроме README — рабочие данные бота.
- `github-export/`, `.DS_Store`.

Перед каждым коммитом Claude проверяет, что в изменения не попал токен (шаблон `цифры:длинная строка`).

## Как отправляются изменения

После правок Claude делает коммит с понятным сообщением и `git push`. Вручную:

```bash
cd "/Users/katedeys/job scout"
git status
git add -A
git commit -m "Что поменялось"
git push
```

## Вход в GitHub

Пароль GitHub для git не подходит. Используется **fine-grained personal access token**:

1. GitHub → Settings → Developer settings → Personal access tokens → Fine-grained tokens → **Generate new token**.
2. Repository access: **Only select repositories** → `job-scout` и `katedeys-portfolio`.
3. Permissions → Repository permissions → **Contents: Read and write**.
4. При первом `git push` в терминале: Username — `katedeys`, Password — вставить токен.
   macOS запомнит его в Связке ключей (`credential.helper osxkeychain`), больше спрашивать не будет.

Токен вводишь только ты, в своём терминале. Claude его не видит и не хранит.

## Портфолио

`katedeys-portfolio` — отдельный публичный репозиторий. Его рабочая копия лежит в `portfolio/site-repo/`: Claude копирует туда `portfolio/site/index.html`, коммитит и пушит, GitHub Pages обновляет сайт.
