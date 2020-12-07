May I answer the following question:

First of all, both platforms support the deployment of a container application well.

For me personally, I would choose the EKS platform. Because EKS supports an ecosystem both inside and outside the AWS cloud. Use of ECS and Fargate is restricted to the AWS environment. I prefer a flexible platform.

The following minimum requirements are required to implement EKS:
- AWS base: VPC, SG
- IAM roles
- EKS control plan
- ECR to store images
- EC2 as worker nodes

And how i will deploying the application:

Use cloudformation to create infrastructure with follow steps:

1. Create base services like: vpc, sg
2. Create a EKS cluster
3. Create a ECR repository
4. Create EC2 nodes and join to cluster
5. Push image to ECR, write yaml to deploying application to EKS cluster
6. Add monitoring/logging as need