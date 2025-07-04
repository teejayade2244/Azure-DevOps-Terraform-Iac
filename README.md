# Jenkins to Azure DevOps Pipeline Migration

This repository documents the process and scripts used to migrate a CI/CD pipeline from Jenkins to Azure DevOps. It serves as a practical reference for teams modernizing their DevOps workflows and infrastructure, enabling robust automation, improved security, and streamlined deployments using Azure-native tools.

---

## Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Pipeline Stages](#pipeline-stages)
- [Features](#features)
- [Test Results](#test-results)
- [Getting Started](#getting-started)
- [Contributing](#contributing)
- [License](#license)

---

## Overview

Migrating from Jenkins to Azure DevOps enables integration with Azure-native services, improved scalability, and modern DevOps best practices. This repository demonstrates:
![Screenshot 2025-06-08 174224](https://github.com/user-attachments/assets/8a7f7d64-fb58-4d99-a46c-cf893341f636)

- Recreating a Jenkins pipeline in Azure DevOps Pipelines
- Integrating GitHub for source control and PR workflows
- Security scanning (SAST, DAST, Dependency, Container)
- Automated Docker image builds and deployment to Azure Kubernetes Service (AKS)
- Manual and automated gating (approvals, test coverage)

---

## Architecture

The pipeline orchestrates the following flow:

- **Source**: Code is managed in GitHub and synchronized with Azure Pipelines.
- **CI/CD**: Azure Pipelines orchestrates builds, tests, security scans, and deployment to AKS.
- **Security**: Integrates multiple security tools for dependency, container, and runtime scanning.
- **Deployment**: Uses Application Gateways, Ingress, and Argo CD for robust deployment and traffic management.

![Blank diagram (1)](https://github.com/user-attachments/assets/bb960a34-d749-4826-a837-2446f3eed68f)

---

## Pipeline Stages

The Azure DevOps pipeline consists of several key stages:

1. **Build and Test**  
   - Builds the frontend application and runs unit tests.
   
![Screenshot 2025-07-03 174128](https://github.com/user-attachments/assets/704e524f-b27d-446f-9996-4489701ab0cf)

2. **Static Analysis (SAST)**  
   - Runs SonarQube static analysis for code quality and security.
   - Handles deprecated tasks with guidance for upgrades.

3. **Docker Image Build & Scan**  
   - Builds Docker images, scans with Trivy, and publishes results.
   - Pushes images to Azure Container Registry (ACR).

   ![Screenshot 2025-07-03 174221](https://github.com/user-attachments/assets/b55c24ad-c1b6-493d-9613-bfd5658dbba4)

4. **Kubernetes Deployment**  
   - Updates AKS with the new image.
   - Uses Argo for GitOps deployment.

![Screenshot 2025-07-03 174351](https://github.com/user-attachments/assets/c68b0296-7c3a-4b18-804a-9ef7d42e6c35)

5. **Pull Request Automation**  
   - Raises PRs automatically to facilitate review and deployment flow.

6. **Manual Approval**  
   - Introduces validation and manual gating as required.

7. **Dynamic Application Security Testing (DAST)**  
   - Uses OWASP ZAP for runtime security scanning on the live application.

---

## Features

- **Full CI/CD automation** using Azure Pipelines
- **Security Integration**: SAST, DAST, Dependency, and Container scanning
- **GitHub Integration** for seamless code management and PR flows
- **Dockerized Deployments** to AKS with Application Gateway and WAF
- **Manual and Automated Gates** for quality and compliance checks
- **Comprehensive Test Reporting**  
---

## Test Results

- 100% test pass rate on all automated runs
- Rapid feedback on code changes (<10s unit test execution)
- Detailed logs and traceability for each stage
![Screenshot 2025-07-03 174309](https://github.com/user-attachments/assets/867848b3-c177-467e-ab2b-493a9bf8dc27)

![Screenshot 2025-07-03 174241](https://github.com/user-attachments/assets/cde9aec1-c066-43ff-a96c-3c6510376c0c)
---

## Getting Started

1. **Clone this repository**
2. **Review and modify Azure Pipeline YAML files** to match your project structure
3. **Configure Azure DevOps project** and connect to your GitHub repository
4. **Set up required Azure resources**: AKS, ACR, Application Gateway, etc.
5. **Run the pipeline** and monitor results in Azure DevOps

---

## References

- [Azure DevOps Pipelines Documentation](https://docs.microsoft.com/azure/devops/pipelines/)
- [Jenkins Documentation](https://www.jenkins.io/doc/)
- [OWASP ZAP](https://www.zaproxy.org/)
- [Trivy](https://aquasecurity.github.io/trivy/)
- [SonarQube](https://www.sonarqube.org/)
