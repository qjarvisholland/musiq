#!/bin/bash
set -e

echo "Setting up musiq development environment..."

check_requirements() {
    local missing_tools=()
    if ! command -v docker >/dev/null 2>&1; then
        missing_tools+=("docker")
    elif ! docker info >/dev/null 2>&1; then
        echo "Error: Docker is installed but not running" >&2
        exit 1
    fi
    if ! command -v ansible-playbook >/dev/null 2>&1; then
        missing_tools+=("ansible")
    fi
    if [ ${#missing_tools[@]} -gt 0 ]; then
        echo "Error: Missing required tools:" >&2
        printf "  %s\n" "${missing_tools[@]}" >&2
        exit 1
    fi
}

load_config() {
    if [ ! -f "./env.conf" ]; then
        echo "Error: env.conf not found in current directory" >&2
        exit 1
    fi
    source ./env.conf
    local required_vars=("MUSIQ_DIR" "APP_DIR" "CONTAINER_DIR" "RESOURCES_DIR" 
                        "IMAGE_NAME" "CONTAINER_NAME" "DOCKERFILE_PATH" 
                        "TAR_FILE_PATH" "VENV_NAME" "PLAYBOOK_NAME")
    local missing_vars=()
    for var in "${required_vars[@]}"; do
        if [ -z "${!var}" ]; then
            missing_vars+=("$var")
        fi
    done
    if [ ${#missing_vars[@]} -gt 0 ]; then
        echo "Error: Missing required variables in env.conf:" >&2
        printf "  %s\n" "${missing_vars[@]}" >&2
        exit 1
    fi
}

setup_directories() {
    if [ -d "$APP_DIR" ]; then
        echo "Using existing app directory: $APP_DIR"
        if [ ! -w "$APP_DIR" ]; then
            echo "Error: $APP_DIR exists but is not writable" >&2
            exit 1
        fi
    else
        echo "Creating app directory: $APP_DIR"
        mkdir -p "$APP_DIR"
    fi

    local directories=("$CONTAINER_DIR" "$RESOURCES_DIR")
    for dir in "${directories[@]}"; do
        if [ ! -d "$dir" ]; then
            echo "Creating directory: $dir"
            mkdir -p "$dir"
        elif [ ! -w "$dir" ]; then
            echo "Error: $dir exists but is not writable" >&2
            exit 1
        fi
    done

    # Create .gitkeep files for empty directories
    touch "$CONTAINER_DIR/.gitkeep"
    touch "$RESOURCES_DIR/.gitkeep"
}

main() {
    check_requirements
    load_config
    setup_directories
    echo -e "\nSetup completed successfully!"
    echo "Next steps:"
    echo "1. Source the environment variables:"
    echo "   source load-env.sh"
    echo "2. Start the development environment:"
    echo "   ./start.sh"
}

main