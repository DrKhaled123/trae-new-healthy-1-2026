# 🚀 Coolify MCP Deployment Guide

**Status:** ✅ MCP Connected and Ready  
**Date:** December 2024

---

## ✅ MCP Connection Status

The Coolify MCP server is **successfully connected** and verified:
- ✅ MCP Server: Running
- ✅ API Connection: Working
- ✅ Project Found: "new doctorhealthy1" (UUID: `ggwsws84co00844wokgkw08g`)
- ✅ Environment: production (UUID: `v0gkkkgocwswogsc4gkw4g4g`)
- ✅ Server: localhost (UUID: `qcow8kos0gwso4w44ogokgck`)

---

## 🔐 Generated Credentials

**⚠️ IMPORTANT: Save these securely!**

```
JWT_SECRET=33caea9e4154a7dd56a1c5fb7a92c9abbab0e10bb5ecda2dc54903933c404f97
API_KEY_SECRET=bb13a433948cabb8096c6c50bd3b47c6f9316c7294a8b86f0c65fdd0413544d1
DB_PASSWORD=1be1723ba0ab757509d20e28b6d6a7ef
REDIS_PASSWORD=8ed9d9310c8d192dd993702d08759eae
SESSION_SECRET=d329651ebda4923ec819baa046802248
```

---

## 🎯 Deployment Strategy

Due to MCP API validation requirements, we'll use a **hybrid approach**:
1. **MCP Tools** for monitoring and verification
2. **Coolify Dashboard** for application creation (most reliable)
3. **MCP Tools** for environment variables and domain configuration

---

## 📋 Step-by-Step Deployment

### PART 1: Access Coolify Dashboard

1. **Open Coolify Dashboard:**
   - URL: **http://213.199.36.17:8003**
   - Or: **https://api.doctorhealthy1.com** (if configured)

2. **Navigate to Project:**
   - Click on **"Projects"** in sidebar
   - Select **"new doctorhealthy1"**
   - Select **"production"** environment

---

### PART 2: Deploy Backend (Go API)

#### Step 1: Create Backend Application

1. Click **"+ New Resource"** → **"Application"**
2. Choose **"Dockerfile"** type
3. Click **"Continue"**

#### Step 2: Configure Backend Source

**Git Repository:**
- **Repository:** `doctororganic/new`
- **Branch:** `dev`
- **Build Pack:** Dockerfile

**Dockerfile Settings:**
- **Dockerfile Path:** `nutrition-platform/backend/Dockerfile.go`
- **Build Context:** `nutrition-platform/backend`

#### Step 3: Basic Settings

- **Name:** `nutrition-platform-backend`
- **Description:** `Go Backend API Server`
- **Port:** `8080`

#### Step 4: Environment Variables

Add these environment variables one by one:

```bash
# Server Configuration
PORT=8080
ENV=production
DOMAIN=doctorhealthy1.com

# Database Configuration
DB_HOST=postgres
DB_PORT=5432
DB_NAME=nutrition_platform
DB_USER=postgres
DB_PASSWORD=1be1723ba0ab757509d20e28b6d6a7ef
DB_SSL_MODE=require

# Security Secrets
JWT_SECRET=33caea9e4154a7dd56a1c5fb7a92c9abbab0e10bb5ecda2dc54903933c404f97
API_KEY_SECRET=bb13a433948cabb8096c6c50bd3b47c6f9316c7294a8b86f0c65fdd0413544d1
SESSION_SECRET=d329651ebda4923ec819baa046802248

# CORS Configuration
CORS_ORIGIN=https://doctorhealthy1.com,https://www.doctorhealthy1.com
CORS_CREDENTIALS=true

# Redis Configuration (Optional)
REDIS_HOST=redis
REDIS_PORT=6379
REDIS_PASSWORD=8ed9d9310c8d192dd993702d08759eae
```

#### Step 5: Health Check

- **Path:** `/health`
- **Port:** `8080`
- **Interval:** `30` seconds
- **Timeout:** `10` seconds
- **Retries:** `3`
- **Start Period:** `40` seconds

#### Step 6: Domain Configuration

- **Domain:** `backend.doctorhealthy1.com`
- **Enable SSL:** ✅ ON
- **Force HTTPS:** ✅ ON
- **Auto-renew SSL:** ✅ ON

#### Step 7: Deploy Backend

1. Click **"Deploy"** or **"Save & Deploy"**
2. Monitor build logs
3. Wait for deployment to complete (5-10 minutes)

**✅ Backend Complete when:**
- Status: "Running" (green)
- Health Check: "Healthy" (green checkmark)

---

### PART 3: Deploy Frontend (Next.js)

#### Step 8: Create Frontend Application

