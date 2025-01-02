# Musiq Development Environment
A Python environment in Docker, managed with Ansible.
## Prerequisites
Local Machine
- Docker (20.10 or newer)
- Ansible (2.13 or newer)
- Python (3.12 or newer)
Project directory with these files:
```
your-directory/
├── env.conf              # Settings (safe to commit)
├── setup.sh              # Creates directories
├── load-env.sh           # Sets up environment
├── start.sh              # Starts container
└── musiq-playbook.yml    # Ansible configuration
```
If you already have Python code, put it in `musiq/app/` first:
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
2. Set up directories:
   ```
   ./setup.sh
   ```
3. Load environment variables:
   ```
   source load-env.sh
   ```
4. Start the environment:
   ```
   ./start.sh
   ```
## Working With The Container
To stop:
```
docker stop $CONTAINER_NAME
```
To see what changed:
```
docker diff $CONTAINER_NAME
```
To get a shell:
```
docker exec -it $CONTAINER_NAME sh
```
## Environment Configuration
- env.conf contains project-standard settings and is version controlled
- For local overrides, create env.local.conf (it will be gitignored)
- If you change either file, reload with source load-env.sh
## Important Notes
- Existing code in musiq/app/ is safe - nothing will delete it
- If something goes wrong, just stop the container and start over
- Always use source with load-env.sh, not ./load-env.sh
- Docker container changes (like pip installs) are temporary:
  - Changes inside the container are lost when it's removed
  - To make changes permanent, update the playbook
  - Use the container for development and testing
  - Commit infrastructure changes to the playbook, not the container
## Common Issues
- If scripts won't run, check they're executable (chmod +x)
- If Docker fails, make sure it's running
- If Ansible fails, check env.conf is loaded
- After a reboot:
  1. Start Docker
  2. source load-env.sh
  3. ./start.sh
## Making Changes Permanent
To commit container changes to the project:
1. Use `docker diff $CONTAINER_NAME` to see your changes
2. For new Python packages:
   - Add them to the pip install task in musiq-playbook.yml
3. For system packages or configuration:
   - Add appropriate Ansible tasks to musiq-playbook.yml
4. For Dockerfile changes:
   - Update the Dockerfile template in musiq-playbook.yml
5. Test your changes:
   ```
   docker stop $CONTAINER_NAME
   docker rm $CONTAINER_NAME
   ./start.sh
   ```