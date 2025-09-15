# ☕ WebDiário GCP Java Base Image
# Extends GCP base image with Java installer dependencies

FROM webdiario-gcp:latest

# Switch to root for installation
USER root

# Install Java installer dependencies
RUN apt-get update && apt-get install -y \
    openjdk-11-jdk \
    maven \
    gradle \
    && rm -rf /var/lib/apt/lists/*

# Set Java environment variables
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
ENV PATH=$JAVA_HOME/bin:$PATH

# Install additional Java tools
RUN apt-get update && apt-get install -y \
    ant \
    ivy \
    && rm -rf /var/lib/apt/lists/*

# Install Google Cloud Java libraries
RUN apt-get update && apt-get install -y \
    libgoogle-cloud-java \
    && rm -rf /var/lib/apt/lists/*

# Switch back to webdiario user
USER webdiario

# Verify Java installation
RUN java -version && javac -version

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD java -version || exit 1

# Default command
CMD ["/bin/bash"]
