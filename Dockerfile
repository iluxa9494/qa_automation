ARG SELENIUM_BASE_IMAGE=seleniarm/standalone-chromium:latest

FROM ${SELENIUM_BASE_IMAGE}

USER root
WORKDIR /app

RUN apt-get update && \
    apt-get install -y xvfb maven default-jdk-headless && \
    rm -rf /var/lib/apt/lists/*

ENV JAVA_HOME=/usr/lib/jvm/default-java
ENV PATH="${JAVA_HOME}/bin:${PATH}"

COPY . .

ENV DISPLAY=:99
ENV FORMY_BASE_URL="https://formy-project.herokuapp.com"
ENV RESTFUL_BOOKER_BASE_URL="https://restful-booker.herokuapp.com"

CMD ["bash", "-lc", "echo 'Use docker compose services (formy-tests, database-tests, restfulbooker-load) to run tests.'"]