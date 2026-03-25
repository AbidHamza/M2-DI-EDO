"""
Flask Observability Demo Application
=====================================
A simple Flask application instrumented with Prometheus metrics
and structured JSON logging for Loki integration.

Metrics exposed:
- flask_http_requests_total (Counter): Total HTTP requests by method, endpoint, status
- flask_http_request_duration_seconds (Histogram): Request latency distribution
- flask_active_requests (Gauge): Number of requests currently being processed
- flask_app_info (Gauge): Application metadata (version)
"""

import logging
import os
import random
import time

from flask import Flask, jsonify, request, Response
from prometheus_client import (
    Counter,
    Histogram,
    Gauge,
    Info,
    generate_latest,
    CONTENT_TYPE_LATEST,
    REGISTRY,
)
from pythonjsonlogger import jsonlogger

# ---------------------------------------------------------------------------
# Logging Configuration (structured JSON for Loki)
# ---------------------------------------------------------------------------

LOG_LEVEL = os.environ.get("LOG_LEVEL", "INFO").upper()

logger = logging.getLogger("flask-app")
logger.setLevel(LOG_LEVEL)

# Remove default handlers to avoid duplicate log lines
logger.handlers = []

# JSON formatter – every log line is a valid JSON object
log_handler = logging.StreamHandler()
formatter = jsonlogger.JsonFormatter(
    fmt="%(asctime)s %(name)s %(levelname)s %(message)s %(pathname)s %(lineno)d",
    datefmt="%Y-%m-%dT%H:%M:%S",
)
log_handler.setFormatter(formatter)
logger.addHandler(log_handler)

# Also configure the root logger so Flask internal logs are JSON too
root_logger = logging.getLogger()
root_logger.setLevel(LOG_LEVEL)
root_logger.handlers = [log_handler]

# ---------------------------------------------------------------------------
# Prometheus Metrics
# ---------------------------------------------------------------------------

# Counter – monotonically increasing value (total requests served)
REQUEST_COUNT = Counter(
    "flask_http_requests_total",
    "Total number of HTTP requests",
    ["method", "endpoint", "status"],
)

# Histogram – distribution of request durations (for percentile calculations)
REQUEST_LATENCY = Histogram(
    "flask_http_request_duration_seconds",
    "HTTP request latency in seconds",
    ["method", "endpoint"],
    buckets=[0.005, 0.01, 0.025, 0.05, 0.1, 0.25, 0.5, 1.0, 2.5, 5.0, 10.0],
)

# Gauge – value that can go up and down (current in-flight requests)
ACTIVE_REQUESTS = Gauge(
    "flask_active_requests",
    "Number of active requests currently being processed",
)

# Info – static key/value metadata about the application
APP_INFO = Info(
    "flask_app",
    "Application metadata",
)
APP_INFO.info({"version": "1.0.0", "environment": os.environ.get("ENV", "development")})

# ---------------------------------------------------------------------------
# Flask Application
# ---------------------------------------------------------------------------

app = Flask(__name__)


@app.before_request
def before_request():
    """Track request start time and increment active requests gauge."""
    request._start_time = time.time()
    ACTIVE_REQUESTS.inc()


@app.after_request
def after_request(response):
    """Record metrics after each request completes."""
    # Calculate request duration
    duration = time.time() - getattr(request, "_start_time", time.time())

    # Skip /metrics endpoint to avoid self-referential metric inflation
    if request.path != "/metrics":
        # Increment the request counter
        REQUEST_COUNT.labels(
            method=request.method,
            endpoint=request.path,
            status=response.status_code,
        ).inc()

        # Observe the request latency in the histogram
        REQUEST_LATENCY.labels(
            method=request.method,
            endpoint=request.path,
        ).observe(duration)

        # Log the request details (will be captured by Promtail → Loki)
        logger.info(
            "Request processed",
            extra={
                "method": request.method,
                "path": request.path,
                "status": response.status_code,
                "duration_ms": round(duration * 1000, 2),
                "remote_addr": request.remote_addr,
            },
        )

    # Decrement active requests gauge
    ACTIVE_REQUESTS.dec()

    return response


# ---------------------------------------------------------------------------
# Routes
# ---------------------------------------------------------------------------


@app.route("/")
def index():
    """Home page with navigation links."""
    return jsonify(
        {
            "service": "Flask Observability Demo",
            "version": "1.0.0",
            "endpoints": {
                "/": "This page",
                "/health": "Health check",
                "/metrics": "Prometheus metrics",
                "/api/data": "Simulated data endpoint (random latency)",
                "/api/error": "Simulated error endpoint (for testing alerts)",
            },
        }
    )


@app.route("/health")
def health():
    """Health check endpoint used by Docker HEALTHCHECK and monitoring tools."""
    return jsonify({"status": "healthy", "timestamp": time.time()})


@app.route("/metrics")
def metrics():
    """Prometheus metrics endpoint.

    Returns all registered metrics in the Prometheus exposition format.
    Prometheus scrapes this endpoint at the configured interval (default: 15s).
    """
    return Response(generate_latest(REGISTRY), mimetype=CONTENT_TYPE_LATEST)


@app.route("/api/data")
def api_data():
    """Simulated data endpoint with random latency.

    This endpoint introduces artificial latency between 10ms and 500ms
    to create realistic latency distributions in Prometheus histograms.
    Occasionally (5% of the time) it will take longer (1-3 seconds)
    to simulate slow queries.
    """
    # Simulate variable processing time
    if random.random() < 0.05:
        # 5% chance of slow response (simulates slow DB query, external API, etc.)
        delay = random.uniform(1.0, 3.0)
        logger.warning(
            "Slow request detected",
            extra={"delay_seconds": round(delay, 3), "endpoint": "/api/data"},
        )
    else:
        # Normal response time: 10ms to 500ms
        delay = random.uniform(0.01, 0.5)

    time.sleep(delay)

    # Generate some fake data
    data = {
        "id": random.randint(1, 10000),
        "value": round(random.uniform(0, 100), 2),
        "processing_time_ms": round(delay * 1000, 2),
        "timestamp": time.time(),
    }

    return jsonify(data)


@app.route("/api/error")
def api_error():
    """Simulated error endpoint for testing alerting.

    Always returns HTTP 500. Use this to test:
    - HighErrorRate alert in Prometheus
    - Error rate panels in Grafana dashboards
    - Error logs in Loki
    """
    logger.error(
        "Simulated application error",
        extra={
            "error_type": "SimulatedError",
            "endpoint": "/api/error",
            "details": "This error is intentionally generated for testing purposes",
        },
    )
    return jsonify({"error": "Internal Server Error (simulated)"}), 500


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

if __name__ == "__main__":
    port = int(os.environ.get("PORT", 5000))
    logger.info(
        f"Starting Flask Observability Demo on port {port}",
        extra={"port": port, "log_level": LOG_LEVEL},
    )
    app.run(host="0.0.0.0", port=port, debug=False)
