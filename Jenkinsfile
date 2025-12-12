pipeline {
    agent any

    options {
        timestamps()
        ansiColor('xterm')
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
                sh 'chmod +x ./run_all_qa.sh'
                sh './run_all_qa.sh'
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: 'reports/**',
                              fingerprint: true,
                              allowEmptyArchive: true
        }
    }
}