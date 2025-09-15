# 📚 WebDiário Base Image - Grafana Dependencies
# This is the parent image for all WebDiário base images
# Contains Grafana dependencies and common utilities

FROM ubuntu:22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=America/Sao_Paulo

# Update package list and install basic dependencies
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    gnupg \
    software-properties-common \
    apt-transport-https \
    ca-certificates \
    lsb-release \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Install Grafana and monitoring dependencies
RUN apt-get update && apt-get install -y \
    libfontconfig1 \
    libfreetype6 \
    libx11-6 \
    libxext6 \
    libxrender1 \
    libxtst6 \
    libxi6 \
    libxrandr2 \
    libxss1 \
    libgconf-2-4 \
    libasound2 \
    libatk1.0-0 \
    libcairo-gobject2 \
    libdrm2 \
    libgtk-3-0 \
    libgdk-pixbuf2.0-0 \
    libxcomposite1 \
    libxcursor1 \
    libxdamage1 \
    libxfixes3 \
    libxinerama1 \
    libxrandr2 \
    libxss1 \
    libxtst6 \
    && rm -rf /var/lib/apt/lists/*

# Install Grafana CLI and monitoring tools
RUN curl -s https://api.github.com/repos/grafana/grafana/releases/latest | \
    grep "browser_download_url.*linux-amd64.tar.gz" | \
    cut -d '"' -f 4 | \
    wget -qi - && \
    tar -xzf grafana-*.tar.gz && \
    cp grafana-*/bin/grafana-cli /usr/local/bin/ && \
    rm -rf grafana-*

# Install Prometheus Node Exporter for system metrics
RUN wget https://github.com/prometheus/node_exporter/releases/latest/download/node_exporter-*.linux-amd64.tar.gz && \
    tar -xzf node_exporter-*.linux-amd64.tar.gz && \
    cp node_exporter-*.linux-amd64/node_exporter /usr/local/bin/ && \
    rm -rf node_exporter-*

# Create monitoring directories
RUN mkdir -p /etc/grafana/provisioning/datasources \
    /etc/grafana/provisioning/dashboards \
    /var/lib/grafana/dashboards \
    /etc/prometheus

# Create webdiario user
RUN useradd -m -s /bin/bash webdiario

# Set working directory
WORKDIR /app

# Set default user
USER webdiario

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD echo "WebDiário Base Image is healthy" || exit 1

# Default command
CMD ["/bin/bash"]
