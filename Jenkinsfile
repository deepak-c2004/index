pipeline {
    agent any
    stages {
        stage('Clone') {
            steps {
                git branch: 'main', url: 'https://github.com/deepak-c2004/index.git'
            }
        }
        stage('Build') {
            steps {
                sh 'echo Building...'
            }
        }
        stage('Test') {
            steps {
                sh 'echo Testing...'
            }
        }
    }
}
