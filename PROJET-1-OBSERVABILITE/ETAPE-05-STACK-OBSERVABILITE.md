# Etape 5 : Stack d'Observabilite Complete

## Objectif

Dans cette etape, nous assemblons et deploiement la **stack d'observabilite complete** avec Docker Compose. C'est le coeur du projet : tous les services sont interconnectes et fonctionnent ensemble.

---

## Architecture de la Stack

```
                    docker-compose.yml
                           |
    +------+-------+-------+-------+-------+-------+
    |      |       |       |       |       |       |
   app  prometheus grafana  loki  promtail alert   node
  :5000   :9090   :3000   :3100           manager  exporter
                                          :9093    :9100
```

**7 services** communiquent via un reseau Docker interne (`observability-net`) :

| Service | Image | Port | Role |
|---------|-------|------|------|
| `app` | Build local | 5000 | Application Flask instrumentee |
| `prometheus` | prom/prometheus | 9090 | Collecte des metriques |
| `grafana` | grafana/grafana | 3000 | Visualisation |
| `loki` | grafana/loki | 3100 | Stockage des logs |
| `promtail` | grafana/promtail | - | Collecte des logs → Loki |
| `alertmanager` | prom/alertmanager | 9093 | Gestion des alertes |
| `node-exporter` | prom/node-exporter | 9100 | Metriques systeme |

---

## 1. Docker Compose (docker/docker-compose.yml)

### Service par Service

#### Application Flask (`app`)

```yaml
app:
  build:
    context: ../app
    dockerfile: Dockerfile
  ports:
    - "5000:5000"
```

- **Build local** : construit l'image depuis le Dockerfile
- **Port 5000** : expose l'API et le endpoint `/metrics`
- **Logs JSON** : sortie standard capturee par Promtail

#### Prometheus

```yaml
prometheus:
  image: prom/prometheus:v2.51.0
  ports:
    - "9090:9090"
  volumes:
    - ../prometheus/prometheus.yml:/etc/prometheus/prometheus.yml
    - ../prometheus/alert-rules.yml:/etc/prometheus/alert-rules.yml
    - prometheus_data:/prometheus
```

- **Volumes** : monte les fichiers de configuration et persiste les donnees
- **Dependance** : doit pouvoir atteindre l'app, node-exporter et alertmanager

#### Grafana

```yaml
grafana:
  image: grafana/grafana:10.4.0
  ports:
    - "3000:3000"
  environment:
    - GF_SECURITY_ADMIN_PASSWORD=admin
  volumes:
    - ../grafana/provisioning:/etc/grafana/provisioning
    - ../grafana/dashboards:/var/lib/grafana/dashboards
```

