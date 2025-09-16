#!/bin/bash

# 📚 WebDiário Application - Manage OAuth Clients
# Manages OAuth client credentials for applications

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

# Function to show usage
show_usage() {
    echo "Usage: $0 [COMMAND] [OPTIONS]"
    echo ""
    echo "Commands:"
    echo "  list                    List all clients"
    echo "  show <app-name>         Show client information for specific app"
    echo "  add <app-name>          Add new client for app"
    echo "  remove <app-name>       Remove client for app"
    echo "  regenerate <app-name>   Regenerate credentials for app"
    echo "  export <app-name>       Export client credentials as environment variables"
    echo "  import <file>           Import clients from JSON file"
    echo "  backup                  Backup clients file"
    echo "  restore <file>          Restore clients from backup"
    echo ""
    echo "Examples:"
    echo "  $0 list"
    echo "  $0 show api-webdiario"
    echo "  $0 add api-webdiario-new"
    echo "  $0 export api-webdiario"
}

# Function to list all clients
list_clients() {
    local clients_file="$HOME/.webdiario/clients.json"
    
    if [ ! -f "$clients_file" ]; then
        log_warning "Clients file not found: $clients_file"
        return 1
    fi
    
    log "📋 OAuth Clients List"
    echo ""
    jq -r '.[] | "\(.["app-name"]) | \(.["client-id"]) | \(.["roles"] | join(","))"' "$clients_file" | \
    while IFS='|' read -r app_name client_id roles; do
        printf "%-30s %-36s %s\n" "$app_name" "$client_id" "$roles"
    done
}

# Function to show client information
show_client() {
    local app_name="$1"
    local clients_file="$HOME/.webdiario/clients.json"
    
    if [ -z "$app_name" ]; then
        log_error "App name is required"
        return 1
    fi
    
    if [ ! -f "$clients_file" ]; then
        log_error "Clients file not found: $clients_file"
        return 1
    fi
    
    local client_info=$(jq -r --arg app "$app_name" '.[] | select(.["app-name"] == $app)' "$clients_file")
    
    if [ "$client_info" = "null" ]; then
        log_error "Client not found: $app_name"
        return 1
    fi
    
    log "📊 Client Information for: $app_name"
    echo "$client_info" | jq .
}

# Function to add new client
add_client() {
    local app_name="$1"
    local clients_file="$HOME/.webdiario/clients.json"
    
    if [ -z "$app_name" ]; then
        log_error "App name is required"
        return 1
    fi
    
    # Check if app already exists
    if jq -e --arg app "$app_name" '.[] | select(.["app-name"] == $app)' "$clients_file" >/dev/null 2>&1; then
        log_error "Client already exists: $app_name"
        return 1
    fi
    
    # Generate credentials
    local client_id=$(uuidgen | tr '[:upper:]' '[:lower:]' | tr -d '-')
    local client_secret=$(uuidgen | tr '[:upper:]' '[:lower:]' | tr -d '-')
    local roles='["INTERNAL_APPLICATION"]'
    
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
}

# Function to remove client
remove_client() {
    local app_name="$1"
    local clients_file="$HOME/.webdiario/clients.json"
    
    if [ -z "$app_name" ]; then
        log_error "App name is required"
        return 1
    fi
    
    if [ ! -f "$clients_file" ]; then
        log_error "Clients file not found: $clients_file"
        return 1
    fi
    
    # Check if app exists
    if ! jq -e --arg app "$app_name" '.[] | select(.["app-name"] == $app)' "$clients_file" >/dev/null 2>&1; then
        log_error "Client not found: $app_name"
        return 1
    fi
    
    # Remove client
    local temp_file=$(mktemp)
    jq --arg app "$app_name" 'del(.[] | select(.["app-name"] == $app))' "$clients_file" > "$temp_file"
    mv "$temp_file" "$clients_file"
    
    log_success "Removed client for app: $app_name"
}

