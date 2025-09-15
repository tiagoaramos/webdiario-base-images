# ☕ WebDiário AWS Java Base Image Alpine
# Extends AWS Alpine base image with Java installer dependencies

FROM webdiario-aws-alpine:latest

# Switch to root for installation
USER root

# Install Java and build tools
RUN apk add --no-cache \
    openjdk11 \
    maven \
    gradle \
    ant \
    ivy

# Set Java environment variables
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk
ENV PATH=$JAVA_HOME/bin:$PATH

# Switch back to webdiario user
USER webdiario

# Verify Java installation
RUN java -version && javac -version

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD java -version || exit 1

# Default command
CMD ["/bin/bash"]
