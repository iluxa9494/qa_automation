# Dockerfile
ARG SELENIUM_BASE_IMAGE=selenium/standalone-chromium:latest
FROM ${SELENIUM_BASE_IMAGE}

USER root
WORKDIR /app

# --- helper: install package if it exists ---
# (чтобы не падать на разных базах: Ubuntu/Debian, t64/не t64)
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends ca-certificates curl; \
    \
    pick_pkg() { \
      # usage: pick_pkg pkg_t64 pkg_legacy
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
      maven \
      openjdk-17-jdk-headless \
      libxaw7 libx11-6 libxext6 libxi6 libxtst6 libxrender1 libxrandr2 \
      libxcomposite1 libxdamage1 libxfixes3 libxcb1 libxss1 \
      "${A_SOUND}" "${A_CUPS}" libdrm2 libgbm1 \
      "${A_ATK1}" "${A_ATKBR}" "${A_GTK3}" \
      libnss3 libnspr4 fonts-liberation; \
    \
    rm -rf /var/lib/apt/lists/*

# JAVA_HOME (точно JDK)
RUN set -eux; \
    JAVAC_BIN="$(readlink -f "$(command -v javac)")"; \
    JAVA_HOME_DIR="$(dirname "$(dirname "$JAVAC_BIN")")"; \
    echo "export JAVA_HOME=$JAVA_HOME_DIR" > /etc/profile.d/java.sh; \
    echo 'export PATH="$JAVA_HOME/bin:$PATH"' >> /etc/profile.d/java.sh; \
    echo "JAVA_HOME=$JAVA_HOME_DIR" >> /etc/environment

# reports writable
RUN mkdir -p /reports && chown -R seluser:seluser /reports

ENV DISPLAY=:99
ENV MAVEN_OPTS="-Xms128m -Xmx1024m"

# копируем репо внутрь образа (чтобы run_all_qa.sh был внутри)
COPY . .

RUN chown -R seluser:seluser /app
USER seluser

CMD ["bash", "-lc", "echo 'Use docker compose services to run tests'"]