#!/bin/sh
set -e

# Function to create environment file with the correct naming pattern
create_env_file() {
    # Determine the environment (default to development if not set)
    ENV=${NODE_ENV:-development}
    
    # Create the environment-specific file (e.g., .env.development.local)
    ENV_FILE=".env.${ENV}"
    
    # Start with a clean environment file
    echo "# Environment configuration for ${ENV}" > "${ENV_FILE}"
    
    # Add each environment variable with proper formatting
    # Note: Using the :-} syntax to provide empty string as default if variable is unset
    echo "NODE_ENV=${NODE_ENV:-development}" >> "${ENV_FILE}"
    echo "PORT=${PORT:-3000}" >> "${ENV_FILE}"
    echo "DATABASE_URL=${DATABASE_URL:-}" >> "${ENV_FILE}"
    
    # Add the Telegram and AWS specific variables
    echo "TELEGRAM_USER_AWS_ACESS_KEY=${TELEGRAM_USER_AWS_ACESS_KEY:-}" >> "${ENV_FILE}"
    echo "TELEGRAM_USER_AWS_SECRET_KEY=${TELEGRAM_USER_AWS_SECRET_KEY:-}" >> "${ENV_FILE}"
    echo "SUPABASE_DATABASE_PASSWORD=${SUPABASE_DATABASE_PASSWORD:-}" >> "${ENV_FILE}"
    echo "TELEGRAM_BOT_TOKEN=${TELEGRAM_BOT_TOKEN:-}" >> "${ENV_FILE}"
    echo "PORKBUN_TELEGRAM_TOKEN=${PORKBUN_TELEGRAM_TOKEN:-}" >> "${ENV_FILE}"
    
    echo "Environment file ${ENV_FILE} created successfully"
}

# Function to create the Google service account JSON file
create_service_account_file() {
    # Define the file path
    SERVICE_ACCOUNT_FILE="zapbot.service.account.json"
    
    # Check if the GOOGLE_SERVICE_ACCOUNT environment variable is set
    if [ -n "${GOOGLE_SERVICE_ACCOUNT:-}" ]; then
        # Write the service account JSON to the file
        echo "${GOOGLE_SERVICE_ACCOUNT}" > "${SERVICE_ACCOUNT_FILE}"
        echo "Google service account file ${SERVICE_ACCOUNT_FILE} created successfully"
    else
        echo "Warning: GOOGLE_SERVICE_ACCOUNT environment variable not set, service account file not created"
    fi
}

# Create the environment file
create_env_file

# Create the Google service account file
create_service_account_file

# Execute the main command
exec "$@"