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
    stage('Kubeconfig') {
  steps {
    sh '''
      aws eks update-kubeconfig --region us-east-1 --name my-cl --kubeconfig /var/lib/jenkins/.kube/config
      kubectl config current-context
      kubectl get nodes
    '''
  }
}


    stage('Deploy to EKS') {
  steps {
    sh '''
      kubectl apply -f deployment.yaml
      kubectl apply -f service.yaml
    '''
  }
}



  }
}