# Function to regenerate credentials
regenerate_client() {
    local app_name="$1"
    local clients_file="$HOME/.webdiario/clients.json"
    
    if [ -z "$app_name" ]; then
        log_error "App name is required"
        return 1
    fi
    
    if [ ! -f "$clients_file" ]; then
        log_error "Clients file not found: $clients_file"
        return 1
    fi
    
    # Check if app exists
    if ! jq -e --arg app "$app_name" '.[] | select(.["app-name"] == $app)' "$clients_file" >/dev/null 2>&1; then
        log_error "Client not found: $app_name"
        return 1
    fi
    
    # Generate new credentials
    local client_id=$(uuidgen | tr '[:upper:]' '[:lower:]' | tr -d '-')
    local client_secret=$(uuidgen | tr '[:upper:]' '[:lower:]' | tr -d '-')
    
    # Update client
    local temp_file=$(mktemp)
    jq --arg app "$app_name" \
       --arg id "$client_id" \
       --arg secret "$client_secret" \
       '.[] | if (.["app-name"] == $app) then .["client-id"] = $id | .["client-secret"] = $secret else . end' "$clients_file" > "$temp_file"
    mv "$temp_file" "$clients_file"
    
    log_success "Regenerated credentials for app: $app_name"
    log "New Client ID: $client_id"
    log "New Client Secret: $client_secret"
}

# Function to export client credentials
export_client() {
    local app_name="$1"
    local clients_file="$HOME/.webdiario/clients.json"
    
    if [ -z "$app_name" ]; then
        log_error "App name is required"
        return 1
    fi
    
    if [ ! -f "$clients_file" ]; then
        log_error "Clients file not found: $clients_file"
        return 1
    fi
    
    local client_info=$(jq -r --arg app "$app_name" '.[] | select(.["app-name"] == $app)' "$clients_file")
    
    if [ "$client_info" = "null" ]; then
        log_error "Client not found: $app_name"
        return 1
    fi
    
    local client_id=$(echo "$client_info" | jq -r '.["client-id"]')
    local client_secret=$(echo "$client_info" | jq -r '.["client-secret"]')
    local env_prefix=$(echo "$app_name" | tr '[:lower:]' '[:upper:]' | tr '-' '_')
    
    log "📤 Exporting credentials for: $app_name"
    echo ""
    echo "export ${env_prefix}_SERVICE_CLIENT_ID=\"$client_id\""
    echo "export ${env_prefix}_SERVICE_CLIENT_SECRET=\"$client_secret\""
    echo ""
}

# Function to backup clients
backup_clients() {
    local clients_file="$HOME/.webdiario/clients.json"
    local backup_file="$HOME/.webdiario/clients.backup.$(date +%Y%m%d_%H%M%S).json"
    
    if [ ! -f "$clients_file" ]; then
        log_error "Clients file not found: $clients_file"
        return 1
    fi
    
    cp "$clients_file" "$backup_file"
    log_success "Clients backed up to: $backup_file"
}

# Function to restore clients
restore_clients() {
    local backup_file="$1"
    local clients_file="$HOME/.webdiario/clients.json"
    
    if [ -z "$backup_file" ]; then
        log_error "Backup file is required"
        return 1
    fi
    
    if [ ! -f "$backup_file" ]; then
        log_error "Backup file not found: $backup_file"
        return 1
    fi
    
    cp "$backup_file" "$clients_file"
    log_success "Clients restored from: $backup_file"
}

# Main execution
main() {
    local command="$1"
    local app_name="$2"
    
    case "$command" in
        "list")
            list_clients
            ;;
        "show")
            show_client "$app_name"
            ;;
        "add")
            add_client "$app_name"
            ;;
        "remove")
            remove_client "$app_name"
            ;;
        "regenerate")
            regenerate_client "$app_name"
            ;;
        "export")
            export_client "$app_name"
            ;;
        "backup")
            backup_clients
            ;;
        "restore")
            restore_clients "$app_name"
            ;;
        *)
            show_usage
            exit 1
            ;;
    esac
}

# Run main function
main "$@"
