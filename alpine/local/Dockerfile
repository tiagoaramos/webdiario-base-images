# 📚 WebDiário Alpine Local Base Image - OAuth Configuration
# This image works in any environment (dev, staging, production)
# Inherits from webdiario/alpine with OAuth client configuration
# Tag: webdiario/alpine/local

FROM webdiario/alpine:latest

# Set environment variables (can be overridden)
ENV ENVIRONMENT=production
ENV LOG_LEVEL=info
ENV APP_PORT=8080
ENV APP_NAME=webdiario-app

# Install minimal runtime dependencies
USER root
RUN apk add --no-cache \
    # Database Clients
    mysql-client \
    postgresql-client \
    redis \
    # Runtime Tools
    git \
    vim \
    nano \
    htop \
    tree \
    jq \
    # Network Tools
    netcat-openbsd \
    # Additional Tools
    openssh-client \
    rsync \
    unzip \
    tar \
    gzip \
    # UUID generation
    util-linux

# Create application user
RUN adduser -D -s /bin/bash appuser && \
    echo 'appuser:app123' | chpasswd

# Create application directories
RUN mkdir -p /app /home/appuser/app /home/appuser/.ssh

# Set up application environment
RUN chown -R appuser:appuser /app /home/appuser

# Configure Git
RUN git config --global user.name "WebDiário Application" && \
    git config --global user.email "app@webdiario.com" && \
    git config --global init.defaultBranch master

# Create application scripts
COPY alpine/local/app-scripts/ /usr/local/bin/
RUN chmod +x /usr/local/bin/*.sh

# Set working directory
WORKDIR /app

# Switch to application user
USER appuser

# Set up shell environment
RUN echo 'alias ll="ls -la"' >> /home/appuser/.bashrc && \
    echo 'alias la="ls -la"' >> /home/appuser/.bashrc && \
    echo 'alias ..="cd .."' >> /home/appuser/.bashrc

# Expose application port
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8080/health || exit 1

# Default command
CMD ["/bin/bash"]
