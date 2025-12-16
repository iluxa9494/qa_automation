pipeline {
    agent any

    tools {
        jdk   'JDK17'
        maven 'Maven3'
    }

    options { timestamps() }

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
                script {
                    def rc = sh(script: './run_all_qa.sh', returnStatus: true)
                    echo "run_all_qa.sh exit code: ${rc}"
                }
            }
        }
    }

    post {
        always {
            sh 'mkdir -p reports'
            archiveArtifacts artifacts: 'reports/**', fingerprint: true, allowEmptyArchive: true

            // ✅ Одна главная кнопка
            publishHTML(target: [
                allowMissing:          true,
                alwaysLinkToLastBuild: true,
                keepAll:               true,
                reportDir:             'reports',
                reportFiles:           'index.html',
                reportName:            'QA Dashboard'
            ])

            // (опционально) отдельные кнопки можно оставить — но они уже не обязательны
        }
    }
}