# ☕ WebDiário AWS Java 21 Image
# Extends AWS Java base image with Java 21

FROM webdiario-aws-java:latest

# Switch to root for installation
USER root

# Remove existing Java 11 and install Java 21
RUN apt-get update && apt-get remove -y openjdk-11-jdk \
    && apt-get install -y openjdk-21-jdk \
    && rm -rf /var/lib/apt/lists/*

# Update Java environment variables for Java 21
ENV JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64
ENV PATH=$JAVA_HOME/bin:$PATH

# Install additional Java 21 tools
RUN apt-get update && apt-get install -y \
    maven \
    gradle \
    && rm -rf /var/lib/apt/lists/*

# Switch back to webdiario user
USER webdiario

# Verify Java 21 installation
RUN java -version && javac -version

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD java -version | grep "21" || exit 1

# Default command
CMD ["/bin/bash"]
