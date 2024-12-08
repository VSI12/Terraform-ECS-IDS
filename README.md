# Deploying a Containerized Web-App to AWS ECS Using Terraform and CI/CD

## Project Overview
This project focuses on deploying a dockerized Flask Classification based Intrusion Detection System (IDS) to AWS ECS (Elastic Container Service) using Terraform for provisioning AWS infrastructure and GitHub Actions for CI/CD automation.
The IDS allows users to upload network traffic datasets (formatted like the NSL-KDD dataset), analyze them for potential threats, and visualize the results.

The deployment architecture leverages AWS services such as Virtual Private Cloud (VPC) ECS (with Fargate), ECR (Elastic Container Registry), an Application Load Balancer (ALB), and VPC endpoints for secure network communication.
The entire infrastructure is managed as code with Terraform, ensuring consistency, scalability, and easy maintenance.

## Architecture
- **Virtual Private Cloud (VPC)**: Configured with public and private subnets across two availability zones for high availability and security.
- **Interget Gateway**: Enables communication between the VPC and the internet
- **VPC Endpoints**: The VPC endpoints enable the ECS tasks in the private subnet to access certain  AWS resources.
- **Application Load Balancer(ALB)**: Configured to forward traffic to the ECS tasks, through listeners and target groups and distributes the incoming traffic across the ECS tasks.
- **Elastic Container Registry**: Host the docker image
- **Elastic Container Service(ECS)**: creates the ECS cluster that hosts the Fargate service tasks
- **GitHub Actions**: Creates a CI/CD pipeline using GitHub Actions for seamless integration and deployments.
- **Terraform**: Provisions the AWS resources
- **Docker**: Containerizes the flask web-app


## AWS Architecture Diagram
![IDS-Architecture](https://github.com/user-attachments/assets/3f339c02-a339-497d-b679-02552f089f11)



## Setup and Deployment
I have layed out the deployment steps in very high detail in my dev.to blog post. You're welcome to check it out.
- **DEV.TO blog post**: [BLOG POST](https://dev.to/non-existent/deploying-a-flask-based-intrusion-detection-system-to-aws-ecs-with-cicd-4pgm)
