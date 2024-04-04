

# Basic Node Application Deployment Pipeline

This repository contains a basic Node.js application deployment pipeline, including continuous integration and deployment (CI/CD) setup using Docker and Azure Container Registry (ACR).

## Overview

The purpose of this project is to provide a streamlined process for developing, versioning, containerizing, and deploying a basic Node.js application. The pipeline automates the deployment process, ensuring that new versions are built, tested, and deployed efficiently.

## Features

- **Versioning**: Incremental versioning of the Node.js application ensures each release is uniquely identified.
- **Docker Containerization**: The application is containerized using Docker, allowing for consistent deployment across different environments.
- **Azure Container Registry (ACR)**: ACR is used as the registry for storing Docker images, providing a centralized location for managing container images.
- **Automated Deployment**: The CI/CD pipeline automates the deployment process, including building, tagging, pushing, and pulling Docker images.
- **Container Lifecycle Management**: The pipeline manages the lifecycle of Docker containers, ensuring smooth updates and cleanup of previous versions.

## Deployment Process

1. **Develop Application**: Develop or modify the basic Node.js application, adding or updating endpoints as needed.
2. **Version Increment**: Increment the version number of the application.
3. **Local Build**: Build the new version of the application into a Docker image locally.
4. **Push to ACR**: Tag the Docker image with the version number and push it to the Azure Container Registry (ACR).
5. **Pull from ACR**: Pull the Docker image with the new version from ACR to the local system.
6. **Container Management**: Check if the previous version of the Docker container is running. If running, stop and remove it.
7. **Run New Version**: Run the new version of the Docker container in the background on the local system.

## Getting Started

To get started with the deployment pipeline, follow these steps:

1. Clone the repository to your local machine.
2. Initialize the version variable in the PowerShell CLI.
3. Set up your Azure credentials and ACR details.
4. Develop your Node.js application and add endpoints as needed.
5. Run the deployment script to build, containerize, and deploy the application.

## Dependencies

- Docker: [Installation Guide](https://docs.docker.com/get-docker/)
- Azure CLI: [Installation Guide](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
