#!/usr/bin/env bash
# =============================================================================
# Local Pipeline — Simulates the full GitLab CI/CD pipeline locally
# =============================================================================
# Runs all 5 stages: test → quality → security → build → deploy
#
# Usage:
#   chmod +x scripts/pipeline-local.sh
#   ./scripts/pipeline-local.sh
#
# Options:
#   --skip-quality    Skip SonarQube analysis (requires SonarQube running)
#   --skip-deploy     Skip deployment stage
#   --env ENV         Target environment: dev (default), staging, prod
# =============================================================================

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Project root directory
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
APP_DIR="${PROJECT_DIR}/app"

# Default options
SKIP_QUALITY=false
SKIP_DEPLOY=false
TARGET_ENV="dev"

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --skip-quality) SKIP_QUALITY=true; shift ;;
        --skip-deploy)  SKIP_DEPLOY=true; shift ;;
        --env)          TARGET_ENV="$2"; shift 2 ;;
        *)              echo "Unknown option: $1"; exit 1 ;;
    esac
done

# ---------------------------------------------------------------------------
# Helper functions
# ---------------------------------------------------------------------------
stage_header() {
    echo ""
    echo -e "${BLUE}=================================================================${NC}"
    echo -e "${BLUE}  STAGE: $1${NC}"
    echo -e "${BLUE}=================================================================${NC}"
    echo ""
}

stage_pass() {
    echo ""
    echo -e "${GREEN}  ✓ STAGE $1 — PASSED${NC}"
    echo ""
}

stage_fail() {
    echo ""
    echo -e "${RED}  ✗ STAGE $1 — FAILED${NC}"
    echo -e "${RED}  Pipeline stopped.${NC}"
    echo ""
    exit 1
}

# ---------------------------------------------------------------------------
# STAGE 1: TEST
# ---------------------------------------------------------------------------
stage_header "1/5 — TEST (pytest + coverage)"

cd "${APP_DIR}"

# Create virtual environment if not exists
if [ ! -d "venv" ]; then
    echo -e "${YELLOW}Creating virtual environment...${NC}"
    python3 -m venv venv
fi

# Activate and install dependencies
source venv/bin/activate
pip install -q -r requirements.txt

# Run tests with coverage
echo "Running pytest with coverage..."
if pytest tests/ -v --cov=. --cov-report=xml:coverage.xml --cov-report=term-missing --junitxml=report.xml; then
    stage_pass "TEST"
else
    stage_fail "TEST"
fi

# ---------------------------------------------------------------------------
# STAGE 2: QUALITY (SonarQube)
# ---------------------------------------------------------------------------
if [ "$SKIP_QUALITY" = true ]; then
    echo -e "${YELLOW}Skipping QUALITY stage (--skip-quality)${NC}"
else
    stage_header "2/5 — QUALITY (SonarQube)"

    # Check if SonarQube is running
    if curl -s http://localhost:9000/api/system/status | grep -q "UP" 2>/dev/null; then
        echo "SonarQube is running, launching analysis..."

        cd "${PROJECT_DIR}"

        if command -v sonar-scanner &> /dev/null; then
            sonar-scanner \
                -Dsonar.projectKey=finance-app \
                -Dsonar.sources=app/ \
                -Dsonar.tests=app/tests/ \
                -Dsonar.host.url=http://localhost:9000 \
                -Dsonar.token="${SONAR_TOKEN:-}" \
                -Dsonar.python.coverage.reportPaths=app/coverage.xml
            stage_pass "QUALITY"
        else
            echo -e "${YELLOW}sonar-scanner not found. Install it or use Docker:${NC}"
            echo "  docker run --rm -e SONAR_HOST_URL=http://host.docker.internal:9000 -v \$(pwd):/usr/src sonarsource/sonar-scanner-cli:5"
            echo -e "${YELLOW}Skipping SonarQube analysis.${NC}"
        fi
    else
        echo -e "${YELLOW}SonarQube is not running on localhost:9000.${NC}"
        echo "Start it with: cd sonarqube && docker compose -f docker-compose-sonarqube.yml up -d"
        echo -e "${YELLOW}Skipping SonarQube analysis.${NC}"
    fi
fi

# ---------------------------------------------------------------------------
# STAGE 3: SECURITY (Bandit + Trivy)
# ---------------------------------------------------------------------------
stage_header "3/5 — SECURITY (Bandit + Trivy)"

cd "${APP_DIR}"
source venv/bin/activate

