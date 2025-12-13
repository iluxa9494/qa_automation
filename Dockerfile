# Dockerfile

ARG SELENIUM_BASE_IMAGE=seleniarm/standalone-chromium:latest
FROM ${SELENIUM_BASE_IMAGE}

USER root
WORKDIR /app

# Java 17 + Maven + Xvfb
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
       xvfb \
       maven \
       openjdk-17-jdk-headless \
  && rm -rf /var/lib/apt/lists/*

# ✅ Автоматически выставляем корректный JAVA_HOME (arm64/amd64) и PATH
RUN set -eux; \
    JAVA_BIN="$(readlink -f "$(command -v java)")"; \
    JAVA_HOME_DIR="$(dirname "$(dirname "$JAVA_BIN")")"; \
    echo "Detected JAVA_HOME=$JAVA_HOME_DIR"; \
    echo "export JAVA_HOME=$JAVA_HOME_DIR" > /etc/profile.d/java.sh; \
    echo 'export PATH="$JAVA_HOME/bin:$PATH"' >> /etc/profile.d/java.sh; \
    echo "JAVA_HOME=$JAVA_HOME_DIR" >> /etc/environment

# Чтобы headless UI был стабильнее
ENV DISPLAY=:99

# Дефолты (переопределяются через docker compose env)
ENV FORMY_BASE_URL="https://formy-project.herokuapp.com"
ENV RESTFUL_BOOKER_BASE_URL="https://restful-booker.herokuapp.com"

# Иногда помогает снизить потребление памяти Maven в контейнере
ENV MAVEN_OPTS="-Xms128m -Xmx1024m"

COPY . .

CMD ["bash", "-lc", "echo 'Use docker compose services (formy-tests, database-tests, restfulbooker-load) to run tests.'"]