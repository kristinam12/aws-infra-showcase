# aws-infra-showcase
Demo project showcasing a Java application deployed to AWS using Terraform

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

```
aws-java-mongo-demo/
├── app/                    # Java Spring Boot app 
├── docker/                 # Dockerfile
├── terraform/
│   ├── vpc/                # VPC module
│   ├── eks/                # Cluster infra
│   ├── alb/ or apigw/      # Load balancer/gateway
│   └── mongodb/            # MongoDB setup (EC2 or docs)
└── README.md
```

Terraform commands to initiate:
`terraform init`, `terraform plan`, `terraform apply` `terraform destroy`