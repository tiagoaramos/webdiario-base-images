#!/bin/bash

# 📚 WebDiário Base Images - Build Script for All Images
# Builds all images (Ubuntu and Alpine) with Prometheus monitoring

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

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

log "🚀 Starting WebDiário Alpine Images Build..."
log "Project root: $PROJECT_ROOT"

# Build Alpine base image
build_alpine_base() {
    log "Building webdiario/alpine:latest..."
    
    cd "$PROJECT_ROOT/alpine"
    
    if docker build -t webdiario/alpine:latest .; then
        log_success "webdiario/alpine:latest built successfully"
    else
        log_error "Failed to build webdiario/alpine:latest"
        exit 1
    fi
}

# Build all images
build_all_images() {
    log "Building all Alpine images..."
    
    # Build Alpine base image
    build_alpine_base
    
    # Note: Other Alpine images (local, java, etc.) would be built here
    # when their Dockerfiles are created in the respective directories
    
    log_success "All Alpine images built successfully"
}

# Test all images
test_all_images() {
    log "Testing all Alpine images..."
    
    # Test Alpine base image
    if docker run --rm webdiario/alpine:latest echo "Alpine base image test successful"; then
        log_success "webdiario/alpine:latest test passed"
    else
        log_error "webdiario/alpine:latest test failed"
        exit 1
    fi
}

# Main execution
main() {
    log "🏔️ WebDiário Alpine Images Build Process"
    
    # Check if Docker is running
    if ! docker info > /dev/null 2>&1; then
        log_error "Docker is not running. Please start Docker and try again."
        exit 1
    fi
    
    # Build all images
    build_all_images
    
    # Test images
    test_all_images
    
    log_success "🎯 All images built and tested successfully!"
    
    # Show built images
    log "Built images:"
    docker images | grep webdiario/ || true
}

# Run main function
main "$@"
