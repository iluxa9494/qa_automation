pipeline {
    agent any

    tools {
        jdk   'JDK17'
        maven 'Maven3'
    }

    options {
        timestamps()
        // ansiColor('xterm')
    }

    environment {
        SELENIUM_BASE_IMAGE = 'seleniarm/standalone-chromium:latest'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/iluxa9494/qa_automation.git'
            }
        }

        stage('Run all QA tests') {
            steps {
                sh 'chmod +x run_all_qa.sh'
                sh './run_all_qa.sh'
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: 'reports/**', fingerprint: true, allowEmptyArchive: true

            // ✅ Nested Data Reporting — JSON (Nested Data Reporting plugin)
            // ВАЖНО: name без пробелов/скобок + стабильный id, чтобы URL не разваливался
            publishReport(
                name: 'QA_Summary_Nested',
                displayType: 'ALWAYS',
                provider: json(
                    id: 'qa_summary',
                    pattern: 'reports/nested/data.json'
                )
            )

            // UI-тесты (Formy) — Cucumber HTML (папка + index.html)
            publishHTML(target: [
                allowMissing:          true,
                alwaysLinkToLastBuild: true,
                keepAll:               true,
                reportDir:             'reports/formy/cucumber-html-report',
                reportFiles:           'index.html',
                reportName:            'UI tests (Formy)'
            ])

            // DB-тесты — Cucumber HTML (ФАЙЛ)
            publishHTML(target: [
                allowMissing:          true,
                alwaysLinkToLastBuild: true,
                keepAll:               true,
                reportDir:             'reports/databaseUsage',
                reportFiles:           'cucumber.html',
                reportName:            'DB tests'
            ])

            // Нагрузочные тесты — Gatling HTML
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