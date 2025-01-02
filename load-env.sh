#!/bin/bash

# Check if env.conf exists
if [ ! -f ./env.conf ]; then
    echo "Error: env.conf not found. Ensure it exists in the current directory." >&2
    exit 1
fi

# Source env.conf
set -a
source ./env.conf
set +a

# Validate required variables
REQUIRED_VARS=("MUSIQ_DIR" "APP_DIR" "CONTAINER_DIR" "RESOURCES_DIR"
               "IMAGE_NAME" "CONTAINER_NAME" "DOCKERFILE_PATH"
               "TAR_FILE_PATH" "VENV_NAME" "PLAYBOOK_NAME")
missing_vars=()

for var in "${REQUIRED_VARS[@]}"; do
    if [ -z "${!var}" ]; then
        missing_vars+=("$var")
    fi
done

if [ ${#missing_vars[@]} -gt 0 ]; then
    echo "Error: Missing required environment variables in env.conf:" >&2
    printf "  %s\n" "${missing_vars[@]}" >&2
    exit 1
fi

echo "Environment loaded successfully:"
env | grep -E "^(MUSIQ_|CONTAINER_|IMAGE_|VENV_|PLAYBOOK_)" | sort
