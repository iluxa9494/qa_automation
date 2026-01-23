# Dockerfile
FROM debian:bookworm-slim

ARG DEBIAN_FRONTEND=noninteractive
ARG ALLURE_VERSION=2.29.0

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates curl unzip tar gzip \
    python3 \
    openjdk-17-jre-headless \
    maven \
    xvfb \
    chromium \
    chromium-driver \
    fonts-liberation \
    && rm -rf /var/lib/apt/lists/*

# ✅ Allure CLI (для генерации HTML отчёта на VPS/в CI)
RUN set -eux; \
    curl -fsSL -o /tmp/allure.tgz \
      "https://github.com/allure-framework/allure2/releases/download/${ALLURE_VERSION}/allure-${ALLURE_VERSION}.tgz"; \
    tar -xzf /tmp/allure.tgz -C /opt; \
    ln -s "/opt/allure-${ALLURE_VERSION}/bin/allure" /usr/local/bin/allure; \
    allure --version; \
    rm -f /tmp/allure.tgz

WORKDIR /app

COPY entrypoint.sh /entrypoint.sh
COPY entrypoint-qa-dashboard.sh /entrypoint-qa-dashboard.sh
COPY run_all_qa.sh /app/run_all_qa.sh

COPY tools /app/tools
COPY formyProject /app/formyProject
COPY databaseUsage /app/databaseUsage
COPY restfulBookerLoad /app/restfulBookerLoad
COPY docker-compose.ci.yml /app/docker-compose.ci.yml

RUN chmod +x /entrypoint.sh /entrypoint-qa-dashboard.sh /app/run_all_qa.sh \
    /app/tools/run_formy.sh /app/tools/run_database.sh /app/tools/run_gatling.sh

# ✅ Build-time compilation + deps (so /target/deps exists in the image)

# formyProject
RUN set -euo pipefail; \
    cd /app/formyProject; \
    mvn -B -q -DskipTests dependency:copy-dependencies -DoutputDirectory=target/deps; \
    mvn -B -q -DskipTests test-compile

# databaseUsage
RUN set -euo pipefail; \
    cd /app/databaseUsage; \
    mvn -B -q -DskipTests dependency:copy-dependencies -DoutputDirectory=target/deps; \
    mvn -B -q -DskipTests test-compile

# restfulBookerLoad (scala testCompile + deps for gatling main class)
RUN set -euo pipefail; \
    cd /app/restfulBookerLoad; \
    mvn -B -q -DskipTests dependency:copy-dependencies -DoutputDirectory=target/deps; \
    mvn -B -q -DskipTests test-compile

ENTRYPOINT ["/entrypoint.sh"]