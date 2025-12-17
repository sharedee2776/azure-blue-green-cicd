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

## 🔐 Required GitHub Secrets

⚠️ **IMPORTANT:** You must configure these secrets before the CI/CD pipeline can run successfully.

### How to Add Secrets

1. Go to your repository on GitHub
2. Click **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret**
4. Add each of the following secrets:

| Secret Name | Description | How to Get It |
|------------|-------------|---------------|
| `DOCKER_USERNAME` | Docker Hub username | Your Docker Hub account username (e.g., `sharedee2776`) |
| `DOCKER_PASSWORD` | Docker Hub access token | **Recommended:** Create a [Docker Access Token](https://hub.docker.com/settings/security) instead of using your password |
| `AZURE_CREDENTIALS` | Azure Service Principal JSON | Run: `az ad sp create-for-rbac --name "github-actions" --role contributor --scopes /subscriptions/{subscription-id}/resourceGroups/{resource-group} --sdk-auth` |

### Docker Hub Access Token Setup (Recommended)

Instead of using your Docker Hub password, create a Personal Access Token:

1. Log in to [Docker Hub](https://hub.docker.com/)
2. Go to **Account Settings** → **Security**
3. Click **New Access Token**
4. Name: `github-actions-cicd`
5. Permissions: **Read & Write**
6. Click **Generate** and copy the token
7. Use this token as the value for `DOCKER_PASSWORD` secret

### Azure Service Principal Setup

Run this Azure CLI command to create credentials:

```bash
az ad sp create-for-rbac \
  --name "github-actions-blue-green" \
  --role contributor \
  --scopes /subscriptions/{subscription-id}/resourceGroups/devops-rg \
  --sdk-auth
```

Copy the entire JSON output and paste it as the `AZURE_CREDENTIALS` secret value.

> 💡 **Troubleshooting:** If your workflow is failing, see [TROUBLESHOOTING.md](./TROUBLESHOOTING.md) for detailed solutions to common issues.
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