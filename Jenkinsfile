pipeline {
    agent any

    tools {
        nodejs 'NodeJS 7.8.0'
    }

    environment {
        IMAGE_NAME = "${env.BRANCH_NAME == 'main' ? 'nodemain:v1.0' : 'nodedev:v1.0'}"
        CONTAINER_NAME = "${env.BRANCH_NAME == 'main' ? 'nodemain' : 'nodedev'}"
        PORT = "${env.BRANCH_NAME == 'main' ? '3000' : '3001'}"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build') {
            steps {
                sh 'npm install'
            }
        }

        stage('Test') {
            steps {
                sh 'npm test'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${IMAGE_NAME} ."
            }
        }

        stage('Deploy') {
            steps {
                script {

                    sh """
                    docker stop ${CONTAINER_NAME} || true
                    docker rm ${CONTAINER_NAME} || true
                    """

                    sh """
                    docker run -d \
                    --name ${CONTAINER_NAME} \
                    --expose ${PORT} \
                    -p ${PORT}:3000 \
                    ${IMAGE_NAME}
                    """
                }
            }
        }    
    }
    
    post {
        success {
            echo "Deployment successful"
        }

        failure {
            echo "Deployment failed"
        }
    }
}