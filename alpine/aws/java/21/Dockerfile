# ☕ WebDiário AWS Java 21 Image Alpine
# Extends AWS Java Alpine base image with Java 21

FROM webdiario-aws-java-alpine:latest

# Switch to root for installation
USER root

# Remove Java 11 and install Java 21
RUN apk del openjdk11 \
    && apk add --no-cache openjdk21

# Update Java environment variables for Java 21
ENV JAVA_HOME=/usr/lib/jvm/java-21-openjdk
ENV PATH=$JAVA_HOME/bin:$PATH

# Install additional Java 21 tools
RUN apk add --no-cache \
    maven \
    gradle

# Switch back to webdiario user
USER webdiario

# Verify Java 21 installation
RUN java -version && javac -version

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD java -version | grep "21" || exit 1

# Default command
CMD ["/bin/bash"]
