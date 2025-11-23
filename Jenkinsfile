pipeline {
    options {
        githubProjectProperty(url: 'https://github.com/sameduTM/jenkins-docker-demo')
    }

    agent any

    environment {
        DOCKER_IMAGE = "samedutm/jenkins-demo:latest"
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/sameduTM/jenkins-docker-demo.git'
            }
        }

        stage('Install Dependencies') {
            steps {
                sh """
                    python3 -m venv venv
                    . venv/bin/activate
                    pip install --upgrade pip
                    pip install -r requirements.txt
                """
            }
        }

        stage('Lint') {
            steps {
                sh """
                    . venv/bin/activate
                    flake8 .
                """
            }
        }

        stage('Test') {
            steps {
                sh """
                    . venv/bin/activate
                    pytest -q
                """
            }
        }

        stage('Docker Build & Push') {
            steps {
                script {
                    withCredentials([usernamePassword(
                        credentialsId: 'dockerhub-creds', 
                        usernameVariable: 'DOCKERHUB_USERNAME', 
                        passwordVariable: 'DOCKERHUB_PASSWORD'
                    )]) {
                        sh """
                            docker build -t ${DOCKER_IMAGE} .
                            echo ${DOCKERHUB_PASSWORD} | docker login -u ${DOCKERHUB_USERNAME} --password-stdin
                            docker push ${DOCKER_IMAGE}
                        """
                    }
                }
            }
        }

        stage('Deploy to EC2') {
            when {
                allOf() {
                    branch 'main'
                    not { changeRequest() }
                }
            }
            steps {
                withCredentials([sshUserPrivateKey(
                    credentialsId: 'ec2-ssh', 
                    keyFileVariable: 'SSH_KEY'
                    )]) {
                        sh """
                            ssh -i \$SSH_KEY -o StrictHostKeyChecking=no ubuntu@3.238.196.249 '
                            docker pull ${DOCKER_IMAGE} &&
                            docker stop jenkins-demo || true &&
                            docker rm jenkins-demo || true &&
                            docker run -d -p 80:3000 --name jenkins-demo ${DOCKER_IMAGE}
                            '
                        """
                }
            }
        }
    }
}