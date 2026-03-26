#!/usr/bin/env bash

set -euo pipefail

IMAGE_NAME="${IMAGE_NAME:-myapp}"
CONTAINER_NAME="${CONTAINER_NAME:-myapp_container}"
PORT="${PORT:-8080}"

echo "=== Docker Helper ==="

# Help flag to show use instructions
if [[ "${1:-}" == "--help" ]]; then
    echo "Usage: docker_helper.sh [build|run|stop|restart|clean|logs|status|--help] [directory]"
    echo ""
    echo "Commands:"
    echo "  build       Build the Docker image"
    echo "  run         Run the Docker container"
    echo "  stop        Stop the Docker container"
    echo "  restart     Restart the Docker container"
    echo "  logs        Show Docker container logs"
    echo "  status      Check Docker container status"
    echo "  clean       Clean up Docker resources"
    echo ""
    echo "Options:"
    echo "  --help      Show this help message"
    exit 0
fi

# Check if Docker is installed
if command -v docker > /dev/null 2>&1; then
    echo "Docker found: $(docker --version)"
else
    echo "Docker not found. Please install Docker to use this helper."
    exit 1
fi

# Check for second argument and change directory if provided
if [[ -n "${2:-}" ]]; then
    if [[ -d "$2" ]]; then
        echo "Changing to directory: $2"
        cd "$2"
    else
        echo "Directory $2 does not exist."
        exit 1
    fi
fi

# Logging 
REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || pwd)  # get the root directory of the git repo
echo "$(date) - ran: ${1:-}" >> "$REPO_ROOT/docker_helper.log"  # log the command with time

# Main logic
case "${1:-}" in
    build)
        # Check for Dockerfile in the current directory
        if [[ -f "Dockerfile" ]]; then
            echo "Dockerfile found."
        else
            echo "No Dockerfile found in the current directory."
            exit 1
        fi
        echo "Building Docker image..."
        docker build -t "$IMAGE_NAME" .
        echo "Image '$IMAGE_NAME' built successfully."
        ;;
    run)
        # Check if container exists
        if docker ps -a --filter "name=$CONTAINER_NAME" --format "{{.Names}}" | grep -q "$CONTAINER_NAME"; then
            echo "Container '$CONTAINER_NAME' already exists. Run 'clean' first."
            exit 1
        fi
        echo "Running Docker container..."
        docker run -d -p "$PORT:$PORT" --name "$CONTAINER_NAME" "$IMAGE_NAME"
        echo "Container '$CONTAINER_NAME' running successfully on http://localhost:$PORT."
        # health check after starting container
        sleep 2
        if curl -s "http://localhost:$PORT/health" > /dev/null; then
            echo "Health check passed: Container is healthy."
        else
            echo "Health check failed: Container is not responding."
        fi
        ;;
    stop)
        echo "Stopping Docker container..."
        docker stop "$CONTAINER_NAME" || true
        echo "Container '$CONTAINER_NAME' stopped."
        ;;
    restart)
        echo "Restarting Docker container..."
        docker stop "$CONTAINER_NAME" || true
        docker rm "$CONTAINER_NAME" -f || true
        docker run -d -p "$PORT:$PORT" --name "$CONTAINER_NAME" "$IMAGE_NAME"
        echo "Container '$CONTAINER_NAME' restarted on http://localhost:$PORT."
        ;;
    clean)
        echo "Cleaning up Docker resources..."
        docker rm "$CONTAINER_NAME" -f || true
        docker rmi "$IMAGE_NAME" -f || true
        echo "Docker resources cleaned up."
        ;;
    logs)
        echo "Showing Docker container logs..."
        docker logs "$CONTAINER_NAME"
        echo "Logs displayed."
        ;;
    status)
        echo "Checking Docker container status..."
        docker ps -a --filter "name=$CONTAINER_NAME"
        ;;
    *)
        echo "Unknown command. Use --help for usage instructions."
        exit 1
        ;;      

esac
