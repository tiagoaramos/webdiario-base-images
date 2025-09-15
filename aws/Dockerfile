# 🚀 WebDiário AWS Base Image
# Extends the base image with AWS CLI and dependencies

FROM webdiario-base:latest

# Switch to root for installation
USER root

# Install AWS CLI v2
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install \
    && rm -rf awscliv2.zip aws

# Install additional AWS tools
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    jq \
    && rm -rf /var/lib/apt/lists/*

# Install AWS SDK for Python
RUN pip3 install boto3 awscli

# Install AWS CDK
RUN npm install -g aws-cdk

# Set AWS environment variables
ENV AWS_DEFAULT_REGION=us-east-1
ENV AWS_DEFAULT_OUTPUT=json

# Switch back to webdiario user
USER webdiario

# Verify AWS CLI installation
RUN aws --version

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD aws --version || exit 1

# Default command
CMD ["/bin/bash"]
