React Application CI/CD Pipeline on AWS
This project demonstrates a production-ready CI/CD pipeline for a React application. It automates the process from code commit to deployment on an AWS EC2 instance using Jenkins, Docker, and Bash scripting.
🚀 Project Overview
The goal of this project is to deploy a React application to a production environment on port 80 [HTTP] with a fully automated pipeline that handles building, pushing to both public and private repositories, and real-time monitoring.
🛠 Tech Stack
Cloud: AWS (EC2 t2.micro)
CI/CD: Jenkins
Containerization: Docker & Docker Compose
Version Control: Git & GitHub
Monitoring: Uptime Kuma
Notifications: Discord Webhooks
📋 Requirements & Features
Dockerization
Custom Dockerfile for the React application.
Docker Compose file to orchestrate the deployment on the server.
Bash Scripting
Automation is handled via two main scripts:
build.sh: Builds Docker images with branch-specific tags (dev/prod).
deploy.sh: Pulls the latest images and restarts the service using Docker Compose.
Docker Hub
Two separate repositories are used:
dev (Public): Stores images built from the dev branch.
prod (Private): Stores production-ready images built from the master branch.
Jenkins Pipeline
The pipeline is configured to:
Trigger automatically on pushes to dev and master.
Build and push to the dev repo if the code is on the dev branch.
Build, push to the prod repo, and deploy to EC2 if code is merged into master.
AWS Configuration
Security Groups:
Port 80: Open to the world (0.0.0.0/0).
Port 22 (SSH): Restricted to My IP only for secure management.
Port 3001: Open for monitoring dashboard access.
📊 Monitoring & Notifications
Uptime Kuma: An open-source monitoring system checks the health status of the application on Port 80.
Alerting: Configured to send notifications via Discord Webhooks only if the application goes down.
A Comprehensive CI/CD Pipeline for a Production-Ready React Application on AWS

This document details the architecture and implementation of a robust, production-ready Continuous Integration and Continuous Deployment (CI/CD) pipeline for a modern React application. The entire process, from a developer's code commit to a live deployment on an Amazon Web Services (AWS) EC2 instance, is fully automated. The core of this automation is orchestrated by Jenkins, leveraged by the speed and consistency of Docker, and tied together with efficient Bash scripting.🚀 Project Overview and Core Objectives

The principal goal of this project is to establish an end-to-end, zero-downtime deployment strategy. The pipeline is engineered to serve the React application on the standard HTTP port 80, making it accessible to users globally. Beyond mere deployment, the project emphasizes reliability through a fully automated workflow that includes:
Automated Building and Containerization: Creating portable, self-contained Docker images for the application.
Dual Repository Strategy: Maintaining separation and security by pushing images to both public (development) and private (production) Docker Hub repositories.
Real-Time Application Health Monitoring: Implementing an external monitoring solution to ensure the application remains operational and to provide instant alerts in case of failure.
🛠 Detailed Technology Stack and Rationale

The selection of the following technologies was made to ensure a scalable, maintainable, and secure CI/CD environment:
Category
Technology
Rationale
Cloud Infrastructure
AWS (EC2 t2.micro)
Provides a reliable, scalable virtual machine for hosting the Jenkins server (orchestrator) and the final deployed application (target server). The t2.micro instance is chosen for cost-efficiency in a demonstration or small-scale production environment.
CI/CD Orchestration
Jenkins
Acts as the central brain of the pipeline. It monitors the GitHub repository and executes the multi-stage pipeline, including building, testing (implicit), and deployment.
Containerization
Docker & Docker Compose
Docker standardizes the build and runtime environment, eliminating "it works on my machine" issues. Docker Compose simplifies multi-container deployment and resource management on the EC2 target server.
Version Control
Git & GitHub
Industry-standard platform for collaborative code management and for providing the crucial commit and push triggers that initiate the Jenkins pipeline.
Monitoring
Uptime Kuma
An open-source, user-friendly monitoring tool deployed alongside the application to perform active, external health checks on the production port.
Notifications
Discord Webhooks
Provides a fast, low-latency channel for sending critical, actionable alerts directly to the development/operations team in case of a service disruption.

