pipeline {
    agent any

    environment {
        IMAGE_NAME = "hotstar_site"
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/akramsyed8046/hostar.git'
            }
        }

        stage('Build WAR') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('JENKINS TO NEXUS') {
            when {
                expression { false }   // always skip
            }
            steps {
                withMaven(globalMavenSettingsConfig: 'settings.xml', 
                          jdk: 'jdk17', 
                          maven: 'maven3', 
                          traceability: true) {
                    sh 'mvn deploy'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    def commit = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()

                    sh """
                        docker build -t ${IMAGE_NAME}:${commit} .
                        docker tag ${IMAGE_NAME}:${commit} ${IMAGE_NAME}:latest
                    """
                }
            }
        }

        stage('Deploy') {
            steps {
                sh '''
                    docker stop hotstar_site || true
                    docker rm hotstar_site || true
                    docker run -d --name hotstar_site -p 9090:8080 ${IMAGE_NAME}:latest
                '''
            }
        }
    }

    post {
        always {
            sh 'docker system prune -af'
        }
    }
}
