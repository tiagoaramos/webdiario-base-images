# ☁️ WebDiário GCP Base Image
# Extends the base image with Google Cloud SDK and dependencies

FROM webdiario-base:latest

# Switch to root for installation
USER root

# Add Google Cloud SDK repository
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list

# Import Google Cloud SDK key
RUN curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -

# Install Google Cloud SDK
RUN apt-get update && apt-get install -y \
    google-cloud-cli \
    google-cloud-cli-gke-gcloud-auth-plugin \
    kubectl \
    && rm -rf /var/lib/apt/lists/*

# Install additional GCP tools
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    jq \
    && rm -rf /var/lib/apt/lists/*

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
