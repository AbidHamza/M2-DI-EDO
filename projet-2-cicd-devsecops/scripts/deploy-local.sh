#!/usr/bin/env bash
# =============================================================================
# Local Deployment Script — Deploy Finance App with Docker
# =============================================================================
# Usage:
#   chmod +x scripts/deploy-local.sh
#   ./scripts/deploy-local.sh           # Deploy dev (default)
#   ./scripts/deploy-local.sh staging   # Deploy staging
#   ./scripts/deploy-local.sh prod      # Deploy production
# =============================================================================

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENVIRONMENT="${1:-dev}"

# Port mapping per environment
case $ENVIRONMENT in
    dev)     PORT=5001; LOG_LEVEL="DEBUG" ;;
    staging) PORT=5002; LOG_LEVEL="INFO" ;;
    prod)    PORT=5000; LOG_LEVEL="WARNING" ;;
    *)
        echo -e "${RED}Unknown environment: $ENVIRONMENT${NC}"
        echo "Usage: $0 [dev|staging|prod]"
        exit 1
        ;;
esac

CONTAINER_NAME="finance-app-${ENVIRONMENT}"
IMAGE_NAME="finance-app:latest"

echo -e "${BLUE}=== Deploying Finance App ===${NC}"
echo "  Environment: ${ENVIRONMENT}"
echo "  Port:        ${PORT}"
echo "  Container:   ${CONTAINER_NAME}"
echo "  Image:       ${IMAGE_NAME}"
echo ""

# ---------------------------------------------------------------------------
# Step 1: Build image if not exists
# ---------------------------------------------------------------------------
if ! docker image inspect "${IMAGE_NAME}" &> /dev/null 2>&1; then
    echo -e "${YELLOW}Image not found. Building...${NC}"
    docker build -t "${IMAGE_NAME}" -f "${PROJECT_DIR}/app/Dockerfile" "${PROJECT_DIR}/app/"
    echo ""
fi

# ---------------------------------------------------------------------------
# Step 2: Stop existing container
# ---------------------------------------------------------------------------
if docker ps -a --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
    echo "Stopping existing container: ${CONTAINER_NAME}"
    docker rm -f "${CONTAINER_NAME}" > /dev/null 2>&1
fi

# ---------------------------------------------------------------------------
# Step 3: Start new container
# ---------------------------------------------------------------------------
echo "Starting container: ${CONTAINER_NAME}"
docker run -d \
    --name "${CONTAINER_NAME}" \
    -p "${PORT}:5000" \
    -e "APP_ENV=${ENVIRONMENT}" \
    -e "LOG_LEVEL=${LOG_LEVEL}" \
    -e "APP_VERSION=1.0.0" \
    --label "project=finance-app" \
    --label "environment=${ENVIRONMENT}" \
    --label "managed-by=deploy-script" \
    --restart unless-stopped \
    "${IMAGE_NAME}"

# ---------------------------------------------------------------------------
# Step 4: Wait and health check
# ---------------------------------------------------------------------------
echo "Waiting for application to start..."
sleep 5

RETRIES=5
for i in $(seq 1 $RETRIES); do
    if curl -s "http://localhost:${PORT}/health" | grep -q "healthy"; then
        echo ""
        echo -e "${GREEN}=== Deployment Successful ===${NC}"
        echo ""
        echo "  App URL:     http://localhost:${PORT}"
        echo "  Health:      http://localhost:${PORT}/health"
        echo "  Metrics:     http://localhost:${PORT}/metrics"
        echo "  API:         http://localhost:${PORT}/api/transactions"
        echo ""
        echo "  Container logs: docker logs -f ${CONTAINER_NAME}"
        echo "  Stop:           docker rm -f ${CONTAINER_NAME}"
        echo ""

        # Show health check response
        echo "Health check response:"
        curl -s "http://localhost:${PORT}/health" | python3 -m json.tool 2>/dev/null || curl -s "http://localhost:${PORT}/health"
        echo ""
        exit 0
    fi
    echo "  Retry ${i}/${RETRIES}..."
    sleep 3
done

echo -e "${RED}Health check failed after ${RETRIES} retries!${NC}"
echo "Container logs:"
docker logs "${CONTAINER_NAME}" --tail 20
exit 1
