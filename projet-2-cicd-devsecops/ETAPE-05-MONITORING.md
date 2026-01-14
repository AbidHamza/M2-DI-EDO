# Etape 05 : Monitoring et alertes

## Objectif

Mettre en place le monitoring de l'application et configurer des alertes pour etre notifie en cas de probleme. Cette etape couvre le monitoring avec GitLab (integre), ainsi que des solutions de monitoring local.

## Duree estimee

30-45 minutes (avec GitLab)
45 minutes-1h (monitoring local complet)

## Prérequis

- Application deployee (etape 04 validee)
- Compte GitLab avec projet cree (pour la partie GitLab)
- Docker installe (pour la partie locale)
- Compréhension de base du monitoring

## Deux approches possibles

Cette etape propose deux approches :
1. **Avec GitLab Monitoring** : Utilise les fonctionnalites integrees de GitLab
2. **En local** : Utilise des outils de monitoring locaux (Prometheus, Grafana, Uptime Kuma)

Vous pouvez choisir l'approche qui vous convient le mieux.

---

## PARTIE A : Monitoring avec GitLab

### Etape 5.1 : Comprendre le monitoring

**Monitoring** : Surveillance continue de l'application pour detecter les problemes, mesurer les performances, et s'assurer que l'application fonctionne correctement.

