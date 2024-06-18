#!/usr/bin/env groovy
def call() {
	echo "Building App..."
	    sh 'chmod +x ./gradlew'
        sh './gradlew clean build'
}
