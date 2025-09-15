#!/bin/bash

# 🚀 WebDiário Base Images Alpine - Build Script
# Builds all Alpine Docker images in the correct order

set -e

echo "🏗️ Building WebDiário Base Images Alpine..."

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

# Build Alpine base image first
print_status "Building Alpine base image..."
build_image "WebDiário Base Alpine" "./alpine" "webdiario-base-alpine:latest"

# Build AWS Alpine images
print_status "Building AWS Alpine images..."
build_image "WebDiário AWS Alpine" "./alpine/aws" "webdiario-aws-alpine:latest"
build_image "WebDiário AWS Java Alpine" "./alpine/aws/java" "webdiario-aws-java-alpine:latest"
build_image "WebDiário AWS Java 21 Alpine" "./alpine/aws/java/21" "webdiario-aws-java-21-alpine:latest"
build_image "WebDiário AWS Node Alpine" "./alpine/aws/node" "webdiario-aws-node-alpine:latest"
build_image "WebDiário AWS Node 22.17.1 Alpine" "./alpine/aws/node/22.17.1" "webdiario-aws-node-22.17.1-alpine:latest"

# Build GCP Alpine images
print_status "Building GCP Alpine images..."
build_image "WebDiário GCP Alpine" "./alpine/gcp" "webdiario-gcp-alpine:latest"
build_image "WebDiário GCP Java Alpine" "./alpine/gcp/java" "webdiario-gcp-java-alpine:latest"
build_image "WebDiário GCP Java 21 Alpine" "./alpine/gcp/java/21" "webdiario-gcp-java-21-alpine:latest"
build_image "WebDiário GCP Node Alpine" "./alpine/gcp/node" "webdiario-gcp-node-alpine:latest"
build_image "WebDiário GCP Node 22.17.1 Alpine" "./alpine/gcp/node/22.17.1" "webdiario-gcp-node-22.17.1-alpine:latest"

print_success "All Alpine images built successfully!"

# List all built Alpine images
print_status "Built Alpine images:"
docker images | grep webdiario | grep alpine

echo ""
print_success "🎉 WebDiário Base Images Alpine build completed!"
print_status "You can now use these Alpine images in your projects:"
echo "  - webdiario-base-alpine:latest"
echo "  - webdiario-aws-alpine:latest"
echo "  - webdiario-aws-java-alpine:latest"
echo "  - webdiario-aws-java-21-alpine:latest"
echo "  - webdiario-aws-node-alpine:latest"
echo "  - webdiario-aws-node-22.17.1-alpine:latest"
echo "  - webdiario-gcp-alpine:latest"
echo "  - webdiario-gcp-java-alpine:latest"
echo "  - webdiario-gcp-java-21-alpine:latest"
echo "  - webdiario-gcp-node-alpine:latest"
echo "  - webdiario-gcp-node-22.17.1-alpine:latest"