1. Click **"+ New Resource"** → **"Application"**
2. Choose **"Dockerfile"** type
3. Click **"Continue"**

#### Step 9: Configure Frontend Source

**Git Repository:**
- **Repository:** `doctororganic/new`
- **Branch:** `dev`
- **Build Pack:** Dockerfile

**Dockerfile Settings:**
- **Dockerfile Path:** `nutrition-platform/frontend-nextjs/Dockerfile`
- **Build Context:** `nutrition-platform/frontend-nextjs`

#### Step 10: Basic Settings

- **Name:** `nutrition-platform-frontend`
- **Description:** `Next.js Frontend Application`
- **Port:** `3000`

#### Step 11: Environment Variables

**⚠️ CRITICAL:** These must be set correctly!

```bash
# Application Configuration
NODE_ENV=production
PORT=3000
HOSTNAME=0.0.0.0

# API Configuration (CRITICAL!)
NEXT_PUBLIC_API_URL=https://backend.doctorhealthy1.com
```

**⚠️ IMPORTANT:** 
- `NEXT_PUBLIC_API_URL` must be `https://backend.doctorhealthy1.com`
- This is used at build time, so it must be set before deployment
- Use `https://` not `http://`

#### Step 12: Health Check

- **Path:** `/`
- **Port:** `3000`
- **Interval:** `30` seconds
- **Timeout:** `10` seconds
- **Retries:** `3`
- **Start Period:** `40` seconds

#### Step 13: Domain Configuration

- **Domain:** `doctorhealthy1.com`
- **Enable SSL:** ✅ ON
- **Force HTTPS:** ✅ ON
- **Auto-renew SSL:** ✅ ON

#### Step 14: Dependencies

- **Add Dependency:** `nutrition-platform-backend`
- **Condition:** `service_healthy`

#### Step 15: Deploy Frontend

1. Click **"Deploy"** or **"Save & Deploy"**
2. Monitor build logs
3. Wait for deployment (10-15 minutes - Next.js builds take longer)

**✅ Frontend Complete when:**
- Status: "Running" (green)
- Health Check: "Healthy" (green checkmark)

---

## 🔍 Verification Using MCP

After deployment, you can use MCP tools to verify:

### Check Applications Status

```bash
# List all applications
mcp_coolify-mcp_applications list

# Get specific application details
mcp_coolify-mcp_applications get --id <application-uuid>

# Check deployment logs
mcp_coolify-mcp_deployments list_by_app --applicationUuid <application-uuid>
```

### Monitor Deployments

```bash
# List deployments
mcp_coolify-mcp_deployments list

# Get deployment status
mcp_coolify-mcp_deployments get --id <deployment-uuid>
```

---

## ✅ Verification Checklist

### Backend Verification

- [ ] Application created: `nutrition-platform-backend`
- [ ] Status: Running
- [ ] Health check: Healthy
- [ ] Domain: `backend.doctorhealthy1.com`
- [ ] SSL: Valid certificate
- [ ] Health endpoint: https://backend.doctorhealthy1.com/health

### Frontend Verification

- [ ] Application created: `nutrition-platform-frontend`
- [ ] Status: Running
- [ ] Health check: Healthy
- [ ] Domain: `doctorhealthy1.com`
- [ ] SSL: Valid certificate
- [ ] Website loads: https://doctorhealthy1.com
- [ ] API calls working (check browser Network tab)

---

## 🌐 Final URLs

Once deployment is complete:

- **Frontend:** https://doctorhealthy1.com
- **Backend API:** https://backend.doctorhealthy1.com
- **Health Check:** https://backend.doctorhealthy1.com/health
- **Coolify Dashboard:** http://213.199.36.17:8003

---

## 🆘 Troubleshooting

### If Backend Won't Start

1. Check environment variables in Coolify dashboard
2. Verify database connection settings
3. Check logs: `mcp_coolify-mcp_applications get_logs --id <backend-uuid>`

### If Frontend Build Fails

1. Verify `NEXT_PUBLIC_API_URL` is set correctly
2. Check Dockerfile path: `nutrition-platform/frontend-nextjs/Dockerfile`
3. Review build logs in Coolify dashboard

### If CORS Errors

1. Verify `CORS_ORIGIN` includes `https://doctorhealthy1.com`
2. Check backend logs for CORS errors
3. Ensure backend domain is `backend.doctorhealthy1.com`

---

## 📞 Next Steps

1. **Monitor** deployments in Coolify dashboard
2. **Test** all endpoints once deployment completes
3. **Verify** SSL certificates (may take 5-10 minutes)
4. **Check** application logs for any errors
5. **Test** API connectivity from frontend

---

**Last Updated:** December 2024  
**MCP Status:** ✅ Connected and Ready

