# aws-infra-showcase
Demo project showcasing a Java application deployed to AWS using Terraform

To initiate:
`cd vpc` and then follow with `terraform init`, `terraform plan`, `terraform apply` and then `terraform destroy`

```
aws-java-mongo-demo/
├── app/                    # Java Spring Boot app 
├── docker/                 # Dockerfile
├── terraform/
│   ├── vpc/                # VPC module
│   ├── eks/ or ec2/        # Cluster or EC2 infra
│   ├── alb/ or apigw/      # Load balancer/gateway
│   └── mongodb/            # MongoDB setup (EC2 or docs)
└── README.md
```