pipeline {

    agent any

    tools {
        jdk 'Java8'
        maven 'Maven3'
    }

    environment {
        TOMCAT_HOME = '/opt/tomcat/latest'
        APP_NAME = 'devops-e2e-app'
        WAR_FILE = 'target/devops-e2e-app.war'
    }

    stages {

        stage('Verify Tools') {
            steps {
                sh '''
                echo "Checking Java version..."
                java -version

                echo "Checking Maven version..."
                mvn -version
                '''
            }
        }


        stage('Checkout Code') {
            steps {
                echo "Checking out source code"
                checkout scm
            }
        }


        stage('Run Tests') {
            steps {
                echo "Running Unit Tests"
                sh '''
                mvn clean test
                '''
            }
        }


        stage('Build WAR') {
            steps {
                echo "Building Application WAR"
                sh '''
                mvn clean package -DskipTests
                ls -lh target/*.war
                '''
            }
        }


        stage('Deploy to Tomcat') {
            steps {
                echo "Deploying WAR to Tomcat"

                sh '''
                echo "Copying WAR file..."
                sudo cp ${WAR_FILE} ${TOMCAT_HOME}/webapps/

                echo "Restarting Tomcat..."
                sudo systemctl restart tomcat

                echo "Waiting for Tomcat startup..."
                sleep 10

                sudo systemctl status tomcat --no-pager
                '''
            }
        }


        stage('Verify Deployment') {
            steps {
                echo "Checking application health"

                sh '''
                for i in {1..12}
                do
                    echo "Attempt $i: Checking application..."

                    if curl -f http://localhost:8080/${APP_NAME}/hello
                    then
                        echo "Application deployed successfully"
                        exit 0
                    fi

                    echo "Application not ready. Waiting 5 seconds..."
                    sleep 5
                done

                echo "Application deployment verification failed"
                exit 1
                '''
            }
        }

    }


    post {

        success {
            echo "Deployment completed successfully!"
        }

        failure {
            echo "Deployment failed."
        }

        always {
            cleanWs()
        }

    }
}
