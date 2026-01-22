// /Users/ilia/IdeaProjects/pet_projects/qa_automation/Jenkinsfile
pipeline {
    agent any

    // ✅ Schedule-as-code: run примерно раз в 10 минут (hash-based, чтобы не долбить ровно в минуту)
    triggers {
        cron('H/10 * * * *')
    }

    options {
        timestamps()
        skipDefaultCheckout(true)

        disableConcurrentBuilds()
        timeout(time: 30, unit: 'MINUTES')
        buildDiscarder(logRotator(
            numToKeepStr: '60',
            artifactNumToKeepStr: '60'
        ))
    }

    parameters {
        string(
            name: 'RUN_ID',
            defaultValue: '',
            description: 'Optional. If empty, uses /home/pet_projects/qa_automation/reports/LATEST'
        )
    }

    environment {
        QA_BASE = "/home/pet_projects/qa_automation/reports"

        // Jenkins connection (via nginx + SSL)
        JENKINS_URL = "https://jenkins.murashkin.dev"
    }

    stages {
        stage('Resolve RUN_ID') {
            steps {
                script {
                    def latest = sh(
                        script: "cat ${env.QA_BASE}/LATEST 2>/dev/null || true",
                        returnStdout: true
                    ).trim()

                    env.RESOLVED_RUN_ID = params.RUN_ID?.trim() ? params.RUN_ID.trim() : latest
                    if (!env.RESOLVED_RUN_ID) {
                        error("RUN_ID is empty and ${env.QA_BASE}/LATEST is empty. Nothing to ingest.")
                    }

                    echo "Using RUN_ID=${env.RESOLVED_RUN_ID}"
                }
            }
        }

        stage('Contract check (reports structure)') {
            steps {
                sh '''
                  set -eux

                  SRC="${QA_BASE}/runs/${RESOLVED_RUN_ID}"
                  echo "🔎 Checking reports contract in: $SRC"

                  if [ ! -d "$SRC" ]; then
                    echo "❌ Missing run folder: $SRC"
                    exit 2
                  fi

                  # Required directories (contract)
                  for d in databaseUsage formy gatling; do
                    if [ ! -d "$SRC/$d" ]; then
                      echo "❌ Missing required directory: $SRC/$d"
                      exit 3
                    fi
                  done

                  # Gatling contract: gatling/latest
                  if [ ! -d "$SRC/gatling/latest" ]; then
                    echo "❌ Missing required directory: $SRC/gatling/latest"
                    exit 4
                  fi

                  # JUnit contract: at least one XML should exist (any of the supported patterns)
                  if ! find "$SRC" -type f \\( \
                        -path "*/surefire-reports/*.xml" -o \
                        -path "*/surefire/*.xml" -o \
                        -name "TEST-*.xml" \
                      \\) -print -quit | grep -q .; then
                    echo "⚠️ No JUnit XML found under $SRC (surefire-reports/*.xml or surefire/*.xml or TEST-*.xml)."
                    echo "   Jenkins trend/passed-failed-skipped will be empty until you export JUnit XML into reports."
                  fi

                  echo "✅ Contract check passed (or warnings only)."
                '''
            }
        }

        stage('Import reports from VPS into workspace') {
            steps {
                sh '''
                  set -eux
                  rm -rf reports || true
                  mkdir -p reports
                  SRC="${QA_BASE}/runs/${RESOLVED_RUN_ID}"
                  cp -a "$SRC/." reports/
                '''
            }
        }

        stage('Debug: show imported structure') {
            steps {
                sh '''
                  set -eux
                  echo "📦 Imported reports structure (depth=4):"
                  (command -v tree >/dev/null 2>&1 && tree -L 4 reports) || find reports -maxdepth 4 -type f | sed 's#^# - #'
                '''
            }
        }

        // ✅ Credentials (Option A): single "Username with password" credential (ilia + API token)
        stage('Verify Jenkins API secrets (sanity)') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'jenkins_api',
                    usernameVariable: 'JENKINS_USER',
                    passwordVariable: 'JENKINS_API_TOKEN'
                )]) {
                    sh '''
                      set -euo pipefail

                      if [ -z "${JENKINS_URL:-}" ] || [ -z "${JENKINS_USER:-}" ] || [ -z "${JENKINS_API_TOKEN:-}" ]; then
                        echo "❌ Missing Jenkins secrets (JENKINS_URL/JENKINS_USER/JENKINS_API_TOKEN)."
                        exit 1
                      fi

                      echo "✅ Jenkins secrets are present (masked)."

                      # Optional: quick auth check (do not print token)
                      curl -sS -u "${JENKINS_USER}:${JENKINS_API_TOKEN}" "${JENKINS_URL}/api/json" >/dev/null
                      echo "✅ Jenkins API reachable with provided credentials."
                    '''
                }
            }
        }
    }

    post {
        always {
            // ✅ JUnit: источник passed/failed/skipped + trend (JUnit plugin) + анализатор
            // Contract expects at least one of these patterns to exist under reports/
            junit testResults: 'reports/**/surefire-reports/*.xml, reports/**/surefire/*.xml, reports/**/TEST-*.xml',
                  allowEmptyResults: true,
                  keepLongStdio: true

            // Сохраняем артефакты билда — это и есть «история» в Jenkins
            archiveArtifacts artifacts: 'reports/**', fingerprint: true, allowEmptyArchive: true

            // Главный index (если он реально приезжает в reports/)
            publishHTML(target: [
                allowMissing:          true,
                alwaysLinkToLastBuild: true,
                keepAll:               true,
                reportDir:             'reports',
                reportFiles:           'index.html',
                reportName:            'QA Dashboard'
            ])

            // Formy: ожидаем HTML в reports/formy/index.html (сейчас может отсутствовать — allowMissing=true)
            publishHTML(target: [
                allowMissing:          true,
                alwaysLinkToLastBuild: true,
                keepAll:               true,
                reportDir:             'reports/formy',
                reportFiles:           'index.html',
                reportName:            'UI tests (Formy)'
            ])

            // Database usage: у тебя реально есть reports/databaseUsage/cucumber.html
            publishHTML(target: [
                allowMissing:          true,
                alwaysLinkToLastBuild: true,
                keepAll:               true,
                reportDir:             'reports/databaseUsage',
                reportFiles:           'cucumber.html',
                reportName:            'DB tests'
            ])

            // Если в reports/databaseUsage/cucumber-html-report есть index.html
            publishHTML(target: [
                allowMissing:          true,
                alwaysLinkToLastBuild: true,
                keepAll:               true,
                reportDir:             'reports/databaseUsage/cucumber-html-report',
                reportFiles:           'index.html',
                reportName:            'DB tests (Cucumber HTML Report)'
            ])

            // Gatling: reports/gatling/latest/index.html
            publishHTML(target: [
                allowMissing:          true,
                alwaysLinkToLastBuild: true,
                keepAll:               true,
                reportDir:             'reports/gatling/latest',
                reportFiles:           'index.html',
                reportName:            'Load tests (Gatling)'
            ])
        }
    }
}