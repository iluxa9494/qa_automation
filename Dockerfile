ARG SELENIUM_BASE_IMAGE=seleniarm/standalone-chromium:latest
FROM ${SELENIUM_BASE_IMAGE}

USER root
WORKDIR /app

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
       xvfb \
       maven \
       openjdk-17-jdk-headless \
       libxaw7 libx11-6 libxext6 libxi6 libxtst6 libxrender1 libxrandr2 \
       libxcomposite1 libxdamage1 libxfixes3 libxcb1 libxss1 \
       libasound2 libcups2 libdrm2 libgbm1 \
       libatk1.0-0 libatk-bridge2.0-0 libgtk-3-0 \
       libnss3 libnspr4 fonts-liberation \
  && rm -rf /var/lib/apt/lists/*

RUN set -eux; \
    JAVAC_BIN="$(readlink -f "$(command -v javac)")"; \
    JAVA_HOME_DIR="$(dirname "$(dirname "$JAVAC_BIN")")"; \
    echo "export JAVA_HOME=$JAVA_HOME_DIR" > /etc/profile.d/java.sh; \
    echo 'export PATH="$JAVA_HOME/bin:$PATH"' >> /etc/profile.d/java.sh; \
    echo "JAVA_HOME=$JAVA_HOME_DIR" >> /etc/environment

RUN mkdir -p /reports \
  && chown -R seluser:seluser /reports

ENV DISPLAY=:99
ENV FORMY_BASE_URL="https://formy-project.herokuapp.com"
ENV RESTFUL_BOOKER_BASE_URL="https://restful-booker.herokuapp.com"
ENV MAVEN_OPTS="-Xms128m -Xmx1024m"

COPY . .

RUN chown -R seluser:seluser /app
USER seluser

CMD ["bash", "-lc", "echo 'Use docker compose services (formy-tests, database-tests, restfulbooker-load) to run tests.'"]