# ⚡ Quick Start - Fix Docker Hub Login Issues

## TL;DR - What's Wrong?

Your CI/CD pipeline is failing because **GitHub secrets are not configured**. Here's the fastest way to fix it:

---

## ✅ 3-Minute Fix

### Step 1: Add Docker Hub Secrets (2 minutes)

1. Go to your repository → **Settings** → **Secrets and variables** → **Actions**
2. Click **New repository secret**
3. Add these two secrets:

   **Secret 1:**
   - Name: `DOCKER_USERNAME`
   - Value: `sharedee2776` (or your Docker Hub username)

   **Secret 2:**
   - Name: `DOCKER_PASSWORD`
   - Value: Your Docker Hub password OR [create an access token](https://hub.docker.com/settings/security) (recommended)

### Step 2: Add Azure Credentials (1 minute if you have them)

If you already have Azure credentials JSON:

1. Click **New repository secret**
2. Name: `AZURE_CREDENTIALS`
3. Value: Paste your Azure Service Principal JSON

If you don't have Azure credentials, see [SETUP.md](./SETUP.md#step-2-create-azure-service-principal).

### Step 3: Re-run the Workflow

1. Go to **Actions** tab
2. Click on the failed workflow run
3. Click **Re-run all jobs**

---

## 🎯 What Was Fixed

This PR fixed multiple issues that would have caused failures:

1. ✅ Fixed Docker Hub login (requires secrets - see above)
2. ✅ Fixed incorrect script filenames in workflow
3. ✅ Fixed Dockerfile capitalization
4. ✅ Fixed health check endpoint URL
5. ✅ Added comprehensive documentation

---

## 📚 Need More Help?

- **Complete setup from scratch:** See [SETUP.md](./SETUP.md)
- **Troubleshooting errors:** See [TROUBLESHOOTING.md](./TROUBLESHOOTING.md)
- **Docker Hub token setup:** [Docker Hub Security Settings](https://hub.docker.com/settings/security)
- **Azure Service Principal:** See [SETUP.md Step 2](./SETUP.md#step-2-create-azure-service-principal)

---

## 🔐 Security Tip

**Use Docker Access Tokens instead of passwords:**

1. Go to [Docker Hub Security Settings](https://hub.docker.com/settings/security)
2. Click **New Access Token**
3. Name it: `github-actions-cicd`
4. Permissions: **Read & Write**
5. Copy the token and use it as `DOCKER_PASSWORD`

This is more secure because:
- ✅ You can revoke tokens without changing your password
- ✅ Tokens can have limited permissions
- ✅ You can create separate tokens for different purposes

---

**That's it!** Your pipeline should now work. 🚀
