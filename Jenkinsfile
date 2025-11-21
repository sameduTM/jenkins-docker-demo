pipeline {
	agent any
	
	environment {
		DOCKERHUB_REPO = "samedutm/jenkins-demo"
	}

	stages {
		stage('Checkout') {
			steps {
				checkout scm
                script {
                    SHORT_COMMIT = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
                    TIMESTAMP = sh(script: "date +%Y%m%d%H%M%S", returnStdout: true).trim()
                    echo "Short Commit: ${SHORT_COMMIT}"
                    echo "Timestamp: ${TIMESTAMP}"
                }
			}
		}

        stage('Build Docker Image') {
            steps {
                sh """
                    docker build -t ${DOCKERHUB_REPO}:latest \
                                 -t ${DOCKERHUB_REPO}:${SHORT_COMMIT} \
                                 -t ${DOCKERHUB_REPO}:${TIMESTAMP} .
                """
            }
        }

        stage('Docker login') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh """
                        echo "$DOCKER_PASS"
                        echo "Logging into Docker Hub..."
                        echo "$DOCKER_PASS" | docker login -u "${DOCKER_USER}" --password-stdin
                    """
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                sh """
                    docker push ${DOCKERHUB_REPO}:latest
                    docker push ${DOCKERHUB_REPO}:${SHORT_COMMIT}
                    docker push ${DOCKERHUB_REPO}:${TIMESTAMP}
                """
            }
        }

        stage('List Images') {
            steps {
                sh "docker images | grep ${DOCKERHUB_REPO}"
            }
        }
	}
}
