pipeline {
    agent any

    parameters {
        choice(name: 'DEPLOYMENT_ENV', choices: ['staging', 'production'], description: 'Deployment environment')
        string(name: 'NODE_VERSION', defaultValue: '20.x', description: 'Node.js version to use')
    }

    environment {
        REPO_URL = 'https://github.com/doctororganic/new.git'
        BRANCH = "${env.BRANCH_NAME ?: 'main'}"
        NODE_ENV = "${params.DEPLOYMENT_ENV}"
        APP_HOME = '/var/www/trae-nutrition-app'
        PM2_NAME = 'trae-app'
    }

    options {
        timestamps()
        timeout(time: 30, unit: 'MINUTES')
        buildDiscarder(logRotator(numToKeepStr: '10'))
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    echo "🔄 Checking out code from ${REPO_URL}"
                    checkout([
                        $class: 'GitSCM',
                        branches: [[name: "*/${BRANCH}"]],
                        userRemoteConfigs: [[url: "${REPO_URL}"]]
                    ])
                }
            }
        }

        stage('Setup') {
            steps {
                script {
                    echo "🔧 Setting up Node.js ${params.NODE_VERSION}"
                    sh '''
                        node --version
                        npm --version
                    '''
                }
            }
        }

        stage('Install Dependencies') {
            steps {
                script {
                    echo "📦 Installing dependencies..."
                    sh '''
                        cd frontend
                        npm ci --prefer-offline --no-audit
                    '''
                }
            }
        }

        stage('Build') {
            steps {
                script {
                    echo "🏗️  Building application..."
                    sh '''
                        cd frontend
                        NODE_ENV=production npm run build
                    '''
                }
            }
        }

        stage('Deploy') {
            when {
                branch 'main'
            }
            steps {
                script {
                    echo "🚀 Deploying to ${NODE_ENV}..."
                    sh '''
                        TARGET_DIR="/var/www/trae-nutrition-app"
                        mkdir -p "${TARGET_DIR}"
                        cp -r frontend/.next "${TARGET_DIR}/"
                        cp frontend/package.json "${TARGET_DIR}/"
                        cd "${TARGET_DIR}"
                        npm ci --only=production
                        pm2 restart trae-app || pm2 start ecosystem.config.js
                    '''
                }
            }
        }
    }

    post {
        success {
            echo "✅ Deployment successful!"
        }
        failure {
            echo "❌ Deployment failed!"
        }
    }
}
