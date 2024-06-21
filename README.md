# End To End DevOps Automation Project Jenkins ArgoCD EKS Grafana

![](https://github.com/AliKhamed/MultiCloudDevOpsProject/blob/main/screenshots/appDiagram.gif)


This project implements a comprehensive End-to-End DevOps automation pipeline using Jenkins for continuous integration, SonarQube for code quality analysis, ArgoCD for GitOps-based continuous deployment on Amazon EKS (Elastic Kubernetes Service). It leverages Prometheus and Grafana for monitoring and observability, ensuring efficient management and optimization of the entire software delivery lifecycle.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Project Structure](#project-structure)
- [Terraform Setup](#terraform-setup)
- [Ansible Setup](#ansible-setup)
- [Jenkins Configuration](#jenkins-configuration)
- [Running the Pipeline](#running-the-pipeline)
- [Checking Results](#checking-results)
- [Contributing](#contributing)


## Prerequisites

- AWS Account
- Terraform installed
- Ansible installed
- GitHub Account
- DockerHub Account

## Project Structure

```
├── Terraform
│   ├── backend.tf
│   ├── key-pair.tf
│   ├── main.tf
│   ├── modules
│   │   ├── cloudwatch
│   │   │   ├── main.tf
│   │   │   ├── output.tf
│   │   │   └── variables.tf
│   │   ├── ec2
│   │   │   ├── main.tf
│   │   │   ├── output.tf
│   │   │   └── variables.tf
|   |   ├── eks
│   │   │   ├── main.tf
│   │   │   ├── output.tf
│   │   │   └── variables.tf
│   │   └── network
│   │       ├── main.tf
│   │       ├── output.tf
│   │       └── variables.tf
│   ├── terraform.tfvars
│   └── variables.tf
├── Ansible
│   ├── ansible.cfg
│   ├── aws_ec2.yml
│   ├── playbook.yml
│   └── roles
│       ├── docker
│       │   ├── tasks
│       │   │   └── main.yml
│       │   └── vars
│       │       └── main.yml
│       ├── jenkins
│       │   ├── tasks
│       │   │   └── main.yml
│       │   └── vars
│       │       └── main.yml
│       ├── oc_cli
│       │   └── tasks
│       │       └── main.yml
│       └── sonarqube
│           ├── tasks
│           │   └── main.yml
│           └── vars
│               └── main.yml
├── Application
├── Jenkinsfile
├── oc
│   ├── deployment.yml
│   ├── route.yml
│   └── service.yml
├── shared_library
│   └── vars
│       ├── buildAndPushDockerImage.groovy
│       ├── build.groovy
│       ├── deployOnOc.groovy
│       ├── editNewImage.groovy
│       ├── runUnitTests.groovy
│       └── sonarQubeAnalysis.groovy
└── README.md

```
## Terraform Setup

1. **Clone the Repository:**

    ```
    git clone <repository-url>
    cd <repository-directory>/terraform

    ```
2. **Configure Variables:**

    Edit the terraform.tfvars file to set values for your AWS setup.

3. **Initialize Terraform:**

    ```
    terraform init

    ```
    ![](https://github.com/AliKhamed/MultiCloudDevOpsProject/blob/main/screenshots/terrInit.png)

4. **Review the Plan:**

    ```
     terraform plan

    ```
    ![](https://github.com/AliKhamed/MultiCloudDevOpsProject/blob/dev/screenshots/terraPlan.png)

5. **Apply the Configuration:**

    ```
    terraform apply
    ```

    Confirm the action by typing yes when prompted.

    ![](https://github.com/AliKhamed/MultiCloudDevOpsProject/blob/dev/screenshots/terraApply.png)

6. **AWS Resources Created:**

    - EC2 Instances

        ![](https://github.com/AliKhamed/MultiCloudDevOpsProject/blob/dev/screenshots/ec2.png)

    - VPC

        ![](https://github.com/AliKhamed/MultiCloudDevOpsProject/blob/dev/screenshots/vpc2.png)

    - CloudWatch with SNS topic for email notifications

        ![](https://github.com/AliKhamed/MultiCloudDevOpsProject/blob/dev/screenshots/cloudwatch.png)
        ![](https://github.com/AliKhamed/MultiCloudDevOpsProject/blob/dev/screenshots/sns.png)
        ![](https://github.com/AliKhamed/MultiCloudDevOpsProject/blob/dev/screenshots/snsEmail.png)

    - S3 Bucket for Terraform state file backend

        ![](https://github.com/AliKhamed/MultiCloudDevOpsProject/blob/dev/screenshots/s3.png)


## Ansible Setup

1. **Navigate to Ansible Directory:**
    ```
    cd ../Ansible

    ```
2. **Install Jenkins, SonarQube, Docker, and OC CLI:**

    Use Ansible roles to install the necessary services.

3. **Dynamic Inventory:**

    Use the aws_ec2 plugin for dynamic inventory.

4. **Generate Private Key:**

    Terraform will generate private_key.pem and add it to the Ansible folder.

5. **Run Ansible Playbook:**

    ```
    ansible-playbook -i aws_ec2.yml playbook.yml

    ```
    ![](https://github.com/AliKhamed/MultiCloudDevOpsProject/blob/dev/screenshots/ansibleApply.png)
    

6. **Outputs:**

- SonarQube token

    ![](https://github.com/AliKhamed/MultiCloudDevOpsProject/blob/dev/screenshots/sonarToken1.png)

- Jenkins initial password

    ![](https://github.com/AliKhamed/MultiCloudDevOpsProject/blob/dev/screenshots/jenkinsPass.png)


## Jenkins Configuration

1. **Install Plugins:**
    - Suggested plugins

    ![](https://github.com/AliKhamed/MultiCloudDevOpsProject/blob/dev/screenshots/jenkinsPlugins.png)

    - SonarQube Scanner
    
    ![](https://github.com/AliKhamed/MultiCloudDevOpsProject/blob/dev/screenshots/sonarPlugins.png)

    - Groovy Plugins: To Shared Library

    ![](https://github.com/AliKhamed/MultiCloudDevOpsProject/blob/dev/screenshots/plugins2.png)


2. **Create Credentials:**
    - GitHub token
    - SonarQube token
    - OpenShift token
    - DockerHub token

    ![](https://github.com/AliKhamed/MultiCloudDevOpsProject/blob/dev/screenshots/cred1.png)


3. **Configure Shared Library:**

- Add repository URL and name in Jenkins system configuration:

    ![](https://github.com/AliKhamed/MultiCloudDevOpsProject/blob/dev/screenshots/sharedLib.png)
    ![](https://github.com/AliKhamed/MultiCloudDevOpsProject/blob/dev/screenshots/sharedLib2.png)



4. **Create Pipeline:**

    - Create a new pipeline.

    ![](https://github.com/AliKhamed/MultiCloudDevOpsProject/blob/dev/screenshots/pipeline1.png)

    - Choose SCM and add repository URL and branch name.

    ![](https://github.com/AliKhamed/MultiCloudDevOpsProject/blob/dev/screenshots/pipeline2.png)

## Running the Pipeline

1. **Run Pipeline:**
    Execute the pipeline from Jenkins.


2. **Monitor Pipeline:**

    Ensure the pipeline runs successfully.

![](https://github.com/AliKhamed/MultiCloudDevOpsProject/blob/dev/screenshots/pipelineSuccess1.png)
![](https://github.com/AliKhamed/MultiCloudDevOpsProject/blob/dev/screenshots/pipelineSuccess2.png)


## Checking Results

1. **SonarQube Quality Gate:**

    Review code quality reports on SonarQube.

![](https://github.com/AliKhamed/MultiCloudDevOpsProject/blob/dev/screenshots/sonarSuccess1.png)

![](https://github.com/AliKhamed/MultiCloudDevOpsProject/blob/dev/screenshots/sonarSuccess2.png)

![](https://github.com/AliKhamed/MultiCloudDevOpsProject/blob/dev/screenshots/sonarSuccess3.png)


2. **Application Deployment:**

    Verify your application is running on the OpenShift cluster.

    Login In Your Cluster and Run 

    ```
    oc get all -n namespace

    ```

![](https://github.com/AliKhamed/MultiCloudDevOpsProject/blob/dev/screenshots/oc1.png)

Get Application Route

![](https://github.com/AliKhamed/MultiCloudDevOpsProject/blob/dev/screenshots/oc2.png)

Past It in Your Browser

![](https://github.com/AliKhamed/MultiCloudDevOpsProject/blob/dev/screenshots/applicationRun.png)


## Contributing

    Contributions are welcome! Please submit a pull request or open an issue for any suggestions or improvements.