@Library('Jenkins-Shared-Library')_
pipeline {
    agent any
	// { 
 //        // Specifies a label to select an available agent
 //         node { 
 //             label 'jenkins-slave'
 //         }
 //    }
    
    environment {
    dockerHubCredentialsID	    = 'DockerHub'  		    			// DockerHub credentials ID.
    imageName   		        = 'alikhames/java-app'     			        // DockerHub repo/image name.
	openshiftCredentialsID	    = 'openshift'	    				// KubeConfig credentials ID.   
	nameSpace                   = 'alikhames'
	clusterUrl                  = 'https://api.ocp-training.ivolve-test.com:6443'
	SONAR_PROJECT_KEY           = 'ivolve_java_app'
	gitRepoName 	            = 'MultiCloudDevOpsProject'
    gitUserName 	            = 'Alikhamed'
	gitUserEmail                = 'Alikhames566@gmail.com'
	githubToken                 = 'github-token'
	sonarqubeUrl                = 'http://192.168.49.1:9000/'
	sonarTokenCredentialsID     = 'sonar-token'
	k8sCredentialsID	        = 'kubernetes'
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

		    //    withCredentials([string(credentialsId: 'sonar-token', variable: 'SONAR_TOKEN')]) {
            //             sh  """
			//                  chmod +x ./gradlew
            //                 ./gradlew sonar \
            //                 -Dsonar.projectKey=${SONAR_PROJECT_KEY} \
            //                 -Dsonar.host.url=${sonarqubeUrl} \
            //                 -Dsonar.token=${SONAR_TOKEN} \
            //                 -Dsonar.scm.provider=git \
            //                 -Dsonar.java.binaries=build/classes
            //                 """
            //    }
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
	stage('Deploy on ArgoCD') {
            steps {
                script { 
			deployOnArgoCD("${k8sCredentialsID}")
                }
            }
        }

   //      stage('Deploy on OpenShift Cluster') {
   //          steps {
   //              script { 
			// dir('oc') {
                        
			// 	deployOnOc("${openshiftCredentialsID}", "${nameSpace}", "${clusterUrl}")
			// }
   //              }
   //          }
   //      }
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
