# Learning Log

A running record of what was built, what was learned, and what to improve.

---

### What I built
- Bash scripts: environment checker, system health monitor, Docker helper, Terraform wrapper
- Python tools: HTTP health checker with retries, GitHub API client, log parser
- Ansible playbooks: simple localhost setup, nginx web server provisioning with Docker target
- Full test suite: pytest for Python (mocking, fixtures, custom marks), BATS for Bash (PATH tricks, temp dirs, CI skips)
- CI pipeline: GitHub Actions with 6 jobs (lint, bash-tests, python, terraform, ansible, docker)
- Sample Flask app with health/readiness endpoints in Docker

### What I learned
- Mocking lets you test your logic without depending on external services 
- Functions make scripts testable. Can't mock or unit test top-level code
- `set -euo pipefail` catches errors early in Bash instead of silently continuing
- Ansible is agentless. It connects over SSH (or Docker) and pushes changes, no agent needed on the target
- Idempotency means running something twice gives the same result 
- `when` conditions let you skip tasks based on environment like skipping firewall in Docker since containers
share the host's network kernel and don't have permission to modify firewall rules.
- Handlers only run once at the end, even if notified multiple times
- Docker containers share the host kernel. Firewall rules don't work inside them
- CI environments differ from local. Some tests need to be skipped because CI runners may not have the same tools   installed or the same filesystem layout as your local machine.
- `.get()` is safer than `[]` for dictionary access to return None instead of crashing
- Returning a dict instead of a tuple makes data easier to access by name rather than remembering index positions

### What to improve
- Learn Ansible roles for organizing larger playbooks
- Add Ansible vault for managing secrets
- Run playbooks against real cloud VMs (EC2)
- Explore dynamic inventory — let Ansible pull the list of servers from AWS instead of hardcoding IPs in a file
- Add more error handling in bash scripts for things like network timeouts
- Learn how to monitor servers and set up alerts when something breaks
- Use a coverage tool to find out which parts of the code don't have tests yet
