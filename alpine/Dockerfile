# 📚 WebDiário Alpine Base Image
# This is the parent Alpine image for all WebDiário base images
# Contains common utilities and dependencies
# Tag: webdiario/alpine

FROM alpine:3.19

# Set environment variables
ENV TZ=America/Sao_Paulo

# Install basic dependencies
RUN apk add --no-cache \
    curl \
    wget \
    bash \
    tzdata \
    ca-certificates \
    jq \
    netcat-openbsd

# Create webdiario user
RUN adduser -D -s /bin/bash webdiario

# Set working directory
WORKDIR /app

# Set permissions for app directory
RUN chown -R webdiario:webdiario /app

# Set default user
USER webdiario

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD echo "WebDiário Base Alpine Image is healthy" || exit 1

# Default command
CMD ["/bin/bash"]
