#!/bin/bash

# 📚 WebDiário Application - Start Application
# Starts application based on environment variables

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

# Function to start application
start_application() {
    log "🚀 Starting WebDiário Application..."
    
    # Set environment-specific variables
    case "$ENVIRONMENT" in
        "development")
            log "🔧 Development environment detected"
            export LOG_LEVEL=debug
            export DEBUG=true
            ;;
        "staging")
            log "🧪 Staging environment detected"
            export LOG_LEVEL=info
            export DEBUG=false
            ;;
        "production")
            log "🏭 Production environment detected"
            export LOG_LEVEL=warn
            export DEBUG=false
            ;;
        *)
            log_warning "Unknown environment: $ENVIRONMENT, using production settings"
            export ENVIRONMENT=production
            export LOG_LEVEL=warn
            export DEBUG=false
            ;;
    esac
    
    # Start application based on type
    if [ -f "app.py" ]; then
        log "Starting Python application..."
        python3 app.py
    elif [ -f "main.go" ]; then
        log "Starting Go application..."
        go run main.go
    elif [ -f "app.js" ]; then
        log "Starting Node.js application..."
        node app.js
    elif [ -f "app.jar" ]; then
        log "Starting Java application..."
        java -jar app.jar
    else
        log_error "No application file found (app.py, main.go, app.js, app.jar)"
        exit 1
    fi
}

# Function to check application health
check_health() {
    log "🔍 Checking application health..."
    
    # Wait for application to start
    sleep 5
    
    # Check if application is responding
    if curl -s http://localhost:$APP_PORT/health > /dev/null 2>&1; then
        log_success "Application is healthy"
        return 0
    else
        log_error "Application health check failed"
        return 1
    fi
}

# Function to configure OAuth clients
configure_oauth_clients() {
    log "🔐 Configuring OAuth clients..."
    
    # Run OAuth client configuration
    /usr/local/bin/configure-clients.sh
    
    log_success "OAuth clients configured successfully"
}

# Main execution
main() {
    log "🎯 WebDiário Application Startup"
    log "Environment: $ENVIRONMENT"
    log "Log Level: $LOG_LEVEL"
    log "Port: $APP_PORT"
    
    # Configure OAuth clients first
    configure_oauth_clients
    
    # Start application
    start_application &
    
    # Check health
    if check_health; then
        log_success "🎉 Application started successfully!"
    else
        log_error "❌ Application failed to start"
        exit 1
    fi
    
    # Keep container running
    wait
}

# Run main function
main "$@"
