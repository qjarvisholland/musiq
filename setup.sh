#!/bin/bash
set -e

echo "Setting up musiq development environment..."

# Source load-env.sh to ensure environment variables are loaded
if ! source ./load-env.sh; then
    echo "Error: Failed to load environment variables. Check env.conf and load-env.sh." >&2
    exit 1
fi

# Validate directories
validate_directories() {
    echo "Validating directory variables:"
    local missing_vars=()
    for dir_var in "APP_DIR" "CONTAINER_DIR" "RESOURCES_DIR"; do
        if [ -z "${!dir_var}" ]; then
            echo "  $dir_var is missing or empty"
            missing_vars+=("$dir_var")
        else
            echo "  $dir_var=${!dir_var}"
        fi
    done
    if [ ${#missing_vars[@]} -gt 0 ]; then
        echo "Error: The following directories are not defined in the environment:" >&2
        printf "  %s\n" "${missing_vars[@]}" >&2
        exit 1
    fi
}

validate_directories

# Debug directory values
echo "Resolved directories:"
echo "  APP_DIR: $APP_DIR"
echo "  CONTAINER_DIR: $CONTAINER_DIR"
echo "  RESOURCES_DIR: $RESOURCES_DIR"

# Setup directories
setup_directories() {
    local directories=("$APP_DIR" "$CONTAINER_DIR" "$RESOURCES_DIR")
    for dir in "${directories[@]}"; do
        if [ ! -d "$dir" ]; then
            echo "Creating directory: $dir"
            mkdir -p "$dir"
        elif [ ! -w "$dir" ]; then
            echo "Error: $dir exists but is not writable" >&2
            exit 1
        fi
    done
    echo "Directories set up successfully."
}

setup_directories

echo "Setup completed successfully!"
echo "Next steps:"
echo "1. Verify environment variables by running:"
echo "   ./load-env.sh"
echo "2. Start the development environment:"
echo "   ./start.sh"
