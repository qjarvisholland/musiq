#!/bin/bash
set -e

echo "Setting up musiq development environment..."

# Run load-env.sh to ensure environment variables are loaded
if ! ./load-env.sh; then
    echo "Error: Failed to load environment variables. Check env.conf and load-env.sh." >&2
    exit 1
fi

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
echo "Verify environment variables by running:  ./load-env.sh"
echo "Next: Start the development environment:"
echo "   ./start.sh"
