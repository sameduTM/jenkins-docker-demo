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
                }
			}
		}

        stage('Run Tests') {
            steps {
                sh """
                    echo "Creating virtual environment..."
                    python3 -m venv venv
                    . venv/bin/activate

                    echo "Installing dependencies..."
                    pip install --upgrade pip
                    pip install -r requirements.txt

                    echo "Running tests..."
                    pytest --maxfail=1 --disable-warnings -q
                """
            }
        }

        stage('Build Docker Image') {
            when {
                expression {
                    currentBuild.resultIsBetterOrEqualTo('SUCCESS')
                }
            }
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
