pipeline {
    agent any

    environment {
        IMAGE_NAME = "react-app"
        DEV_REPO   = "krsh11/react-app-dev"
        PROD_REPO  = "krsh11/react-app-prod"
    }

    stages {

        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('Docker Build') {
            steps {
                sh """
                  docker build -t ${IMAGE_NAME}:${BUILD_NUMBER} .
                """
            }
        }

        stage('Docker Login') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'krsh11',
                    passwordVariable: 'Krish@987'
                )]) {
                    sh """
                      echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                    """
                }
            }
        }

        stage('Push Image') {
            steps {
                script {
                    if (env.BRANCH_NAME == 'dev') {
                        sh """
                          docker tag ${IMAGE_NAME}:${BUILD_NUMBER} ${DEV_REPO}:${BUILD_NUMBER}
                          docker push ${DEV_REPO}:${BUILD_NUMBER}
                        """
                    }

                    if (env.BRANCH_NAME == 'master') {
                        sh """
                          docker tag ${IMAGE_NAME}:${BUILD_NUMBER} ${PROD_REPO}:${BUILD_NUMBER}
                          docker push ${PROD_REPO}:${BUILD_NUMBER}
                        """
                    }
                }
            }
        }

        stage('Deploy to Server') {
            when {
                branch 'master'
            }
            steps {
                sh 'bash scripts/deploy.sh'
            }
        }
    }

    post {
        success {
            echo " Pipeline completed successfully"
        }
        failure {
            echo " Pipeline failed"
        }
    }
}
