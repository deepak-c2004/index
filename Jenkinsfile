pipeline {
  agent any

  environment {
    DOCKERHUB_REPO = "deepakc742004/myapp"   // change this
    IMAGE_TAG      = "latest"            // or "latest"
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Build Docker Image') {
      steps {
        sh '''
          docker build -t ${DOCKERHUB_REPO}:${IMAGE_TAG} .
          docker tag ${DOCKERHUB_REPO}:${IMAGE_TAG} ${DOCKERHUB_REPO}:latest
        '''
      }
    }

    stage('Login to DockerHub') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'docker', usernameVariable: 'DH_USER', passwordVariable: 'DH_PASS')]) {
          sh '''
            echo "$DH_PASS" | docker login -u "$DH_USER" --password-stdin
          '''
        }
      }
    }

    stage('Push Image') {
      steps {
        sh '''
          docker push ${DOCKERHUB_REPO}:${IMAGE_TAG}
          docker push ${DOCKERHUB_REPO}:latest
        '''
      }
    }

    stage('Deploy to Remote Server') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'docker', usernameVariable: 'DH_USER', passwordVariable: 'DH_PASS')]) {
          sh """
            ssh -o StrictHostKeyChecking=no ubuntu@35.172.178.88 '
              echo "$DH_PASS" | docker login -u "$DH_USER" --password-stdin &&
              docker pull deepakc742004/myapp:latest &&
              docker stop myapp || true &&
              docker rm myapp || true &&
              docker run -d -p 8080:80 --name myapp deepakc742004/myapp:latest
            '
          """
        }
      }
    }
  }
}
