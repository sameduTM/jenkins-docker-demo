pipeline {
	agent any
	
	environment {
		DOCKERHUB_REPO = "samedutm/jenkins-demo"
		TAG = "latest"
	}
	stages {
		stage('Checkout') {
			steps {
				checkout scm
			}
		}

        stage('Build Docker Image') {
            sh """
                echo "Building Docker Image..."
                docker build -t ${DOCKERHUB_REPO}:${TAG} .
            """
        }

        stage('Docker login') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh """
                        echo "Logging into Docker Hub..."
                        echo "${DOCKER_PASS} | docker login -u ${DOCKERHUB_REPO} --password-stdin"
                    """
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                sh """
                    docker push ${DOCKERHUB_REPO}:${TAG}
                """
            }
        }

        stage('List Images') {
            steps {
                sh "docker images"
            }
        }
	}
}
