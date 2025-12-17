# 🚀 Azure Blue-Green CI/CD Pipeline with Docker & GitHub Actions

## 📌 Project Overview

This project demonstrates a **production-ready DevOps CI/CD pipeline** implementing **Blue-Green deployment** on **Azure App Service (Linux)** using **Docker** and **GitHub Actions**.

The pipeline automatically builds a Docker image, pushes it to Docker Hub, deploys the application to a **staging slot**, performs a **health check**, and then swaps the staging slot with production — achieving **zero-downtime deployment**.

This project is designed to showcase **real-world DevOps practices** commonly used in modern cloud environments.

---

## 🏗️ Architecture

            ┌────────────────────┐
            │   Developer Push   │
            │   (GitHub - main)  │
            └─────────┬──────────┘
                      │
                      ▼
        ┌──────────────────────────┐
        │     GitHub Actions CI/CD  │
        └─────────┬────────────────┘
                  │
  ┌───────────────┼───────────────────────┐
  ▼               ▼                       ▼
Build Docker Push Image Authenticate
Image to Docker Hub to Azure
│
▼
┌──────────────────────────┐
│ Azure App Service (Linux)│
│ ├── Staging Slot │
│ └── Production Slot │
└─────────┬────────────────┘
│
▼
Health Check Validation
│
▼
Slot Swap (Blue-Green)


---

## 🧰 Tech Stack

| Category | Tools |
|-------|------|
| Cloud Provider | Azure |
| Compute | Azure App Service (Linux) |
| CI/CD | GitHub Actions |
| Containerization | Docker |
| Container Registry | Docker Hub |
| Language | Python (Flask) |
| OS | Linux |
| Deployment Strategy | Blue-Green |

---

## 📁 Repository Structure

.
├── app/
│ ├── app.py # Flask application
│ ├── requirements.txt # Python dependencies
│ └── Dockerfile # Docker build configuration
│
├── scripts/
│ ├── healthcheck.sh # Health validation script
│ └── swapslots.sh # Slot swap automation
│
├── .github/
│ └── workflows/
│ └── cicd.yml # GitHub Actions pipeline
│
├── .gitignore
└── README.md


---

## 🔄 CI/CD Pipeline Workflow

### Trigger
- Any push to the `main` branch

### Pipeline Steps
1. Checkout source code
2. Build Docker image
3. Push Docker image to Docker Hub
4. Authenticate to Azure using Service Principal
5. Deploy image to **staging slot**
6. Run application health check
7. Swap staging slot with production

---

## 🐳 Docker Setup

The application is fully containerized using Docker.

### Build Image Locally
```bash
docker build -t myapp:latest ./app

Run Locally
docker run -d -p 5000:5000 myapp:latest

☁️ Azure App Service Configuration

OS: Linux

Deployment Type: Docker Container

Slots:

production

staging

Deployments are always performed to the staging slot first, ensuring production stability.

🔐 Required GitHub Secrets
Secret Name	Description
AZURE_CREDENTIALS	Azure Service Principal JSON
DOCKER_USERNAME	Docker Hub username
DOCKER_PASSWORD	Docker Hub access token
🩺 Health Check

The application exposes a health endpoint:

GET /health


Example response:

{ "status": "ok" }


The CI/CD pipeline verifies this endpoint before slot swapping.

🎯 Key DevOps Concepts Demonstrated

✔ Blue-Green deployment strategy
✔ Zero-downtime releases
✔ Docker containerization
✔ GitHub Actions CI/CD pipelines
✔ Azure App Service deployment
✔ Secure secret management

📌 Future Enhancements

Add monitoring with Azure Application Insights

Implement automatic rollback on failure

Add unit and integration testing

Convert infrastructure to IaC (Bicep / Terraform)

👤 Author

Adedamola Dauda
Aspiring DevOps Engineer
Focused on Cloud, CI/CD, Docker, and Linux Automation

🧠 Why This Project Matters

This project reflects real-world DevOps workflows used in production systems and demonstrates the skills required for modern DevOps and Cloud Engineer roles.

✅ How to Run the Pipeline

Push code to main branch

GitHub Actions triggers automatically

Application is deployed with zero downtime

📎 License

This project is for learning and portfolio demonstration purposes.