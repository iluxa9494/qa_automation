pipeline {
    agent any

    tools {
        jdk   'JDK17'
        maven 'Maven3'
    }

    options {
        timestamps()
        // ansiColor('xterm')  // оставлено выключенным
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
            // Сохраняем все артефакты отчётов (для скачивания / архива)
            archiveArtifacts artifacts: 'reports/**', fingerprint: true, allowEmptyArchive: true

            // UI-тесты (Formy) — Cucumber HTML
            publishHTML(target: [
                allowMissing:          true,   // чтобы билд не падал, если отчёта вдруг нет
                alwaysLinkToLastBuild: true,
                keepAll:               true,
                reportDir:             'reports/formy/cucumber-html-report',
                reportFiles:           'index.html',
                reportName:            'UI tests (Formy)'
            ])

            // DB-тесты — Cucumber HTML
            publishHTML(target: [
                allowMissing:          true,
                alwaysLinkToLastBuild: true,
                keepAll:               true,
                reportDir:             'reports/databaseUsage/cucumber-html-report',
                reportFiles:           'index.html',
                reportName:            'DB tests'
            ])

            // Нагрузочные тесты — Gatling HTML (через стабильный симлинк latest)
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
