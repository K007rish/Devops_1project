pipeline {
  agent any

  environment {
    IMAGE_NAME = "krsh11/react-app"
    DOCKERHUB = credentials('dockerhub-creds')
  }

  stages {

    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Docker Login') {
      steps {
        sh '''
          echo $DOCKERHUB_PSW | docker login \
          -u $DOCKERHUB_USR --password-stdin
        '''
      }
    }

    stage('Build & Push Image') {
      steps {
        script {
          if (env.BRANCH_NAME == 'dev') {
            sh '''
              docker build -t $IMAGE_NAME:dev .
              docker push $IMAGE_NAME:dev
            '''
          }

          if (env.BRANCH_NAME == 'master') {
            sh '''
              docker build -t $IMAGE_NAME:prod .
              docker push $IMAGE_NAME:prod
            '''
          }
        }
      }
    }

    stage('Deploy to EC2') {
      when {
        branch 'master'
      }
      steps {
        sh '''
          docker stop react-app || true
          docker rm react-app || true
          docker run -d --name react-app -p 3000:80 $IMAGE_NAME:prod
        '''
      }
    }
  }
}
