# 🔧 Troubleshooting Guide - Azure Blue-Green CI/CD

## Common Issues and Solutions

### 1. Docker Hub Login Failure

**Error Message:**
```
Must provide --username with --password-stdin
Error: Process completed with exit code 1
```

**Root Cause:**
The `DOCKER_USERNAME` and/or `DOCKER_PASSWORD` GitHub secrets are not configured in your repository.

**Solution:**

1. **Navigate to Repository Settings**
   - Go to your repository on GitHub
   - Click on **Settings** tab
   - Select **Secrets and variables** → **Actions** from the left sidebar

2. **Add Required Secrets**
   
   Create the following repository secrets:

   | Secret Name | Description | Example Value |
   |------------|-------------|---------------|
   | `DOCKER_USERNAME` | Your Docker Hub username | `sharedee2776` |
   | `DOCKER_PASSWORD` | Docker Hub password or access token | `dckr_pat_xxxxx` |

3. **Recommended: Use Docker Access Token**
   
   Instead of using your Docker Hub password, create a personal access token:
   - Log in to [Docker Hub](https://hub.docker.com/)
   - Go to **Account Settings** → **Security** → **New Access Token**
   - Name: `github-actions-azure-cicd`
   - Permissions: **Read & Write** (or **Read, Write & Delete**)
   - Copy the generated token and use it as `DOCKER_PASSWORD`

4. **Re-run the Workflow**
   - Go to **Actions** tab
   - Select the failed workflow run
   - Click **Re-run all jobs**

---

### 2. Azure Login Failure

**Error Message:**
```
Error: Login failed with Error: AADSTS700016: Application with identifier 'xxxx' was not found
```

**Root Cause:**
The `AZURE_CREDENTIALS` secret is missing or contains invalid Azure Service Principal credentials.

**Solution:**

1. **Create Azure Service Principal**
   
   Run this command in Azure CLI:
   ```bash
   az ad sp create-for-rbac \
     --name "github-actions-blue-green" \
     --role contributor \
     --scopes /subscriptions/{subscription-id}/resourceGroups/{resource-group} \
     --sdk-auth
   ```

2. **Copy the JSON Output**
   
   The command will return JSON like this:
   ```json
   {
     "clientId": "xxxx",
     "clientSecret": "xxxx",
     "subscriptionId": "xxxx",
     "tenantId": "xxxx",
     "activeDirectoryEndpointUrl": "https://login.microsoftonline.com",
     "resourceManagerEndpointUrl": "https://management.azure.com/",
     "activeDirectoryGraphResourceId": "https://graph.windows.net/",
     "sqlManagementEndpointUrl": "https://management.core.windows.net:8443/",
     "galleryEndpointUrl": "https://gallery.azure.com/",
     "managementEndpointUrl": "https://management.core.windows.net/"
   }
   ```

3. **Add to GitHub Secrets**
   - Repository Settings → Secrets and variables → Actions
   - Create new secret named `AZURE_CREDENTIALS`
   - Paste the entire JSON output as the value

---

### 3. Docker Build Failure

**Error Message:**
```
Error: Cannot find Dockerfile in ./app
```

**Root Cause:**
The Dockerfile is named incorrectly or is in the wrong location.

**Solution:**

1. Ensure your Dockerfile is located at: `./app/Dockerfile`
2. The filename should be exactly `Dockerfile` (capital D, no extension)
3. If you have `dockerfile` (lowercase), rename it to `Dockerfile`

---

### 4. Azure App Service Deployment Failure

**Error Message:**
```
Error: Slot 'staging' not found
```

**Root Cause:**
The staging deployment slot doesn't exist in your Azure App Service.

**Solution:**

1. **Create Staging Slot in Azure Portal**
   - Navigate to your App Service
   - Go to **Deployment** → **Deployment slots**
   - Click **+ Add Slot**
   - Name: `staging`
   - Clone settings from: `production` (optional)
   - Click **Add**

2. **Or Create via Azure CLI**
   ```bash
   az webapp deployment slot create \
     --name my-devops-app \
     --resource-group devops-rg \
     --slot staging
   ```

---

### 5. Health Check Script Failure

**Error Message:**
```
./scripts/healthcheck.sh: Permission denied
```

**Root Cause:**
The shell script doesn't have execute permissions.

**Solution:**

1. **Make the script executable**
   ```bash
   git update-index --chmod=+x scripts/healthcheck.sh
   git update-index --chmod=+x scripts/swapslots.sh
   git commit -m "Make scripts executable"
   git push
   ```

---

## Verification Checklist

Before running the CI/CD pipeline, ensure:

- [ ] `DOCKER_USERNAME` secret is set
- [ ] `DOCKER_PASSWORD` secret is set (preferably access token)
- [ ] `AZURE_CREDENTIALS` secret is set with valid Service Principal JSON
- [ ] Azure App Service exists with the name specified in workflow
- [ ] Azure Resource Group exists
- [ ] Staging slot exists in Azure App Service
- [ ] Scripts have execute permissions (`+x`)
- [ ] Dockerfile exists at `./app/Dockerfile`

---

## Debugging Tips

### View Workflow Logs
1. Go to **Actions** tab
2. Click on the failed workflow run
3. Expand failed job steps to see detailed error messages

### Test Docker Login Locally
```bash
echo "YOUR_TOKEN" | docker login -u "YOUR_USERNAME" --password-stdin
```

### Test Azure Login Locally
```bash
az login --service-principal \
  -u {clientId} \
  -p {clientSecret} \
  --tenant {tenantId}
```

### Test Docker Build Locally
```bash
cd app
docker build -t test-image:latest .
docker run -p 5000:5000 test-image:latest
```

---

## Need More Help?

- Review the [GitHub Actions documentation](https://docs.github.com/en/actions)
- Check [Docker Hub documentation](https://docs.docker.com/docker-hub/)
- Read [Azure App Service docs](https://learn.microsoft.com/en-us/azure/app-service/)
- Review workflow file: `.github/workflows/ci-cd.yml`

---

**Last Updated:** December 2025
