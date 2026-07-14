pipeline {

    agent any

    tools {
        jdk 'JDK8'
        maven 'Maven3'
    }

    environment {
        APP_NAME = "devops-e2e-app"
        TOMCAT_HOME = "/opt/tomcat/latest"
        TOMCAT_SERVICE = "tomcat"
    }

    stages {

        stage('Verify Tools') {
            steps {
                sh '''
                echo "Checking Java version"
                java -version

                echo "Checking Maven version"
                mvn -version
                '''
            }
        }


        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }


        stage('Build Application') {
            steps {
                sh '''
                echo "Cleaning previous build"
                mvn clean

                echo "Running tests and creating WAR"
                mvn test package
                '''
            }
        }


        stage('Deploy to Tomcat') {
            steps {
                sh '''
                echo "Stopping Tomcat"

                sudo systemctl stop ${TOMCAT_SERVICE} || true


                echo "Removing old deployment"

                sudo rm -rf ${TOMCAT_HOME}/webapps/${APP_NAME}
                sudo rm -f ${TOMCAT_HOME}/webapps/${APP_NAME}.war


                echo "Copying new WAR"

                sudo cp target/${APP_NAME}.war ${TOMCAT_HOME}/webapps/


                echo "Changing ownership"

                sudo chown tomcat:tomcat ${TOMCAT_HOME}/webapps/${APP_NAME}.war


                echo "Starting Tomcat"

                sudo systemctl start ${TOMCAT_SERVICE}


                echo "Waiting for Tomcat startup"

                sleep 15
                '''
            }
        }


        stage('Verify Deployment') {
            steps {
                sh '''
                echo "Checking application"

                curl -f http://localhost:8080/${APP_NAME}/hello


                echo ""
                echo "Deployment Successful"
                '''
            }
        }

    }


    post {

        success {
            echo "CI/CD Pipeline completed successfully"
        }


        failure {
            echo "Deployment failed"
        }

    }

}