- **Auto-provisioning** : les datasources et dashboards sont charges au demarrage
- **Login** : admin/admin (configurable via variable d'environnement)

#### Loki

```yaml
loki:
  image: grafana/loki:2.9.4
  ports:
    - "3100:3100"
  volumes:
    - ../loki/loki-config.yml:/etc/loki/local-config.yaml
```

- **Configuration locale** : stockage sur le filesystem du conteneur
- **Retention 7 jours** : les logs plus anciens sont supprimes automatiquement

#### Promtail

```yaml
promtail:
  image: grafana/promtail:2.9.4
  volumes:
    - ./promtail-config.yml:/etc/promtail/config.yml
    - /var/log:/var/log
    - /var/run/docker.sock:/var/run/docker.sock
```

- **Socket Docker** : permet a Promtail de decouvrir et lire les logs des conteneurs
- **Pas de port expose** : Promtail pousse les logs vers Loki (modele push)

> **Note Windows/macOS** : le montage du socket Docker (`/var/run/docker.sock`) fonctionne nativement sur Linux. Sur Docker Desktop (Windows/macOS), Docker fournit un socket compatible.

#### Alertmanager

```yaml
alertmanager:
  image: prom/alertmanager:v0.27.0
  ports:
    - "9093:9093"
  volumes:
    - ../alertmanager/alertmanager.yml:/etc/alertmanager/alertmanager.yml
```

- **Recoit les alertes** de Prometheus
- **Route les notifications** vers webhook, email, Slack, etc.

#### Node Exporter

```yaml
node-exporter:
  image: prom/node-exporter:v1.7.0
  ports:
    - "9100:9100"
```

- **Expose les metriques systeme** : CPU, memoire, disque, reseau
- **Scrape par Prometheus** : endpoint `/metrics` sur le port 9100

---

## 2. Configuration Prometheus (prometheus/prometheus.yml)

Le fichier `prometheus.yml` definit :
- Les **cibles a scraper** (quelles applications surveiller)
- Les **fichiers de regles d'alerte** a charger
- La connexion a **Alertmanager**

### Scrape Configs

```yaml
scrape_configs:
  # L'application Flask
  - job_name: 'flask-app'
    scrape_interval: 15s
    static_configs:
      - targets: ['app:5000']

  # Node Exporter (metriques systeme)
  - job_name: 'node-exporter'
    scrape_interval: 15s
    static_configs:
      - targets: ['node-exporter:9100']

  # Prometheus lui-meme
  - job_name: 'prometheus'
    scrape_interval: 15s
    static_configs:
      - targets: ['localhost:9090']
```

**Pourquoi `scrape_interval: 15s` ?**
- C'est la valeur par defaut recommandee par Prometheus
- Trop frequent (1s) = surcharge ; trop rare (60s) = perte de precision
- 15s est un bon compromis entre granularite et performance

---

## 3. Configuration Loki (loki/loki-config.yml)

La configuration Loki definit le stockage, l'indexation et la retention des logs.

**Points importants :**
- **Stockage local** (`filesystem`) : suffisant pour un environnement de dev/test
- **Retention 168h** (7 jours) : les logs anciens sont supprimes
- **Pas de clustering** : Loki tourne en mode "single binary" (monolithique)

En production, Loki utiliserait un stockage objet (S3, GCS) et un deploiement distribue.

---

## 4. Configuration Promtail (docker/promtail-config.yml)

Promtail collecte les logs des conteneurs Docker et les envoie a Loki.

**Fonctionnement :**
1. Promtail se connecte au **socket Docker** pour decouvrir les conteneurs
2. Il lit les **logs de chaque conteneur** (stdout/stderr)
3. Il ajoute des **labels** (nom du conteneur, image, compose_service)
4. Il **envoie les logs** a Loki via HTTP POST

**Labels automatiques :**
- `container_name` : nom du conteneur Docker
- `compose_service` : nom du service dans docker-compose
- Ces labels permettent de filtrer dans Grafana : `{container_name="app"}`

---

## 5. Configuration Alertmanager (alertmanager/alertmanager.yml)

Alertmanager recoit les alertes de Prometheus et les route vers les bons destinataires.

```yaml
route:
  group_by: ['alertname']    # Regrouper les alertes par nom
  group_wait: 10s            # Attendre 10s avant d'envoyer (pour regrouper)
  group_interval: 10s        # Interval entre les groupes
  repeat_interval: 1h        # Re-notifier toutes les heures
  receiver: 'webhook'        # Destinataire par defaut
```

**Explication du routage :**
- `group_by` : les alertes avec le meme `alertname` sont regroupees
- `group_wait` : on attend 10s pour collecter les alertes similaires
- `repeat_interval` : on ne spamme pas, on re-notifie apres 1h

---

## 6. Regles d'Alerte (prometheus/alert-rules.yml)

Les regles d'alerte definissent **quand** declencher une alerte :

| Alerte | Condition | Severite |
|--------|-----------|----------|
| HighErrorRate | >5% d'erreurs sur 5 min | critical |
| HighLatency | P95 > 1s sur 5 min | warning |
| ServiceDown | Cible indisponible > 1 min | critical |
| HighCpuUsage | CPU > 80% sur 5 min | warning |
| HighMemoryUsage | Memoire > 85% sur 5 min | warning |

---

## 7. Provisioning Grafana

### Datasources Automatiques

```yaml
# grafana/provisioning/datasources/datasources.yml
datasources:
  - name: Prometheus
    type: prometheus
    url: http://prometheus:9090
  - name: Loki
    type: loki
    url: http://loki:3100
```

Grafana charge automatiquement ces datasources au demarrage. Pas besoin de configuration manuelle via l'interface.

### Dashboards Automatiques

Les dashboards JSON sont places dans `grafana/dashboards/` et references par le fichier de provisioning.

---

## 8. Demarrage de la Stack

### Lancer la Stack

```bash
cd docker/
docker compose up -d --build
```

### Verifier les Services

```bash
# Etat des conteneurs
docker compose ps

# Logs d'un service
docker compose logs prometheus

# Tester l'application
curl http://localhost:5000/health

# Tester Prometheus
curl http://localhost:9090/-/healthy

# Tester Grafana
curl http://localhost:3000/api/health

# Tester Loki
curl http://localhost:3100/ready
```

### Verifier dans Prometheus

1. Accedez a http://localhost:9090
2. Allez dans **Status → Targets**
3. Verifiez que tous les targets sont `UP` :
   - `flask-app` (app:5000)
   - `node-exporter` (node-exporter:9100)
   - `prometheus` (localhost:9090)

### Arreter la Stack

```bash
docker compose down          # Arrete les conteneurs
docker compose down -v       # Arrete ET supprime les volumes (donnees)
```

---

## 9. Troubleshooting

| Probleme | Cause Probable | Solution |
|----------|---------------|----------|
| Target `DOWN` dans Prometheus | Service pas demarre ou erreur de nom | `docker compose logs <service>` |
| Grafana affiche "No data" | Datasource mal configuree | Verifier l'URL dans datasources.yml |
| Promtail ne collecte pas les logs | Socket Docker non monte | Verifier le volume `/var/run/docker.sock` |
| Alertmanager ne recoit pas d'alertes | Mauvaise URL dans prometheus.yml | Verifier `alerting.alertmanagers` |
| Port deja utilise | Conflit avec un autre service | Changer le port dans docker-compose.yml |

---

## 10. Points Cles pour le Rapport

- Presentez l'**architecture complete** avec un schema detaille
- Expliquez le **role de chaque service** et comment ils communiquent
- Montrez les **captures d'ecran** de Prometheus (Targets UP)
- Detaillez les **fichiers de configuration** avec des commentaires
- Expliquez les **choix techniques** (pourquoi ces versions, ces ports, ces volumes)
- Discutez des **reseaux Docker** et de l'isolation
