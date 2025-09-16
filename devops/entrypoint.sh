#!/bin/bash

# 📚 WebDiário Base Image - Prometheus Monitoring Entrypoint
# Configures automatic Prometheus monitoring for WebDiário applications

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

# Function to set default values based on docker-compose configuration
set_default_values() {
    log "🔧 Setting default values for WebDiário Platform..."
    
    # Prometheus Configuration Defaults (based on docker-compose)
    if [ -z "$PROMETHEUS_URL" ]; then
        export PROMETHEUS_URL="http://prometheus:9090"
        log "Set default PROMETHEUS_URL: $PROMETHEUS_URL"
    fi
    
    if [ -z "$PROMETHEUS_JOB_NAME" ]; then
        export PROMETHEUS_JOB_NAME="webdiario-app"
        log "Set default PROMETHEUS_JOB_NAME: $PROMETHEUS_JOB_NAME"
    fi
    
    # Application Configuration Defaults
    if [ -z "$APP_NAME" ]; then
        export APP_NAME="webdiario-app"
        log "Set default APP_NAME: $APP_NAME"
    fi
    
    if [ -z "$APP_HOST" ]; then
        export APP_HOST="localhost"
        log "Set default APP_HOST: $APP_HOST"
    fi
    
    if [ -z "$APP_PORT" ]; then
        export APP_PORT="8080"
        log "Set default APP_PORT: $APP_PORT"
    fi
    
    # Monitoring Configuration Defaults
    if [ -z "$ENABLE_PROMETHEUS_MONITORING" ]; then
        export ENABLE_PROMETHEUS_MONITORING="true"
        log "Set default ENABLE_PROMETHEUS_MONITORING: $ENABLE_PROMETHEUS_MONITORING"
    fi
    
    if [ -z "$MONITORING_INTERVAL" ]; then
        export MONITORING_INTERVAL="5s"
        log "Set default MONITORING_INTERVAL: $MONITORING_INTERVAL"
    fi
    
    if [ -z "$METRICS_PATH" ]; then
        export METRICS_PATH="/actuator/prometheus"
        log "Set default METRICS_PATH: $METRICS_PATH"
    fi
    
    log_success "Default values configured successfully"
}

# Function to check if Prometheus is available
check_prometheus_availability() {
    if [ -n "$PROMETHEUS_URL" ]; then
        log "Checking Prometheus availability at $PROMETHEUS_URL..."
        
        # Wait for Prometheus to be available (max 30 seconds)
        for i in {1..30}; do
            if curl -s -f "$PROMETHEUS_URL/-/healthy" > /dev/null 2>&1; then
                log_success "Prometheus is available at $PROMETHEUS_URL"
                return 0
            fi
            log "Waiting for Prometheus... (attempt $i/30)"
            sleep 1
        done
        
        log_warning "Prometheus is not available at $PROMETHEUS_URL"
        return 1
    else
        log_warning "PROMETHEUS_URL not set, skipping Prometheus configuration"
        return 1
    fi
}

# Function to configure Prometheus target
configure_prometheus_target() {
    if [ -z "$PROMETHEUS_URL" ] || [ -z "$APP_HOST" ] || [ -z "$APP_PORT" ]; then
        log_warning "Prometheus or application configuration not provided, skipping target configuration"
        return 0
    fi

    log "Configuring Prometheus target for ${APP_NAME}..."

    # Create target configuration
    TARGET_CONFIG=$(cat <<EOF
{
    "targets": ["${APP_HOST}:${APP_PORT}"],
    "labels": {
        "job": "${PROMETHEUS_JOB_NAME}",
        "instance": "${APP_NAME}",
        "service": "${APP_NAME}",
        "environment": "docker"
    }
}
EOF
)

    # Note: In a real scenario, you would need to configure Prometheus to scrape this target
    # This is typically done through Prometheus configuration files or service discovery
    log_success "Prometheus target configuration prepared for ${APP_NAME}"
    log "Target: ${APP_HOST}:${APP_PORT}"
    log "Job: ${PROMETHEUS_JOB_NAME}"
    log "Metrics Path: ${METRICS_PATH}"
}

# Function to configure Prometheus metrics endpoint
configure_prometheus_metrics() {
    log "Configuring Prometheus metrics endpoint..."

    # Create metrics configuration
    cat > /app/monitoring/prometheus-config.yml <<EOF
# WebDiário Prometheus Monitoring Configuration
prometheus:
  url: "${PROMETHEUS_URL}"
  job_name: "${PROMETHEUS_JOB_NAME}"
  scrape_interval: "${MONITORING_INTERVAL}"
  metrics_path: "${METRICS_PATH}"

application:
  name: "${APP_NAME}"
  host: "${APP_HOST}"
  port: "${APP_PORT}"

monitoring:
  enabled: true
  interval: "${MONITORING_INTERVAL}"
  timeout: "10s"
  metrics_path: "${METRICS_PATH}"
EOF

    log_success "Prometheus metrics configuration created"
}

# Function to configure Prometheus monitoring
configure_prometheus_monitoring() {
    log "Configuring Prometheus monitoring..."
    
    # Create monitoring configuration file
    cat > /app/monitoring/monitoring-config.yml <<EOF
# WebDiário Prometheus Monitoring Configuration
prometheus:
  url: "${PROMETHEUS_URL}"
  job_name: "${PROMETHEUS_JOB_NAME}"
  enabled: "${ENABLE_PROMETHEUS_MONITORING}"

application:
  name: "${APP_NAME}"
  host: "${APP_HOST}"
  port: "${APP_PORT}"

monitoring:
  enabled: true
  interval: "${MONITORING_INTERVAL}"
  timeout: "10s"
  metrics_path: "${METRICS_PATH}"
EOF

    log_success "Prometheus monitoring configuration created"
}

# Main execution
main() {
    log "🚀 Starting WebDiário Prometheus Monitoring Configuration..."
    
    # Set default values first
    set_default_values
    
    # Check if we should configure Prometheus
    if [ "$ENABLE_PROMETHEUS_MONITORING" = "true" ]; then
        log "Prometheus monitoring is enabled"
        
        # Configure Prometheus monitoring
        configure_prometheus_monitoring
        configure_prometheus_metrics
        
        # Check Prometheus availability
        if check_prometheus_availability; then
            # Configure Prometheus components
            configure_prometheus_target
        else
            log_warning "Prometheus is not available, monitoring will be configured when available"
        fi
    else
        log "Prometheus monitoring is disabled (ENABLE_PROMETHEUS_MONITORING=false)"
    fi
    
    log_success "🎯 WebDiário Prometheus Monitoring Configuration completed!"
    
    # Execute the original command
    exec "$@"
}

# Run main function with all arguments
main "$@"
