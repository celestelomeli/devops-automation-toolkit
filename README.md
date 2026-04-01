# devops-automation-toolkit

Bash and Python automation tools for Cloud and DevOps workflows covering scripting, testing, CI/CD, infrastructure as code, configuration management, and containerization.

## Skills demonstrated

- Bash scripting (functions, argument parsing, error handling, `set -euo pipefail`)
- Python automation (API integration, log parsing, health checks, argparse, retry logic)
- Testing with pytest (mocking, fixtures, assertions, custom marks) and BATS (Bash Automated Testing System)
- CI/CD with GitHub Actions (multi-job pipeline: lint, test, build, deploy, syntax check)
- Docker (Dockerfile, container lifecycle management, health endpoints)
- Terraform (fmt, validate, plan/apply wrapper with safety checks)
- Ansible (playbooks, inventory, handlers, variables, Jinja2 templates, `when` conditions, idempotency)
- Git workflow 

## Tools used

Bash, Python 3, Docker, Terraform, Ansible, GitHub Actions, pytest, BATS, ShellCheck, Flask, Jinja2, requests, PyYAML

## Repo structure

```
bash/                        Shell scripts
  check_env.sh                 Validate required tools are installed
  system_health.sh             Check disk, memory, CPU, and uptime
  docker_helper.sh             Build, run, stop, restart, and clean Docker containers
  tf_wrapper.sh                Terraform fmt, validate, plan, apply, destroy wrapper

python/                      Python automation tools
  health_check.py              Check HTTP endpoint health with retries
  api_check.py                 Fetch GitHub repo details via API
  log_parser.py                Parse log files for errors and warnings

ansible/                     Ansible playbooks and config
  playbook.yml                 Simple playbook to create dir and config on localhost
  webserver.yml                Provision nginx web server (Docker target)
  inventory.ini                Host groups for local and Docker targets
  templates/nginx.conf.j2      Jinja2 template for nginx config
  Dockerfile                   Ubuntu target container for Ansible testing

tests/                       Test suite
  test_check_env.bats          BATS tests for check_env.sh
  test_docker_helper.bats      BATS tests for docker_helper.sh
  test_tf_wrapper.bats         BATS tests for tf_wrapper.sh
  test_health_check.py         pytest tests for health_check.py
  test_api_check.py            pytest tests for api_check.py
  test_log_parser.py           pytest tests for log_parser.py

sample_data/                 Test inputs and mock data
  docker/                      Sample Flask app with Dockerfile
  terraform/                   Sample Terraform config
  app.log                      Sample log file for log_parser
  endpoints.yaml               URL list for health_check

.github/workflows/ci.yml    CI pipeline (lint, test, build, syntax check)
```

## Setup

```bash
# Clone the repo
git clone https://github.com/celestelomeli/devops-automation-toolkit.git
cd devops-automation-toolkit

# Install Python dependencies
pip install -r requirements.txt
```

## Usage

### Bash scripts

```bash
# Check if required DevOps tools are installed
bash bash/check_env.sh

# System health check (disk, memory, CPU, uptime)
bash bash/system_health.sh

# Docker helper (build, run, stop, restart, clean)
bash bash/docker_helper.sh build sample_data/docker
bash bash/docker_helper.sh run
bash bash/docker_helper.sh clean

# Terraform wrapper (fmt, validate, plan, apply, destroy)
bash bash/tf_wrapper.sh fmt sample_data/terraform
bash bash/tf_wrapper.sh validate sample_data/terraform
```

### Python scripts

```bash
# Health check endpoints
python python/health_check.py https://google.com https://example.com
python python/health_check.py --config sample_data/endpoints.yaml --json

# GitHub API check
python python/api_check.py torvalds/linux
python python/api_check.py torvalds/linux --json

# Log parser
python python/log_parser.py sample_data/app.log
python python/log_parser.py sample_data/app.log --json
```

### Ansible

```bash
cd ansible

# Simple playbook (runs on localhost)
ansible-playbook -i inventory.ini playbook.yml

# Nginx web server playbook (runs against Docker container)
docker build -t ansible-target .
docker run -d --name target ansible-target
ansible-playbook -i inventory.ini webserver.yml

# Cleanup
docker rm -f target
```

### Tests

```bash
# Run all Python tests
python -m pytest tests/ -v

# Run Python tests excluding live endpoint tests
python -m pytest tests/ -v -m "not live"

# Run all Bash tests
bats tests/*.bats
```

## CI pipeline

The GitHub Actions workflow (`.github/workflows/ci.yml`) runs on every push and PR to `main`:

| Job | What it does |
|-----|-------------|
| lint | Runs ShellCheck on all bash scripts |
| bash-tests | Runs BATS tests for bash scripts |
| python | Installs dependencies and runs pytest |
| terraform | Runs `terraform fmt` and `validate` on sample config |
| ansible | Syntax checks all Ansible playbooks |
| docker | Builds image, runs container, tests health endpoints, cleans up |
