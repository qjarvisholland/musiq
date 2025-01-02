#!/bin/bash

TIMEOUT=30
REQUIRED_VARS=("CONTAINER_NAME" "VENV_NAME" "PLAYBOOK_NAME")

# Check for missing environment variables
missing_vars=()
for var in "${REQUIRED_VARS[@]}"; do
    [ -z "${!var}" ] && missing_vars+=("$var")
done

if [ ${#missing_vars[@]} -gt 0 ]; then
    echo "Error: Environment not loaded. Run 'source load-env.sh' first" >&2
    exit 1
fi

run_playbook() {
    echo "Running playbook '$PLAYBOOK_NAME'..."
    ansible-playbook "$PLAYBOOK_NAME" || {
        echo "Error: Failed to run playbook" >&2
        exit 1
    }
}

wait_for_container() {
    echo "Waiting for container '$CONTAINER_NAME'..."
    for ((i=1; i<=TIMEOUT; i++)); do
        if docker inspect --format '{{.State.Running}}' "$CONTAINER_NAME" 2>/dev/null | grep -q true; then
            echo "Container is running"
            return 0
        fi
        sleep 1
    done
    echo "Error: Container failed to start in $TIMEOUT seconds" >&2
    exit 1
}

connect_to_container() {
    echo "Connecting to container shell..."
    docker exec -it "$CONTAINER_NAME" sh -c "
        . /home/app/$VENV_NAME/bin/activate &&
        exec sh" || {
        echo "Error: Failed to connect to container" >&2
        exit 1
    }
}

# Main execution
echo "Starting development environment..."
run_playbook
wait_for_container
connect_to_container