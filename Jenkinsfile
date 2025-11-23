pipeline {
    agent any

    environment {
        APP_NAME = "simple-java-docker-app"
        IMAGE_TAG = "latest"
        ECR_REPO = "853715069488.dkr.ecr.ap-south-1.amazonaws.com/mydemorepo-32"
        AWS_REGION = "ap-south-1"
    }

    stages {
        stage("Checkout Code") {
            steps {
                git branch: 'main', url: 'https://github.com/bhagyashreep032/simple-java-docker-app.git'
            }
        }

        stage("Build JAR") {
            steps {
                sh "mvn clean package -DskipTests"
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
        withCredentials([[$class: 'AmazonWebServicesCredentialsBinding',
                          credentialsId: 'aws-cred']]) {
            sh """
                aws ecr get-login-password --region ${AWS_REGION} \
                | docker login --username AWS --password-stdin ${ECR_REPO}
            """
        }
    }
}

        stage("Push to ECR") {
            steps {
                sh "docker push ${ECR_REPO}:latest"
            }
        }

        stage('Deploy using Helm') {
            steps {
                 withCredentials([
            [$class: 'AmazonWebServicesCredentialsBinding', 
             credentialsId: 'aws-cred']
        ]) {
                sh """
                helm upgrade --install myapp $WORKSPACE/helm-repo \
                  --namespace jenkins \
                  --create-namespace \
                  --set image.repository=${ECR_REPO} \
                  --set image.tag=${IMAGE_TAG}
                """
        }
            }
    }

    }
}
