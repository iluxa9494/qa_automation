#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

mkdir -p reports/formy reports/databaseUsage reports/gatling reports/nested reports/nested/attachments

docker_compose() {
  if docker compose version >/dev/null 2>&1; then
    docker compose "$@"
  elif command -v docker-compose >/dev/null 2>&1; then
    docker-compose "$@"
  else
    echo "❌ Docker Compose не установлен (ни 'docker compose', ни 'docker-compose' не найдены)." >&2
    exit 1
  fi
}

copy_reports_from_container() {
  local container_name="$1"
  local src_path="${2:-/reports}"
  local dst_dir="${3:-reports}"

  if docker ps -a --format '{{.Names}}' | grep -qx "$container_name"; then
    echo "▶ Copying reports from $container_name:$src_path -> ./$dst_dir ..."
    mkdir -p "$dst_dir"
    docker cp "${container_name}:${src_path}/." "${dst_dir}/" 2>/dev/null || true
    echo "▶ Removing container $container_name ..."
    docker rm -f "$container_name" >/dev/null 2>&1 || true
  else
    echo "⚠ Container $container_name not found — nothing to copy"
  fi
}

run_service_keep_container() {
  local service="$1"
  local container_name="$2"
  local clean_dir="$3"

  echo "▶ Running: $service (container: $container_name) ..."

  # убираем контейнер, если остался
  docker rm -f "$container_name" >/dev/null 2>&1 || true

  # чистим папку отчётов этого suite, чтобы не было stale
  rm -rf "$clean_dir"
  mkdir -p "$clean_dir"

  set +e
  docker_compose up --no-deps --abort-on-container-exit --exit-code-from "$service" "$service"
  local exit_code=$?
  set -e

  copy_reports_from_container "$container_name" "/reports" "reports"

  if [[ $exit_code -ne 0 ]]; then
    echo "⚠ $service failed (exit=$exit_code) — продолжаем"
  fi
  return 0
}

echo "▶ Building qa-tests image (Docker)..."
docker_compose build || echo "⚠ Docker build failed — продолжаем"

# ✅ В CI проще всего гарантировать “чистую” БД перед DB-suite
# (иначе init.sql может не примениться при непустом datadir)
echo "▶ Reset DB containers/volumes for clean init.sql ..."
docker_compose down -v --remove-orphans >/dev/null 2>&1 || true

run_service_keep_container "formy-tests"         "qa-formy-tests"           "reports/formy"
run_service_keep_container "database-tests"      "qa-database-tests"        "reports/databaseUsage"
run_service_keep_container "restfulbooker-load"  "qa-gatling-restfulbooker" "reports/gatling"

echo "▶ Checking expected report files..."
[[ -f reports/formy/cucumber.json ]] && echo "   ✔ reports/formy/cucumber.json" || echo "⚠ reports/formy/cucumber.json NOT found"
[[ -f reports/databaseUsage/cucumber.json ]] && echo "   ✔ reports/databaseUsage/cucumber.json" || echo "⚠ reports/databaseUsage/cucumber.json NOT found"
[[ -f reports/gatling/latest/index.html ]] && echo "   ✔ reports/gatling/latest/index.html" || echo "⚠ reports/gatling/latest/index.html NOT found"

echo "▶ Generating Nested HTML (reports/nested/index.html)..."
mkdir -p reports/nested

# Простой “агрегатор” без плагинов Jenkins: просто страница со ссылками на отчёты
cat > reports/nested/index.html <<'HTML'
<!doctype html>
<html lang="ru">
<head>
  <meta charset="utf-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <title>QA Summary (Nested)</title>
  <style>
    body { font-family: system-ui, -apple-system, Segoe UI, Roboto, Arial, sans-serif; padding: 16px; }
    .ok { color: #0a7; }
    .bad { color: #c33; }
    code { background: #f4f4f4; padding: 2px 6px; border-radius: 6px; }
  </style>
</head>
<body>
  <h1>QA Summary (Nested)</h1>
  <p>Сводная страница Jenkins-артефактов (UI / DB / Load).</p>

  <ul>
    <li>
      UI (Formy):
      <a href="../formy/cucumber-html-report/index.html">cucumber-html-report</a>
      (<code>reports/formy</code>)
    </li>
    <li>
      DB (databaseUsage):
      <a href="../databaseUsage/cucumber.html">cucumber.html</a>
      (<code>reports/databaseUsage</code>)
    </li>
    <li>
      Load (Gatling):
      <a href="../gatling/latest/index.html">latest/index.html</a>
      (<code>reports/gatling/latest</code>)
    </li>
  </ul>

  <h2>Наличие файлов</h2>
  <ul>
    <li id="ui"></li>
    <li id="db"></li>
    <li id="gatling"></li>
  </ul>

<script>
  async function exists(url) {
    try {
      const r = await fetch(url, { method: "HEAD" });
      return r.ok;
    } catch (e) {
      return false;
    }
  }
  (async () => {
    const ui = await exists("../formy/cucumber.json");
    const db = await exists("../databaseUsage/cucumber.json");
    const ga = await exists("../gatling/latest/index.html");

    const set = (id, ok, label) => {
      const el = document.getElementById(id);
      el.className = ok ? "ok" : "bad";
      el.textContent = (ok ? "✔ " : "✖ ") + label;
    };

    set("ui", ui, "reports/formy/cucumber.json");
    set("db", db, "reports/databaseUsage/cucumber.json");
    set("gatling", ga, "reports/gatling/latest/index.html");
  })();
</script>

</body>
</html>
HTML

echo "   ✔ reports/nested/index.html generated"

echo "✔ All QA test suites finished"
echo "📊 Reports directory structure:"
ls -la reports || true