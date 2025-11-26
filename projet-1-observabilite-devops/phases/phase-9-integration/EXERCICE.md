# Exercice Phase 9 : Intégration complète et tests

## Exercice à réaliser

Intégrez tous les composants et testez le fonctionnement complet de la solution.

## Correction complète - Docker Compose complet

```yaml
# docker-compose.yml - Solution complète
version: '3.8'

services:
  # Application exemple
  app:
    build: ./application-example
    ports:
      - "5000:5000"
    networks:
      - observability
    labels:
      - "prometheus.scrape=true"
      - "prometheus.port=5000"
      - "prometheus.path=/metrics"

  # Prometheus
  prometheus:
    image: prom/prometheus:latest
    ports:
      - "9090:9090"
    volumes:
      - ./prometheus/prometheus.yml:/etc/prometheus/prometheus.yml
      - ./prometheus/alerts.yml:/etc/prometheus/alerts.yml
      - prometheus-data:/prometheus
    command:
      - '--config.file=/etc/prometheus/prometheus.yml'
      - '--storage.tsdb.path=/prometheus'
      - '--web.console.libraries=/usr/share/prometheus/console_libraries'
      - '--web.console.templates=/usr/share/prometheus/consoles'
    networks:
      - observability
    depends_on:
      - app

  # Alertmanager
  alertmanager:
    image: prom/alertmanager:latest
    ports:
      - "9093:9093"
    volumes:
      - ./alertmanager/alertmanager.yml:/etc/alertmanager/alertmanager.yml
      - alertmanager-data:/alertmanager
    command:
      - '--config.file=/etc/alertmanager/alertmanager.yml'
      - '--storage.path=/alertmanager'
    networks:
      - observability

  # Loki
  loki:
    image: grafana/loki:latest
    ports:
      - "3100:3100"
    volumes:
      - ./loki/loki-config.yml:/etc/loki/local-config.yaml
      - loki-data:/loki
    command: -config.file=/etc/loki/local-config.yaml
    networks:
      - observability

  # Promtail
  promtail:
    image: grafana/promtail:latest
    volumes:
      - ./promtail/promtail-config.yml:/etc/promtail/config.yml
      - /var/run/docker.sock:/var/run/docker.sock
      - /var/lib/docker/containers:/var/lib/docker/containers:ro
    command: -config.file=/etc/promtail/config.yml
    networks:
      - observability
    depends_on:
      - loki

  # Grafana
  grafana:
    image: grafana/grafana:latest
    ports:
      - "3000:3000"
    environment:
      - GF_SECURITY_ADMIN_PASSWORD=admin
      - GF_USERS_ALLOW_SIGN_UP=false
    volumes:
      - grafana-data:/var/lib/grafana
      - ./grafana/provisioning:/etc/grafana/provisioning
    networks:
      - observability
    depends_on:
      - prometheus
      - loki

  # Node Exporter (métriques système)
  node-exporter:
    image: prom/node-exporter:latest
    ports:
      - "9100:9100"
    command:
      - '--path.procfs=/host/proc'
      - '--path.sysfs=/host/sys'
      - '--collector.filesystem.mount-points-exclude=^/(sys|proc|dev|host|etc)($$|/)'
    volumes:
      - /proc:/host/proc:ro
      - /sys:/host/sys:ro
      - /:/rootfs:ro
    networks:
      - observability

volumes:
  prometheus-data:
  loki-data:
  alertmanager-data:
  grafana-data:

networks:
  observability:
    driver: bridge
```

## Tests de validation

### Test 1 : Vérifier la collecte de métriques

```bash
# Vérifier que Prometheus scrape l'application
curl http://localhost:9090/api/v1/targets

# Vérifier les métriques collectées
curl http://localhost:9090/api/v1/query?query=up
```

### Test 2 : Vérifier l'ingestion de logs

```bash
# Générer des logs
curl http://localhost:5000/api/data
curl http://localhost:5000/error

# Vérifier dans Loki (via Grafana ou API)
curl -G -s "http://localhost:3100/loki/api/v1/query_range" \
  --data-urlencode 'query={service="example-app"}' \
  --data-urlencode 'limit=10'
```

