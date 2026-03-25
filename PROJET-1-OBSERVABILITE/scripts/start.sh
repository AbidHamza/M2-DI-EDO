#!/bin/bash
# =============================================================================
# Quick Start Script - Observability Stack
# =============================================================================
# This script builds and starts the complete observability stack using
# Docker Compose. It also verifies that all services are healthy.
#
# Usage:
#   chmod +x scripts/start.sh
#   ./scripts/start.sh
# =============================================================================

set -e

# Colors for terminal output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Project root (relative to script location)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
COMPOSE_FILE="$PROJECT_ROOT/docker/docker-compose.yml"

echo -e "${BLUE}============================================================${NC}"
echo -e "${BLUE}  Observability Stack - Quick Start${NC}"
echo -e "${BLUE}============================================================${NC}"
echo ""

# ---------------------------------------------------------------------------
# Step 1: Check prerequisites
# ---------------------------------------------------------------------------
echo -e "${YELLOW}[1/5] Checking prerequisites...${NC}"

if ! command -v docker &> /dev/null; then
    echo -e "${RED}ERROR: Docker is not installed. Please install Docker first.${NC}"
    exit 1
fi

if ! docker compose version &> /dev/null; then
    echo -e "${RED}ERROR: Docker Compose is not available. Please install Docker Compose.${NC}"
    exit 1
fi

echo -e "${GREEN}  Docker: $(docker --version)${NC}"
echo -e "${GREEN}  Compose: $(docker compose version)${NC}"

# ---------------------------------------------------------------------------
# Step 2: Build the application image
# ---------------------------------------------------------------------------
echo ""
echo -e "${YELLOW}[2/5] Building Flask application image...${NC}"
docker compose -f "$COMPOSE_FILE" build app
echo -e "${GREEN}  Application image built successfully.${NC}"

# ---------------------------------------------------------------------------
# Step 3: Start all services
# ---------------------------------------------------------------------------
echo ""
echo -e "${YELLOW}[3/5] Starting all services...${NC}"
docker compose -f "$COMPOSE_FILE" up -d
echo -e "${GREEN}  All services started.${NC}"

# ---------------------------------------------------------------------------
# Step 4: Wait for services to be healthy
# ---------------------------------------------------------------------------
echo ""
echo -e "${YELLOW}[4/5] Waiting for services to be healthy...${NC}"

check_service() {
    local name=$1
    local url=$2
    local max_retries=30
    local retry=0

    while [ $retry -lt $max_retries ]; do
        if curl -s -o /dev/null -w "%{http_code}" "$url" | grep -q "200"; then
            echo -e "${GREEN}  $name: OK${NC}"
            return 0
        fi
        retry=$((retry + 1))
        sleep 2
    done

    echo -e "${RED}  $name: FAILED (not responding after ${max_retries} retries)${NC}"
    return 1
}

sleep 5  # Give services a moment to initialize

check_service "Application"   "http://localhost:5000/health"
check_service "Prometheus"    "http://localhost:9090/-/healthy"
check_service "Grafana"       "http://localhost:3000/api/health"
check_service "Loki"          "http://localhost:3100/ready"
check_service "Alertmanager"  "http://localhost:9093/-/healthy"

# ---------------------------------------------------------------------------
# Step 5: Display summary
# ---------------------------------------------------------------------------
echo ""
echo -e "${BLUE}============================================================${NC}"
echo -e "${GREEN}  Stack deployed successfully!${NC}"
echo -e "${BLUE}============================================================${NC}"
echo ""
echo -e "  Application:    ${BLUE}http://localhost:5000${NC}"
echo -e "  Prometheus:     ${BLUE}http://localhost:9090${NC}"
echo -e "  Grafana:        ${BLUE}http://localhost:3000${NC}  (admin/admin)"
echo -e "  Alertmanager:   ${BLUE}http://localhost:9093${NC}"
echo -e "  Loki:           ${BLUE}http://localhost:3100${NC}"
echo -e "  Node Exporter:  ${BLUE}http://localhost:9100/metrics${NC}"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo -e "  1. Open Grafana and explore the pre-configured dashboards"
echo -e "  2. Run './scripts/test-load.sh' to generate traffic"
echo -e "  3. Run './scripts/simulate-failure.sh' to test alerting"
echo ""
echo -e "${BLUE}============================================================${NC}"
