# aws-infra-showcase
Demo project showcasing a Java backend API deployed to AWS using Terraform

## VPC Layer
This configuration provisions the foundational networking layer in AWS using a Virtual Private Cloud (VPC). It sets up the core infrastructure required to deploy resources with internet access and public IP assignment.

Key resources created:
- A VPC with a custom CIDR block, DNS resolution, and hostname support
- A public subnet in a specified availability zone
- An Internet Gateway to enable outbound internet traffic
- A route table with a default route through the Internet Gateway
- A route table association connecting the public subnet to that route

This setup ensures that resources launched in the subnet (like Kubernetes pods) can be accessed from the internet and resolve domain names correctly.

## EKS Layer
This module sets up an Amazon Elastic Kubernetes Service (EKS) cluster within the VPC defined earlier.

Key components:
- An EKS cluster with the required IAM role and permissions
- A managed node group (EC2 worker nodes) registered to the cluster
- Control plane & Node-level IAM policies
- A scaling configuration that automatically adjusts the number of worker nodes based on demand

This setup allows you to deploy containerized applications on Kubernetes in a scalable way, while offloading operational overhead to AWS.

# Set up infrastructure with Terraform:
- Navigate to: ```cd aws-infra-showcase/terraform```
- Login AWS: ```aws configure```
- Initialize Terraform:
```terraform init```       
- Preview the infrastructure changes Terraform will make:
```terraform plan```        
- Create/update the infrastructure (VPC, EKS):
```terraform apply```  
- Destroy all Terraform-managed infrastructure:
```terraform destroy```

## Task API - Java Spring Boot
A simple Java Spring Boot REST API (https://start.spring.io/) to manage tasks as the backend component for task management & this demo project.
It exposes endpoints (e.g., /api/tasks) to create, read, update, and delete tasks. This API is part of the overall app infrastructure, designed to be deployed on AWS EKS with Terraform.

For local testing purposes:
- Ensure you have Java 17+ installed:
```choco install openjdk```
- Run the application with:
```./mvnw spring-boot:run```
- Open the browser and visit:
```http://localhost:8080/api/tasks```

## Docker image
For building the image:
- Package into jar for docker file:
``` ./mvnw clean package ```
- Build Docker image from ```app/``` directory:
```docker build -f docker/Dockerfile -t taskapi-app .```
- Run it and map ports:
``` docker run -d -p 8080:8080 taskapi-app```
- Test:
```http://localhost:8080/api/tasks```

For pushing the image to ECR:
- Authenticate your Docker client with AWS ECR.
(The repo url can be retrieved from AWS UI or Terraform outputs):
```aws ecr get-login-password --region eu-central-1 | docker login --username AWS --password-stdin <my-repo-url>```
- Tag local image with ECR repo URL:
```docker tag taskapi:latest <my-repo-url>:latest```
- Push the tagged image to ECR:
```docker push <your-repo-url>:latest```

## K8s Deployment
After the EKS cluster is created, you configure your local environment to connect to it via kubectl. The kubeconfig file contains the necessary authentication and endpoint info.

You then deploy your application manifests (YAML files defining deployments and services) to run your app in Kubernetes pods. The deployment manages the number of replicas (copies) of your app to run for availability. A service of type LoadBalancer exposes your app publicly, routing internet traffic to your pods.

Steps to follow:
- Update K8s deployment yaml to use newly pushed app image (from previou step), for e.g.:
```spec:
  containers:
  - name: taskapi
    image: 123456789012.dkr.ecr.us-west-2.amazonaws.com/taskapi:latest
    ports:
    - containerPort: 8080
```
- Configure local kubeconfig to connect kubectl to EKS cluster:
```aws eks --region eu-central-1 update-kubeconfig --name aws-infra-showcase-eks```
- Apply your Kubernetes manifests (deployments, services):
```kubectl apply -f k8s/```
- Verify service and get external IP or DNS:
```kubectl get svc demo-service```

## Project directory set up:
```
aws-java-mongo-demo/
├── app/                    # Java Backend API built with Spring Boot 
│   ├── docker/             # Dockerfile
├── terraform/
│   ├── vpc/                # VPC module
│   ├── eks/                # Cluster infra
│   └── mongodb/            # MongoDB setup (EC2 or docs) - todo
└── README.md
```
