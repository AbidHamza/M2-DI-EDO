#!/usr/bin/env bash
# =============================================================================
# Security Scan Script — Run Bandit + Trivy locally
# =============================================================================
# Usage:
#   chmod +x scripts/scan-security.sh
#   ./scripts/scan-security.sh
# =============================================================================

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
APP_DIR="${PROJECT_DIR}/app"

echo -e "${BLUE}=== Security Scan — Finance App ===${NC}"
echo ""

# ---------------------------------------------------------------------------
# 1. Bandit — Python SAST
# ---------------------------------------------------------------------------
echo -e "${BLUE}--- 1/3: Bandit (Python Security Linter) ---${NC}"

cd "${APP_DIR}"

# Ensure bandit is installed
if ! command -v bandit &> /dev/null; then
    echo "Installing bandit..."
    pip install -q bandit
fi

echo "Scanning Python code for security issues..."
echo ""

# Screen output
bandit -r . -x ./tests/,./venv/ -f screen --severity-level low || true

# JSON report
bandit -r . -x ./tests/,./venv/ -f json -o "${PROJECT_DIR}/bandit-report.json" --severity-level low 2>/dev/null || true
echo ""
echo -e "${GREEN}Bandit report saved: bandit-report.json${NC}"
echo ""

# ---------------------------------------------------------------------------
# 2. Trivy — Dependency & Filesystem scan
# ---------------------------------------------------------------------------
echo -e "${BLUE}--- 2/3: Trivy (Vulnerability Scanner) ---${NC}"

if command -v trivy &> /dev/null; then
    echo "Scanning filesystem for vulnerabilities..."
    trivy fs --severity LOW,MEDIUM,HIGH,CRITICAL "${APP_DIR}" || true

    # Check if Docker image exists
    if docker image inspect finance-app:latest &> /dev/null 2>&1; then
        echo ""
        echo "Scanning Docker image finance-app:latest..."
        trivy image --severity HIGH,CRITICAL finance-app:latest || true
    fi
elif command -v docker &> /dev/null; then
    echo "Trivy not installed locally, running via Docker..."
    docker run --rm -v "${APP_DIR}:/project" aquasec/trivy:latest fs --severity HIGH,CRITICAL /project/ || true
else
    echo -e "${YELLOW}Trivy not available (install it or use Docker).${NC}"
fi
echo ""

# ---------------------------------------------------------------------------
# 3. pip-audit — Dependency audit
# ---------------------------------------------------------------------------
echo -e "${BLUE}--- 3/3: pip-audit (Dependency Audit) ---${NC}"

if ! command -v pip-audit &> /dev/null; then
    echo "Installing pip-audit..."
    pip install -q pip-audit
fi

echo "Auditing Python dependencies..."
pip-audit -r "${APP_DIR}/requirements.txt" || true

echo ""

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------
echo -e "${BLUE}=== Security Scan Complete ===${NC}"
echo ""
echo "Reports generated:"
echo "  - bandit-report.json (Python SAST)"
echo ""
echo "Review any findings and fix before deploying to production."
