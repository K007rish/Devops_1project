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
                echo $DOCKERHUB_PSW | docker login -u $DOCKERHUB_USR --password-stdin
                '''
            }
        }

        stage('Build & Push Image') {
            steps {
                script {
                    if (env.GIT_BRANCH.contains('dev')) {
                        sh "docker build -t krsh11/react-app:dev ."
                        sh "docker push krsh11/react-app:dev"
                    } else if (env.GIT_BRANCH.contains('master')) {
                        // Push to the private repository for production
                        sh "docker build -t krsh11/react-app-prod:latest ."
                        sh "docker push krsh11/react-app-prod:latest"
                    }
                }
            }
        }

        stage('Deploy to EC2') {
            when {
                // branch 'master' only works reliably in Multibranch Pipelines
                // Use an expression for standard Pipelines
                expression { env.GIT_BRANCH.contains('master') }
            }
            steps {
                sh '''
                docker pull $IMAGE_NAME:prod
                docker stop react-app || true
                docker rm react-app || true
                docker run -d --name react-app -p 80:80 $IMAGE_NAME:prod
                '''
            }
        }
    }
}
