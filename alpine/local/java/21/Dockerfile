# 📚 WebDiário Alpine Local Java 21 Base Image
# This image contains Java 21 for Java applications
# Inherits from webdiario/alpine/local/java with Java 21
# Tag: webdiario/alpine/local/java/21

FROM webdiario/alpine/local/java:latest

# Set environment variables for Java 21
ENV JAVA_VERSION="21"
ENV JAVA_HOME="/usr/lib/jvm/java-21-openjdk"
ENV PATH="$JAVA_HOME/bin:$PATH"

# Install Java 21 first (to be the default java-jdk provider)
USER root
RUN apk add --no-cache \
    # Java 21 (install first to be the default java-jdk provider)
    openjdk21-jdk

# Install additional tools
RUN apk add --no-cache \
    # Additional monitoring tools
    curl \
    wget \
    jq \
    # Build tools for native dependencies
    gcc \
    g++ \
    musl-dev \
    linux-headers \
    # Additional utilities
    htop \
    tree \
    vim \
    nano

# Create Java application directories
RUN mkdir -p /app /home/appuser/app

# Copy Java application scripts
COPY ../../../devops/start-java-app.sh /usr/local/bin/start-java-app.sh
COPY ../../../devops/health-check.sh /usr/local/bin/health-check.sh

# Copy JMX Exporter and configuration
COPY ../../../devops/jmx_prometheus_javaagent.jar /app/jmx_prometheus_javaagent.jar
COPY ../../../devops/jmx_prometheus_config.yml /app/jmx_prometheus_config.yml

# Make scripts executable
RUN chmod +x /usr/local/bin/start-java-app.sh /usr/local/bin/health-check.sh

# Set permissions for Java directories
RUN chown -R appuser:appuser /app /home/appuser

# Switch back to application user
USER appuser

# Expose application port and JMX Exporter port
EXPOSE 8080 9404

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 \
    CMD /usr/local/bin/health-check.sh

# Default command - start Java application
CMD ["/usr/local/bin/start-java-app.sh"]
