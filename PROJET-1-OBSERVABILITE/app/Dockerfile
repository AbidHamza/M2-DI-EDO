# =============================================================================
# Multi-stage Dockerfile for Flask Observability Demo
# =============================================================================
# Stage 1: Install dependencies in a builder stage
# Stage 2: Copy only what's needed into the final slim image
# =============================================================================

# ---------------------------------------------------------------------------
# Stage 1: Builder – install Python dependencies
# ---------------------------------------------------------------------------
FROM python:3.11-slim AS builder

WORKDIR /build

# Copy only requirements first to leverage Docker layer caching.
# If requirements.txt hasn't changed, Docker reuses the cached layer
# and skips pip install entirely on subsequent builds.
COPY requirements.txt .

RUN pip install --no-cache-dir --prefix=/install -r requirements.txt

# ---------------------------------------------------------------------------
# Stage 2: Runtime – minimal image with app code and installed packages
# ---------------------------------------------------------------------------
FROM python:3.11-slim

# Metadata labels (OCI standard)
LABEL maintainer="M2 Expert DevOps - ENSITECH"
LABEL description="Flask application instrumented with Prometheus metrics"
LABEL version="1.0.0"

# Prevent Python from writing .pyc files and enable unbuffered stdout/stderr
# so that log lines appear immediately in Docker logs (important for Promtail).
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV PORT=5000

WORKDIR /app

# Copy installed Python packages from the builder stage
COPY --from=builder /install /usr/local

# Copy application source code
COPY app.py .

# Create a non-root user for security best practice.
# Running as root inside a container is a security risk.
RUN groupadd -r appuser && useradd -r -g appuser -d /app -s /sbin/nologin appuser \
    && chown -R appuser:appuser /app

USER appuser

# Expose the application port
EXPOSE ${PORT}

# Health check – Docker will mark the container as unhealthy if this fails.
# Used by Docker Compose "depends_on: condition: service_healthy"
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:${PORT}/health')" || exit 1

# Run with gunicorn (production WSGI server) instead of Flask's dev server.
# - 4 worker processes for concurrency
# - bind to 0.0.0.0 so the container is accessible from outside
# - access-logfile disabled because we handle logging in the app
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "--workers", "4", "--timeout", "120", "--access-logfile", "-", "app:app"]
