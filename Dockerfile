# Dockerfile
ARG SELENIUM_BASE_IMAGE=seleniarm/standalone-chromium:latest
FROM ${SELENIUM_BASE_IMAGE}

USER root
WORKDIR /app

# FIX: base image часто содержит apt sources на sid + bookworm → ломает зависимости chromium (t64)
RUN set -eux; \
  sed -i '/sid/d' /etc/apt/sources.list || true; \
  for f in /etc/apt/sources.list.d/*.list; do sed -i '/sid/d' "$f" || true; done

# Java 17 (JDK) + Maven + Xvfb + Chromium + Chromedriver + X11/AWT deps
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
       xvfb maven openjdk-17-jdk-headless \
       chromium chromium-driver \
       libxaw7 libx11-6 libxext6 libxi6 libxtst6 libxrender1 libxrandr2 \
       libxcomposite1 libxdamage1 libxfixes3 libxcb1 libxss1 \
       libasound2 libcups2 libdrm2 libgbm1 \
       libatk1.0-0 libatk-bridge2.0-0 libgtk-3-0 \
       libnss3 libnspr4 fonts-liberation \
  && rm -rf /var/lib/apt/lists/*

# на всякий случай (если бинарь окажется не /usr/bin/chromedriver)
RUN set -eux; \
  if [ ! -f /usr/bin/chromedriver ] && command -v chromedriver >/dev/null 2>&1; then \
    ln -s "$(command -v chromedriver)" /usr/bin/chromedriver; \
  fi

# ✅ Берём JAVA_HOME от javac, чтобы точно был JDK (а не JRE)
RUN set -eux; \
  JAVAC_BIN="$(readlink -f "$(command -v javac)")"; \
  JAVA_HOME_DIR="$(dirname "$(dirname "$JAVAC_BIN")")"; \
  echo "export JAVA_HOME=$JAVA_HOME_DIR" > /etc/profile.d/java.sh; \
  echo 'export PATH="$JAVA_HOME/bin:$PATH"' >> /etc/profile.d/java.sh; \
  echo "JAVA_HOME=$JAVA_HOME_DIR" >> /etc/environment

# ✅ /reports должен быть writable для seluser
RUN mkdir -p /reports && chown -R seluser:seluser /reports

ENV DISPLAY=:99
ENV MAVEN_OPTS="-Xms128m -Xmx1024m"

COPY . .

# selenium base images ожидают запуск не под root
RUN chown -R seluser:seluser /app
USER seluser

CMD ["bash", "-lc", "echo 'Use docker compose services (formy-tests, database-tests, restfulbooker-load) to run tests.'"]