### Test 3 : Vérifier les dashboards Grafana

1. Connectez-vous à Grafana (http://localhost:3000)
2. Vérifiez les datasources (Prometheus et Loki)
3. Vérifiez que les dashboards affichent des données
4. Testez les requêtes dans Explore

### Test 4 : Vérifier les alertes

```bash
# Simuler une condition d'alerte
# Augmenter le taux d'erreur de l'application
# Ou utiliser un script de test de charge

# Vérifier les alertes dans Prometheus
curl http://localhost:9090/api/v1/alerts

# Vérifier qu'Alertmanager a reçu l'alerte
curl http://localhost:9093/api/v1/alerts
```

## Script de test de charge

```python
# test_load.py
import requests
import time
import random
from concurrent.futures import ThreadPoolExecutor

def make_request():
    """Fait une requête à l'application."""
    try:
        if random.random() < 0.1:  # 10% d'erreur
            response = requests.get("http://localhost:5000/error", timeout=5)
        else:
            response = requests.get("http://localhost:5000/api/data", timeout=5)
        return response.status_code
    except Exception as e:
        return None

def load_test(duration=60, concurrent=10):
    """Test de charge pendant duration secondes avec concurrent requêtes."""
    print(f"Starting load test: {concurrent} concurrent requests for {duration}s")
    
    start_time = time.time()
    request_count = 0
    
    with ThreadPoolExecutor(max_workers=concurrent) as executor:
        while time.time() - start_time < duration:
            futures = [executor.submit(make_request) for _ in range(concurrent)]
            for future in futures:
                future.result()
                request_count += 1
            time.sleep(0.1)
    
    print(f"Completed {request_count} requests in {duration}s")
    print(f"Rate: {request_count/duration:.2f} req/s")

if __name__ == "__main__":
    load_test(duration=60, concurrent=10)
```

## Scénarios de test

### Scénario 1 : Surcharge CPU

```bash
# Sur le serveur, générer une charge CPU
stress --cpu 4 --timeout 60s

# Observer dans Grafana :
# - CPU usage augmente
# - Alertes déclenchées si configurées
```

### Scénario 2 : Augmentation du taux d'erreur

```python
# Modifier temporairement l'application pour augmenter error_rate
# error_rate = 0.5  # 50% d'erreur

# Observer :
# - Métriques d'erreur dans Prometheus
# - Alertes déclenchées
# - Logs d'erreur dans Loki
```

### Scénario 3 : Service down

```bash
# Arrêter l'application
docker-compose stop app

# Observer :
# - Target DOWN dans Prometheus
# - Alerte "ServiceDown" déclenchée
# - Notification envoyée
```

## Checklist de validation

- [ ] Prometheus collecte les métriques de l'application
- [ ] Prometheus collecte les métriques système (Node Exporter)
- [ ] Loki ingère les logs de l'application
- [ ] Grafana se connecte à Prometheus et Loki
- [ ] Les dashboards affichent des données à jour
- [ ] Les règles d'alerte sont actives
- [ ] Alertmanager reçoit les alertes
- [ ] Les notifications sont envoyées (email/webhook)
- [ ] Les tests de charge fonctionnent
- [ ] Les alertes se déclenchent correctement

## Captures à faire

1. **Prometheus Targets** : Tous les targets UP
2. **Grafana Dashboards** : Dashboards avec données
3. **Loki Logs** : Logs visibles dans Grafana
4. **Alertes** : Alertes actives dans Prometheus
5. **Notifications** : Email/webhook reçu

## Problèmes courants

- **Targets DOWN** : Vérifiez la connectivité réseau
- **Pas de logs** : Vérifiez Promtail et la configuration
- **Alertes non déclenchées** : Vérifiez les règles et PromQL
- **Dashboards vides** : Vérifiez les datasources et queries

## Prochaine phase

Passez à la **Phase 10 : Tests, analyse et amélioration**.

