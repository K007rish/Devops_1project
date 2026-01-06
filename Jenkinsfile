pipeline {
    agent any

    environment {
        IMAGE_NAME = "react--app"
        IMAGE_TAG  = "latest"
        CONTAINER_NAME = "react-app-container"
    }

    stages {

        stage('Checkout Code') {
            steps {
                echo 'Code checked out from GitHub'
            }
        }

        stage('Verify Tools') {
            steps {
                bat '"C:\\Program Files\\Git\\cmd\\git.exe" --version'
                bat 'docker --version'
            }
        }

        stage('Docker Build') {
            steps {
                echo 'Building Docker image'
                bat """
                docker build -t %IMAGE_NAME%:%IMAGE_TAG% .
                """
            }
        }

        stage('Docker Images') {
            steps {
                bat 'docker images'
            }
        }

        stage('Run Container') {
            steps {
                echo ' Running container'
                bat """
                docker rm -f %CONTAINER_NAME% 2>nul
                docker run -d -p 3000:3000 --name %CONTAINER_NAME% %IMAGE_NAME%:%IMAGE_TAG%
                """
            }
        }
    }

    post {
        success {
            echo ' Pipeline completed successfully'
        }
        failure {
            echo ' Pipeline failed — check logs'
        }
    }
}
