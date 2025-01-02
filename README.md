# Musiq Development Environment

A Python environment in Docker, managed with Ansible.

## Prerequisites

### Local Machine
- Docker (20.10 or newer)
- Ansible (2.13 or newer)
- Python (3.12 or newer)

### Project Directory Structure
Ensure your directory includes these files:
```
your-directory/
├── env.conf              # Settings (safe to commit)
├── setup.sh              # Creates directories
├── load-env.sh           # Sets up environment
├── start.sh              # Starts container
└── musiq-playbook.yml    # Ansible configuration
```

### Adding Python Code
Place your Python code in `musiq/app/` before starting:
```
your-directory/
├── [files from above]
└── musiq/
    └── app/              # Your Python code goes here
```

## Getting Started

1. Make sure the scripts are executable:
   ```
   chmod +x setup.sh load-env.sh start.sh
   ```

2. Set up directories, variables, config:
   ```
   ./setup.sh
   ```
3. (Optional) Verify environment variable defaults:
   ```
   ./load-env.sh
   ```

3. Start the development environment:
   ```
   ./start.sh
   ```

## Working With The Container

- To stop the container:
  ```
  docker stop $CONTAINER_NAME
  ```
- To see what changed inside the container:
  ```
  docker diff $CONTAINER_NAME
  ```
- To access the container shell:
  ```
  docker exec -it $CONTAINER_NAME sh
  ```

## Environment Configuration

- `env.conf` contains project-standard settings and is version controlled.
- For local overrides, create `env.local.conf` (it will be gitignored).
- If you change either file, reload the environment variables with:
  ```
  source load-env.sh
  ```

## Troubleshooting

### Common Issues
- **Scripts won't run:** Ensure they are executable using `chmod +x`.
- **Docker not running:** Start Docker before running scripts.
- **Ansible playbook fails:** Check `musiq-playbook.yml` logs for errors.
- **Missing environment variables:** Run `source load-env.sh` before other scripts.

### After a Reboot
1. Start Docker.
2. Reload environment variables:
   ```
   source load-env.sh
   ```
3. Start the development environment:
   ```
   ./start.sh
   ```

## Making Changes Permanent

### To Commit Container Changes:
1. Check changes with:
   ```
   docker diff $CONTAINER_NAME
   ```
2. For new Python packages:
   - Update the `RUN` instruction in the Dockerfile template in `musiq-playbook.yml`.
3. For system packages or configurations:
   - Add appropriate Ansible tasks to `musiq-playbook.yml`.
4. Test your updates:
   ```
   docker stop $CONTAINER_NAME
   docker rm $CONTAINER_NAME
   ./start.sh
   ```

## Important Notes

- Existing code in `musiq/app/` is safe from deletion.
- Changes inside the container (like pip installs) are temporary. To persist changes, update the playbook or Dockerfile.
- Use the container for development and testing, and commit infrastructure changes to the playbook, not the container.

