@Library('Argo-Shared-Library')_
pipeline {
    agent any

    environment {
        dockerHubCredentialsID = 'DockerHub'   // DockerHub credentials ID.
        imageName = 'alikhames/new-java-app'        // DockerHub repo/image name.
        gitRepoName = 'End-To-End-DevOps-Project-Jenkins-ArgoCD-EKS-Grafana'
        gitFilePath = 'ArgoCD_k8s_manifest_files'
        gitUserName = 'Alikhamed'
        gitUserEmail = 'Alikhames566@gmail.com'
        githubToken = 'github-token'
        sonarqubeUrl = 'http://192.168.49.1:9000/'
        sonarTokenCredentialsID = 'sonar-token'       
    }

    stages {       
        stage('Run Unit Test') {
            steps {
                script {
                    dir('Application') {    
                        runUnitTests()
                    }
                }
            }
        }

        stage('Build') {
            steps {
                script {
                    dir('Application') {
                        build() 
                    }
                }
            }
        }

        stage('SonarQube Analysis') {
            steps {
                script {
                    dir('Application') {
                        sonarQubeAnalysis() 
                    }
                }
            }
        }

        stage('Build and Push Docker Image') {
            steps {
                script {
                    dir('Application') {
                        buildandPushDockerImage("${dockerHubCredentialsID}", "${imageName}")
                    }   
                }
            }
        }

        stage('Edit new image in deployment.yaml file and push new image on ArgoCD manifest files github repo') {
            steps {
                script { 
                    editNewImage("${githubToken}", "${imageName}", "${gitUserEmail}", "${gitUserName}", "${gitRepoName}", "${gitFilePath}")
                }
            } 
        }
    }

    post {
        success {
            echo "${JOB_NAME}-${BUILD_NUMBER} pipeline succeeded"
        }
        failure {
            echo "${JOB_NAME}-${BUILD_NUMBER} pipeline failed"
        }
    }
}
