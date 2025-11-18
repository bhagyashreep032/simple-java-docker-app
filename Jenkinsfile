pipeline {
    agent {
        docker {
            image 'my-docker-agent:latest'   // mandatory
            args '-v /var/run/docker.sock:/var/run/docker.sock'  // optional for Docker-in-Docker
        }
    }

    environment {
        APP_NAME = "simple-java-docker-app"
        AWS_REGION = "ap-south-1"
        ACCOUNT_ID = "853715069488"
        ECR_URL = "${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
        ECR_REPO_NAME = "mydemorepo-32"
        ECR_REPO = "${ECR_URL}/${ECR_REPO_NAME}"
    }

    stages {

        stage("Checkout Code") {
            steps {
                git url: 'https://github.com/bhagyashreep032/simple-java-docker-app.git',
                    branch: 'main'
            }
        }

        stage("Install AWS CLI") {
            steps {
                sh """
                apk add --no-cache python3 py3-pip
                pip3 install awscli
                """
            }
        }

        stage("Docker Build") {
            steps {
                sh """
                docker build -t ${APP_NAME}:latest .
                docker tag ${APP_NAME}:latest ${ECR_REPO}:latest
                """
            }
        }

        stage("ECR Login") {
            steps {
                sh """
                aws ecr get-login-password --region ${AWS_REGION} \
                | docker login --username AWS --password-stdin ${ECR_URL}
                """
            }
        }

        stage("Push to ECR") {
            steps {
                sh "docker push ${ECR_REPO}:latest"
            }
        }

        stage("Deploy Container") {
            steps {
                sh """
                docker rm -f ${APP_NAME} || true
                docker pull ${ECR_REPO}:latest
                docker run -d --name ${APP_NAME} -p 8081:8080 ${ECR_REPO}:latest
                """
            }
        }
    }
}
