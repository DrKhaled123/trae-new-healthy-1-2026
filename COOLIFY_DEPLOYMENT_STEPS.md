# 🚀 Complete Coolify Deployment Guide - Step by Step

**Date:** December 2024  
**Status:** ✅ Ready for Deployment  
**Estimated Time:** 30-45 minutes

---

## 📋 PREREQUISITES CHECKLIST

Before starting, ensure you have:

- [ ] Coolify instance running and accessible
- [ ] Access to Coolify dashboard (https://api.doctorhealthy1.com or your Coolify URL)
- [ ] GitHub repository access (https://github.com/doctororganic/new)
- [ ] Domain names configured:
  - Frontend: `super.doctorhealthy1.com`
  - Backend API: `api.super.doctorhealthy1.com`
- [ ] DNS records pointing to your Coolify server IP (128.140.111.171)
- [ ] PostgreSQL database (external or managed)
- [ ] Redis cache (external or managed) - Optional but recommended

---

## 🎯 PART 1: PREPARATION (5 minutes)

### Step 1: Generate Secure Credentials

Open Terminal and run these commands to generate secure secrets:

```bash
# Navigate to project directory
cd "/Users/khaledahmedmohamed/Desktop/trae new healthy1/nutrition-platform"

# Generate JWT Secret (64 characters)
openssl rand -hex 32

# Generate API Key Secret (64 characters)
openssl rand -hex 32

# Generate Database Password (32 characters)
openssl rand -hex 16

# Generate Redis Password (32 characters) - if using Redis
openssl rand -hex 16
```

**⚠️ IMPORTANT:** Copy each generated value and save them securely. You'll need them in Step 4.

**Example output:**
```
JWT_SECRET: a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0u1v2w3x4y5z6a7b8c9d0e1f2
DB_PASSWORD: 1a2b3c4d5e6f7g8h9i0j1k2l3m4n5o6p7
```

---

## 🎯 PART 2: COOLIFY DASHBOARD SETUP (10 minutes)

### Step 2: Access Coolify Dashboard

1. Open your web browser (Chrome, Safari, or Firefox)
2. Navigate to: **https://api.doctorhealthy1.com**
   - If this doesn't work, use your Coolify instance URL
3. Login with your Coolify credentials
4. You should see the Coolify dashboard

### Step 3: Create or Select Project

1. In the left sidebar, click **"Projects"**
2. Look for project named **"new doctorhealthy1"**
   - If it exists: Click on it to open
   - If it doesn't exist: Click **"+ New Project"** button
     - **Name:** `new doctorhealthy1`
     - **Description:** `Nutrition Platform - Full Stack Application`
     - Click **"Create"** or **"Save"**

---

## 🎯 PART 3: DEPLOY BACKEND (Go API) (15 minutes)

### Step 4: Create Backend Application

1. Inside your project, click **"+ New Resource"** button (top right)
2. Select **"Application"** from the dropdown menu
3. Choose **"Dockerfile"** as the application type
4. Click **"Continue"** or **"Next"**

### Step 5: Configure Backend Source Code

**Git Repository Section:**
1. **Repository:** `doctororganic/new`
   - If repository is private, you may need to connect GitHub first
   - Click **"Connect GitHub"** if needed and authorize
2. **Branch:** `dev` (or `main` if that's your main branch)
3. **Build Pack:** Select **"Dockerfile"**

**Dockerfile Configuration:**
1. **Dockerfile Path:** `nutrition-platform/backend/Dockerfile.go`
   - This is the relative path from repository root
2. **Build Context:** `nutrition-platform/backend`
   - This tells Coolify where to build from
3. **Docker Build Arguments:** Leave empty (unless you have specific build args)

### Step 6: Configure Backend Application Settings

**Basic Settings:**
1. **Name:** `nutrition-platform-backend` (or `backend`)
2. **Description:** `Go Backend API Server`
3. **Port:** `8080` (this is the internal port your app listens on)

**Resource Limits (Optional but Recommended):**
1. **CPU Limit:** `1.0` (or leave default)
2. **Memory Limit:** `512M` (or `512 MB`)
3. **CPU Reservation:** `0.25`
4. **Memory Reservation:** `256M`

### Step 7: Configure Backend Environment Variables

Click on **"Environment Variables"** section and add these one by one:

**Database Configuration:**
```
DB_HOST=your-postgres-host
DB_PORT=5432
DB_NAME=nutrition_platform
DB_USER=postgres
DB_PASSWORD=your-generated-db-password
DB_SSL_MODE=require
```

**Server Configuration:**
```
PORT=8080
ENV=production
DOMAIN=super.doctorhealthy1.com
```

**Security Secrets (Use your generated values):**
```
JWT_SECRET=your-generated-jwt-secret-64-chars
API_KEY_SECRET=your-generated-api-key-secret-64-chars
SESSION_SECRET=your-generated-session-secret-32-chars
```

**CORS Configuration:**
```
CORS_ORIGIN=https://super.doctorhealthy1.com,https://www.super.doctorhealthy1.com
CORS_CREDENTIALS=true
```

**Redis Configuration (if using Redis):**
```
REDIS_HOST=your-redis-host
REDIS_PORT=6379
REDIS_PASSWORD=your-generated-redis-password
```

**⚠️ IMPORTANT NOTES:**
- Replace `your-postgres-host` with your actual PostgreSQL host
- Replace `your-generated-db-password` with the password you generated in Step 1
- Replace `your-generated-jwt-secret-64-chars` with your generated JWT secret
- Replace `your-redis-host` with your actual Redis host (or leave empty if not using Redis)

### Step 8: Configure Backend Health Check

1. Scroll to **"Health Check"** section
2. Enable health check: Toggle **"Enabled"** to ON
3. **Health Check Path:** `/health`
4. **Health Check Port:** `8080`
5. **Interval:** `30` seconds
6. **Timeout:** `10` seconds
7. **Retries:** `3`
8. **Start Period:** `40` seconds

### Step 9: Configure Backend Domain

1. Scroll to **"Domains"** section
2. Click **"+ Add Domain"**
3. **Domain:** `api.super.doctorhealthy1.com`
4. **Enable SSL:** Toggle to **ON** (Let's Encrypt)
5. **Force HTTPS:** Toggle to **ON**
6. **Auto-renew SSL:** Toggle to **ON**
7. Click **"Save"** or **"Add"**

### Step 10: Deploy Backend

1. Review all settings one more time
2. Scroll to bottom of the page
3. Click **"Deploy"** or **"Save & Deploy"** button
4. You'll be redirected to the deployment logs page
5. **Wait for deployment to complete** (5-10 minutes)
   - Watch the build logs
   - Look for "Build successful" message
   - Wait for "Container started" message
   - Verify health check passes (green checkmark)

**✅ Backend Deployment Complete when you see:**
- Status: "Running" (green)
- Health Check: "Healthy" (green checkmark)
- Logs show: "Server started on port 8080"

---

## 🎯 PART 4: DEPLOY FRONTEND (Next.js) (15 minutes)

### Step 11: Create Frontend Application

1. Go back to your project dashboard
2. Click **"+ New Resource"** button again
3. Select **"Application"**
4. Choose **"Dockerfile"** as the application type
5. Click **"Continue"**

### Step 12: Configure Frontend Source Code

**Git Repository Section:**
1. **Repository:** `doctororganic/new` (same repository)
2. **Branch:** `dev` (same branch as backend)
3. **Build Pack:** Select **"Dockerfile"**

**Dockerfile Configuration:**
1. **Dockerfile Path:** `nutrition-platform/frontend-nextjs/Dockerfile`
2. **Build Context:** `nutrition-platform/frontend-nextjs`

### Step 13: Configure Frontend Application Settings

**Basic Settings:**
1. **Name:** `nutrition-platform-frontend` (or `frontend`)
2. **Description:** `Next.js Frontend Application`
3. **Port:** `3000` (Next.js default port)

**Resource Limits:**
1. **CPU Limit:** `0.75`
2. **Memory Limit:** `512M`
3. **CPU Reservation:** `0.25`
4. **Memory Reservation:** `256M`

### Step 14: Configure Frontend Environment Variables

Click on **"Environment Variables"** section and add:

**Application Configuration:**
```
NODE_ENV=production
PORT=3000
HOSTNAME=0.0.0.0
```

**API Configuration (CRITICAL):**
```
NEXT_PUBLIC_API_URL=https://api.super.doctorhealthy1.com
```

**⚠️ IMPORTANT:** 
- `NEXT_PUBLIC_API_URL` must match your backend domain
- Use `https://` (not `http://`)
- This is used during build time, so it must be set before deployment

### Step 15: Configure Frontend Health Check

1. Scroll to **"Health Check"** section
2. Enable health check: Toggle **"Enabled"** to ON
3. **Health Check Path:** `/` (root path)
4. **Health Check Port:** `3000`
5. **Interval:** `30` seconds
6. **Timeout:** `10` seconds
7. **Retries:** `3`
8. **Start Period:** `40` seconds

### Step 16: Configure Frontend Domain

1. Scroll to **"Domains"** section
2. Click **"+ Add Domain"**
3. **Domain:** `super.doctorhealthy1.com`
4. **Enable SSL:** Toggle to **ON**
5. **Force HTTPS:** Toggle to **ON**
6. **Auto-renew SSL:** Toggle to **ON**
7. Click **"Save"**

### Step 17: Configure Frontend Dependencies

1. Scroll to **"Dependencies"** or **"Service Dependencies"** section
2. Add dependency: Select `nutrition-platform-backend`
3. **Condition:** `service_healthy` (wait for backend to be healthy before starting frontend)
4. Click **"Save"**

### Step 18: Deploy Frontend

1. Review all settings
2. Click **"Deploy"** or **"Save & Deploy"** button
3. Monitor deployment logs
4. **Wait for deployment** (10-15 minutes - Next.js builds take longer)
   - Watch for "Installing dependencies"
   - Wait for "Building application"
   - Look for "Build successful"
   - Wait for "Container started"
   - Verify health check passes

**✅ Frontend Deployment Complete when you see:**
- Status: "Running" (green)
- Health Check: "Healthy" (green checkmark)
- Logs show: "Ready on port 3000"

---

## 🎯 PART 5: VERIFICATION (5 minutes)

### Step 19: Verify Backend Deployment

1. Open a new browser tab
2. Navigate to: **https://api.super.doctorhealthy1.com/health**
3. **Expected Result:** You should see a JSON response like:
   ```json
   {
     "status": "ok",
     "timestamp": "2024-12-XX...",
     "service": "nutrition-platform-api"
   }
   ```
4. **If you see this:** ✅ Backend is working correctly
5. **If you see an error:** Check Coolify logs for the backend application

### Step 20: Verify Frontend Deployment

1. Navigate to: **https://super.doctorhealthy1.com**
2. **Expected Result:** 
   - Page loads without errors
   - No console errors (check browser DevTools: F12)
   - API calls are working (check Network tab)
3. **If page loads:** ✅ Frontend is working correctly
4. **If you see errors:** 
   - Check browser console (F12 → Console tab)
   - Verify `NEXT_PUBLIC_API_URL` is correct
   - Check Coolify logs for frontend application

### Step 21: Test API Connectivity

1. Open browser DevTools (F12)
2. Go to **Network** tab
3. Refresh the frontend page
4. Look for API calls to `api.super.doctorhealthy1.com`
5. **Expected:** API calls return 200 status (success)
6. **If API calls fail:** 
   - Check CORS configuration in backend
   - Verify backend domain is correct
   - Check backend logs in Coolify

### Step 22: Verify SSL Certificates

1. Check the padlock icon in browser address bar
2. Click on the padlock
3. **Expected:** "Connection is secure" or "Certificate is valid"
4. **Certificate Issuer:** Should show "Let's Encrypt"
5. **If SSL is not working:**
   - Wait 5-10 minutes (Let's Encrypt certificates take time)
   - Check DNS records are correct
   - Verify domains are accessible
   - Check Coolify SSL logs

---

## 🎯 PART 6: POST-DEPLOYMENT CONFIGURATION (5 minutes)

### Step 23: Configure Database (if not already done)

If you're using an external PostgreSQL database:

1. Ensure database is accessible from Coolify server
2. Run database migrations (if needed):
   ```bash
   # SSH into Coolify server or use Coolify terminal
   # Navigate to backend container
   docker exec -it nutrition-platform-backend sh
   
   # Run migrations (if you have migration scripts)
   ./migrate up
   ```

### Step 24: Configure Redis (Optional)

If you're using Redis:

1. Ensure Redis is accessible from backend
2. Test Redis connection:
   ```bash
   # From backend container
   redis-cli -h your-redis-host -p 6379 -a your-redis-password ping
   # Should return: PONG
   ```

### Step 25: Set Up Monitoring

1. In Coolify dashboard, go to your applications
2. Enable **"Logs"** monitoring
3. Set up **"Alerts"** (if available):
   - Alert on health check failures
   - Alert on high memory usage
   - Alert on high CPU usage

---

## 🎯 PART 7: TROUBLESHOOTING

### Common Issues and Solutions

#### Issue 1: Backend Won't Start

**Symptoms:**
- Container keeps restarting
- Health check failing
- Logs show errors

**Solutions:**
1. Check environment variables are all set correctly
2. Verify database connection:
   - Check `DB_HOST`, `DB_PORT`, `DB_NAME`, `DB_USER`, `DB_PASSWORD`
   - Test database connection from Coolify server
3. Check logs in Coolify dashboard
4. Verify port 8080 is correct

#### Issue 2: Frontend Build Fails

**Symptoms:**
- Build logs show errors
- Deployment fails during build

**Solutions:**
1. Check `NEXT_PUBLIC_API_URL` is set correctly
2. Verify Dockerfile path: `nutrition-platform/frontend-nextjs/Dockerfile`
3. Check build context: `nutrition-platform/frontend-nextjs`
4. Review build logs for specific errors
5. Ensure Node.js version is compatible (20.14.0)

#### Issue 3: Frontend Can't Connect to Backend

**Symptoms:**
- Frontend loads but API calls fail
- CORS errors in browser console
- Network errors

**Solutions:**
1. Verify `NEXT_PUBLIC_API_URL` matches backend domain exactly:
   - Should be: `https://api.super.doctorhealthy1.com`
   - No trailing slash
   - Use `https://` not `http://`
2. Check backend CORS configuration:
   - `CORS_ORIGIN` should include frontend domain
   - Should be: `https://super.doctorhealthy1.com,https://www.super.doctorhealthy1.com`
3. Verify backend is running and healthy
4. Check backend logs for CORS errors

#### Issue 4: SSL Certificate Not Working

**Symptoms:**
- Browser shows "Not Secure"
- SSL certificate errors

**Solutions:**
1. Wait 5-10 minutes (Let's Encrypt takes time)
2. Verify DNS records point to Coolify server:
   - `super.doctorhealthy1.com` → 128.140.111.171
   - `api.super.doctorhealthy1.com` → 128.140.111.171
3. Check DNS propagation: Use `nslookup` or `dig` command
4. Verify domains are accessible (not blocked by firewall)
5. Check Coolify SSL logs

#### Issue 5: Health Check Failing

**Symptoms:**
- Health check shows red X
- Application status shows "Unhealthy"

**Solutions:**
1. Verify health check path is correct:
   - Backend: `/health`
   - Frontend: `/`
2. Check health check port matches application port
3. Verify application is actually running (check logs)
4. Test health endpoint manually:
   ```bash
   curl https://api.super.doctorhealthy1.com/health
   ```

---

## ✅ DEPLOYMENT CHECKLIST

Use this checklist to ensure everything is configured:

### Backend Checklist:
- [ ] Repository connected: `doctororganic/new`
- [ ] Branch: `dev` (or `main`)
- [ ] Dockerfile path: `nutrition-platform/backend/Dockerfile.go`
- [ ] Build context: `nutrition-platform/backend`
- [ ] Port: `8080`
- [ ] All environment variables set (DB_HOST, DB_PASSWORD, JWT_SECRET, etc.)
- [ ] Health check configured (`/health`, port `8080`)
- [ ] Domain configured: `api.super.doctorhealthy1.com`
- [ ] SSL enabled
- [ ] Deployment successful
- [ ] Health check passing

### Frontend Checklist:
- [ ] Repository connected: `doctororganic/new`
- [ ] Branch: `dev` (or `main`)
- [ ] Dockerfile path: `nutrition-platform/frontend-nextjs/Dockerfile`
- [ ] Build context: `nutrition-platform/frontend-nextjs`
- [ ] Port: `3000`
- [ ] `NEXT_PUBLIC_API_URL` set to `https://api.super.doctorhealthy1.com`
- [ ] Health check configured (`/`, port `3000`)
- [ ] Domain configured: `super.doctorhealthy1.com`
- [ ] SSL enabled
- [ ] Backend dependency configured
- [ ] Deployment successful
- [ ] Health check passing

### Verification Checklist:
- [ ] Backend health endpoint accessible: `https://api.super.doctorhealthy1.com/health`
- [ ] Frontend accessible: `https://super.doctorhealthy1.com`
- [ ] SSL certificates valid (padlock icon)
- [ ] API calls working (check browser Network tab)
- [ ] No console errors
- [ ] Database connected (check backend logs)
- [ ] CORS working (no CORS errors in console)

---

## 🎉 DEPLOYMENT COMPLETE!

Once all checkboxes are checked, your application is successfully deployed!

### Your Live URLs:
- **Frontend:** https://super.doctorhealthy1.com
- **Backend API:** https://api.super.doctorhealthy1.com
- **Health Check:** https://api.super.doctorhealthy1.com/health

### Next Steps:
1. **Monitor** your application in Coolify dashboard
2. **Test** all features (nutrition analysis, meal plans, etc.)
3. **Set up** automated backups (if not already configured)
4. **Configure** monitoring alerts
5. **Document** any custom configurations

---

## 📞 SUPPORT

If you encounter issues not covered here:

1. **Check Coolify Logs:**
   - Go to application → Logs tab
   - Look for error messages
   - Check build logs

2. **Verify Configuration:**
   - Double-check all environment variables
   - Verify Dockerfile paths
   - Confirm domain DNS settings

3. **Test Manually:**
   - Use `curl` commands to test endpoints
   - Check database connectivity
   - Verify Redis connection (if using)

4. **Review Documentation:**
   - Check `DOCKER_DEPLOYMENT_GUIDE.md`
   - Review `COOLIFY_DEPLOYMENT.md`
   - See troubleshooting sections

---

**Last Updated:** December 2024  
**Status:** ✅ Ready for Production Deployment

