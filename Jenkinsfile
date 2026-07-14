pipeline {
    agent any

    tools {
        jdk 'JDK8'
        maven 'Maven3'
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('Deploy to Tomcat') {
            steps {
                sh 'sudo cp target/devops-e2e-app.war /opt/tomcat/latest/webapps/'
                sh 'sudo systemctl restart tomcat'
            }
        }

stage('Verify Deployment') {
    steps {
        sh '''
        for i in {1..10}; do
            curl -f http://localhost:8081/devops-e2e-app/hello && exit 0
            echo "Waiting for Tomcat to start..."
            sleep 5
        done
        exit 1
        '''
    }
}
    }

    post {
        success {
            echo 'Application deployed successfully.'
        }

        failure {
            echo 'Deployment failed.'
        }

        always {
            cleanWs()
        }
    }
}
