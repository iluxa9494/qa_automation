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
        // Persist across workspaces (survives cleanup)
        LAST_RUN_FILE = "${JENKINS_HOME}/qa_automation_last_run_id"
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

        stage('Skip if RUN_ID unchanged') {
            steps {
                script {
                    def last = sh(
                        script: "cat '${env.LAST_RUN_FILE}' 2>/dev/null || true",
                        returnStdout: true
                    ).trim()

                    if (last && last == env.RESOLVED_RUN_ID) {
                        echo "⏭  RUN_ID unchanged (${env.RESOLVED_RUN_ID}). Skipping to avoid duplicate builds."
                        currentBuild.result = 'NOT_BUILT'
                        return
                    }

                    echo "✅ New RUN_ID detected. last='${last}', current='${env.RESOLVED_RUN_ID}'"
                }
            }
        }

        stage('Contract check (reports structure)') {
            when {
                expression { currentBuild.result != 'NOT_BUILT' }
            }
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

                  # Allure contract (soft for now: warn until CI starts exporting it)
                  if [ ! -d "$SRC/allure-results" ]; then
                    echo "⚠️ Allure results folder is missing: $SRC/allure-results"
                    echo "   Jenkins Allure tab will be empty until CI uploads allure-results/**"
                  else
                    if ! find "$SRC/allure-results" -type f -print -quit | grep -q .; then
                      echo "⚠️ Allure results folder exists but is empty: $SRC/allure-results"
                      echo "   Jenkins Allure tab will be empty until CI generates results."
                    fi
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
            when {
                expression { currentBuild.result != 'NOT_BUILT' }
            }
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

        stage('Mark RUN_ID as processed') {
            when {
                expression { currentBuild.result != 'NOT_BUILT' }
            }
            steps {
                sh '''
                  set -euo pipefail
                  # Update only after successful contract + import
                  echo "${RESOLVED_RUN_ID}" > "${LAST_RUN_FILE}"
                  chmod 600 "${LAST_RUN_FILE}" || true
                  echo "📝 Stored last processed RUN_ID=${RESOLVED_RUN_ID} -> ${LAST_RUN_FILE}"
                '''
            }
        }

        stage('Debug: show imported structure') {
            when {
                expression { currentBuild.result != 'NOT_BUILT' }
            }
            steps {
                sh '''
                  set -eux
                  echo "📦 Imported reports structure (depth=4):"
                  (command -v tree >/dev/null 2>&1 && tree -L 4 reports) || find reports -maxdepth 4 -type f | sed 's#^# - #'
                '''
            }
        }
    }

    post {
        always {
            script {
                // If we skipped early, reports/ likely does not exist.
                def hasReports = sh(script: 'test -d reports && echo yes || echo no', returnStdout: true).trim() == 'yes'
                if (!hasReports) {
                    echo "ℹ️ No reports workspace (likely skipped). Post actions are skipped."
                    return
                }

                // ✅ JUnit: источник passed/failed/skipped + trend (JUnit plugin)
                junit testResults: 'reports/**/surefire-reports/*.xml, reports/**/surefire/*.xml, reports/**/TEST-*.xml',
                      allowEmptyResults: true,
                      keepLongStdio: true

                // ✅ Allure: вкладка Allure + trend (если есть результаты)
                def hasAllure = sh(script: 'test -d reports/allure-results && find reports/allure-results -type f -print -quit >/dev/null 2>&1 && echo yes || echo no', returnStdout: true).trim() == 'yes'
                if (hasAllure) {
                    allure(
                        includeProperties: false,
                        jdk: '',
                        results: [[path: 'reports/allure-results']]
                    )
                } else {
                    echo "ℹ️ No allure-results in this build (reports/allure-results is missing or empty)."
                }

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

                // Formy: cucumber.html
                publishHTML(target: [
                    allowMissing:          true,
                    alwaysLinkToLastBuild: true,
                    keepAll:               true,
                    reportDir:             'reports/formy',
                    reportFiles:           'cucumber.html',
                    reportName:            'UI tests (Formy)'
                ])

                // Formy: cucumber-html-report/index.html (если есть)
                publishHTML(target: [
                    allowMissing:          true,
                    alwaysLinkToLastBuild: true,
                    keepAll:               true,
                    reportDir:             'reports/formy/cucumber-html-report',
                    reportFiles:           'index.html',
                    reportName:            'UI tests (Formy) — Cucumber HTML Report'
                ])

                // Database usage: cucumber.html
                publishHTML(target: [
                    allowMissing:          true,
                    alwaysLinkToLastBuild: true,
                    keepAll:               true,
                    reportDir:             'reports/databaseUsage',
                    reportFiles:           'cucumber.html',
                    reportName:            'DB tests'
                ])

                // Database usage: cucumber-html-report/index.html (если есть)
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
}