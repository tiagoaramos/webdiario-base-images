#!/bin/bash

# 📚 WebDiário Application - Configure OAuth Clients
# Generates and configures OAuth client credentials for applications

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging function
log() {
    echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')] ✅${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[$(date +'%Y-%m-%d %H:%M:%S')] ⚠️${NC} $1"
}

log_error() {
    echo -e "${RED}[$(date +'%Y-%m-%d %H:%M:%S')] ❌${NC} $1"
}

# Function to generate UUID
generate_uuid() {
    if command -v uuidgen >/dev/null 2>&1; then
        uuidgen | tr '[:upper:]' '[:lower:]' | tr -d '-'
    else
        # Fallback UUID generation using /dev/urandom
        cat /dev/urandom | tr -dc 'a-f0-9' | fold -w 32 | head -n 1
    fi
}

# Function to get app name from environment
get_app_name() {
    if [ -n "$APP_NAME" ]; then
        echo "$APP_NAME"
    elif [ -n "$SERVICE_NAME" ]; then
        echo "$SERVICE_NAME"
    else
        # Use default from Dockerfile
        echo "webdiario-app"
    fi
}

# Function to get default roles based on app name pattern
get_default_roles() {
    local app_name="$1"
    
    # Check if it's an API application
    if [[ "$app_name" =~ ^api- ]]; then
        case "$app_name" in
            *-security)
                echo '["INTERNAL_APPLICATION","AUTH_SERVICE"]'
                ;;
            *-subscription)
                echo '["INTERNAL_APPLICATION","SUBSCRIPTION_SERVICE"]'
                ;;
            *-event-hub)
                echo '["INTERNAL_APPLICATION","EVENT_HUB_SERVICE"]'
                ;;
            *)
                echo '["INTERNAL_APPLICATION","EVENT_HUB_PUB","EVENT_HUB_SUB"]'
                ;;
        esac
    # Check if it's a frontend application
    elif [[ "$app_name" =~ ^app- ]]; then
        case "$app_name" in
            *-financial)
                echo '["FRONTEND_APPLICATION","FINANCIAL_INTERFACE"]'
                ;;
            *-security)
                echo '["FRONTEND_APPLICATION","AUTH_INTERFACE"]'
                ;;
            *-parent)
                echo '["FRONTEND_APPLICATION","PARENT_INTERFACE"]'
                ;;
            *)
                echo '["FRONTEND_APPLICATION","USER_INTERFACE"]'
                ;;
        esac
    # Check if it's a service application
    elif [[ "$app_name" =~ ^service- ]]; then
        echo '["INTERNAL_APPLICATION","SERVICE_APPLICATION"]'
    # Default for other applications
    else
        echo '["INTERNAL_APPLICATION"]'
    fi
}

# Function to create clients directory and file
create_clients_file() {
    local clients_dir="$HOME/.webdiario"
    local clients_file="$clients_dir/clients.json"
    
    # Create directory if it doesn't exist
    if [ ! -d "$clients_dir" ]; then
        mkdir -p "$clients_dir"
        log "Created directory: $clients_dir"
    fi
    
    # Create file if it doesn't exist
    if [ ! -f "$clients_file" ]; then
        echo "[]" > "$clients_file"
        log "Created clients file: $clients_file"
    fi
}

# Function to check if app exists in clients file
app_exists() {
    local app_name="$1"
    local clients_file="$HOME/.webdiario/clients.json"
    
    if [ ! -f "$clients_file" ]; then
        return 1
    fi
    
    jq -e --arg app "$app_name" '.[] | select(.["app-name"] == $app)' "$clients_file" >/dev/null 2>&1
}

# Function to get client credentials
get_client_credentials() {
    local app_name="$1"
    local clients_file="$HOME/.webdiario/clients.json"
    
    if [ ! -f "$clients_file" ]; then
        log_error "Clients file not found: $clients_file"
        return 1
    fi
    
    local client_id=$(jq -r --arg app "$app_name" '.[] | select(.["app-name"] == $app) | .["client-id"]' "$clients_file")
    local client_secret=$(jq -r --arg app "$app_name" '.[] | select(.["app-name"] == $app) | .["client-secret"]' "$clients_file")
    
    if [ "$client_id" = "null" ] || [ "$client_secret" = "null" ]; then
        log_error "Client credentials not found for app: $app_name"
        return 1
    fi
    
    echo "$client_id"
    echo "$client_secret"
}

