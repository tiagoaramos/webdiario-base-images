# 🟢 WebDiário GCP Node Base Image
# Extends GCP base image with Node.js installer dependencies

FROM webdiario-gcp:latest

# Switch to root for installation
USER root

# Install Node.js installer dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    python3 \
    python3-pip \
    git \
    && rm -rf /var/lib/apt/lists/*

# Install Node Version Manager (NVM)
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash

# Set NVM environment variables
ENV NVM_DIR=/root/.nvm
ENV NODE_VERSION=18.17.0

# Install Node.js using NVM
RUN . "$NVM_DIR/nvm.sh" && nvm install $NODE_VERSION && nvm use $NODE_VERSION

# Add Node.js to PATH
ENV PATH=$NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

# Install global npm packages
RUN npm install -g \
    npm@latest \
    yarn \
    pnpm \
    typescript \
    @angular/cli \
    @vue/cli \
    create-react-app

# Install Google Cloud Node.js libraries
RUN npm install -g \
    @google-cloud/storage \
    @google-cloud/bigquery \
    @google-cloud/firestore

# Switch back to webdiario user
USER webdiario

# Verify Node.js installation
RUN node --version && npm --version

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD node --version || exit 1

# Default command
CMD ["/bin/bash"]
