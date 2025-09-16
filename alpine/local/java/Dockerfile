# 📚 WebDiário Alpine Local Java Base Image - Build Dependencies
# This image contains basic build dependencies without Java tools
# Inherits from webdiario/alpine/local with build tools
# Tag: webdiario/alpine/local/java

FROM webdiario/alpine/local:latest

# Set environment variables for development
ENV DEVELOPMENT_MODE=true

# Install basic build dependencies (without Java tools)
USER root
RUN apk add --no-cache \
    # Build tools
    make \
    gcc \
    g++ \
    musl-dev \
    linux-headers \
    # Additional build tools
    git \
    curl \
    wget \
    unzip \
    tar \
    gzip \
    # Development tools
    vim \
    nano \
    tree \
    htop \
    jq \
    # Certificates and repositories
    ca-certificates \
    openssl

# Create basic development directories
RUN mkdir -p /home/appuser/.ssh

# Set permissions
RUN chown -R appuser:appuser /home/appuser

# Switch back to application user
USER appuser

# Set up basic shell environment
RUN echo 'alias ll="ls -la"' >> /home/appuser/.bashrc && \
    echo 'alias la="ls -la"' >> /home/appuser/.bashrc && \
    echo 'alias ..="cd .."' >> /home/appuser/.bashrc

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD echo "WebDiário Java Dependencies Base Image is healthy" || exit 1

# Default command
CMD ["/bin/bash"]
