pipeline {
    agent any

    tools {
        nodejs 'node'
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
                    def container = "${CONTAINER_NAME}"

                    sh """
                    if docker ps -a --format '{{.Names}}' | grep -Eq '^${container}\$'; then
                        docker stop ${container} || true
                        docker rm ${container} || true
                    fi
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