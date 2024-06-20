@Library('Argo-Shared-Library')_
pipeline {
    agent any

    environment {
        dockerHubCredentialsID = 'DockerHub'   // DockerHub credentials ID.
        imageName = 'alikhames/java-app'        // DockerHub repo/image name.
        gitRepoName = 'End-To-End-DevOps-Project-Jenkins-ArgoCD-EKS-Grafana'
        gitUserName = 'Alikhamed'
        gitUserEmail = 'Alikhames566@gmail.com'
        githubToken = 'github-token'
        sonarqubeUrl = 'http://192.168.49.1:9000/'
        sonarTokenCredentialsID = 'sonar-token'
        eksTokenCredentialsID = 'eks-token'  // Assuming this holds the EKS API token directly
        CLUSTER_NAME = 'ivolve_eks_cluster'
        KUBECONFIG_PATH = '/tmp/kubeconfig'
        awsCredentialsID = 'aws-credentials'  
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        AWS_DEFAULT_REGION = "us-east-1"
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

        stage('Edit new image in deployment.yaml file') {
            steps {
                script { 
                    editNewImage("${githubToken}", "${imageName}", "${gitUserEmail}", "${gitUserName}", "${gitRepoName}")
                }
            }
        }

        stage('Deploy on EKS') {
            steps {
                script {
 
                    sh "aws eks update-kubeconfig --name $CLUSTER_NAME"
                    sh "kubectl apply -f argoCD_application.yaml"
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
