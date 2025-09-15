#!/bin/bash

# 🚀 WebDiário Base Images - Build Script
# Builds all Docker images in the correct order

set -e

echo "🏗️ Building WebDiário Base Images..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to build image
build_image() {
    local image_name=$1
    local dockerfile_path=$2
    local tag=$3
    
    print_status "Building $image_name from $dockerfile_path..."
    
    if docker build -t "$tag" "$dockerfile_path"; then
        print_success "Successfully built $image_name"
    else
        print_error "Failed to build $image_name"
        exit 1
    fi
}

# Build base image first
print_status "Building base image..."
build_image "WebDiário Base" "." "webdiario-base:latest"

# Build AWS images
print_status "Building AWS images..."
build_image "WebDiário AWS" "./aws" "webdiario-aws:latest"
build_image "WebDiário AWS Java" "./aws/java" "webdiario-aws-java:latest"
build_image "WebDiário AWS Java 21" "./aws/java/21" "webdiario-aws-java-21:latest"
build_image "WebDiário AWS Node" "./aws/node" "webdiario-aws-node:latest"
build_image "WebDiário AWS Node 22.17.1" "./aws/node/22.17.1" "webdiario-aws-node-22.17.1:latest"

# Build GCP images
print_status "Building GCP images..."
build_image "WebDiário GCP" "./gcp" "webdiario-gcp:latest"
build_image "WebDiário GCP Java" "./gcp/java" "webdiario-gcp-java:latest"
build_image "WebDiário GCP Java 21" "./gcp/java/21" "webdiario-gcp-java-21:latest"
build_image "WebDiário GCP Node" "./gcp/node" "webdiario-gcp-node:latest"
build_image "WebDiário GCP Node 22.17.1" "./gcp/node/22.17.1" "webdiario-gcp-node-22.17.1:latest"

print_success "All images built successfully!"

# List all built images
print_status "Built images:"
docker images | grep webdiario

echo ""
print_success "🎉 WebDiário Base Images build completed!"
print_status "You can now use these images in your projects:"
echo "  - webdiario-base:latest"
echo "  - webdiario-aws:latest"
echo "  - webdiario-aws-java:latest"
echo "  - webdiario-aws-java-21:latest"
echo "  - webdiario-aws-node:latest"
echo "  - webdiario-aws-node-22.17.1:latest"
echo "  - webdiario-gcp:latest"
echo "  - webdiario-gcp-java:latest"
echo "  - webdiario-gcp-java-21:latest"
echo "  - webdiario-gcp-node:latest"
echo "  - webdiario-gcp-node-22.17.1:latest"
