# =============================================================================
# Dockerfile for Finance App — DevSecOps
# Multi-stage build with security best practices
# =============================================================================

# ---------------------------------------------------------------------------
# Stage 1: Builder — install dependencies
# ---------------------------------------------------------------------------
FROM python:3.11-slim AS builder

WORKDIR /build

# Install dependencies in a virtual environment for clean copy
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Copy only requirements first (Docker layer caching optimization)
COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# ---------------------------------------------------------------------------
# Stage 2: Runtime — minimal image with app code only
# ---------------------------------------------------------------------------
FROM python:3.11-slim AS runtime

# Security: add metadata labels
LABEL maintainer="M2 DevOps ENSITECH"
LABEL description="Finance App - DevSecOps Pipeline Demo"
LABEL version="1.0.0"

# Security: create non-root user
RUN groupadd -r appgroup && \
    useradd -r -g appgroup -d /app -s /sbin/nologin appuser

# Copy virtual environment from builder stage
COPY --from=builder /opt/venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Set working directory
WORKDIR /app

# Copy application code
COPY app.py .

# Security: change ownership to non-root user
RUN chown -R appuser:appgroup /app

# Security: switch to non-root user
USER appuser

# Expose port (documentation only, does not publish)
EXPOSE 5000

# Health check — Docker will monitor container health
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:5000/health')" || exit 1

# Environment variables
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    APP_ENV=production

# Run with Gunicorn (production-grade WSGI server)
# 4 workers, bind to all interfaces on port 5000
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "--workers", "4", "--access-logfile", "-", "--error-logfile", "-", "app:app"]