# Function to add new client
add_new_client() {
    local app_name="$1"
    local clients_file="$HOME/.webdiario/clients.json"
    
    log "Adding new client for app: $app_name"
    
    # Generate credentials
    local client_id=$(generate_uuid)
    local client_secret=$(generate_uuid)
    local roles=$(get_default_roles "$app_name")
    
    # Create new client entry
    local new_client=$(jq -n \
        --arg app "$app_name" \
        --arg id "$client_id" \
        --arg secret "$client_secret" \
        --argjson roles "$roles" \
        '{
            "app-name": $app,
            "client-id": $id,
            "client-secret": $secret,
            "roles": $roles
        }')
    
    # Add to clients file
    local temp_file=$(mktemp)
    jq --argjson new_client "$new_client" '. + [$new_client]' "$clients_file" > "$temp_file"
    mv "$temp_file" "$clients_file"
    
    log_success "Added new client for app: $app_name"
    log "Client ID: $client_id"
    log "Client Secret: $client_secret"
    log "Roles: $roles"
}

# Function to set environment variables
set_environment_variables() {
    local app_name="$1"
    local client_id="$2"
    local client_secret="$3"
    
    # Convert app name to uppercase for environment variables
    local env_prefix=$(echo "$app_name" | tr '[:lower:]' '[:upper:]' | tr '-' '_')
    
    # Set environment variables
    export "${env_prefix}_SERVICE_CLIENT_ID"="$client_id"
    export "${env_prefix}_SERVICE_CLIENT_SECRET"="$client_secret"
    
    log "Set environment variables:"
    log "  ${env_prefix}_SERVICE_CLIENT_ID=$client_id"
    log "  ${env_prefix}_SERVICE_CLIENT_SECRET=$client_secret"
}

# Function to create environment file
create_environment_file() {
    local app_name="$1"
    local client_id="$2"
    local client_secret="$3"
    
    local env_prefix=$(echo "$app_name" | tr '[:lower:]' '[:upper:]' | tr '-' '_')
    local env_file="/app/.env.oauth"
    
    cat > "$env_file" <<EOF
# WebDiário OAuth Client Configuration
# Generated for app: $app_name

${env_prefix}_SERVICE_CLIENT_ID=$client_id
${env_prefix}_SERVICE_CLIENT_SECRET=$client_secret

# OAuth Configuration
OAUTH_CLIENT_ID=$client_id
OAUTH_CLIENT_SECRET=$client_secret
OAUTH_APP_NAME=$app_name
EOF
    
    log "Created OAuth environment file: $env_file"
}

# Function to display client information
display_client_info() {
    local app_name="$1"
    local clients_file="$HOME/.webdiario/clients.json"
    
    log "📊 Client Information for: $app_name"
    
    if [ -f "$clients_file" ]; then
        local client_info=$(jq -r --arg app "$app_name" '.[] | select(.["app-name"] == $app)' "$clients_file")
        if [ "$client_info" != "null" ]; then
            echo "$client_info" | jq .
        else
            log_warning "No client information found for: $app_name"
        fi
    else
        log_warning "Clients file not found: $clients_file"
    fi
}

# Main execution
main() {
    log "🎯 WebDiário OAuth Client Configuration"
    
    # Get app name
    local app_name=$(get_app_name)
    log "App Name: $app_name"
    
    # Create clients file if it doesn't exist
    create_clients_file
    
    # Check if app exists
    if app_exists "$app_name"; then
        log "App '$app_name' already exists in clients file"
        
        # Get existing credentials
        local credentials=$(get_client_credentials "$app_name")
        local client_id=$(echo "$credentials" | head -n 1)
        local client_secret=$(echo "$credentials" | tail -n 1)
        
        if [ -n "$client_id" ] && [ -n "$client_secret" ]; then
            log_success "Retrieved existing credentials for: $app_name"
        else
            log_error "Failed to retrieve credentials for: $app_name"
            exit 1
        fi
    else
        log "App '$app_name' not found, creating new client"
        add_new_client "$app_name"
        
        # Get newly created credentials
        local credentials=$(get_client_credentials "$app_name")
        local client_id=$(echo "$credentials" | head -n 1)
        local client_secret=$(echo "$credentials" | tail -n 1)
    fi
    
    # Set environment variables
    set_environment_variables "$app_name" "$client_id" "$client_secret"
    
    # Create environment file
    create_environment_file "$app_name" "$client_id" "$client_secret"
    
    # Display client information
    display_client_info "$app_name"
    
    log_success "🎉 OAuth client configuration completed!"
}

# Run main function
main "$@"
