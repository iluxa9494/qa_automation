# /Users/ilia/IdeaProjects/pet_projects/qa_automation/Dockerfile
# (оставляем логику как есть — она рабочая; фиксим именно tools/run_*.sh)
ARG SELENIUM_BASE_IMAGE=selenium/standalone-chromium:latest
ARG BUILDER_IMAGE=maven:3.9.6-eclipse-temurin-17

FROM ${BUILDER_IMAGE} AS builder
WORKDIR /app

COPY . .

RUN set -eux; \
    mvn -B -q -f formyProject/pom.xml -DskipTests test-compile; \
    mvn -B -q -f formyProject/pom.xml -DskipTests dependency:copy-dependencies \
      -DincludeScope=test -DoutputDirectory=formyProject/target/deps; \
    mvn -B -q -f databaseUsage/pom.xml -DskipTests test-compile; \
    mvn -B -q -f databaseUsage/pom.xml -DskipTests dependency:copy-dependencies \
      -DincludeScope=test -DoutputDirectory=databaseUsage/target/deps; \
    mvn -B -q -f restfulBookerLoad/pom.xml -DskipTests test-compile; \
    mvn -B -q -f restfulBookerLoad/pom.xml -DskipTests dependency:copy-dependencies \
      -DincludeScope=test -DoutputDirectory=restfulBookerLoad/target/deps

FROM ${SELENIUM_BASE_IMAGE}

USER root
WORKDIR /app

ENV DEBIAN_FRONTEND=noninteractive

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends ca-certificates curl python3 util-linux; \
    \
    pick_pkg() { \
      if apt-cache show "$1" >/dev/null 2>&1; then echo "$1"; else echo "$2"; fi; \
    }; \
    \
    A_SOUND="$(pick_pkg libasound2t64 libasound2)"; \
    A_ATK1="$(pick_pkg libatk1.0-0t64 libatk1.0-0)"; \
    A_ATKBR="$(pick_pkg libatk-bridge2.0-0t64 libatk-bridge2.0-0)"; \
    A_CUPS="$(pick_pkg libcups2t64 libcups2)"; \
    A_GTK3="$(pick_pkg libgtk-3-0t64 libgtk-3-0)"; \
    \
    apt-get install -y --no-install-recommends \
      xvfb \
      openjdk-17-jre-headless \
      libxaw7 libx11-6 libxext6 libxi6 libxtst6 libxrender1 libxrandr2 \
      libxcomposite1 libxdamage1 libxfixes3 libxcb1 libxss1 \
      "${A_SOUND}" "${A_CUPS}" libdrm2 libgbm1 \
      "${A_ATK1}" "${A_ATKBR}" "${A_GTK3}" \
      libnss3 libnspr4 fonts-liberation; \
    \
    rm -rf /var/lib/apt/lists/*; \
    apt-get clean

RUN set -eux; \
    JAVA_BIN="$(readlink -f "$(command -v java)")"; \
    JAVA_HOME_DIR="$(dirname "$(dirname "$JAVA_BIN")")"; \
    echo "export JAVA_HOME=$JAVA_HOME_DIR" > /etc/profile.d/java.sh; \
    echo 'export PATH="$JAVA_HOME/bin:$PATH"' >> /etc/profile.d/java.sh; \
    echo "JAVA_HOME=$JAVA_HOME_DIR" >> /etc/environment

COPY --from=builder /app/formyProject /app/formyProject
COPY --from=builder /app/databaseUsage /app/databaseUsage
COPY --from=builder /app/restfulBookerLoad /app/restfulBookerLoad
COPY --from=builder /app/tools /app/tools

RUN chmod +x /app/tools/run_formy.sh /app/tools/run_database.sh /app/tools/run_gatling.sh

COPY entrypoint-qa-dashboard.sh /entrypoint-qa-dashboard.sh
RUN chmod +x /entrypoint-qa-dashboard.sh

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

RUN mkdir -p /reports && chown -R seluser:seluser /reports
RUN chown -R seluser:seluser /app

ENV DISPLAY=:99
ENV JAVA_OPTS="-Xms128m -Xmx1024m"

USER seluser

ENTRYPOINT ["/bin/bash", "-lc"]
CMD ["/entrypoint-qa-dashboard.sh"]