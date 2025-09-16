#!/bin/bash

# 📚 WebDiário Nginx Application Startup Script
# Starts Nginx for serving React applications

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging function
log() {
    echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')] ✅${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[$(date +'%Y-%m-%d %H:%M:%S')] ⚠️${NC} $1"
}

log_error() {
    echo -e "${RED}[$(date +'%Y-%m-%d %H:%M:%S')] ❌${NC} $1"
}

# Default values
NGINX_PORT="${NGINX_PORT:-80}"
APP_DIR="${APP_DIR:-/app}"
NGINX_CONF="${NGINX_CONF:-/etc/nginx/nginx.conf}"

# Prometheus monitoring defaults
PROMETHEUS_URL="${PROMETHEUS_URL:-http://prometheus:9090}"
PROMETHEUS_JOB_NAME="${PROMETHEUS_JOB_NAME:-webdiario-app}"
APP_HOST="${APP_HOST:-localhost}"
MONITORING_INTERVAL="${MONITORING_INTERVAL:-5s}"
ENABLE_PROMETHEUS_MONITORING="${ENABLE_PROMETHEUS_MONITORING:-true}"

# Check Nginx availability
check_nginx() {
    log "Checking Nginx availability..."
    
    if ! nginx -v > /dev/null 2>&1; then
        log_error "Nginx is not available"
        return 1
    fi
    
    # Check Nginx version
    NGINX_VERSION=$(nginx -v 2>&1 | cut -d ' ' -f 3)
    log_success "Nginx version $NGINX_VERSION is available"
    
    return 0
}

# Validate Nginx configuration
validate_nginx_config() {
    log "Validating Nginx configuration..."
    
    if [ ! -f "$NGINX_CONF" ]; then
        log_error "Nginx configuration file not found: $NGINX_CONF"
        return 1
    fi
    
    if nginx -t -c "$NGINX_CONF"; then
        log_success "Nginx configuration is valid"
        return 0
    else
        log_error "Nginx configuration is invalid"
        return 1
    fi
}

# Create app directory if it doesn't exist
setup_app_directory() {
    log "Setting up application directory..."
    
    if [ ! -d "$APP_DIR" ]; then
        log "Creating application directory: $APP_DIR"
        mkdir -p "$APP_DIR"
    fi
    
    # Create a default index.html if none exists
    if [ ! -f "$APP_DIR/index.html" ]; then
        log "Creating default index.html"
        cat > "$APP_DIR/index.html" << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WebDiário - React App</title>
    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            margin: 0;
            padding: 20px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .container {
            text-align: center;
            background: rgba(255, 255, 255, 0.1);
            padding: 40px;
            border-radius: 20px;
            backdrop-filter: blur(10px);
            box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.37);
        }
        h1 { margin-bottom: 20px; }
        p { margin-bottom: 10px; opacity: 0.9; }
        .status { color: #4ade80; font-weight: bold; }
    </style>
</head>
<body>
    <div class="container">
        <h1>🚀 WebDiário Platform</h1>
        <p class="status">✅ Nginx is running successfully!</p>
        <p>Ready to serve React applications</p>
        <p>Place your React build files in the /app directory</p>
    </div>
</body>
</html>
EOF
    fi
    
    log_success "Application directory is ready"
}

# Start Nginx
start_nginx() {
    log "🚀 Starting Nginx application"
    log "App name: $APP_NAME"
    log "App port: $APP_PORT"
    log "API host: $API_HOST"
    log "API port: $API_PORT"
    log "API path: $API_PATH"
    log "Nginx port: $NGINX_PORT"
    log "App directory: $APP_DIR"
    log "Config file: $NGINX_CONF"
    
    # Prometheus monitoring configuration
    log "Prometheus monitoring enabled: $ENABLE_PROMETHEUS_MONITORING"
    if [ "$ENABLE_PROMETHEUS_MONITORING" = "true" ]; then
        log "Prometheus URL: $PROMETHEUS_URL"
        log "Prometheus job name: $PROMETHEUS_JOB_NAME"
        log "App host: $APP_HOST"
        log "Monitoring interval: $MONITORING_INTERVAL"
    fi
    
    # Check Nginx
    check_nginx || exit 1
    
    # Setup app directory
    setup_app_directory
    
    # Generate nginx configuration from template
    log "Generating Nginx configuration from template..."
    /usr/local/bin/generate-nginx-config.sh
    
    # Set proper permissions for nginx directories
    chown -R nginx:nginx /var/log/nginx /var/lib/nginx /tmp/nginx /app
    
    # Validate configuration
    validate_nginx_config || exit 1
    
    # Switch to nginx user for running nginx
    log "Switching to nginx user..."
    exec su-exec nginx nginx -g "daemon off;" -c "$NGINX_CONF"
}

# Main function
main() {
    log "🚀 Starting WebDiário Nginx Application..."
    
    # Start Nginx
    start_nginx
}

# Run main function
main "$@"
