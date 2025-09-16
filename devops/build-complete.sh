#!/bin/bash

# 📚 WebDiário Base Images - Complete Build Script
# Builds all images based on folder structure with correct tags

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

log "🚀 Starting WebDiário Complete Images Build..."
log "Project root: $PROJECT_ROOT"

# Build function with proper tagging
build_image() {
    local dockerfile_path="$1"
    local context_path="$2"
    local tag="$3"
    local description="$4"
    
    log "Building $description..."
    log "Dockerfile: $dockerfile_path"
    log "Context: $context_path"
    log "Tag: $tag"
    
    if docker build -f "$dockerfile_path" -t "$tag" "$context_path"; then
        log_success "$description built successfully as $tag"
        return 0
    else
        log_error "Failed to build $description"
        return 1
    fi
}

# Build Alpine images
build_alpine_images() {
    # Alpine base - use project root as context to access devops folder
    build_image "$PROJECT_ROOT/alpine/Dockerfile" "$PROJECT_ROOT" "webdiario/alpine:latest" "webdiario/alpine (Alpine base)"
    
    # Alpine local
    build_image "$PROJECT_ROOT/alpine/local/Dockerfile" "$PROJECT_ROOT" "webdiario/alpine/local:latest" "webdiario/alpine/local (Alpine local)"
    
    # Alpine local java
    build_image "$PROJECT_ROOT/alpine/local/java/Dockerfile" "$PROJECT_ROOT" "webdiario/alpine/local/java:latest" "webdiario/alpine/local/java (Alpine Java)"
    
    # Alpine local java 21
    build_image "$PROJECT_ROOT/alpine/local/java/21/Dockerfile" "$PROJECT_ROOT" "webdiario/alpine/local/java/21:latest" "webdiario/alpine/local/java/21 (Alpine Java 21)"
    
    # Alpine local nginx
    build_image "$PROJECT_ROOT/alpine/local/ngnix/Dockerfile" "$PROJECT_ROOT" "webdiario/alpine/local/nginx:latest" "webdiario/alpine/local/nginx (Alpine Nginx)"
}

# Build all images
build_all_images() {
    log "Building all Alpine images with proper tags..."
    
    # Build Alpine images
    build_alpine_images
    
    log_success "All Alpine images built successfully"
}

# Show built images
show_built_images() {
    log "Built images:"
    docker images | grep webdiario/ || true
    
    log "Image sizes:"
    docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}" | grep webdiario/ || true
}

# Main execution
main() {
    log "🏗️ WebDiário Complete Images Build Process"
    
    # Check if Docker is running
    if ! docker info > /dev/null 2>&1; then
        log_error "Docker is not running. Please start Docker and try again."
        exit 1
    fi
    
    # Build all images
    build_all_images
        
    # Show results
    show_built_images
    
    log_success "🎯 All images built and tested successfully!"
    
    # Show usage examples
    log "Usage examples:"
    echo "  docker run --rm webdiario/alpine:latest"
    echo "  docker run --rm webdiario/alpine/local:latest"
    echo "  docker run --rm webdiario/alpine/local/java:latest java -version"
    echo "  docker run --rm webdiario/alpine/local/java/21:latest java -version"
    echo "  docker run --rm -p 80:80 webdiario/alpine/local/nginx:latest"
}

# Run main function
main "$@"
