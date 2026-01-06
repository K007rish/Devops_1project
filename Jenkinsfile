pipeline {
    agent any

    environment {
        IMAGE_NAME     = "react--app"
        IMAGE_TAG      = "latest"
        CONTAINER_NAME = "react-app-container"

        
        DOCKER = 'C:\\Program Files\\Docker\\Docker\\resources\\bin\\docker.exe'
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
                bat '"%DOCKER%" --version'
            }
        }

        stage('Docker Build') {
            steps {
                echo 'Building Docker image'
                bat """
                "%DOCKER%" build -t %IMAGE_NAME%:%IMAGE_TAG% .
                """
            }
        }

        stage('Docker Images') {
            steps {
                bat '"%DOCKER%" images'
            }
        }

        stage('Run Container') {
            steps {
                echo 'Running container'
                bat """
                "%DOCKER%" rm -f %CONTAINER_NAME% 2>nul
                "%DOCKER%" run -d -p 3000:3000 --name %CONTAINER_NAME% %IMAGE_NAME%:%IMAGE_TAG%
                """
            }
        }
    }

    post {
        success {
            echo 'Pipeline completed successfully'
        }
        failure {
            echo 'Pipeline failed — check logs'
        }
    }
}
