#!/bin/sh

TIMEOUT=100
REQUIRED_VARS="CONTAINER_NAME VENV_NAME PLAYBOOK_NAME"


# Source environment variables
if [ -f ./load-env.sh ]; then
    . ./load-env.sh
    echo "Environment variables loaded successfully."
    for var in $REQUIRED_VARS; do
        eval "value=\$$var"
        if [ -z "$value" ]; then
            echo "Error: $var is not set. Check env.conf or load-env.sh." >&2
            exit 1
        fi
    done
else
    echo "Error: load-env.sh not found. Ensure it exists in the current directory." >&2
    exit 1
fi

# Debugging loaded variables
echo "Loaded environment variables:"
for var in $REQUIRED_VARS; do
    eval "value=\$$var"
    echo "  $var=$value"
done

run_playbook() {
    ansible-playbook "$PLAYBOOK_NAME" || {
        echo "Error: Failed to run playbook" >&2
        exit 1
    }
}

# Wait for the Docker container to start


# Connect to the Docker container shell
connect_to_container() {
    echo "Connecting to container shell..."
    docker exec -it "$CONTAINER_NAME" sh -c "echo 'Welcome to the musiq-container'; exec sh" || {
        echo "Error: Failed to connect to container." >&2
        exit 1
    }
}

# Main execution flow
main() {
    echo "Starting development environment..."
    run_playbook
#    wait_for_container
    connect_to_container
}

main
