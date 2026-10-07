# Аудит безопасности и внесённые изменения

## Исходная ситуация

Код основан на открытом форке **ghostgram** (`ichmagmaus111/ghostgram`, GPL-2.0), который, в свою очередь, встроил в себя код форка **Swiftgram**. Аудит выявил, что приложение:

- отправляло на сторонний сервер **`api.swiftgram.app`**: device-token, Telegram user ID, App Store receipt и пользовательские настройки;
- имело **платную подписку / paywall** (StoreKit IAP), за которой были заперты многие функции;
- подтягивало настройки и локализацию с GitHub-репозиториев Swiftgram;
- использовало официальный `api_id = 8` Telegram (вместо собственного ключа).

Явного вредоносного кода (обфускации, зашитых IP, скрытого сбора данных) не обнаружено. Криптографический/сетевой слой Telegram не тронут.

## Что изменено

| Файл | Изменение |
|---|---|
| `Swiftgram/SGConfig/Sources/File.swift` | `api.swiftgram.app` / `my.swiftgram.app` заменены на `127.0.0.1` — трафик на чужой сервер отрезан |
| `Swiftgram/SGStatus/Sources/SGStatus.swift` | статус подписки по умолчанию `1 → 5` — все Pro-функции разблокированы |
| `Swiftgram/SGGHSettings/Sources/SGGHSettings.swift` | удалённая загрузка настроек отключена, URL → localhost |
| `Swiftgram/SGStrings/Sources/LocalizationManager.swift` | удалённая загрузка локализации отключена, URL → localhost |
| `Swiftgram/SGAPIWebSettings/Sources/File.swift` | загрузка/отправка настроек на сервер → заглушки |
| `submodules/TelegramUI/Sources/SharedAccountContext.swift` | `initSGIAP` всегда возвращает `nil` — подписка/StoreKit/paywall отключены |
| `submodules/TelegramUI/Sources/AppDelegate.swift` | убраны вызовы отправки чека (`postSGReceipt`) и удалённой проверки статуса подписки (`fetchSGStatus`) |

## Что сохранено

- **Ghost Mode** (скрытие прочтения/онлайна) — `GhostModeManager` + `MiscSettingsManager` (Always Online);
- **Anti-Delete** (защита от удаления сообщений) — `AntiDeleteManager`;
- **Send Delay** (отложенная отправка) — `SendDelayManager`;
- **обход view-once** и **локальная транскрипция голосовых**;
- stealth-режим сторис (флаг `canUseStealthMode` по умолчанию `true`).

Эти модули не зависят от сервера Swiftgram и не затронуты.

## Оставшиеся нюансы (не влияют на утечку данных)

- В `.strings`-файлах локализации остались текстовые ссылки `swiftgram.app/terms` — они показываются только в окне оплаты, которое больше не открывается.
- Отладчик **FLEX** линкуется только в debug-сборках (`compilation_mode: dbg`); в `release_arm64` отсутствует.
- `SGLogger` пишет логи локально на устройство (не в сеть).

## Что нужно сделать перед сборкой

1. Добавить собственные `api_id`/`api_hash` как секреты GitHub `API_ID`/`API_HASH` — они не должны храниться в исходном коде (см. [INSTALL.md](INSTALL.md)).
2. Задать свой `bundle_id` (секрет `BUNDLE_ID`).

> Лицензия: исходный код Telegram-iOS распространяется под GPL. Свой форк также нужно публиковать под открытой лицензией.
