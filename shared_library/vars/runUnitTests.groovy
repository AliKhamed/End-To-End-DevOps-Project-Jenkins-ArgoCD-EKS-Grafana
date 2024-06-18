#!/usr/bin/env groovy
def call() {
	echo "Running Unit Test..."
	sh 'chmod +x gradlew'
	sh './gradlew clean test'	
}
