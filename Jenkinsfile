pipeline {
    agent any

    tools {
        jdk    'JDK17'
        maven  'Maven3'
    }

    options {
        timestamps()
        ansiColor('xterm')
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

        stage('Allure report') {
            steps {
                // Jenkins Allure plugin: собираем все директории с результатами
                allure includeProperties: false,
                       jdk: '',
                       results: [[path: '**/allure-results']]
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: '**/allure-results/**', fingerprint: true, allowEmptyArchive: true
        }
    }
}