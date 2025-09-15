# 🟢 WebDiário GCP Node 22.17.1 Image Alpine
# Extends GCP Node Alpine base image with Node.js 22.17.1

FROM webdiario-gcp-node-alpine:latest

# Switch to root for installation
USER root

# Set specific Node.js version
ENV NODE_VERSION=22.17.1

# Install Node.js 22.17.1 using NVM
RUN . "$NVM_DIR/nvm.sh" && nvm install $NODE_VERSION && nvm use $NODE_VERSION

# Update PATH for Node.js 22.17.1
ENV PATH=$NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

# Install additional tools for Node.js 22.17.1
RUN npm install -g \
    npm@latest \
    yarn \
    pnpm \
    typescript@latest \
    @angular/cli@latest \
    @vue/cli@latest \
    create-react-app@latest

# Install Google Cloud Node.js libraries for Node 22.17.1
RUN npm install -g \
    @google-cloud/storage@latest \
    @google-cloud/bigquery@latest \
    @google-cloud/firestore@latest

# Switch back to webdiario user
USER webdiario

# Verify Node.js 22.17.1 installation
RUN node --version && npm --version

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD node --version | grep "22.17.1" || exit 1

# Default command
CMD ["/bin/bash"]
