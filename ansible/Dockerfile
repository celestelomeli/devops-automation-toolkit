# Ubuntu container that acts as a target server for Ansible playbooks
FROM ubuntu:22.04

# Avoid interactive prompts during package installs
ENV DEBIAN_FRONTEND=noninteractive

# Install Python (required for Ansible to work on the target)
RUN apt-get update && apt-get install -y python3 sudo && rm -rf /var/lib/apt/lists/*

CMD ["sleep", "infinity"]
