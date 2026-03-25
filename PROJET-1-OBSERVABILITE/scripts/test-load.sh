#!/bin/bash
# =============================================================================
# Load Test Script - Observability Stack
# =============================================================================
# Sends a mix of HTTP requests to the Flask application to generate
# realistic traffic patterns for Grafana dashboards.
#
# Traffic distribution:
#   - 80% normal requests (/api/data) with variable latency
#   - 15% health checks (/health) with fast response
#   - 5% error requests (/api/error) to trigger alerts
#
# Usage:
#   chmod +x scripts/test-load.sh
#   ./scripts/test-load.sh              # Default: 200 requests
#   ./scripts/test-load.sh 500          # Custom: 500 requests
#   ./scripts/test-load.sh 1000 20      # 1000 requests, 20 concurrent
# =============================================================================

set -e

# Configuration
APP_URL="http://localhost:5000"
TOTAL_REQUESTS=${1:-200}
CONCURRENCY=${2:-10}

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}============================================================${NC}"
echo -e "${BLUE}  Load Test - Observability Stack${NC}"
echo -e "${BLUE}============================================================${NC}"
echo ""
echo -e "  Target:       ${APP_URL}"
echo -e "  Total:        ${TOTAL_REQUESTS} requests"
echo -e "  Concurrency:  ${CONCURRENCY} parallel"
echo ""

# Check if app is reachable
if ! curl -s -o /dev/null -w "%{http_code}" "${APP_URL}/health" | grep -q "200"; then
    echo -e "${RED}ERROR: Application is not reachable at ${APP_URL}${NC}"
    echo -e "${RED}Run './scripts/start.sh' first.${NC}"
    exit 1
fi

# Counters
SUCCESS=0
ERRORS=0
START_TIME=$(date +%s)

echo -e "${YELLOW}Starting load test...${NC}"
echo ""

send_request() {
    local endpoint=$1
    local status
    status=$(curl -s -o /dev/null -w "%{http_code}" "${APP_URL}${endpoint}" 2>/dev/null)
    echo "$status"
}

# Main load test loop
for i in $(seq 1 "$TOTAL_REQUESTS"); do
    # Determine request type based on distribution
    RAND=$((RANDOM % 100))

    if [ $RAND -lt 80 ]; then
        # 80% normal data requests
        ENDPOINT="/api/data"
    elif [ $RAND -lt 95 ]; then
        # 15% health checks
        ENDPOINT="/health"
    else
        # 5% error requests
        ENDPOINT="/api/error"
    fi

    # Send request in background (up to CONCURRENCY limit)
    (
        STATUS=$(send_request "$ENDPOINT")
        if [ "$STATUS" -ge 200 ] && [ "$STATUS" -lt 400 ]; then
            echo "OK"
        else
            echo "ERR"
        fi
    ) &

    # Limit concurrency
    if [ $((i % CONCURRENCY)) -eq 0 ]; then
        wait
    fi

    # Progress indicator every 50 requests
    if [ $((i % 50)) -eq 0 ]; then
        PERCENT=$((i * 100 / TOTAL_REQUESTS))
        echo -e "  Progress: ${i}/${TOTAL_REQUESTS} (${PERCENT}%)"
    fi
done

# Wait for remaining background jobs
wait

END_TIME=$(date +%s)
DURATION=$((END_TIME - START_TIME))

echo ""
echo -e "${BLUE}============================================================${NC}"
echo -e "${GREEN}  Load Test Complete${NC}"
echo -e "${BLUE}============================================================${NC}"
echo ""
echo -e "  Duration:     ${DURATION} seconds"
echo -e "  Requests:     ${TOTAL_REQUESTS}"
echo -e "  Rate:         ~$((TOTAL_REQUESTS / (DURATION + 1))) req/s"
echo ""
echo -e "${YELLOW}Check your Grafana dashboards to see the results:${NC}"
echo -e "  ${BLUE}http://localhost:3000${NC}"
echo ""
echo -e "${YELLOW}Check Prometheus for alert status:${NC}"
echo -e "  ${BLUE}http://localhost:9090/alerts${NC}"
echo ""
echo -e "${BLUE}============================================================${NC}"
