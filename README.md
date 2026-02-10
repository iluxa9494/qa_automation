# qa_automation

Набор QA-проектов: UI, DB и нагрузочные тесты. На VPS проект используется как dashboard/статическая раздача отчётов, сами тесты выполняются в CI.

## Что внутри
- `formyProject` — UI автотесты
- `databaseUsage` — проверки MySQL/Mongo
- `restfulBookerLoad` — нагрузочные сценарии

## Стек
- Java 17, Maven
- Selenium, Cucumber, TestNG
- Gatling
- MySQL, MongoDB
- Docker

## Требования
- JDK 17+
- Maven 3.9+
- Docker + Docker Compose

## Запуск
### Локально
```bash
# UI
cd formyProject && mvn -B clean test

# DB
cd /path/to/qa_automation
./run_db_local.sh

# Load
cd restfulBookerLoad && mvn -B test
```

### Docker (полный прогон)
```bash
cd /path/to/qa_automation
./run_all_qa.sh
```

### VPS
На VPS постоянно работает только dashboard с отчётами (`/home/pet_projects/qa_automation/reports`).

## Конфигурация и env
- `MONGO_URI`
- `MYSQL_URL`
- `MYSQL_USER`
- `MYSQL_PASSWORD`
- `CHROMEDRIVER_PATH`
- `CHROME_BIN`

## Структура
- `formyProject/`
- `databaseUsage/`
- `restfulBookerLoad/`
- `tools/`
- `reports/`
- `run_all_qa.sh`, `run_db_local.sh`

## API / Endpoints / Swagger
Собственного API нет.
Нагрузочные тесты используют внешний API `restful-booker.herokuapp.com`.
Swagger/OpenAPI в проекте не ведется.

## БД и миграции
- Схема MySQL инициализируется SQL-скриптами тестов.
- Mongo коллекции подготавливаются тестами.
- Flyway/Liquibase не используются.

## Ограничения
- UI и load зависят от внешних ресурсов и сети.
- На VPS не держим always-on тест-раннеры; только отчеты/дашборд.
- Основной сценарий запуска тестов — CI, не VPS.
