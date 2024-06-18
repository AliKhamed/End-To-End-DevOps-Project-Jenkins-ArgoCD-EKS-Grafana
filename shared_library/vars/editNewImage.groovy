#!/usr/bin/env groovy

def call(String githubToken, String imageName, String gitUserEmail, String gitUserName, String gitRepoName) {

    withCredentials([string(credentialsId: "${githubToken}", variable: 'GITHUB_TOKEN')]) {
                sh '''
                    git config user.email "${gitUserEmail}"
                    git config user.name "${gitUserName}"
                    sed -i "s|image:.*|image: ${imageName}:${BUILD_NUMBER}|g" oc/deployment.yml
                    git add oc/deployment.yml
                    git commit -m "Update deployment image to version ${BUILD_NUMBER}"
                    git push https://${GITHUB_TOKEN}@github.com/${gitUserName}/${gitRepoName} HEAD:dev
                   '''
    

  }
}

