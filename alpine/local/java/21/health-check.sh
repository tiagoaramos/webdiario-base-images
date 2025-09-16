#!/bin/bash

# 📚 WebDiário Java Application Health Check
# Performs comprehensive health checks for Java applications

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
APP_PORT="${APP_PORT:-8080}"
HEALTH_ENDPOINT="${HEALTH_ENDPOINT:-/actuator/health}"

# Check Java availability
check_java() {
    log "Checking Java availability..."
    
    if ! java -version > /dev/null 2>&1; then
        log_error "Java is not available"
        return 1
    fi
    
    # Check Java version
    JAVA_VERSION=$(java -version 2>&1 | head -n 1 | cut -d '"' -f 2 | cut -d '.' -f 1)
    if [ "$JAVA_VERSION" -lt 17 ]; then
        log_warning "Java version $JAVA_VERSION is below recommended version 17"
    else
        log_success "Java version $JAVA_VERSION is available"
    fi
    
    return 0
}

# Check Maven availability (optional)
check_maven() {
    log "Checking Maven availability..."
    
    if command -v mvn > /dev/null 2>&1; then
        if mvn --version > /dev/null 2>&1; then
            log_success "Maven is available"
            return 0
        fi
    fi
    
    log_warning "Maven is not available (optional)"
    return 0
}

# Check Gradle availability (optional)
check_gradle() {
    log "Checking Gradle availability..."
    
    if command -v gradle > /dev/null 2>&1; then
        if gradle --version > /dev/null 2>&1; then
            log_success "Gradle is available"
            return 0
        fi
    fi
    
    log_warning "Gradle is not available (optional)"
    return 0
}

# Check application health endpoint
check_application_health() {
    log "Checking application health on port $APP_PORT..."
    
    # Try different health endpoints
    local endpoints=("$HEALTH_ENDPOINT" "/health" "/actuator/health" "/")
    local success=false
    
    for endpoint in "${endpoints[@]}"; do
        if curl -f -s "http://localhost:$APP_PORT$endpoint" > /dev/null 2>&1; then
            log_success "Application is healthy on port $APP_PORT (endpoint: $endpoint)"
            success=true
            break
        fi
    done
    
    if [ "$success" = false ]; then
        log_error "Application health check failed on port $APP_PORT"
        return 1
    fi
    
    return 0
}

# Check Prometheus connectivity
check_prometheus() {
    if [ -n "$PROMETHEUS_URL" ]; then
        log "Checking Prometheus connectivity at $PROMETHEUS_URL..."
        
        if curl -f -s "$PROMETHEUS_URL/-/healthy" > /dev/null 2>&1; then
            log_success "Prometheus is accessible"
            return 0
        else
            log_warning "Prometheus is not accessible at $PROMETHEUS_URL"
            return 1
        fi
    else
        log "Prometheus URL not configured, skipping check"
        return 0
    fi
}

# Check Prometheus connectivity (enhanced)
check_prometheus_enhanced() {
    if [ -n "$PROMETHEUS_URL" ]; then
        log "Checking Prometheus connectivity at $PROMETHEUS_URL..."
        
        # Check Prometheus health endpoint
        if curl -f -s "$PROMETHEUS_URL/-/healthy" > /dev/null 2>&1; then
            log_success "Prometheus is accessible and healthy"
            
            # Check if metrics endpoint is available
            if curl -f -s "$PROMETHEUS_URL/api/v1/query?query=up" > /dev/null 2>&1; then
                log_success "Prometheus query API is working"
                return 0
            else
                log_warning "Prometheus query API is not responding"
                return 1
            fi
        else
            log_warning "Prometheus is not accessible at $PROMETHEUS_URL"
            return 1
        fi
    else
        log "Prometheus URL not configured, skipping check"
        return 0
    fi
}

# Main health check function
main() {
    log "🚀 Starting WebDiário Java Application Health Check..."
    
    local exit_code=0
    
    # Check Java tools
    check_java || exit_code=1
    check_maven || exit_code=1
    check_gradle || exit_code=1
    
    # Check application health
    check_application_health || exit_code=1
    
    # Check external services
    check_prometheus || exit_code=1
    check_prometheus_enhanced || exit_code=1
    
    if [ $exit_code -eq 0 ]; then
        log_success "All health checks passed"
    else
        log_error "Some health checks failed"
    fi
    
    exit $exit_code
}

# Run main function
main "$@"
