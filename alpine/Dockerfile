# 📚 WebDiário Base Image Alpine - Grafana Dependencies
# This is the parent Alpine image for all WebDiário base images
# Contains Grafana dependencies and common utilities

FROM alpine:3.19

# Set environment variables
ENV TZ=America/Sao_Paulo

# Install basic dependencies and Grafana dependencies
RUN apk add --no-cache \
    curl \
    wget \
    bash \
    tzdata \
    ca-certificates \
    fontconfig \
    freetype \
    libx11 \
    libxext \
    libxrender \
    libxtst \
    libxi \
    libxrandr \
    libxss \
    libgconf \
    alsa-lib \
    atk \
    cairo-gobject \
    libdrm \
    gtk+3.0 \
    gdk-pixbuf \
    libxcomposite \
    libxcursor \
    libxdamage \
    libxfixes \
    libxinerama \
    libxrandr \
    libxss \
    libxtst \
    musl \
    libc6-compat

# Create webdiario user
RUN adduser -D -s /bin/bash webdiario

# Set working directory
WORKDIR /app

# Set default user
USER webdiario

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD echo "WebDiário Base Alpine Image is healthy" || exit 1

# Default command
CMD ["/bin/bash"]
