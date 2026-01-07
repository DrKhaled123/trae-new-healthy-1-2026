#!/bin/bash

# Automated Coolify Deployment via REST API
# Deploys Backend + Frontend based on deployment plan

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log() { echo -e "${BLUE}[DEPLOY]${NC} $1"; }
success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }
warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }

# Configuration
COOLIFY_URL="http://213.199.36.17:8003"
COOLIFY_TOKEN="${COOLIFY_API_TOKEN:-1|vK4ThPO8Uq6QMW58hOOLP1MjoEgVLmmsKkDK2qA016a8348d}"
PROJECT_UUID="ggwsws84co00844wokgkw08g"
ENVIRONMENT_UUID="v0gkkkgocwswogsc4gkw4g4g"
SERVER_UUID="qcow8kos0gwso4w44ogokgck"

# Generated Credentials
JWT_SECRET="${JWT_SECRET:-$(openssl rand -hex 32)}"
API_KEY_SECRET="${API_KEY_SECRET:-$(openssl rand -hex 32)}"
DB_PASSWORD="${DB_PASSWORD:-$(openssl rand -hex 16)}"
REDIS_PASSWORD="${REDIS_PASSWORD:-$(openssl rand -hex 16)}"
SESSION_SECRET="${SESSION_SECRET:-$(openssl rand -hex 16)}"

echo ""
echo "🚀 ==========================================="
echo "🚀 COOLIFY AUTOMATED DEPLOYMENT"
echo "🚀 ==========================================="
echo ""

log "Configuration:"
echo "  Project: new doctorhealthy1"
echo "  Environment: production"
echo "  Frontend Domain: doctorhealthy1.com"
echo "  Backend Domain: backend.doctorhealthy1.com"
echo ""

# Function to make API calls
api_call() {
    local method=$1
    local endpoint=$2
    local data=$3
    
    if [ -n "$data" ]; then
        curl -s -X "$method" \
            -H "Authorization: Bearer $COOLIFY_TOKEN" \
            -H "Content-Type: application/json" \
            -H "Accept: application/json" \
            -d "$data" \
            "$COOLIFY_URL/api/v1$endpoint"
    else
        curl -s -X "$method" \
            -H "Authorization: Bearer $COOLIFY_TOKEN" \
            -H "Accept: application/json" \
            "$COOLIFY_URL/api/v1$endpoint"
    fi
}

# Step 1: Create Backend Application
log "🚀 Creating Backend Application..."

BACKEND_DATA=$(cat <<EOF
{
  "name": "nutrition-platform-backend",
  "description": "Go Backend API Server",
  "project_uuid": "$PROJECT_UUID",
  "environment_uuid": "$ENVIRONMENT_UUID",
  "server_uuid": "$SERVER_UUID",
  "git_repository": "doctororganic/new",
  "git_branch": "dev",
  "build_pack": "dockerfile",
  "dockerfile_location": "nutrition-platform/backend/Dockerfile.go",
  "dockerfile_build_context": "nutrition-platform/backend",
  "ports_exposes": "8080",
  "health_check_path": "/health",
  "health_check_port": 8080,
  "health_check_interval": 30,
  "health_check_timeout": 10,
  "health_check_retries": 3,
  "health_check_start_period": 40
}
EOF
)

BACKEND_RESPONSE=$(api_call "POST" "/applications" "$BACKEND_DATA")

if echo "$BACKEND_RESPONSE" | grep -q "error\|Error"; then
    error "Backend creation failed: $BACKEND_RESPONSE"
fi

BACKEND_UUID=$(echo "$BACKEND_RESPONSE" | grep -o '"uuid":"[^"]*"' | head -1 | cut -d'"' -f4)

if [ -z "$BACKEND_UUID" ]; then
    error "Could not extract backend UUID. Response: $BACKEND_RESPONSE"
fi

success "✅ Backend application created: $BACKEND_UUID"

# Step 2: Add Backend Environment Variables
log "⚙️ Configuring Backend Environment Variables..."

BACKEND_ENV_DATA=$(cat <<EOF
{
  "key": "PORT",
  "value": "8080",
  "is_build_time": false,
  "is_multiline": false
}
EOF
)

# Add all backend env vars
ENV_VARS=(
    "PORT=8080"
    "ENV=production"
    "DOMAIN=doctorhealthy1.com"
    "DB_HOST=postgres"
    "DB_PORT=5432"
    "DB_NAME=nutrition_platform"
    "DB_USER=postgres"
    "DB_PASSWORD=$DB_PASSWORD"
    "DB_SSL_MODE=require"
    "JWT_SECRET=$JWT_SECRET"
    "API_KEY_SECRET=$API_KEY_SECRET"
    "SESSION_SECRET=$SESSION_SECRET"
    "CORS_ORIGIN=https://doctorhealthy1.com,https://www.doctorhealthy1.com"
    "CORS_CREDENTIALS=true"
    "REDIS_HOST=redis"
    "REDIS_PORT=6379"
    "REDIS_PASSWORD=$REDIS_PASSWORD"
)

for env_var in "${ENV_VARS[@]}"; do
    KEY=$(echo "$env_var" | cut -d'=' -f1)
    VALUE=$(echo "$env_var" | cut -d'=' -f2-)
    
    ENV_DATA=$(cat <<EOF
{
  "key": "$KEY",
  "value": "$VALUE",
  "is_build_time": false,
  "is_multiline": false
}
EOF
)
    
    api_call "POST" "/applications/$BACKEND_UUID/environment/variables" "$ENV_DATA" > /dev/null
done

success "✅ Backend environment variables configured"

