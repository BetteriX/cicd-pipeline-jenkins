pipeline {
    agent any

    tools {
        nodejs 'node'
    }

    environment {
        DOCKER_REPO = "betterix1"

        IMAGE_NAME = "${DOCKER_REPO}/${env.BRANCH_NAME == 'main' ? 'nodemain' : 'nodedev'}:v1.0"
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

        stage('Lint Check') {
            steps {
                sh "docker run --rm hadolint/hadolint < Dockerfile"
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${IMAGE_NAME} ."
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    withCredentials([usernamePassword(
                        credentialsId: 'dockerhub-creds',
                        usernameVariable: 'DOCKER_USER',
                        passwordVariable: 'DOCKER_PASS'
                    )]) {

                        sh """
                        echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                        docker push ${IMAGE_NAME}
                        """
                    }
                }
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
                    docker pull ${IMAGE_NAME}

                    docker run -d \
                    --name ${CONTAINER_NAME} \
                    -p ${PORT}:3000 \
                    ${IMAGE_NAME}
                    """
                }
            }
        }
        stage ('Scan Docker Image for Vulnerabilities') {
            steps {
                script {
                    sh """
                    docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
                    aquasec/trivy image --exit-code 0 --severity HIGH,MEDIUM,LOW --no-progress ${IMAGE_NAME}
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