**Metriques** : Donnees quantifiables sur l'etat de l'application (temps de reponse, taux d'erreur, utilisation CPU, etc.).

**Alertes** : Notifications automatiques lorsque quelque chose ne va pas (application down, erreurs elevees, etc.).

### Etape 5.2 : Ajouter des metriques au pipeline GitLab CI/CD

Modifiez votre fichier `.gitlab-ci.yml` pour ajouter la collecte de metriques :

```yaml
# ... (gardez les stages precedents)

deploy-railway:
  stage: deploy
  image: node:16
  before_script:
    - npm install -g @railway/cli
  script:
    - echo "Deploiement sur Railway"
    - railway login --token $RAILWAY_TOKEN
    - railway link $RAILWAY_PROJECT_ID
    - railway up --detach
    - echo "Deploiement termine"
  environment:
    name: production
    url: https://$RAILWAY_DOMAIN
    # Ajout du monitoring
    on_stop: stop-production
  only:
    - main
  when: on_success

stop-production:
  stage: deploy
  image: node:16
  script:
    - railway login --token $RAILWAY_TOKEN
    - railway link $RAILWAY_PROJECT_ID
    - railway down
  environment:
    name: production
    action: stop
  when: manual
  only:
    - main
```

**Explication** :
- `environment` : Definit l'environnement de deploiement
- `url` : URL de l'application pour le monitoring
- `on_stop` : Job a executer pour arreter l'environnement
- GitLab surveille automatiquement l'URL definie

### Etape 5.3 : Configurer les alertes dans GitLab

**Action** : Configurer les alertes pour etre notifie en cas de probleme

1. Allez sur votre projet GitLab
2. Cliquez sur "Settings" dans le menu de gauche
3. Allez dans "Monitor" (ou "Operations" → "Alerts")
4. Configurez les alertes selon vos besoins :

**Alertes sur les echecs de pipeline** :
- Activez "Pipeline failure alerts"
- Configurez les destinataires (email, webhook, etc.)

**Alertes sur les vulnerabilites critiques** :
- Activez "Security alerts"
- Configurez le seuil de severite (Critical, High, etc.)

**Alertes sur les deploiements** :
- Activez "Deployment alerts"
- Configurez les notifications

**Alertes sur la disponibilite** :
- Activez "Uptime monitoring"
- GitLab verifie automatiquement que l'URL est accessible

### Etape 5.4 : Ajouter un endpoint de health check

**Action** : Creer un endpoint pour verifier la sante de l'application

Dans votre application Python, ajoutez un endpoint de health check :

```python
# app.py
from flask import Flask, jsonify
import time

app = Flask(__name__)

@app.route('/')
def index():
    return jsonify({"message": "Application DevSecOps", "status": "running"})

@app.route('/health')
def health():
    """
    Endpoint de health check pour le monitoring.
    Retourne l'etat de sante de l'application.
    """
    return jsonify({
        "status": "healthy",
        "timestamp": time.time(),
        "version": "1.0.0"
    }), 200

@app.route('/metrics')
def metrics():
    """
    Endpoint de metriques pour Prometheus (format texte).
    """
    metrics_text = """
# HELP app_requests_total Total number of requests
# TYPE app_requests_total counter
app_requests_total 100

# HELP app_errors_total Total number of errors
# TYPE app_errors_total counter
app_errors_total 2
"""
    return metrics_text, 200, {'Content-Type': 'text/plain'}

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=8000)
```

**Explication** :
- `/health` : Endpoint simple pour verifier que l'application fonctionne
- `/metrics` : Endpoint au format Prometheus pour les metriques detaillees
- Ces endpoints permettent aux outils de monitoring de verifier l'etat de l'application

### Etape 5.5 : Configurer le health check dans Railway

**Action** : Configurer Railway pour utiliser le health check

1. Dans Railway, allez sur votre service
2. Cliquez sur "Settings"
3. Trouvez "Healthcheck Path"
4. Entrez `/health`
5. Railway monitorera automatiquement votre application

---

## PARTIE B : Monitoring local (confidentialite garantie)

Cette partie permet de mettre en place un monitoring complet sur votre ordinateur, sans envoyer de donnees sur Internet.

### Etape 5.6 : Deployer Prometheus et Grafana localement

**Action** : Creer un fichier Docker Compose pour Prometheus et Grafana

Creez un fichier `docker-compose-monitoring.yml` :

```yaml
version: '3.8'

services:
  prometheus:
    image: prom/prometheus:latest
    container_name: prometheus
    ports:
      - "9090:9090"
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
      - prometheus_data:/prometheus
    command:
      - '--config.file=/etc/prometheus/prometheus.yml'
      - '--storage.tsdb.path=/prometheus'
    networks:
      - monitoring

  grafana:
    image: grafana/grafana:latest
    container_name: grafana
    ports:
      - "3000:3000"
    environment:
      - GF_SECURITY_ADMIN_USER=admin
      - GF_SECURITY_ADMIN_PASSWORD=admin
      - GF_USERS_ALLOW_SIGN_UP=false
    volumes:
      - grafana_data:/var/lib/grafana
    depends_on:
      - prometheus
    networks:
      - monitoring

  node-exporter:
    image: prom/node-exporter:latest
    container_name: node-exporter
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
      - monitoring

networks:
  monitoring:
    driver: bridge

volumes:
  prometheus_data:
  grafana_data:
```

**Explication** :
- **Prometheus** : Systeme de collecte et stockage de metriques
- **Grafana** : Interface de visualisation des metriques
- **node-exporter** : Collecte les metriques systeme (CPU, memoire, disque)

### Etape 5.7 : Configurer Prometheus

**Action** : Creer le fichier de configuration Prometheus

Creez un fichier `prometheus.yml` :

```yaml
global:
  scrape_interval: 15s
  evaluation_interval: 15s

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']

  - job_name: 'node-exporter'
    static_configs:
      - targets: ['node-exporter:9100']

  - job_name: 'mon-app'
    static_configs:
      - targets: ['host.docker.internal:8000']
    metrics_path: '/metrics'
    scrape_interval: 10s
```

**Explication** :
- `scrape_interval` : Frequence de collecte des metriques
- `scrape_configs` : Liste des cibles a monitorer
- `mon-app` : Configuration pour monitorer votre application

### Etape 5.8 : Demarrer le monitoring local

**Action** : Lancer Prometheus et Grafana

```bash
docker-compose -f docker-compose-monitoring.yml up -d
```

**Verification** :
```bash
docker ps | grep -E "prometheus|grafana|node-exporter"
```

**Resultat attendu** :
```
CONTAINER ID   IMAGE                        STATUS         PORTS                    NAMES
abc123def456   prom/prometheus:latest       Up 2 minutes   0.0.0.0:9090->9090/tcp  prometheus
def456abc123   grafana/grafana:latest        Up 2 minutes   0.0.0.0:3000->3000/tcp   grafana
ghi789def456   prom/node-exporter:latest    Up 2 minutes   0.0.0.0:9100->9100/tcp  node-exporter
```

### Etape 5.9 : Acceder a Prometheus

**Action** : Ouvrir l'interface Prometheus

1. Ouvrez votre navigateur
2. Allez sur http://localhost:9090
3. Vous verrez l'interface Prometheus

**Tester une requete** :
1. Cliquez sur "Graph" dans le menu
2. Dans la barre de recherche, tapez : `up`
3. Cliquez sur "Execute"
4. Vous devriez voir les metriques collectees

### Etape 5.10 : Configurer Grafana

**Action** : Configurer Grafana pour visualiser les metriques

1. Ouvrez votre navigateur
2. Allez sur http://localhost:3000
3. Connectez-vous avec :
   - Username : admin
   - Password : admin
4. Changez le mot de passe a la premiere connexion

**Ajouter Prometheus comme source de donnees** :
1. Cliquez sur "Configuration" (icone d'engrenage) → "Data Sources"
2. Cliquez sur "Add data source"
3. Selectionnez "Prometheus"
4. Dans "URL", entrez : `http://prometheus:9090`
5. Cliquez sur "Save & Test"
6. Vous devriez voir "Data source is working"

### Etape 5.11 : Creer un dashboard dans Grafana

**Action** : Creer un dashboard pour visualiser les metriques

1. Dans Grafana, cliquez sur "+" → "Create" → "Dashboard"
2. Cliquez sur "Add visualization"
3. Selectionnez "Prometheus" comme source de donnees
4. Dans "Metrics", tapez : `up`
5. Cliquez sur "Run query"
6. Vous devriez voir un graphique
7. Cliquez sur "Apply" pour sauvegarder

**Ajouter d'autres metriques** :
- CPU usage : `100 - (avg(irate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)`
- Memory usage : `node_memory_MemTotal_bytes - node_memory_MemAvailable_bytes`
- Application requests : `app_requests_total`

### Etape 5.12 : Deployer Uptime Kuma pour le monitoring de disponibilite

**Action** : Ajouter Uptime Kuma pour monitorer la disponibilite

Modifiez `docker-compose-monitoring.yml` pour ajouter Uptime Kuma :

```yaml
  uptime-kuma:
    image: louislam/uptime-kuma:latest
    container_name: uptime-kuma
    ports:
      - "3001:3001"
    volumes:
      - uptime_kuma_data:/app/data
    networks:
      - monitoring
    restart: unless-stopped

volumes:
  prometheus_data:
  grafana_data:
  uptime_kuma_data:
```

**Redemarrer** :
```bash
docker-compose -f docker-compose-monitoring.yml up -d
```

### Etape 5.13 : Configurer Uptime Kuma

**Action** : Configurer Uptime Kuma pour monitorer l'application

1. Ouvrez votre navigateur
2. Allez sur http://localhost:3001
3. Creez un compte administrateur
4. Cliquez sur "+ Add New Monitor"
5. Configurez le monitor :
   - **Monitor Type** : HTTP(s)
   - **Friendly Name** : Mon Application DevSecOps
   - **URL** : http://localhost:8000/health
   - **Heartbeat Interval** : 60 seconds
   - **Retries** : 2
6. Cliquez sur "Save"
7. Uptime Kuma commencera a monitorer votre application

### Etape 5.14 : Configurer les alertes dans Uptime Kuma

**Action** : Configurer des alertes pour etre notifie en cas de probleme

1. Dans Uptime Kuma, allez dans "Settings" → "Notifications"
2. Cliquez sur "Setup Notification"
3. Choisissez un type de notification :
   - **Email** : Pour recevoir des emails
   - **Telegram** : Pour recevoir des messages Telegram
   - **Webhook** : Pour envoyer des notifications vers un webhook
4. Configurez la notification selon le type choisi
5. Retournez sur votre monitor
6. Cliquez sur "Edit"
7. Dans "Notification List", selectionnez votre notification
8. Cliquez sur "Save"

### Etape 5.15 : Creer un script de monitoring local complet

**Action** : Creer un script qui demarre tout le monitoring

Creez un fichier `start-monitoring.sh` (Linux/Mac) ou `start-monitoring.bat` (Windows) :

**Pour Linux/Mac (start-monitoring.sh)** :
```bash
#!/bin/bash
# Script pour demarrer le monitoring local

echo "============================================================"
echo "DEMARRAGE DU MONITORING LOCAL"
echo "============================================================"

# Verifier que Docker fonctionne
if ! command -v docker &> /dev/null; then
    echo "ERREUR : Docker n'est pas installe"
    exit 1
fi

# Demarrer Prometheus et Grafana
echo "Demarrage de Prometheus et Grafana..."
docker-compose -f docker-compose-monitoring.yml up -d

# Attendre que les services demarrent
echo "Attente du demarrage des services..."
sleep 10

# Verifier que les services sont demarres
if docker ps | grep -q prometheus && docker ps | grep -q grafana; then
    echo ""
    echo "============================================================"
    echo "MONITORING DEMARRE AVEC SUCCES"
    echo "============================================================"
    echo "Prometheus : http://localhost:9090"
    echo "Grafana : http://localhost:3000 (admin/admin)"
    echo "Uptime Kuma : http://localhost:3001"
    echo ""
    echo "Pour arreter : docker-compose -f docker-compose-monitoring.yml down"
else
    echo "ERREUR : Les services ne sont pas demarres correctement"
    echo "Consultez les logs : docker-compose -f docker-compose-monitoring.yml logs"
fi
```

**Pour Windows (start-monitoring.bat)** :
```batch
@echo off
echo ============================================================
echo DEMARRAGE DU MONITORING LOCAL
echo ============================================================

REM Verifier que Docker fonctionne
docker --version >nul 2>&1
if errorlevel 1 (
    echo ERREUR : Docker n'est pas installe
    exit /b 1
)

REM Demarrer Prometheus et Grafana
echo Demarrage de Prometheus et Grafana...
docker-compose -f docker-compose-monitoring.yml up -d

REM Attendre que les services demarrent
echo Attente du demarrage des services...
timeout /t 10 /nobreak >nul

REM Verifier que les services sont demarres
docker ps | findstr prometheus >nul
if errorlevel 1 (
    echo ERREUR : Les services ne sont pas demarres correctement
    echo Consultez les logs : docker-compose -f docker-compose-monitoring.yml logs
    exit /b 1
)

echo.
echo ============================================================
echo MONITORING DEMARRE AVEC SUCCES
echo ============================================================
echo Prometheus : http://localhost:9090
echo Grafana : http://localhost:3000 (admin/admin)
echo Uptime Kuma : http://localhost:3001
echo.
echo Pour arreter : docker-compose -f docker-compose-monitoring.yml down
```

**Rendre executable (Linux/Mac)** :
```bash
chmod +x start-monitoring.sh
```

---

## Verification

Avant de considerer le projet termine, verifiez que :

**Avec GitLab** :
- [ ] Le monitoring est configure dans GitLab
- [ ] Les alertes sont configurees
- [ ] L'endpoint de health check fonctionne (/health)
- [ ] Les metriques sont visibles dans GitLab
- [ ] Les alertes fonctionnent (testez en simulant un probleme)

**En local** :
- [ ] Prometheus est demarre et accessible sur http://localhost:9090
- [ ] Grafana est demarre et accessible sur http://localhost:3000
- [ ] Uptime Kuma est demarre et accessible sur http://localhost:3001
- [ ] L'application est configuree dans Uptime Kuma
- [ ] Les metriques sont collectees dans Prometheus
- [ ] Un dashboard est cree dans Grafana
- [ ] Les alertes sont configurees dans Uptime Kuma

## Problemes courants

### Les metriques ne s'affichent pas dans GitLab

**Solution** :
- Verifiez que l'URL de l'environnement est bien configuree dans GitLab
- Verifiez que l'endpoint /health fonctionne
- Attendez quelques minutes pour que GitLab collecte les metriques

### Prometheus ne collecte pas les metriques

**Solution** :
- Verifiez que Prometheus peut acceder a l'application
- Verifiez la configuration dans prometheus.yml
- Consultez les logs : `docker-compose -f docker-compose-monitoring.yml logs prometheus`
- Verifiez que l'application expose bien l'endpoint /metrics

### Grafana ne peut pas se connecter a Prometheus

**Solution** :
- Verifiez que Prometheus est demarre
- Verifiez l'URL dans Grafana : doit etre `http://prometheus:9090` (nom du service Docker)
- Verifiez que les deux services sont sur le meme reseau Docker

### Uptime Kuma ne detecte pas l'application

**Solution** :
- Verifiez que l'application est demarree et accessible
- Verifiez l'URL dans Uptime Kuma : doit etre accessible depuis le conteneur
- Utilisez `host.docker.internal:8000` si l'application tourne sur l'hote
- Consultez les logs : `docker-compose -f docker-compose-monitoring.yml logs uptime-kuma`

### Les alertes ne fonctionnent pas

**Solution** :
- Verifiez la configuration des notifications dans Uptime Kuma
- Testez la notification manuellement
- Verifiez que les parametres de notification sont corrects (email, webhook, etc.)

## Commandes utiles

**Voir les logs de Prometheus** :
```bash
docker-compose -f docker-compose-monitoring.yml logs prometheus
```

**Voir les logs de Grafana** :
```bash
docker-compose -f docker-compose-monitoring.yml logs grafana
```

**Arreter le monitoring** :
```bash
docker-compose -f docker-compose-monitoring.yml down
```

**Redemarrer le monitoring** :
```bash
docker-compose -f docker-compose-monitoring.yml restart
```

**Voir toutes les metriques dans Prometheus** :
- Allez sur http://localhost:9090
- Cliquez sur "Status" → "Targets"
- Vous verrez toutes les cibles configurees

**Exporter les metriques de l'application** :
- Assurez-vous que l'endpoint /metrics retourne des donnees au format Prometheus
- Testez avec : `curl http://localhost:8000/metrics`

## Notes importantes

- Le monitoring permet de detecter les problemes rapidement
- Les alertes permettent d'etre notifie immediatement en cas de probleme
- Le monitoring local garantit la confidentialite totale
- Prometheus et Grafana sont des outils puissants et gratuits
- Uptime Kuma est excellent pour le monitoring de disponibilite simple
- Vous pouvez combiner plusieurs outils selon vos besoins

## Felicitations !

Vous avez termine le Projet 2 ! Vous avez maintenant :
- Un pipeline CI/CD complet et securise
- Des scans de securite automatiques (Bandit, Trivy, SonarQube)
- Un Container Registry pour gerer vos images Docker
- Un deploiement automatique fonctionnel
- Un monitoring en place avec alertes

Vous maitrisez maintenant les concepts de CI/CD et DevSecOps !

## Prochaines etapes

- Experimentez avec d'autres outils de securite
- Ajoutez plus de tests a votre application
- Configurez des alertes plus sophistiquees
- Explorez d'autres plateformes de deploiement
- Approfondissez vos connaissances en monitoring

Bon apprentissage !
