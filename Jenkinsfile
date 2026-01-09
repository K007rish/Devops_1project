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
                    // Changed to env.GIT_BRANCH and checking for contains 'master' or 'dev'
                    if (env.GIT_BRANCH.contains('dev')) {
                        sh '''
                        docker build -t $IMAGE_NAME:dev .
                        docker push $IMAGE_NAME:dev
                        '''
                    } else if (env.GIT_BRANCH.contains('master')) {
                        sh '''
                        docker build -t $IMAGE_NAME:prod .
                        docker push $IMAGE_NAME:prod
                        '''
                    } else {
                        echo "Current branch is ${env.GIT_BRANCH}. No build logic defined for this branch."
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
                docker run -d --name react-app -p 3000:80 $IMAGE_NAME:prod
                '''
            }
        }
    }
}
