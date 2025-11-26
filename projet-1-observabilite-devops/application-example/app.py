"""
Application exemple pour la supervision avec Prometheus, Grafana et Loki.
Cette application génère des métriques et des logs pour être supervisée.
"""

from flask import Flask, jsonify, request
from prometheus_client import Counter, Histogram, generate_latest, CONTENT_TYPE_LATEST
import logging
import time
import random
import json
from datetime import datetime

# Configuration du logging au format JSON pour Loki
logging.basicConfig(
    level=logging.INFO,
    format='{"timestamp":"%(asctime)s","level":"%(levelname)s","message":"%(message)s","module":"%(name)s"}',
    datefmt='%Y-%m-%dT%H:%M:%S'
)

logger = logging.getLogger(__name__)

app = Flask(__name__)

# Métriques Prometheus
http_requests_total = Counter(
    'http_requests_total',
    'Total number of HTTP requests',
    ['method', 'endpoint', 'status']
)

http_request_duration_seconds = Histogram(
    'http_request_duration_seconds',
    'HTTP request duration in seconds',
    ['method', 'endpoint']
)

app_errors_total = Counter(
    'app_errors_total',
    'Total number of application errors',
    ['error_type']
)

# Variables pour simuler l'état de l'application
request_count = 0
error_rate = 0.1  # 10% de chance d'erreur


@app.before_request
def before_request():
    """Middleware pour mesurer la durée des requêtes."""
    request.start_time = time.time()


@app.after_request
def after_request(response):
    """Middleware pour enregistrer les métriques après chaque requête."""
    duration = time.time() - request.start_time
    
    # Enregistrer les métriques
    http_requests_total.labels(
        method=request.method,
        endpoint=request.endpoint or 'unknown',
        status=response.status_code
    ).inc()
    
    http_request_duration_seconds.labels(
        method=request.method,
        endpoint=request.endpoint or 'unknown'
    ).observe(duration)
    
    # Logger la requête
    logger.info(
        f"Request: {request.method} {request.path} - "
        f"Status: {response.status_code} - "
        f"Duration: {duration:.3f}s"
    )
    
    return response


@app.route('/')
def home():
    """Page d'accueil."""
    logger.info("Home page accessed")
    return jsonify({
        "message": "Application exemple pour l'observabilité",
        "endpoints": {
            "/health": "Health check",
            "/api/data": "API endpoint",
            "/metrics": "Prometheus metrics",
            "/error": "Simule une erreur"
        }
    })


@app.route('/health')
def health():
    """Health check endpoint."""
    return jsonify({
        "status": "healthy",
        "timestamp": datetime.now().isoformat()
    })


@app.route('/api/data')
def get_data():
    """Endpoint API qui génère des données."""
    global request_count
    request_count += 1
    
    # Simuler parfois une erreur
    if random.random() < error_rate:
        app_errors_total.labels(error_type='api_error').inc()
        logger.error("API error occurred")
        return jsonify({"error": "Internal server error"}), 500
    
    # Simuler un traitement
    time.sleep(random.uniform(0.1, 0.5))
    
    data = {
        "id": request_count,
        "value": random.randint(1, 100),
        "timestamp": datetime.now().isoformat()
    }
    
    logger.info(f"Data generated: {data}")
    return jsonify(data)


@app.route('/metrics')
def metrics():
    """Endpoint pour les métriques Prometheus."""
    return generate_latest(), 200, {'Content-Type': CONTENT_TYPE_LATEST}


@app.route('/error')
def simulate_error():
    """Endpoint pour simuler une erreur."""
    app_errors_total.labels(error_type='simulated_error').inc()
    logger.error("Simulated error triggered")
    return jsonify({"error": "Simulated error"}), 500


@app.route('/slow')
def slow_endpoint():
    """Endpoint qui prend du temps pour tester les métriques de latence."""
    time.sleep(random.uniform(1, 3))
    logger.warning("Slow endpoint accessed")
    return jsonify({"message": "This was a slow request"})


if __name__ == '__main__':
    logger.info("Starting application on port 5000")
    app.run(host='0.0.0.0', port=5000, debug=False)

