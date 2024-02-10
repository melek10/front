pipeline {
    agent any

    environment {
        NEXUS_URL = 'http://192.168.12.150:8081'
        NEXUS_REPO = 'repository/maven-releases'
        ARTIFACT_GROUP = 'front.angular'
        ARTIFACT_NAME = 'summer-workshop-angular'
        ARTIFACT_VERSION = "1.0.${env.BUILD_NUMBER}"
       
        DOCKER_IMAGE_TAG = 'front'
        DOCKER_IMAGE_NAME2 = 'melekfront2'
        DOCKER_IMAGE_TAG2 = 'front2'
    }

    tools {
        // Déclarez l'installation de Node.js dans Jenkins
        //nodejs '20.5.0'
        nodejs 'Nodejs'
    }

    stages {
        stage('Git') {
            steps {
                echo 'My first job pipeline angular'
                checkout([$class: 'GitSCM', branches: [[name: '*/main']], doGenerateSubmoduleConfigurations: false, extensions: [], 
                          submoduleCfg: [], userRemoteConfigs: [[url: 'https://github.com/melek10/front.git']]])
            }
        }

        stage('Install Dependencies') {
            steps {
                script {
                    // Utilisez npm du chemin de l'installation de Node.js configuré dans Jenkins
                    sh 'chmod 777 /var/lib/jenkins/workspace/devopsfront'
                    sh 'npm install'
                }
            }
        }

        stage('Build') {
            steps {
                sh 'npm run build --prod'
            }
        }

        stage('Publish to Nexus') {
            steps {
                script {
                    def artifactPath = "dist/${ARTIFACT_NAME}-{ARTIFACT_VERSION}.tar.gz"
                    def nexusArtifactUrl = "${NEXUS_URL}/${NEXUS_REPO}/${ARTIFACT_GROUP}/${ARTIFACT_NAME}/${ARTIFACT_VERSION}/${ARTIFACT_NAME}-${ARTIFACT_VERSION}.tar.gz"

                    // Deploy the artifact to Nexus
                    sh "curl -v --user admin:nexus --upload-file dist/summer-workshop-angular ${nexusArtifactUrl}"
                }
            }
        }

        stage('Pull & Build Docker Image') {
            steps {
                sh "curl -o summer-workshop-angular.jar ${NEXUS_URL}/${NEXUS_REPO}/${ARTIFACT_GROUP}/${ARTIFACT_NAME}/${ARTIFACT_VERSION}/${ARTIFACT_NAME}-${ARTIFACT_VERSION}.tar.gz"
                sh 'chmod 777 /var/lib/jenkins/workspace/devopsfront/Dockerfile'
                sh "docker build -t front:front /var/lib/jenkins/workspace/devopsfront"
            }
        }
        stage('Push Docker Image to Nexus') {
                    steps {
                        withCredentials([usernamePassword(credentialsId: 'nexus', usernameVariable: 'NEXUS_USERNAME', passwordVariable: 'NEXUS_PASSWORD')]) {
                            sh "docker login -u admin -p nexus http://192.168.12.150:8083/"
                           

                        }

                        script {

                            sh "docker tag  front:front 192.168.12.150:8083/${DOCKER_IMAGE_NAME2}:${DOCKER_IMAGE_TAG2}"
                            sh "docker push 192.168.12.150:8083/${DOCKER_IMAGE_NAME2}:${DOCKER_IMAGE_TAG2}"

                      }
                    }
                }

        
    }

    post {
        always {
            sh 'npm cache clean --force'
           
        }
    }
}
