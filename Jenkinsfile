
pipeline {
  agent any

  environment {
    IMAGE_NAME = "my_app"
    TAG = "latest"
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Build Docker Image') {
      steps {
        sh 'docker build -t ${IMAGE_NAME}:${TAG} .'
      }
    }

    stage('Test Run') {
      steps {
        sh """
          docker run -d --rm --name test_container ${IMAGE_NAME}:${TAG}
          sleep 2
          docker ps
          docker stop test_container
        """
      }
    }
  }
}
