# End To End DevOps Automation Project Jenkins ArgoCD EKS Grafana

![](https://github.com/AliKhamed/MultiCloudDevOpsProject/blob/main/screenshots/appDiagram.gif)


This project implements a comprehensive End-to-End DevOps automation pipeline using Jenkins for continuous integration, SonarQube for code quality analysis, ArgoCD for GitOps-based continuous deployment on Amazon EKS (Elastic Kubernetes Service). It leverages Prometheus and Grafana for monitoring and observability, ensuring efficient management and optimization of the entire software delivery lifecycle.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Terraform Setup](#terraform-setup)
- [Ansible Setup](#ansible-setup)
- [Jenkins Configuration](#jenkins-configuration)
- [Running the Pipeline](#running-the-pipeline)
- [EKS Setup](#eks-setup)
- [Checking Results](#checking-results)
- [Contributing](#contributing)


## Prerequisites

- AWS Account
- Terraform installed
- Ansible installed
- GitHub Account
- DockerHub Account


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

    - EKS Cluster

        ![](https://github.com/AliKhamed/MultiCloudDevOpsProject/blob/dev/screenshots/s3.png)



## Ansible Setup

1. **Navigate to Ansible Directory:**
    ```
    cd ../Ansible

    ```
2. **Install Jenkins, SonarQube, Docker, and OC CLI On EC2:**

    Use Ansible roles to install the necessary services.
    And Use host: ec2_ip to Install this Roles On EC2
    And Run playbook.yml playbook

3. **Install ArgoCD, Prometheus and Grafana On EKS Cluster:**

    Use hosts: localhost to Configure Config file ~/.kube/config in Your Local Machine
    And Run eks_setup.yml playbook

4. **Dynamic Inventory:**

    Use the aws_ec2 plugin for dynamic inventory.

5. **Generate Private Key:**

    Terraform will generate private_key.pem and add it to the Ansible folder.

6. **Run Ansible playbook.yml Playbook:**

    ```
    ansible-playbook -i aws_ec2.yml playbook.yml

    ```
    ![](https://github.com/AliKhamed/MultiCloudDevOpsProject/blob/dev/screenshots/ansibleApply.png)
    

#### Outputs

- SonarQube token

    ![](https://github.com/AliKhamed/MultiCloudDevOpsProject/blob/dev/screenshots/sonarToken1.png)

- Jenkins initial password

    ![](https://github.com/AliKhamed/MultiCloudDevOpsProject/blob/dev/screenshots/jenkinsPass.png)

7. **Run Ansible eks_setup.yml Playbook**
    ```
        ansible-playbook  eks_setup.yml

    ```

    #### Outputs

    - ArgoCD LoadBalancer URL And Admin Initial Password

    - Promethues LoadBalancer URL

    - Grafana LoadBalancer URL And Admin Initial Password


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

3. **Check Your Manifest Files is updated in Your Repo**




## EKS Setup

1. **Ckeck ArgoCD Installed In argocd namespace**

2. **Ckeck Promethues And Grafana Installed In monitoring namespace**

3. **Ckeck ArgoCD Application In ArgoCD GUI**

4. **Sync Your App After Running Jenkins**



## Checking Results

1. **SonarQube Quality Gate:**

    Review code quality reports on SonarQube.

![](https://github.com/AliKhamed/MultiCloudDevOpsProject/blob/dev/screenshots/sonarSuccess1.png)

![](https://github.com/AliKhamed/MultiCloudDevOpsProject/blob/dev/screenshots/sonarSuccess2.png)

![](https://github.com/AliKhamed/MultiCloudDevOpsProject/blob/dev/screenshots/sonarSuccess3.png)


2. **Application Deployment On ArgoCD:**

    Verify your application is running on the eks cluster.


    ```
    kubectl get all -n myapp

    ```

    ![](https://github.com/AliKhamed/MultiCloudDevOpsProject/blob/dev/screenshots/oc1.png)

    Get Application Loadbalancer

!   [](https://github.com/AliKhamed/MultiCloudDevOpsProject/blob/dev/screenshots/oc2.png)

    Past It in Your Browser

    ![](https://github.com/AliKhamed/MultiCloudDevOpsProject/blob/dev/screenshots/applicationRun.png)


## Contributing

    Contributions are welcome! Please submit a pull request or open an issue for any suggestions or improvements.