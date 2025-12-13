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
                sh './run_all_qa.sh'
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: 'reports/**', fingerprint: true, allowEmptyArchive: true

            publishReport(
                name: 'QA Summary (Nested)',
                displayType: 'ALWAYS',
                provider: json(pattern: 'reports/nested/data.json')
            )

            publishHTML(target: [
                allowMissing:          true,
                alwaysLinkToLastBuild: true,
                keepAll:               true,
                reportDir:             'reports/formy/cucumber-html-report',
                reportFiles:           'index.html',
                reportName:            'UI tests (Formy)'
            ])

            publishHTML(target: [
                allowMissing:          true,
                alwaysLinkToLastBuild: true,
                keepAll:               true,
                reportDir:             'reports/databaseUsage',
                reportFiles:           'cucumber.html',
                reportName:            'DB tests'
            ])

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