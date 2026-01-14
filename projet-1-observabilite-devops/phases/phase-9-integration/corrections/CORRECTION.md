# Correction Phase 9 : Intégration complète

## Docker Compose complet

```yaml
version: '3.8'

services:
  app:
    build: ./application-example
    ports:
      - "5000:5000"
    networks:
      - observability

  prometheus:
    image: prom/prometheus:latest
    ports:
      - "9090:9090"
    volumes:
      - ./prometheus/prometheus.yml:/etc/prometheus/prometheus.yml
      - prometheus-data:/prometheus
    command:
      - '--config.file=/etc/prometheus/prometheus.yml'

  alertmanager:
    image: prom/alertmanager:latest
    ports:
      - "9093:9093"
    volumes:
      - ./alertmanager/alertmanager.yml:/etc/alertmanager/alertmanager.yml

  loki:
    image: grafana/loki:latest
    ports:
      - "3100:3100"
    volumes:
      - ./loki/loki-config.yml:/etc/loki/local-config.yaml

  promtail:
    image: grafana/promtail:latest
    volumes:
      - ./promtail/promtail-config.yml:/etc/promtail/config.yml
      - /var/run/docker.sock:/var/run/docker.sock

  grafana:
    image: grafana/grafana:latest
    ports:
      - "3000:3000"
    environment:
      - GF_SECURITY_ADMIN_PASSWORD=admin
    volumes:
      - grafana-data:/var/lib/grafana

volumes:
  prometheus-data:
  grafana-data:

networks:
  observability:
    driver: bridge
```

### Tests de validation

```bash
# Vérifier tous les services
docker-compose ps

# Vérifier Prometheus
curl http://localhost:9090/api/v1/targets

# Vérifier Loki
curl http://localhost:3100/ready

# Vérifier Grafana
curl http://localhost:3000/api/health
```

### Checklist

- [ ] Tous les conteneurs sont UP
- [ ] Prometheus collecte les métriques
- [ ] Loki ingère les logs
- [ ] Grafana affiche les dashboards
- [ ] Alertmanager reçoit les alertes

