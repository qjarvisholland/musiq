#!/bin/bash

(return 0 2>/dev/null) && SOURCED=true || SOURCED=false
if [ "$SOURCED" = false ]; then
    echo "Error: Run with: source load-env.sh" >&2
    exit 1
fi

if [ -z "${MUSIQ_DIR}" ]; then
    echo "Error: MUSIQ_DIR not set. Run setup.sh first" >&2
    return 1
fi

if [ ! -f "./env.conf" ]; then
    echo "Error: env.conf not found" >&2
    return 1
fi

# Export variables from env.conf
set -a
source ./env.conf
set +a

for dir in "$APP_DIR" "$CONTAINER_DIR" "$RESOURCES_DIR"; do
    if [ ! -d "$dir" ]; then
        echo "Error: Directory $dir missing. Run setup.sh again" >&2
        return 1
    fi
done

echo "Environment loaded:"
env | grep -E "^(MUSIQ_|CONTAINER_|IMAGE_|VENV_|PLAYBOOK_)" | sort
return 0