# Step 3: Add Backend Domain
log "🌐 Configuring Backend Domain..."

DOMAIN_DATA=$(cat <<EOF
{
  "domain": "backend.doctorhealthy1.com",
  "is_letsencrypt_enabled": true,
  "is_force_https_enabled": true
}
EOF
)

api_call "POST" "/applications/$BACKEND_UUID/domains" "$DOMAIN_DATA" > /dev/null

success "✅ Backend domain configured: backend.doctorhealthy1.com"

# Step 4: Create Frontend Application
log "🚀 Creating Frontend Application..."

FRONTEND_DATA=$(cat <<EOF
{
  "name": "nutrition-platform-frontend",
  "description": "Next.js Frontend Application",
  "project_uuid": "$PROJECT_UUID",
  "environment_uuid": "$ENVIRONMENT_UUID",
  "server_uuid": "$SERVER_UUID",
  "git_repository": "doctororganic/new",
  "git_branch": "dev",
  "build_pack": "dockerfile",
  "dockerfile_location": "nutrition-platform/frontend-nextjs/Dockerfile",
  "dockerfile_build_context": "nutrition-platform/frontend-nextjs",
  "ports_exposes": "3000",
  "health_check_path": "/",
  "health_check_port": 3000,
  "health_check_interval": 30,
  "health_check_timeout": 10,
  "health_check_retries": 3,
  "health_check_start_period": 40
}
EOF
)

FRONTEND_RESPONSE=$(api_call "POST" "/applications" "$FRONTEND_DATA")

if echo "$FRONTEND_RESPONSE" | grep -q "error\|Error"; then
    error "Frontend creation failed: $FRONTEND_RESPONSE"
fi

FRONTEND_UUID=$(echo "$FRONTEND_RESPONSE" | grep -o '"uuid":"[^"]*"' | head -1 | cut -d'"' -f4)

if [ -z "$FRONTEND_UUID" ]; then
    error "Could not extract frontend UUID. Response: $FRONTEND_RESPONSE"
fi

success "✅ Frontend application created: $FRONTEND_UUID"

# Step 5: Add Frontend Environment Variables
log "⚙️ Configuring Frontend Environment Variables..."

FRONTEND_ENV_VARS=(
    "NODE_ENV=production"
    "PORT=3000"
    "HOSTNAME=0.0.0.0"
    "NEXT_PUBLIC_API_URL=https://backend.doctorhealthy1.com"
)

for env_var in "${FRONTEND_ENV_VARS[@]}"; do
    KEY=$(echo "$env_var" | cut -d'=' -f1)
    VALUE=$(echo "$env_var" | cut -d'=' -f2-)
    
    ENV_DATA=$(cat <<EOF
{
  "key": "$KEY",
  "value": "$VALUE",
  "is_build_time": true,
  "is_multiline": false
}
EOF
)
    
    api_call "POST" "/applications/$FRONTEND_UUID/environment/variables" "$ENV_DATA" > /dev/null
done

success "✅ Frontend environment variables configured"

# Step 6: Add Frontend Domain
log "🌐 Configuring Frontend Domain..."

DOMAIN_DATA=$(cat <<EOF
{
  "domain": "doctorhealthy1.com",
  "is_letsencrypt_enabled": true,
  "is_force_https_enabled": true
}
EOF
)

api_call "POST" "/applications/$FRONTEND_UUID/domains" "$DOMAIN_DATA" > /dev/null

success "✅ Frontend domain configured: doctorhealthy1.com"

# Step 7: Trigger Deployments
log "🚀 Triggering Backend Deployment..."
api_call "POST" "/applications/$BACKEND_UUID/deploy" '{"force_rebuild":true,"pull":true}' > /dev/null
success "✅ Backend deployment triggered"

log "🚀 Triggering Frontend Deployment..."
api_call "POST" "/applications/$FRONTEND_UUID/deploy" '{"force_rebuild":true,"pull":true}' > /dev/null
success "✅ Frontend deployment triggered"

# Save credentials
CREDENTIALS_FILE="coolify-deployment-credentials.txt"
cat > "$CREDENTIALS_FILE" <<EOF
===========================================
COOLIFY DEPLOYMENT CREDENTIALS
Generated: $(date)
===========================================

Backend UUID: $BACKEND_UUID
Frontend UUID: $FRONTEND_UUID

Database Password: $DB_PASSWORD
Redis Password: $REDIS_PASSWORD
JWT Secret: $JWT_SECRET
API Key Secret: $API_KEY_SECRET
Session Secret: $SESSION_SECRET

===========================================
⚠️ SAVE THIS FILE SECURELY!
===========================================
EOF

success "✅ Credentials saved to: $CREDENTIALS_FILE"

# Summary
echo ""
echo "🎉 ==========================================="
echo "🎉 DEPLOYMENT INITIATED!"
echo "🎉 ==========================================="
echo ""
echo "📍 Application URLs:"
echo "   🌐 Frontend: https://doctorhealthy1.com"
echo "   🔧 Backend: https://backend.doctorhealthy1.com"
echo "   🏥 Health: https://backend.doctorhealthy1.com/health"
echo ""
echo "📊 Coolify Dashboard:"
echo "   🌐 URL: $COOLIFY_URL"
echo "   📱 Backend UUID: $BACKEND_UUID"
echo "   📱 Frontend UUID: $FRONTEND_UUID"
echo ""
echo "⏳ Deployment Status:"
echo "   - Check Coolify dashboard for build progress"
echo "   - Builds typically take 5-15 minutes"
echo "   - SSL certificates will auto-configure (5-10 min)"
echo ""
success "🚀 Deployment process started successfully!"

