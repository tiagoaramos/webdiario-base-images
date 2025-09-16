# 📚 WebDiário Alpine Local Nginx Base Image
# This image contains Nginx for serving React applications
# Inherits from webdiario/alpine/local with Nginx
# Tag: webdiario/alpine/local/nginx
FROM webdiario/alpine/local:latest

# Set environment variables for Nginx
ENV NGINX_VERSION="1.24.0"
ENV NGINX_HOME="/etc/nginx"
ENV APP_DIR="/app"

# Install Nginx
USER root
RUN apk add --no-cache \
    nginx \
    su-exec

# Create Nginx directories and app directory
RUN mkdir -p /var/log/nginx /var/lib/nginx /tmp/nginx /app

# Create simple Nginx configuration to serve /app directory
RUN cat > /etc/nginx/nginx.conf << 'EOF'
user nginx;
worker_processes auto;
error_log /var/log/nginx/error.log notice;
pid /var/run/nginx.pid;

events {
    worker_connections 1024;
}

http {
    include /etc/nginx/mime.types;
    default_type application/octet-stream;
    
    sendfile on;
    keepalive_timeout 65;
    
    server {
        listen 80;
        server_name localhost;
        root /app;
        index index.html index.htm;
        
        # Serve static files
        location / {
            try_files $uri $uri/ /index.html;
        }
        
        # Health check endpoint
        location /health {
            access_log off;
            return 200 "healthy\n";
            add_header Content-Type text/plain;
        }
    }
}
EOF

# Create a simple default index.html for testing
RUN cat > /app/index.html << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WebDiário - Nginx Server</title>
    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            margin: 0;
            padding: 20px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .container {
            text-align: center;
            background: rgba(255, 255, 255, 0.1);
            padding: 40px;
            border-radius: 20px;
            backdrop-filter: blur(10px);
        }
        h1 { margin-bottom: 20px; }
        p { margin-bottom: 10px; opacity: 0.9; }
        .status { color: #4ade80; font-weight: bold; }
    </style>
</head>
<body>
    <div class="container">
        <h1>🚀 WebDiário Nginx Server</h1>
        <p class="status">✅ Nginx is running successfully!</p>
        <p>Ready to serve files from /app directory</p>
    </div>
</body>
</html>
EOF

# Create startup script that works with the base entrypoint
RUN cat > /usr/local/bin/start-nginx.sh << 'EOF'
#!/bin/bash
set -e

echo "🚀 Starting Nginx server..."
echo "Serving files from /app directory on port 80"

# Start Nginx in foreground
exec nginx -g "daemon off;"
EOF

RUN chmod +x /usr/local/bin/start-nginx.sh

# Set permissions for Nginx directories and /app
RUN chown -R nginx:nginx /var/log/nginx /var/lib/nginx /tmp/nginx /app

# Expose Nginx port
EXPOSE 80

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost/health || exit 1

# Override entrypoint to start Nginx directly
ENTRYPOINT ["/usr/local/bin/start-nginx.sh"]
