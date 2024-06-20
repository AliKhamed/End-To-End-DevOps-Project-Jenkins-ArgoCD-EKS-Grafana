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
        AWS_REGION = 'us-east-1'
        CLUSTER_NAME = 'ivolve_eks_cluster'
        KUBECONFIG_PATH = '/tmp/kubeconfig'
        awsCredentialsID = 'aws-credentials'  // The ID of the AWS credentials stored in Jenkins
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
                    // Configure AWS CLI with Jenkins credentials
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: awsCredentialsID, accessKeyVariable: 'AWS_ACCESS_KEY_ID', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
                        // Masking the credentials
                        maskPasswords {
                            sh """
                                aws eks --region $AWS_REGION update-kubeconfig --name $CLUSTER_NAME
                            """
                        }
                    }

                    // Set KUBECONFIG environment variable
                    env.KUBECONFIG = "${KUBECONFIG_PATH}"

                    // Apply Kubernetes manifests
                    sh """
                        kubectl apply -f argoCD_application.yaml
                    """
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
