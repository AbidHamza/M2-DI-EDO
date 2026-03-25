#!/bin/bash
# =============================================================================
# Failure Simulation Script - Observability Stack
# =============================================================================
# Simulates various failure scenarios to test alerting and monitoring.
# Each scenario demonstrates a different type of incident.
#
# Usage:
#   chmod +x scripts/simulate-failure.sh
#   ./scripts/simulate-failure.sh              # Interactive menu
#   ./scripts/simulate-failure.sh errors       # Simulate high error rate
#   ./scripts/simulate-failure.sh down         # Simulate service down
#   ./scripts/simulate-failure.sh cpu          # Simulate CPU stress
#   ./scripts/simulate-failure.sh all          # Run all simulations
# =============================================================================

set -e

# Configuration
APP_URL="http://localhost:5000"
COMPOSE_FILE="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/docker/docker-compose.yml"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# ---------------------------------------------------------------------------
# Simulation 1: High Error Rate
# ---------------------------------------------------------------------------
simulate_errors() {
    echo -e "${RED}============================================================${NC}"
    echo -e "${RED}  Simulation: High Error Rate${NC}"
    echo -e "${RED}============================================================${NC}"
    echo ""
    echo -e "${YELLOW}Sending 200 error requests to trigger HighErrorRate alert...${NC}"
    echo -e "${YELLOW}The alert should fire after 5 minutes of >5% error rate.${NC}"
    echo ""

    for i in $(seq 1 200); do
        curl -s -o /dev/null "${APP_URL}/api/error" &
        if [ $((i % 20)) -eq 0 ]; then
            wait
            echo "  Sent $i/200 error requests..."
        fi
    done
    wait

    # Also send some normal requests to maintain a mix
    echo ""
    echo -e "${YELLOW}Sending 50 normal requests for comparison...${NC}"
    for i in $(seq 1 50); do
        curl -s -o /dev/null "${APP_URL}/api/data" &
    done
    wait

    echo ""
    echo -e "${GREEN}Done! Check:${NC}"
    echo -e "  Prometheus Alerts: ${BLUE}http://localhost:9090/alerts${NC}"
    echo -e "  Alertmanager:      ${BLUE}http://localhost:9093${NC}"
    echo -e "  Grafana (errors):  ${BLUE}http://localhost:3000${NC}"
    echo ""
    echo -e "${YELLOW}Wait ~5 minutes for the HighErrorRate alert to transition to FIRING.${NC}"
}

# ---------------------------------------------------------------------------
# Simulation 2: Service Down
# ---------------------------------------------------------------------------
simulate_down() {
    echo -e "${RED}============================================================${NC}"
    echo -e "${RED}  Simulation: Service Down${NC}"
    echo -e "${RED}============================================================${NC}"
    echo ""
    echo -e "${YELLOW}Stopping the Flask application for 90 seconds...${NC}"
    echo -e "${YELLOW}The ServiceDown alert should fire after 1 minute.${NC}"
    echo ""

    docker compose -f "$COMPOSE_FILE" stop app
    echo -e "${RED}  Application stopped.${NC}"

    echo ""
    echo -e "${YELLOW}Waiting 90 seconds for the alert to trigger...${NC}"
    echo -e "${YELLOW}Check Prometheus Targets: ${BLUE}http://localhost:9090/targets${NC}"
    echo ""

    for i in $(seq 1 90); do
        if [ $((i % 15)) -eq 0 ]; then
            echo "  Elapsed: ${i}s / 90s"
        fi
        sleep 1
    done

    echo ""
    echo -e "${YELLOW}Restarting the application...${NC}"
    docker compose -f "$COMPOSE_FILE" start app
    echo -e "${GREEN}  Application restarted.${NC}"

    echo ""
    echo -e "${GREEN}Done! Check:${NC}"
    echo -e "  Prometheus Alerts: ${BLUE}http://localhost:9090/alerts${NC}"
    echo -e "  Alertmanager:      ${BLUE}http://localhost:9093${NC}"
    echo -e "${YELLOW}The alert should transition to RESOLVED after the app is back up.${NC}"
}

# ---------------------------------------------------------------------------
# Simulation 3: CPU Stress
# ---------------------------------------------------------------------------
simulate_cpu() {
    echo -e "${RED}============================================================${NC}"
    echo -e "${RED}  Simulation: CPU Stress${NC}"
    echo -e "${RED}============================================================${NC}"
    echo ""
    echo -e "${YELLOW}Running CPU stress test for 120 seconds...${NC}"
    echo -e "${YELLOW}The HighCpuUsage alert may fire if CPU exceeds 80%.${NC}"
    echo ""

    # Check if stress image is available, pull if not
    if ! docker image inspect progrium/stress &> /dev/null 2>&1; then
        echo -e "${YELLOW}Pulling stress test image...${NC}"
        docker pull progrium/stress
    fi

    echo -e "${RED}  Starting CPU stress (4 workers, 120 seconds)...${NC}"
    docker run --rm -d \
        --name observability-stress-test \
        --network observability-net \
        progrium/stress \
        --cpu 4 --timeout 120s

    echo ""
    echo -e "${GREEN}CPU stress container started.${NC}"
    echo -e "${YELLOW}It will automatically stop after 120 seconds.${NC}"
    echo ""
    echo -e "${GREEN}Check:${NC}"
    echo -e "  Grafana (CPU):    ${BLUE}http://localhost:3000${NC}"
    echo -e "  Prometheus:       ${BLUE}http://localhost:9090/graph?g0.expr=100-avg(rate(node_cpu_seconds_total{mode%3D%22idle%22}[5m]))*100${NC}"
    echo ""
    echo -e "${YELLOW}To stop early:${NC}"
    echo -e "  docker stop observability-stress-test"
}

# ---------------------------------------------------------------------------
# Menu
# ---------------------------------------------------------------------------
show_menu() {
    echo -e "${BLUE}============================================================${NC}"
    echo -e "${BLUE}  Failure Simulation - Observability Stack${NC}"
    echo -e "${BLUE}============================================================${NC}"
    echo ""
    echo -e "  ${YELLOW}1)${NC} errors  - Simulate high error rate (HighErrorRate alert)"
    echo -e "  ${YELLOW}2)${NC} down    - Simulate service down (ServiceDown alert)"
    echo -e "  ${YELLOW}3)${NC} cpu     - Simulate CPU stress (HighCpuUsage alert)"
    echo -e "  ${YELLOW}4)${NC} all     - Run all simulations sequentially"
    echo -e "  ${YELLOW}5)${NC} quit    - Exit"
    echo ""
    read -rp "Select a simulation [1-5]: " choice

    case $choice in
        1|errors)  simulate_errors ;;
        2|down)    simulate_down ;;
        3|cpu)     simulate_cpu ;;
        4|all)
            simulate_errors
            echo ""
            echo -e "${YELLOW}Waiting 30 seconds before next simulation...${NC}"
            sleep 30
            simulate_down
            echo ""
            echo -e "${YELLOW}Waiting 30 seconds before next simulation...${NC}"
            sleep 30
            simulate_cpu
            ;;
        5|quit)    echo "Bye!"; exit 0 ;;
        *)         echo -e "${RED}Invalid choice.${NC}"; show_menu ;;
    esac
}

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------
case "${1:-}" in
    errors)  simulate_errors ;;
    down)    simulate_down ;;
    cpu)     simulate_cpu ;;
    all)
        simulate_errors
        sleep 30
        simulate_down
        sleep 30
        simulate_cpu
        ;;
    *)       show_menu ;;
esac
