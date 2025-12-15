# Dockerfile
ARG SELENIUM_BASE_IMAGE=seleniarm/standalone-chromium:latest
FROM ${SELENIUM_BASE_IMAGE}

USER root
WORKDIR /app

# Java 17 (JDK!) + Maven + Xvfb
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
       xvfb \
       maven \
       openjdk-17-jdk-headless \
  && rm -rf /var/lib/apt/lists/*

# ✅ Берём JAVA_HOME от javac, чтобы точно был JDK (а не JRE)
RUN set -eux; \
    JAVAC_BIN="$(readlink -f "$(command -v javac)")"; \
    JAVA_HOME_DIR="$(dirname "$(dirname "$JAVAC_BIN")")"; \
    echo "Detected JAVA_HOME=$JAVA_HOME_DIR"; \
    echo "export JAVA_HOME=$JAVA_HOME_DIR" > /etc/profile.d/java.sh; \
    echo 'export PATH="$JAVA_HOME/bin:$PATH"' >> /etc/profile.d/java.sh; \
    echo "JAVA_HOME=$JAVA_HOME_DIR" >> /etc/environment

# ✅ ВАЖНО: /reports должен быть writable для seluser (без bind-mount'ов в Jenkins)
RUN mkdir -p /reports \
  && chown -R seluser:seluser /reports

ENV DISPLAY=:99
ENV FORMY_BASE_URL="https://formy-project.herokuapp.com"
ENV RESTFUL_BOOKER_BASE_URL="https://restful-booker.herokuapp.com"
ENV MAVEN_OPTS="-Xms128m -Xmx1024m"

COPY . .

# ✅ важно: selenium base images ожидают запуск не под root
RUN chown -R seluser:seluser /app

USER seluser

CMD ["bash", "-lc", "echo 'Use docker compose services (formy-tests, database-tests, restfulbooker-load) to run tests.'"]