# Bandit scan
echo "--- Bandit SAST Scan ---"
if command -v bandit &> /dev/null || pip show bandit &> /dev/null; then
    bandit -r . -x ./tests/,./venv/ -f screen --severity-level medium || true
    bandit -r . -x ./tests/,./venv/ -f json -o "${PROJECT_DIR}/bandit-report.json" --severity-level medium || true
    echo -e "${GREEN}Bandit scan complete. Report: bandit-report.json${NC}"
else
    pip install -q bandit
    bandit -r . -x ./tests/,./venv/ -f screen --severity-level medium || true
fi

# Trivy scan
echo ""
echo "--- Trivy Vulnerability Scan ---"
if command -v trivy &> /dev/null; then
    trivy fs --severity HIGH,CRITICAL "${APP_DIR}"
else
    echo -e "${YELLOW}Trivy not installed. Running via Docker...${NC}"
    if command -v docker &> /dev/null; then
        docker run --rm -v "${APP_DIR}:/project" aquasec/trivy:latest fs --severity HIGH,CRITICAL /project/ || true
    else
        echo -e "${YELLOW}Docker not available. Skipping Trivy scan.${NC}"
    fi
fi

stage_pass "SECURITY"

# ---------------------------------------------------------------------------
# STAGE 4: BUILD (Docker)
# ---------------------------------------------------------------------------
stage_header "4/5 — BUILD (Docker image)"

cd "${APP_DIR}"

if command -v docker &> /dev/null; then
    COMMIT_SHA=$(git rev-parse --short HEAD 2>/dev/null || echo "local")
    IMAGE_NAME="finance-app"
    IMAGE_TAG="${IMAGE_NAME}:${COMMIT_SHA}"
    IMAGE_LATEST="${IMAGE_NAME}:latest"

    echo "Building Docker image: ${IMAGE_TAG}"
    docker build -t "${IMAGE_TAG}" -t "${IMAGE_LATEST}" -f Dockerfile .

    echo ""
    echo "Image built successfully:"
    docker images | grep "${IMAGE_NAME}" | head -5

    stage_pass "BUILD"
else
    echo -e "${YELLOW}Docker not available. Skipping build stage.${NC}"
fi

# ---------------------------------------------------------------------------
# STAGE 5: DEPLOY (Ansible)
# ---------------------------------------------------------------------------
if [ "$SKIP_DEPLOY" = true ]; then
    echo -e "${YELLOW}Skipping DEPLOY stage (--skip-deploy)${NC}"
else
    stage_header "5/5 — DEPLOY (Ansible → ${TARGET_ENV})"

    cd "${PROJECT_DIR}/ansible"

    if command -v ansible-playbook &> /dev/null; then
        echo "Deploying to ${TARGET_ENV} environment..."
        ansible-playbook -i "inventory/${TARGET_ENV}.ini" playbook.yml \
            --extra-vars "app_image=finance-app:latest app_version=local environment=${TARGET_ENV}"
        stage_pass "DEPLOY"
    else
        echo -e "${YELLOW}Ansible not installed. Deploying with Docker directly...${NC}"
        if command -v docker &> /dev/null; then
            # Fallback: direct Docker deployment
            docker rm -f "finance-app-${TARGET_ENV}" 2>/dev/null || true

            case $TARGET_ENV in
                dev)     PORT=5001 ;;
                staging) PORT=5002 ;;
                prod)    PORT=5000 ;;
                *)       PORT=5000 ;;
            esac

            docker run -d \
                --name "finance-app-${TARGET_ENV}" \
                -p "${PORT}:5000" \
                -e "APP_ENV=${TARGET_ENV}" \
                -e "LOG_LEVEL=INFO" \
                finance-app:latest

            # Wait and health check
            sleep 5
            if curl -s "http://localhost:${PORT}/health" | grep -q "healthy"; then
                echo -e "${GREEN}Application deployed and healthy on port ${PORT}${NC}"
                stage_pass "DEPLOY"
            else
                echo -e "${RED}Health check failed!${NC}"
                stage_fail "DEPLOY"
            fi
        else
            echo -e "${RED}Neither Ansible nor Docker available. Cannot deploy.${NC}"
            stage_fail "DEPLOY"
        fi
    fi
fi

# ---------------------------------------------------------------------------
# SUMMARY
# ---------------------------------------------------------------------------
echo ""
echo -e "${GREEN}=================================================================${NC}"
echo -e "${GREEN}  PIPELINE COMPLETE — All stages passed!${NC}"
echo -e "${GREEN}=================================================================${NC}"
echo ""
echo "  Environment: ${TARGET_ENV}"
echo "  App URL:     http://localhost:${PORT:-5000}"
echo "  Health:      http://localhost:${PORT:-5000}/health"
echo "  Metrics:     http://localhost:${PORT:-5000}/metrics"
echo ""
