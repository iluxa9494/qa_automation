pipeline {
    agent any

    tools {
        jdk   'JDK17'
        maven 'Maven3'
    }

    options {
        timestamps()
        skipDefaultCheckout(true)

        disableConcurrentBuilds()                 // ✅ запрет параллельных запусков
        timeout(time: 6, unit: 'HOURS')           // ✅ чтобы не зависало навсегда
        buildDiscarder(logRotator(
            numToKeepStr: '30',
            artifactNumToKeepStr: '30'
        ))
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/iluxa9494/qa_automation.git'
            }
        }

        stage('Preflight (Docker)') {
            steps {
                sh '''
                  set -eux
                  docker --version
                  docker compose version
                  docker ps
                '''
            }
        }

        stage('Run all QA tests (sequential, safe)') {
            steps {
                sh 'chmod +x run_all_qa.sh'
                sh './run_all_qa.sh'
            }
        }
    }

    post {
        always {
            sh 'mkdir -p reports'
            archiveArtifacts artifacts: 'reports/**', fingerprint: true, allowEmptyArchive: true

            publishHTML(target: [
                allowMissing:          true,
                alwaysLinkToLastBuild: true,
                keepAll:               true,
                reportDir:             'reports',
                reportFiles:           'index.html',
                reportName:            'QA Dashboard'
            ])

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