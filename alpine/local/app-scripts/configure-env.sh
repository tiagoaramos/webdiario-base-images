#!/bin/bash

# 📚 WebDiário Application - Configure Environment
# Configures application based on environment variables

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

# Function to configure environment
configure_environment() {
    log "🔧 Configuring WebDiário Application Environment..."
    
    # Set default values if not provided
    ENVIRONMENT=${ENVIRONMENT:-production}
    LOG_LEVEL=${LOG_LEVEL:-info}
    APP_PORT=${APP_PORT:-8080}
    APP_NAME=${APP_NAME:-webdiario-app}
    
    # Configure based on environment
    case "$ENVIRONMENT" in
        "development")
            log "🔧 Development environment configuration"
            export LOG_LEVEL=debug
            export DEBUG=true
            export RELOAD=true
            export HOT_RELOAD=true
            ;;
        "staging")
            log "🧪 Staging environment configuration"
            export LOG_LEVEL=info
            export DEBUG=false
            export RELOAD=false
            export HOT_RELOAD=false
            ;;
        "production")
            log "🏭 Production environment configuration"
            export LOG_LEVEL=warn
            export DEBUG=false
            export RELOAD=false
            export HOT_RELOAD=false
            ;;
        *)
            log_warning "Unknown environment: $ENVIRONMENT, using production settings"
            export ENVIRONMENT=production
            export LOG_LEVEL=warn
            export DEBUG=false
            export RELOAD=false
            export HOT_RELOAD=false
            ;;
    esac
    
    # Configure database connections
    if [ -n "$DB_HOST" ]; then
        log "Database host configured: $DB_HOST"
    fi
    
    if [ -n "$DB_PORT" ]; then
        log "Database port configured: $DB_PORT"
    fi
    
    if [ -n "$DB_NAME" ]; then
        log "Database name configured: $DB_NAME"
    fi
    
    # Configure Redis
    if [ -n "$REDIS_HOST" ]; then
        log "Redis host configured: $REDIS_HOST"
    fi
    
    # Configure monitoring
    if [ -n "$GRAFANA_URL" ]; then
        log "Grafana URL configured: $GRAFANA_URL"
    fi
    
    if [ -n "$PROMETHEUS_URL" ]; then
        log "Prometheus URL configured: $PROMETHEUS_URL"
    fi
    
    log_success "Environment configuration completed"
}

# Function to create configuration files
create_config_files() {
    log "📝 Creating configuration files..."
    
    # Create application configuration
    cat > /app/config.yml <<EOF
# WebDiário Application Configuration
app:
  name: "${APP_NAME}"
  port: ${APP_PORT}
  environment: "${ENVIRONMENT}"

logging:
  level: "${LOG_LEVEL}"
  debug: ${DEBUG}

database:
  host: "${DB_HOST:-localhost}"
  port: ${DB_PORT:-3306}
  name: "${DB_NAME:-webdiario}"
  username: "${DB_USERNAME:-root}"
  password: "${DB_PASSWORD:-}"

redis:
  host: "${REDIS_HOST:-localhost}"
  port: ${REDIS_PORT:-6379}
  password: "${REDIS_PASSWORD:-}"

monitoring:
  grafana_url: "${GRAFANA_URL:-http://grafana:3000}"
  prometheus_url: "${PROMETHEUS_URL:-http://prometheus:9090}"
  enabled: ${ENABLE_GRAFANA_MONITORING:-true}
EOF
    
    # Create environment file
    cat > /app/.env <<EOF
# WebDiário Application Environment
ENVIRONMENT=${ENVIRONMENT}
LOG_LEVEL=${LOG_LEVEL}
APP_PORT=${APP_PORT}
APP_NAME=${APP_NAME}
DEBUG=${DEBUG}
RELOAD=${RELOAD}
HOT_RELOAD=${HOT_RELOAD}

# Database
DB_HOST=${DB_HOST:-localhost}
DB_PORT=${DB_PORT:-3306}
DB_NAME=${DB_NAME:-webdiario}
DB_USERNAME=${DB_USERNAME:-root}
DB_PASSWORD=${DB_PASSWORD:-}

# Redis
REDIS_HOST=${REDIS_HOST:-localhost}
REDIS_PORT=${REDIS_PORT:-6379}
REDIS_PASSWORD=${REDIS_PASSWORD:-}

# Monitoring
GRAFANA_URL=${GRAFANA_URL:-http://grafana:3000}
PROMETHEUS_URL=${PROMETHEUS_URL:-http://prometheus:9090}
ENABLE_GRAFANA_MONITORING=${ENABLE_GRAFANA_MONITORING:-true}
EOF
    
    log_success "Configuration files created"
}

# Main execution
main() {
    log "🎯 WebDiário Environment Configuration"
    
    # Configure environment
    configure_environment
    
    # Create configuration files
    create_config_files
    
    log_success "🎉 Environment configuration completed!"
    log "Environment: $ENVIRONMENT"
    log "Log Level: $LOG_LEVEL"
    log "Port: $APP_PORT"
    log "App Name: $APP_NAME"
}

# Run main function
main "$@"