📋 Essential Requirements and Pipeline FeaturesRobust Dockerization Strategy

The application's deployment is entirely containerized:
Custom Dockerfile: A tailored, multi-stage Dockerfile is used for the React application. This is essential for creating a lean, production-optimized image by leveraging build-time dependencies (e.g., Node.js and npm run build) in a builder stage and only copying the final, static build artifacts into a lightweight runtime image (e.g., an Nginx base image) for serving, drastically reducing the final image size and attack surface.
Docker Compose Orchestration: A docker-compose.yml file defines the application stack on the EC2 server. It ensures that the built image is pulled and run correctly, mapping the container's internal web server port to the host's Port 80, and managing service dependencies and restarts.
Automation via Bash Scripting

Two highly focused Bash scripts are the backbone of the automated execution phase:
build.sh: This script is responsible for the image creation and tagging process. It dynamically tags the Docker image based on the source branch (e.g., my-react-app:dev-latest or my-react-app:prod-latest). It handles the Docker build command and the subsequent docker push operation to the appropriate repository.
deploy.sh: This script executes on the target EC2 machine. It's designed to perform a safe, in-place update by pulling the latest production image from Docker Hub and using docker-compose up -d to restart the service. Crucially, Docker Compose ensures that the service is restarted with minimal downtime.
Secure and Segregated Docker Hub Repository Management

To maintain a clear separation between pre-production and production builds, a dual repository structure is used:
dev Repository (Public): Images pushed from the dev branch are stored here. This repository is typically public for ease of access by development and staging environments. These images are suitable for feature testing and QA validation.
prod Repository (Private): Only images that have passed all necessary checks and have been merged into the master (or main) branch are stored here. This repository is kept private for enhanced security, ensuring only authenticated systems (like the production EC2 server) can pull the trusted, production-ready code.
Intelligent Jenkins Pipeline Flow

The Jenkins pipeline is meticulously configured to implement a continuous delivery workflow:
Triggering: The pipeline is automatically initiated by SCM (Source Code Management) Webhooks whenever a push occurs to either the dev or the master branch in GitHub.
Dev Branch Workflow:
Action: Code pushed to dev.
Steps: Checkout code -> Execute build.sh (tagged as dev) -> Push image to the public dev Docker Hub repository.
Master Branch Workflow (Production):
Action: Code is merged into master (e.g., from a successful dev branch PR).
Steps: Checkout code -> Execute build.sh (tagged as prod) -> Push image to the private prod Docker Hub repository -> SSH into the target EC2 instance -> Execute deploy.sh to pull the new production image and restart the service.
AWS Infrastructure and Security Hardening

The AWS EC2 instance is configured with a focus on security and accessibility:
Target Application Port: Port 80 (HTTP) is opened globally (0.0.0.0/0) on the Security Group, as this is the port where the final application is served to the end-users.
Secure Management: Port 22 (SSH), used for remote server management and deployment execution, is strictly limited to My IP (a specific, authorized IP address). This minimizes the risk of unauthorized access to the underlying infrastructure.
Monitoring Access: Port 3001 is opened to allow access to the Uptime Kuma monitoring dashboard interface.
📊 Comprehensive Monitoring and Alerting System

Reliability is paramount, and a dedicated monitoring system ensures application uptime:
Uptime Kuma Implementation: An instance of Uptime Kuma is deployed (often alongside the application or on a separate monitoring server) to actively send HTTP requests to the deployed React application's public endpoint on Port 80. It verifies the response status code and content to confirm the service is alive and healthy.
Proactive Alerting: A notification system is configured using Discord Webhooks. This ensures that the development and operations teams receive an immediate, low-latency alert in their primary communication channel only in the event of a detected application failure (e.g., an HTTP 500 error or a timeout from the Port 80 check).

