pipeline {

    agent any

    environment {
    DOCKER_IMAGE_NAME=credentials('image-name')
    DOCKER_USER=credentials('docker-user')
    DOCKER_PASS=credentials('docker-pass')
    K3S_USER=credentials('k3s-user')
    K3S_PASS=credentials('k3s-pass')
    K3S_HOST=credentials('k3s-host')
    }

    stages {
        

        stage('Build image') {

            steps {
                script {
                    if (env.BRANCH_NAME == 'develop') {  
                       sh 'docker build -t $DOCKER_IMAGE_NAME:$BUILD_NUMBER . --no-cache' 
                    } else {
                       sh 'docker build -t $DOCKER_IMAGE_NAME:prod-$BUILD_NUMBER . --no-cache' 
                    }
                }
            }
        }


        stage('DockerHub push') {

            steps {
                script {
                    if (env.BRANCH_NAME == 'develop') {  
                       sh 'docker login --username=$DOCKER_USER --password=$DOCKER_PASS' 
                       sh 'docker push $DOCKER_IMAGE_NAME:$BUILD_NUMBER' 
                       sh 'docker rmi $DOCKER_IMAGE_NAME:$BUILD_NUMBER -f'
                    } else {
                       sh 'docker login --username=$DOCKER_USER --password=$DOCKER_PASS' 
                       sh 'docker push $DOCKER_IMAGE_NAME:prod-$BUILD_NUMBER' 
                       sh 'docker rmi $DOCKER_IMAGE_NAME:prod-$BUILD_NUMBER -f'
                    }
                }
            }
        }


        stage('Deploy to k3s') {

            steps {
                script {
                    if (env.BRANCH_NAME == 'develop') {       
                       sh 'sed -i "s+image: DOCKER_IMAGE_NAME:BUILD_NUMBER+image: $DOCKER_IMAGE_NAME:$BUILD_NUMBER+g" ./Manifest.yaml' 
                       sh 'sshpass -p $K3S_PASS scp -r ./Manifest.yaml $K3S_USER@$K3S_HOST:/home/jenkins/'
                       sh 'sshpass -p $K3S_PASS ssh $K3S_USER@$K3S_HOST kubectl delete deploy php-nginx -n web'
                       sh 'sshpass -p $K3S_PASS ssh $K3S_USER@$K3S_HOST kubectl apply -f Manifest.yaml'
                       sh 'sshpass -p $K3S_PASS ssh $K3S_USER@$K3S_HOST rm Manifest.yaml'
                    } else {
                       input 'Deploy to Production?'
                       sh 'sed -i "s+image: DOCKER_IMAGE_NAME:BUILD_NUMBER+image: $DOCKER_IMAGE_NAME:prod-$BUILD_NUMBER+g" ./Manifest.yaml' 
                       sh 'sshpass -p $K3S_PASS scp -r ./Manifest.yaml $K3S_USER@$K3S_HOST:/home/jenkins/'
                       sh 'sshpass -p $K3S_PASS ssh $K3S_USER@$K3S_HOST kubectl delete deploy php-nginx -n web'
                       sh 'sshpass -p $K3S_PASS ssh $K3S_USER@$K3S_HOST kubectl apply -f Manifest.yaml'
                       sh 'sshpass -p $K3S_PASS ssh $K3S_USER@$K3S_HOST rm Manifest.yaml'   
                    }
                }
            }
        }
    }
}


