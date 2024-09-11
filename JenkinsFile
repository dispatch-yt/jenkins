pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "whether-app" 
        DOCKER_REGISTRY = "ghcr.io/dispatch-yt"
        GIT_CREDENTIALS_ID = "GIT_CREDENTIALS_ID" 
        SSH_CREDENTIALS_ID = "key" 
        SERVER_IP = "192.168.80.2"
        SERVER_USER = "root"
    }
    tools {
        nodejs "nodejs"
        dockerTool "docker-website"
    }
    
    stages {
        stage('Clone Repository') {
            steps {
                git credentialsId: "${GIT_CREDENTIALS_ID}", url: 'https://github.com/dispatch-yt/react-whether-appp'
            }
        }

        stage('Build React Project') {
            steps {
                sh 'npm install'
                sh 'npm run build'
            }
        }

        stage('Create Docker Image') {
            steps {
                script {
                    sh 'ls'
                    sh 'cat src/pages/Home.jsx'
                    sh 'docker build -t ${DOCKER_IMAGE}:latest -f Dockerfile .'
                }
            }
        }

        stage('Push Docker Image to GitHub Registry') {
            steps {
                script {
                    docker.withRegistry('https://ghcr.io', 'GIT_CREDENTIALS_ID') {
                        sh 'docker tag ${DOCKER_IMAGE}:latest ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:latest'
                        sh 'docker push ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:latest'
                    }
                }
            }
        }
        stage('SSH to Server and Deploy') {
            steps {
                script {
                    sshagent([SSH_CREDENTIALS_ID]) {
                        sh """
                        ssh -o StrictHostKeyChecking=no ${SERVER_USER}@${SERVER_IP} << EOF
                            docker stop ${DOCKER_IMAGE} || true
                            docker rm ${DOCKER_IMAGE} || true
                            docker rmi ${DOCKER_IMAGE} || true
                            docker rmi ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:latest || true
                            docker pull ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:latest
                            docker run -d --name ${DOCKER_IMAGE} -p 8084:80 ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:latest
                        """
                    }
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}
