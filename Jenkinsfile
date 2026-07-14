pipeline {
    agent any

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean compile'
            }
        }

        stage('Test') {
            steps {
                sh 'mvn test'
            }
        }

        stage('Archive') {
            steps {
                sh 'mvn package'
                archiveArtifacts artifacts: 'target/*.war', fingerprint: true
            }
        }

        stage('Deploy') {
            steps {
                sh '''
                sudo cp target/devops-e2e-app.war /opt/tomcat/latest/webapps/
                sudo systemctl restart tomcat
                sleep 20
                '''
            }
        }

        stage('Health Check') {
            steps {
                sh '''
                curl -I http://localhost:8081/devops-e2e-app/
                '''
            }
        }
    }
}
