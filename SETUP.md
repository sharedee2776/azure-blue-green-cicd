# 🚀 Setup Guide - Azure Blue-Green CI/CD

This guide will walk you through setting up the entire CI/CD pipeline from scratch.

## Prerequisites

Before you begin, ensure you have:

- [ ] GitHub account
- [ ] Docker Hub account
- [ ] Azure subscription with appropriate permissions
- [ ] Azure CLI installed locally (for setup only)

---

## Step 1: Configure Docker Hub Secrets

### Option A: Using Docker Access Token (Recommended)

1. **Create Docker Hub Access Token**
   - Log in to [Docker Hub](https://hub.docker.com/)
   - Navigate to **Account Settings** → **Security**
   - Click **New Access Token**
   - Name: `github-actions-azure-cicd`
   - Access permissions: **Read & Write**
   - Click **Generate**
   - **Copy the token immediately** (you won't be able to see it again)

2. **Add to GitHub Secrets**
   - Go to your GitHub repository
   - Click **Settings** → **Secrets and variables** → **Actions**
   - Click **New repository secret**
   - Add the following:
     - **Name:** `DOCKER_USERNAME`
     - **Value:** Your Docker Hub username (e.g., `sharedee2776`)
   - Click **Add secret**
   - Click **New repository secret** again
   - Add:
     - **Name:** `DOCKER_PASSWORD`
     - **Value:** The access token you just created
   - Click **Add secret**

### Option B: Using Docker Hub Password (Not Recommended)

If you prefer to use your password instead of a token:

- **Name:** `DOCKER_USERNAME` → **Value:** Your Docker Hub username
- **Name:** `DOCKER_PASSWORD` → **Value:** Your Docker Hub password

> ⚠️ **Security Note:** Access tokens are more secure because you can revoke them without changing your password, and you can limit their scope.

---

## Step 2: Create Azure Service Principal

You need a Service Principal to allow GitHub Actions to authenticate with Azure.

### 2.1 Install Azure CLI

If you haven't already, install the Azure CLI:

- **Windows:** Download from [Azure CLI installer](https://aka.ms/installazurecliwindows)
- **macOS:** `brew install azure-cli`
- **Linux:** Follow instructions at [aka.ms/InstallAzureCLIDeb](https://aka.ms/InstallAzureCLIDeb)

### 2.2 Login to Azure

```bash
az login
```

### 2.3 Get Your Subscription ID

```bash
az account show --query id -o tsv
```

Copy the subscription ID output.

### 2.4 Create Service Principal

Replace `{subscription-id}` with your actual subscription ID:

```bash
az ad sp create-for-rbac \
  --name "github-actions-blue-green" \
  --role contributor \
  --scopes /subscriptions/{subscription-id}/resourceGroups/devops-rg \
  --sdk-auth
```

> 💡 **Note:** If the resource group `devops-rg` doesn't exist yet, either create it first or use a broader scope like `/subscriptions/{subscription-id}`.

### 2.5 Copy the JSON Output

The command will return JSON like this:

```json
{
  "clientId": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
  "clientSecret": "xxxxxxxxxxxxxxxxxxxxxxxxxxxx",
  "subscriptionId": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
  "tenantId": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
  "activeDirectoryEndpointUrl": "https://login.microsoftonline.com",
  "resourceManagerEndpointUrl": "https://management.azure.com/",
  "activeDirectoryGraphResourceId": "https://graph.windows.net/",
  "sqlManagementEndpointUrl": "https://management.core.windows.net:8443/",
  "galleryEndpointUrl": "https://gallery.azure.com/",
  "managementEndpointUrl": "https://management.core.windows.net/"
}
```

**Copy the entire JSON output.**

### 2.6 Add Azure Credentials to GitHub Secrets

- Go to your GitHub repository
- Click **Settings** → **Secrets and variables** → **Actions**
- Click **New repository secret**
- **Name:** `AZURE_CREDENTIALS`
- **Value:** Paste the entire JSON output from step 2.5
- Click **Add secret**

---

## Step 3: Create Azure Resources

### 3.1 Create Resource Group (if not exists)

```bash
az group create --name devops-rg --location eastus
```

### 3.2 Create App Service Plan

```bash
az appservice plan create \
  --name devops-plan \
  --resource-group devops-rg \
  --sku B1 \
  --is-linux
```

### 3.3 Create Web App

```bash
az webapp create \
  --name my-devops-app \
  --resource-group devops-rg \
  --plan devops-plan \
  --deployment-container-image-name sharedee2776/blue-green-app:latest
```

> ⚠️ **Note:** The app name must be globally unique. If `my-devops-app` is taken, choose a different name and update it in `.github/workflows/ci-cd.yml` (line 8).

### 3.4 Create Staging Deployment Slot

```bash
az webapp deployment slot create \
  --name my-devops-app \
  --resource-group devops-rg \
  --slot staging
```

### 3.5 Configure Container Settings for Both Slots

**Production slot:**
```bash
az webapp config container set \
  --name my-devops-app \
  --resource-group devops-rg \
  --docker-custom-image-name sharedee2776/blue-green-app:latest \
  --docker-registry-server-url https://index.docker.io
```

**Staging slot:**
```bash
az webapp config container set \
  --name my-devops-app \
  --resource-group devops-rg \
  --slot staging \
  --docker-custom-image-name sharedee2776/blue-green-app:latest \
  --docker-registry-server-url https://index.docker.io
```

---

## Step 4: Update Workflow Configuration (if needed)

If you used different names, update `.github/workflows/ci-cd.yml`:

```yaml
env:
  APP_NAME: my-devops-app           # ← Change this to your app name
  RESOURCE_GROUP: devops-rg         # ← Change this to your resource group
  ACR_IMAGE: sharedee2776/blue-green-app  # ← Change this to your Docker Hub image
```

---

## Step 5: Verify Setup

### 5.1 Check GitHub Secrets

Go to **Settings** → **Secrets and variables** → **Actions** and verify you have:

- ✅ `DOCKER_USERNAME`
- ✅ `DOCKER_PASSWORD`
- ✅ `AZURE_CREDENTIALS`

### 5.2 Check Azure Resources

```bash
# List resource group resources
az resource list --resource-group devops-rg --output table

# Check web app
az webapp show --name my-devops-app --resource-group devops-rg

# List deployment slots
az webapp deployment slot list --name my-devops-app --resource-group devops-rg --output table
```

---

## Step 6: Test the Pipeline

### 6.1 Trigger Workflow

Make a commit and push to the `main` branch:

```bash
git add .
git commit -m "Test CI/CD pipeline"
git push origin main
```

### 6.2 Monitor Workflow

1. Go to your GitHub repository
2. Click on **Actions** tab
3. You should see a workflow run in progress
4. Click on the run to see detailed logs

### 6.3 Expected Workflow Steps

The workflow should:
1. ✅ Checkout code
2. ✅ Login to Docker Hub
3. ✅ Build Docker image
4. ✅ Push Docker image to Docker Hub
5. ✅ Login to Azure
6. ✅ Deploy to staging slot
7. ✅ Perform health check on staging
8. ✅ Swap staging → production

### 6.4 Verify Deployment

After successful completion, test your app:

```bash
# Test production endpoint
curl https://my-devops-app.azurewebsites.net/health

# Expected response: OK
```

---

## Troubleshooting

If something goes wrong, see [TROUBLESHOOTING.md](./TROUBLESHOOTING.md) for solutions to common issues.

---

## Security Best Practices

- ✅ Use Docker Hub access tokens instead of passwords
- ✅ Limit Service Principal scope to specific resource groups
- ✅ Rotate secrets regularly
- ✅ Never commit secrets to version control
- ✅ Use Azure Managed Identities when possible

---

## Next Steps

- [ ] Add Application Insights for monitoring
- [ ] Implement automatic rollback on failure
- [ ] Add unit and integration tests
- [ ] Convert infrastructure to IaC (Terraform/Bicep)
- [ ] Add environment-specific configurations

---

**Setup Complete!** 🎉

Your blue-green deployment pipeline is now ready. Every push to `main` will automatically deploy your application with zero downtime.
