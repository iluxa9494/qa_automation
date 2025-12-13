pipeline {
    agent any

    tools {
        jdk   'JDK17'
        maven 'Maven3'
    }

    options {
        timestamps()
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
                // не валим pipeline, даже если скрипт вернул != 0
                script {
                    def rc = sh(script: './run_all_qa.sh', returnStatus: true)
                    echo "run_all_qa.sh exit code: ${rc}"
                }
            }
        }
    }

    post {
        always {
            // гарантируем наличие папки, чтобы archiveArtifacts не ругался
            sh 'mkdir -p reports'

            archiveArtifacts artifacts: 'reports/**', fingerprint: true, allowEmptyArchive: true

            // Nested Data Reporting — публикуем только если файл реально есть
            script {
                if (fileExists('reports/nested/data.json')) {
                    publishReport(
                        name: 'QA Summary (Nested)',
                        displayType: 'ALWAYS',
                        provider: json(pattern: 'reports/nested/data.json')
                    )
                } else {
                    echo "Nested report skipped: reports/nested/data.json not found"
                }
            }

            // UI-тесты (Formy)
            publishHTML(target: [
                allowMissing:          true,
                alwaysLinkToLastBuild: true,
                keepAll:               true,
                reportDir:             'reports/formy/cucumber-html-report',
                reportFiles:           'index.html',
                reportName:            'UI tests (Formy)'
            ])

            // DB-тесты
            publishHTML(target: [
                allowMissing:          true,
                alwaysLinkToLastBuild: true,
                keepAll:               true,
                reportDir:             'reports/databaseUsage',
                reportFiles:           'cucumber.html',
                reportName:            'DB tests'
            ])

            // Нагрузочные тесты (Gatling)
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