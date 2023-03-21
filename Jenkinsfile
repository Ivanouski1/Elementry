pipeline {

    agent any

    environment {
    DOCKER_IMAGE_NAME=credentials('image-name')
    DOCKER_USER=credentials('docker-user')
    DOCKER_PASS=credentials('docker-pass')
    }

    stages {
        

        stage('Build image') {
            steps {
               sh 'docker build -t $DOCKER_IMAGE_NAME:$BUILD_NUMBER . --no-cache' 
            }
        }


        stage('DockerHub push') {
            steps {
               sh 'docker login --username=$DOCKER_USER --password=$DOCKER_PASS' 
               sh 'docker push $DOCKER_IMAGE_NAME:$BUILD_NUMBER' 
               sh 'docker rmi $DOCKER_IMAGE_NAME:$BUILD_NUMBER -f' 
            }
        }
    }
}
