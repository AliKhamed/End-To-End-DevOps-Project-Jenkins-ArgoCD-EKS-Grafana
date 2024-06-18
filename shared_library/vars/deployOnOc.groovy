#!/usr/bin/env groovy

def call(String openshiftCredentialsID, String nameSpace, String clusterUrl) {

    
    // Login to OpenShift using the service account token
    withCredentials([string(credentialsId: openshiftCredentialsID, variable: 'OC_TOKEN')]) {
        sh "oc login --token=$OC_TOKEN --server=$clusterUrl --insecure-skip-tls-verify"
    }

    // Apply the updated deployment.yaml to the OpenShift cluster
    sh "oc apply -f . --namespace=${nameSpace}"
}
