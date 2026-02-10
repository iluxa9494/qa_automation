# qa_automation
Набор QA-автоматизаций: UI-тесты, проверки БД и нагрузочные тесты API. Проект удобен как для локального запуска, так и для CI (Jenkins).

## Технологический стек
- Java 17 (UI/Gatling) и target 8 (DB), Maven.
- Cucumber + JUnit 4, TestNG.
- Selenium WebDriver, WebDriverManager, Galen.
- Gatling (Scala DSL).
- MySQL, MongoDB.
- Docker, Docker Compose, Jenkins.

## Требования для запуска
- JDK 17 (рекомендуется для всего проекта; databaseUsage компилируется в target 8).
- Maven 3.x.
- Для локального UI: Chrome/Chromium + chromedriver.
- Для Docker-запуска: Docker + Docker Compose.

## Инструкция запуска
### Локально
UI (Formy):
```bash
cd formyProject
mvn -B clean test
```

DB (MySQL + MongoDB):
```bash
# поднимает БД локально через Docker и запускает тесты
./run_db_local.sh

# или вручную
export MONGO_URI="mongodb://localhost:27017"
export MYSQL_URL="jdbc:mysql://localhost:3306/test"
export MYSQL_USER="test"
export MYSQL_PASSWORD="test"
cd databaseUsage
mvn -B clean test
```
Скрипт использует `docker-compose.db.yml` в корне проекта.

Load (Gatling):
```bash
cd restfulBookerLoad
mvn -B test
```

### Docker
Полный прогон всех наборов тестов:
```bash
./run_all_qa.sh
```
Скрипт ожидает `docker compose` и сервисы `formy-tests`, `database-tests`, `restfulbooker-load`, `mongo`, `mysql` в compose-конфигурации.

## Конфигурация и переменные окружения
### formyProject
Файл `formyProject/src/main/resources/config.properties`:
- `driverType` (chrome)
- `url` (https://formy-project.herokuapp.com)
- `os` (macOS/windowsOS/linuxOS, сейчас не используется в коде)

Переменные окружения:
- `CHROMEDRIVER_PATH` (по умолчанию `/usr/bin/chromedriver`)
- `CHROME_BIN` (путь к бинарнику Chromium/Chrome, если не системный)

### databaseUsage
Переменные окружения:
- `MONGO_URI` (по умолчанию `mongodb://localhost:27017`)
- `MYSQL_URL` (по умолчанию `jdbc:mysql://localhost:3306/test`)
- `MYSQL_USER` (по умолчанию `test`)
- `MYSQL_PASSWORD` (по умолчанию `test`)

### Скрипты/репорты
- `RESET_DB=1` для `run_db_local.sh` (пересоздание volumes).
- `CUCUMBER_DB_JSON`, `CUCUMBER_UI_JSON`, `GATLING_GLOBAL_STATS_JSON`, `NESTED_OUT_JSON` для `tools/NestedReportGenerator`.

## Структура проекта
- `formyProject/` — UI-тесты (Cucumber + Selenium + Galen).
- `databaseUsage/` — тесты БД (MySQL + MongoDB).
- `restfulBookerLoad/` — нагрузочные тесты API (Gatling).
- `tools/` — утилиты (NestedReportGenerator).
- `reports/` — артефакты репортов (HTML/JSON).
- `run_all_qa.sh` — последовательный прогон всех наборов (Docker Compose).
- `run_db_local.sh` — локальный прогон БД (Docker Compose + Maven).

## Описание API / endpoints / Swagger
Собственного API в проекте нет. Нагрузочные тесты используют публичный сервис Restful Booker:
- Base URL: `https://restful-booker.herokuapp.com`
- Endpoints: `GET /ping`, `GET /booking`, `GET /booking/1`, `POST /auth`, `POST /booking`,
  `PUT /booking/1`, `PATCH /booking/1`, `DELETE /booking/1`
- Swagger/OpenAPI: не используется.

## Работа с БД и миграциями
- MySQL схема задается скриптом `databaseUsage/src/test/resources/mysql/init.sql`.
- MongoDB коллекции и документы создаются/изменяются прямо в тестах.
- Миграции (Flyway/Liquibase) не используются.

## Ограничения и допущения проекта
- Опора на внешние публичные сервисы: `formy-project.herokuapp.com`, `restful-booker.herokuapp.com`.
- UI-тесты запускаются в headless Chrome; требуется корректный драйвер.
- Docker образ UI ориентирован на Linux x86_64 (amd64).

## Supported environment
Primary supported runtime: **Linux x86_64 (amd64)** (VPS / CI)

⚠️ Apple Silicon (arm64, Mac M1/M2/M3):
- Not officially supported for UI (Selenium/Chromium) containers.
- If you must run locally, use emulation:
  `docker compose --profile ci up` (or set `platform: linux/amd64` in compose).
- Expect slower builds and possible browser/driver dependency issues.
