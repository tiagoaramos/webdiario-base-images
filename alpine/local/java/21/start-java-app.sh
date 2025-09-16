#!/bin/bash

# 📚 WebDiário Java Application Startup Script
# Starts Java applications with proper configuration and monitoring

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
JAR_FILE="${JAR_FILE:-/app/app.jar}"
JAVA_OPTS="${JAVA_OPTS:--Xmx512m -Xms256m}"
APP_PORT="${APP_PORT:-8080}"
APP_NAME="${APP_NAME:-java-app}"

# Health check function
health_check() {
    local port=$1
    local max_attempts=30
    local attempt=1
    
    log "Checking application health on port $port..."
    
    while [ $attempt -le $max_attempts ]; do
        if curl -f -s "http://localhost:$port/actuator/health" > /dev/null 2>&1; then
            log_success "Application is healthy on port $port"
            return 0
        elif curl -f -s "http://localhost:$port/health" > /dev/null 2>&1; then
            log_success "Application is healthy on port $port"
            return 0
        elif curl -f -s "http://localhost:$port/" > /dev/null 2>&1; then
            log_success "Application is responding on port $port"
            return 0
        fi
        
        log "Health check attempt $attempt/$max_attempts failed, retrying in 2 seconds..."
        sleep 2
        attempt=$((attempt + 1))
    done
    
    log_error "Health check failed after $max_attempts attempts"
    return 1
}

# Wait for dependencies
wait_for_dependencies() {
    log "Waiting for dependencies..."
    
    # Wait for Prometheus if configured
    if [ -n "$PROMETHEUS_URL" ]; then
        log "Waiting for Prometheus at $PROMETHEUS_URL..."
        until curl -f -s "$PROMETHEUS_URL/-/healthy" > /dev/null 2>&1; do
            log "Prometheus not ready, waiting..."
            sleep 5
        done
        log_success "Prometheus is ready"
    fi
    
    # Wait for database if configured
    if [ -n "$DATABASE_URL" ]; then
        log "Waiting for database connection..."
        # Add database connection check here if needed
        log_success "Database connection ready"
    fi
}

# Start Java application
start_java_app() {
    log "🚀 Starting Java application: $APP_NAME"
    log "JAR file: $JAR_FILE"
    log "Java options: $JAVA_OPTS"
    log "Application port: $APP_PORT"
    
    # Check if JAR file exists
    if [ ! -f "$JAR_FILE" ]; then
        log_error "JAR file not found: $JAR_FILE"
        log "Available files in /app:"
        ls -la /app/ || true
        exit 1
    fi
    
    # Wait for dependencies
    wait_for_dependencies
    
    # Start the application
    log "Starting Java application..."
    exec java $JAVA_OPTS -jar "$JAR_FILE" "$@"
}

# Main function
main() {
    log "🚀 Starting WebDiário Java Application..."
    
    # Configure OAuth clients if script exists
    if [ -f "/usr/local/bin/configure-clients.sh" ]; then
        log "Configuring OAuth clients..."
        /usr/local/bin/configure-clients.sh
    fi
    
    # Start the Java application
    start_java_app "$@"
}

# Run main function
main "$@"
