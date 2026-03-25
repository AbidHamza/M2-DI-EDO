#!/usr/bin/env bash
# =============================================================================
# Start Monitoring Stack — Prometheus + Grafana + Node Exporter
# =============================================================================
# Usage:
#   chmod +x scripts/start-monitoring.sh
#   ./scripts/start-monitoring.sh          # Start
#   ./scripts/start-monitoring.sh stop     # Stop
#   ./scripts/start-monitoring.sh status   # Check status
# =============================================================================

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MONITORING_DIR="${PROJECT_DIR}/monitoring"
COMPOSE_FILE="${MONITORING_DIR}/docker-compose-monitoring.yml"
ACTION="${1:-start}"

case $ACTION in
    # -----------------------------------------------------------------------
    # START
    # -----------------------------------------------------------------------
    start)
        echo -e "${BLUE}=== Starting Monitoring Stack ===${NC}"
        echo ""

        # Check prerequisites
        if ! command -v docker &> /dev/null; then
            echo -e "${RED}Docker is not installed. Please install Docker first.${NC}"
            exit 1
        fi

        # Linux: set vm.max_map_count for Elasticsearch (SonarQube needs it)
        if [ "$(uname)" = "Linux" ]; then
            CURRENT_MAP_COUNT=$(sysctl -n vm.max_map_count 2>/dev/null || echo "0")
            if [ "$CURRENT_MAP_COUNT" -lt 262144 ]; then
                echo -e "${YELLOW}Setting vm.max_map_count=262144 (required for Elasticsearch)...${NC}"
                sudo sysctl -w vm.max_map_count=262144 2>/dev/null || true
            fi
        fi

        # Start the stack
        echo "Starting Prometheus, Grafana, and Node Exporter..."
        docker compose -f "${COMPOSE_FILE}" up -d

        echo ""
        echo "Waiting for services to be ready..."
        sleep 10

        # Check services
        echo ""
        echo -e "${BLUE}Service Status:${NC}"

        # Prometheus
        if curl -s http://localhost:9090/-/healthy | grep -q "Healthy" 2>/dev/null; then
            echo -e "  Prometheus:     ${GREEN}UP${NC} — http://localhost:9090"
        else
            echo -e "  Prometheus:     ${YELLOW}STARTING${NC} — http://localhost:9090"
        fi

        # Grafana
        if curl -s http://localhost:3000/api/health | grep -q "ok" 2>/dev/null; then
            echo -e "  Grafana:        ${GREEN}UP${NC} — http://localhost:3000 (admin/admin)"
        else
            echo -e "  Grafana:        ${YELLOW}STARTING${NC} — http://localhost:3000"
        fi

        # Node Exporter
        if curl -s http://localhost:9100/metrics > /dev/null 2>&1; then
            echo -e "  Node Exporter:  ${GREEN}UP${NC} — http://localhost:9100"
        else
            echo -e "  Node Exporter:  ${YELLOW}STARTING${NC} — http://localhost:9100"
        fi

        echo ""
        echo -e "${GREEN}Monitoring stack started!${NC}"
        echo ""
        echo "Next steps:"
        echo "  1. Open Grafana: http://localhost:3000 (admin/admin)"
        echo "  2. Add Prometheus data source: http://prometheus:9090"
        echo "  3. Import dashboard: monitoring/grafana/dashboards/finance-app.json"
        echo ""
        ;;

    # -----------------------------------------------------------------------
    # STOP
    # -----------------------------------------------------------------------
    stop)
        echo -e "${BLUE}=== Stopping Monitoring Stack ===${NC}"
        docker compose -f "${COMPOSE_FILE}" down
        echo -e "${GREEN}Monitoring stack stopped.${NC}"
        ;;

    # -----------------------------------------------------------------------
    # STATUS
    # -----------------------------------------------------------------------
    status)
        echo -e "${BLUE}=== Monitoring Stack Status ===${NC}"
        echo ""
        docker compose -f "${COMPOSE_FILE}" ps
        echo ""

        # Check each service
        echo "Health checks:"
        if curl -s http://localhost:9090/-/healthy 2>/dev/null | grep -q "Healthy"; then
            echo -e "  Prometheus:     ${GREEN}HEALTHY${NC}"
        else
            echo -e "  Prometheus:     ${RED}DOWN${NC}"
        fi

        if curl -s http://localhost:3000/api/health 2>/dev/null | grep -q "ok"; then
            echo -e "  Grafana:        ${GREEN}HEALTHY${NC}"
        else
            echo -e "  Grafana:        ${RED}DOWN${NC}"
        fi

        if curl -s http://localhost:9100/metrics > /dev/null 2>&1; then
            echo -e "  Node Exporter:  ${GREEN}HEALTHY${NC}"
        else
            echo -e "  Node Exporter:  ${RED}DOWN${NC}"
        fi
        echo ""
        ;;

    # -----------------------------------------------------------------------
    # UNKNOWN
    # -----------------------------------------------------------------------
    *)
        echo "Usage: $0 [start|stop|status]"
        exit 1
        ;;
esac
