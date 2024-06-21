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

4. **Review the Plan:**

    ```
     terraform plan

    ```
    ![](https://github.com/AliKhamed/End-To-End-DevOps-Project-Jenkins-ArgoCD-EKS-Grafana/blob/main/screenshots/terraformPlan.png)

5. **Apply the Configuration:**

    ```
    terraform apply
    ```

    Confirm the action by typing yes when prompted.

    And The apply will be long between 15 to 20 m because eks cluster take long time

    After Apply Completed 
     
     ![](https://github.com/AliKhamed/End-To-End-DevOps-Project-Jenkins-ArgoCD-EKS-Grafana/blob/main/screenshots/terraformApply.png)

6. **AWS Resources Created:**

    - EC2 Instances

       ![](https://github.com/AliKhamed/End-To-End-DevOps-Project-Jenkins-ArgoCD-EKS-Grafana/blob/main/screenshots/ec2.png)

    - VPC

         ![](https://github.com/AliKhamed/End-To-End-DevOps-Project-Jenkins-ArgoCD-EKS-Grafana/blob/main/screenshots/vpc.png)

    - CloudWatch with SNS topic for email notifications

        ![](https://github.com/AliKhamed/End-To-End-DevOps-Project-Jenkins-ArgoCD-EKS-Grafana/blob/main/screenshots/cloudwatch.png)

        ![](https://github.com/AliKhamed/End-To-End-DevOps-Project-Jenkins-ArgoCD-EKS-Grafana/blob/main/screenshots/email1.png)

        ![](https://github.com/AliKhamed/End-To-End-DevOps-Project-Jenkins-ArgoCD-EKS-Grafana/blob/main/screenshots/email2.png)

    - S3 Bucket for Terraform state file backend

        ![](https://github.com/AliKhamed/End-To-End-DevOps-Project-Jenkins-ArgoCD-EKS-Grafana/blob/main/screenshots/s3.png)

    - EKS Cluster

        ![](https://github.com/AliKhamed/End-To-End-DevOps-Project-Jenkins-ArgoCD-EKS-Grafana/blob/main/screenshots/eks.png)


## Ansible Setup

1. **Navigate to Ansible Directory:**
    ```
    cd ../Ansible

    ```
2. **Install Jenkins, SonarQube, Docker, and OC CLI On EC2:**

- Use Ansible roles to install the necessary services.
- And Use host: ec2_ip to Install this Roles On EC2
- And Run playbook.yml playbook


3. **Update Config File And Install ArgoCD On EKS Cluster:**

- Use hosts: localhost to Configure Config file ~/.kube/config in Your Local Machine
- And Run eks_setup.yml playbook.




4. **Dynamic Inventory:**

    - Use the aws_ec2 plugin for dynamic inventory.

    ```
        plugin: amazon.aws.aws_ec2
        regions:
        - us-east-1  # Specify your AWS region(s) here
        filters:
        tag:Name: Jenkins_server  # Filter instances by the tag Name=test
        instance-state-name: running  # Only include running instances
        keyed_groups:
        - key: tags.Name  # Group instances by their 'Name' tag
            prefix: tag
        compose:
        ansible_host: public_ip_address  # Use the public IP address to connect

    ```

5. **Generate Private Key:**

- Terraform will generate private_key.pem and add it to the Ansible folder.

6. **Run Ansible playbook.yml Playbook:**

    ```
    ansible-playbook -i aws_ec2.yml playbook.yml

    ```
    ![](https://github.com/AliKhamed/End-To-End-DevOps-Project-Jenkins-ArgoCD-EKS-Grafana/blob/main/screenshots/ansibleApply.png)    

#### Outputs

- SonarQube token

    ![](https://github.com/AliKhamed/End-To-End-DevOps-Project-Jenkins-ArgoCD-EKS-Grafana/blob/main/screenshots/sonarToken1.png)

- Jenkins initial password

    ![](https://github.com/AliKhamed/End-To-End-DevOps-Project-Jenkins-ArgoCD-EKS-Grafana/blob/main/screenshots/jenkinsPass.png)

7. **Run Ansible eks_setup.yml Playbook**
    ```
        ansible-playbook  eks_setup.yml

    ```
    ![](https://github.com/AliKhamed/End-To-End-DevOps-Project-Jenkins-ArgoCD-EKS-Grafana/blob/main/screenshots/ansible1.png)

    #### Outputs

    - ArgoCD LoadBalancer URL And Admin Initial Password

     ![](https://github.com/AliKhamed/End-To-End-DevOps-Project-Jenkins-ArgoCD-EKS-Grafana/blob/main/screenshots/argocdUrl.png)

     #### Check ArgoCD GUI

    If See This Page Press On Accept The Risk And Continue

     ![](https://github.com/AliKhamed/End-To-End-DevOps-Project-Jenkins-ArgoCD-EKS-Grafana/blob/main/screenshots/argocdUrl2.png)

    And Copy The Password From Ansible Output And Put It In Password Field

     ![](https://github.com/AliKhamed/End-To-End-DevOps-Project-Jenkins-ArgoCD-EKS-Grafana/blob/main/screenshots/argocdUrl3.png)
    
    And Check Your App That Created By Ansible Playbook
    Also This App Will Updated Auto After Run Jenkins Pipeline Beacuse Jenkins Will Edite The Image Name In Your Deployment Manifest Files In Your GitHub Repo.

     ![](https://github.com/AliKhamed/End-To-End-DevOps-Project-Jenkins-ArgoCD-EKS-Grafana/blob/main/screenshots/argocdApp.png)

    In EKS Cluster

     ![](https://github.com/AliKhamed/End-To-End-DevOps-Project-Jenkins-ArgoCD-EKS-Grafana/blob/main/screenshots/argocdAll.png)


## Jenkins Configuration

### After Ansible Playbook Completed Successfully Copy EC2 Public IP And Put It In Your Browser http<EC2_IP>:8080


1. **Install Plugins:**
    - Suggested plugins

    ![](https://github.com/AliKhamed/End-To-End-DevOps-Project-Jenkins-ArgoCD-EKS-Grafana/blob/main/screenshots/jenkinsPlugins.png)

    - Groovy Plugins: To Shared Library
    ![](https://github.com/AliKhamed/End-To-End-DevOps-Project-Jenkins-ArgoCD-EKS-Grafana/blob/main/screenshots/argocdAll.png)

    

    ![](https://github.com/AliKhamed/End-To-End-DevOps-Project-Jenkins-ArgoCD-EKS-Grafana/blob/main/screenshots/argocdAll.png)


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