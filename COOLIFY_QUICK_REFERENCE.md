# 🚀 Coolify Deployment - Quick Reference Card

## 📍 Quick Links

- **Coolify Dashboard:** https://api.doctorhealthy1.com
- **Frontend URL:** https://super.doctorhealthy1.com
- **Backend URL:** https://api.super.doctorhealthy1.com
- **Health Check:** https://api.super.doctorhealthy1.com/health
- **GitHub Repo:** https://github.com/doctororganic/new

---

## 🔑 Critical Configuration Values

### Backend Configuration
```
Repository: doctororganic/new
Branch: dev
Dockerfile: nutrition-platform/backend/Dockerfile.go
Build Context: nutrition-platform/backend
Port: 8080
Domain: api.super.doctorhealthy1.com
Health Check: /health (port 8080)
```

### Frontend Configuration
```
Repository: doctororganic/new
Branch: dev
Dockerfile: nutrition-platform/frontend-nextjs/Dockerfile
Build Context: nutrition-platform/frontend-nextjs
Port: 3000
Domain: super.doctorhealthy1.com
Health Check: / (port 3000)
```

---

## 🔐 Required Environment Variables

### Backend (All Required)
```
DB_HOST=your-postgres-host
DB_PORT=5432
DB_NAME=nutrition_platform
DB_USER=postgres
DB_PASSWORD=your-generated-password
DB_SSL_MODE=require
PORT=8080
ENV=production
DOMAIN=super.doctorhealthy1.com
JWT_SECRET=your-generated-64-char-secret
API_KEY_SECRET=your-generated-64-char-secret
SESSION_SECRET=your-generated-32-char-secret
CORS_ORIGIN=https://super.doctorhealthy1.com,https://www.super.doctorhealthy1.com
CORS_CREDENTIALS=true
REDIS_HOST=your-redis-host (optional)
REDIS_PORT=6379 (optional)
REDIS_PASSWORD=your-redis-password (optional)
```

### Frontend (Critical)
```
NODE_ENV=production
PORT=3000
HOSTNAME=0.0.0.0
NEXT_PUBLIC_API_URL=https://api.super.doctorhealthy1.com
```

---

## ⚡ Quick Commands

### Generate Secrets
```bash
# JWT Secret (64 chars)
openssl rand -hex 32

# Database Password (32 chars)
openssl rand -hex 16

# Redis Password (32 chars)
openssl rand -hex 16
```

### Test Deployment
```bash
# Test Backend Health
curl https://api.super.doctorhealthy1.com/health

# Test Frontend
curl https://super.doctorhealthy1.com

# Check SSL Certificate
openssl s_client -connect super.doctorhealthy1.com:443 -servername super.doctorhealthy1.com
```

---

## ✅ Deployment Checklist

### Backend
- [ ] Repository: `doctororganic/new`
- [ ] Branch: `dev`
- [ ] Dockerfile: `nutrition-platform/backend/Dockerfile.go`
- [ ] Context: `nutrition-platform/backend`
- [ ] Port: `8080`
- [ ] Domain: `api.super.doctorhealthy1.com`
- [ ] SSL: Enabled
- [ ] Health Check: `/health` on port `8080`
- [ ] All env vars set
- [ ] Deployed & Healthy

### Frontend
- [ ] Repository: `doctororganic/new`
- [ ] Branch: `dev`
- [ ] Dockerfile: `nutrition-platform/frontend-nextjs/Dockerfile`
- [ ] Context: `nutrition-platform/frontend-nextjs`
- [ ] Port: `3000`
- [ ] Domain: `super.doctorhealthy1.com`
- [ ] SSL: Enabled
- [ ] Health Check: `/` on port `3000`
- [ ] `NEXT_PUBLIC_API_URL` = `https://api.super.doctorhealthy1.com`
- [ ] Backend dependency set
- [ ] Deployed & Healthy

---

## 🆘 Common Issues

| Issue | Solution |
|-------|----------|
| Backend won't start | Check DB credentials, verify all env vars |
| Frontend build fails | Verify `NEXT_PUBLIC_API_URL`, check Dockerfile path |
| CORS errors | Check `CORS_ORIGIN` includes frontend domain |
| SSL not working | Wait 5-10 min, verify DNS records |
| Health check fails | Verify path/port, check app logs |

---

## 📚 Full Documentation

For complete step-by-step instructions, see:
**`COOLIFY_DEPLOYMENT_STEPS.md`**

---

**Last Updated:** December 2024

