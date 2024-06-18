@Library('Argo-Shared-Library')_
pipeline {
    agent any
    
    environment {
        dockerHubCredentialsID = 'DockerHub'   // DockerHub credentials ID.
        imageName = 'alikhames/java-app'        // DockerHub repo/image name.
        nameSpace = 'alikhames'
        clusterUrl = 'https://api.ocp-training.ivolve-test.com:6443'
        SONAR_PROJECT_KEY = 'ivolve_java_app'
        gitRepoName = 'End-To-End-DevOps-Project-Jenkins-ArgoCD-EKS-Grafana'
        gitUserName = 'Alikhamed'
        gitUserEmail = 'Alikhames566@gmail.com'
        githubToken = 'github-token'
        sonarqubeUrl = 'http://192.168.49.1:9000/'
        sonarTokenCredentialsID = 'sonar-token'
        eksTokenCredentialsID = 'eks-token'  // Assuming this holds the EKS API token directly
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
                    // Use the EKS token directly to authenticate
                    withCredentials([string(credentialsId: "${eksTokenCredentialsID}", variable: 'EKS_TOKEN')]) {
                        // Set up kubeconfig with the EKS token
                        sh """
                            aws eks --region us-east-1 update-kubeconfig --name ivolve_eks_cluster --kubeconfig /tmp/kubeconfig --kubeconfig-arg token=$EKS_TOKEN
                        """
                        
                        // Example: Apply deployment.yaml
                        sh """
                            kubectl apply -f argoCD_application.yaml --kubeconfig /tmp/kubeconfig
                        """
                    }
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
