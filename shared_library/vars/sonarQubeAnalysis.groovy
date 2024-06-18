#!/usr/bin/env groovy

def call(){ 
	withSonarQubeEnv() { 
		    sh 'chmod +x gradlew'
        	sh "./gradlew sonar" 
	}
}
