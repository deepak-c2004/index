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

    stage('ssh into remote'){
      steps{
        sh'''
          ssh -i ~/.ssh/id_rsa ubuntu@54.226.250.46
        '''
      }
    }

    stage('Login to remoteDockerHub') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'docker', usernameVariable: 'DH_USER', passwordVariable: 'DH_PASS')]) {
          sh '''
            echo "$DH_PASS" | docker login -u "$DH_USER" --password-stdin
          '''
        }
      }
    }

    stage('pull image and run container'){
      steps{
        sh'''
          sudo docker pull deepakc742004/myapp:latest
          sudo docker run -d -p 8080:8080 deepakc742004/myapp:latest
        '''
      }
    }
  }
}
