# Jenkins CI/CD Setup Guide

## Complete Setup Instructions

### Prerequisites
- Jenkins v2.330+
- Node.js 20+
- Git plugin installed
- GitHub plugin installed

### Step 1: Install Plugins
1. Manage Jenkins → Plugin Manager
2. Install: Git, GitHub, Pipeline, NodeJS Plugin

### Step 2: Add Credentials
1. Manage Jenkins → Credentials
2. Add GitHub token (Secret text)
3. Add SSH key (SSH Username with private key)

### Step 3: Create Pipeline Job
1. New Item → trae-nutrition-deploy → Pipeline
2. GitHub project: https://github.com/doctororganic/new/
3. Build Triggers: Check "GitHub hook trigger for GITscm polling"
4. Pipeline: Pipeline script from SCM
   - SCM: Git
   - URL: https://github.com/doctororganic/new.git
   - Script Path: Jenkinsfile

### Step 4: GitHub Webhook
1. Repo Settings → Webhooks → Add
2. URL: http://your-jenkins-url:8080/github-webhook/
3. Save

### Step 5: Deploy Server Setup
```bash
ssh user@your-server.com
sudo bash /path/to/scripts/setup-deployment.sh
```

### Step 6: Test
```bash
git push origin main
```

For detailed troubleshooting, see logs in Jenkins console.
