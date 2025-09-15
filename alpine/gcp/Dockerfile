# ☁️ WebDiário GCP Base Image Alpine
# Extends the Alpine base image with Google Cloud SDK and dependencies

FROM webdiario-base-alpine:latest

# Switch to root for installation
USER root

# Install Google Cloud SDK dependencies
RUN apk add --no-cache \
    python3 \
    py3-pip \
    jq \
    curl \
    bash \
    openssh-client \
    git

# Install Google Cloud SDK
RUN curl https://sdk.cloud.google.com | bash

# Add Google Cloud SDK to PATH
ENV PATH=/root/google-cloud-sdk/bin:$PATH

# Install kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
    && chmod +x kubectl \
    && mv kubectl /usr/local/bin/

# Install Google Cloud SDK for Python
RUN pip3 install google-cloud-storage google-cloud-bigquery google-cloud-firestore

# Set GCP environment variables
ENV GOOGLE_APPLICATION_CREDENTIALS=/app/credentials.json
ENV GCLOUD_PROJECT=webdiario-project

# Switch back to webdiario user
USER webdiario

# Verify Google Cloud SDK installation
RUN gcloud --version

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD gcloud --version || exit 1

# Default command
CMD ["/bin/bash"]
