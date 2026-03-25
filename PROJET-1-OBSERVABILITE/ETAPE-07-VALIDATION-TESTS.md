# Etape 7 : Validation et Tests

## Objectif

Cette etape valide que l'ensemble de la stack d'observabilite fonctionne correctement. Nous effectuons des **tests de charge**, des **simulations de pannes** et verifions que les **alertes se declenchent** comme prevu.

---

## 1. Tests de Charge

### Pourquoi Tester sous Charge ?

- Des dashboards avec des graphiques plats ne montrent rien d'interessant
- Les alertes ne se declenchent que sous certaines conditions
- Le rapport doit contenir des **captures d'ecran dynamiques**
- Cela demontre que votre stack est **operationnelle**

### Outil : Script Bash avec curl

Le script `scripts/test-load.sh` envoie des requetes en boucle :

```bash
chmod +x scripts/test-load.sh
./scripts/test-load.sh
```

Le script envoie :
- 80% de requetes normales (`/api/data`) → latence variable
- 15% de requetes health (`/health`) → latence faible
- 5% de requetes erreur (`/api/error`) → erreurs 500

### Outil Alternatif : `hey`

[hey](https://github.com/rakyll/hey) est un outil de benchmark HTTP :

```bash
# Installer hey
go install github.com/rakyll/hey@latest

# 1000 requetes, 10 en parallele
hey -n 1000 -c 10 http://localhost:5000/api/data

# Test sur 60 secondes, 20 requetes/seconde
hey -z 60s -q 20 http://localhost:5000/api/data
```

### Outil Alternatif : `wrk`

```bash
# Test sur 30 secondes avec 4 threads et 100 connexions
wrk -t4 -c100 -d30s http://localhost:5000/api/data
```

### Outil Alternatif : `ab` (Apache Bench)

```bash
# 5000 requetes, 50 en parallele
ab -n 5000 -c 50 http://localhost:5000/api/data
```

### Que Surveiller Pendant le Test

Pendant le test de charge, observez dans Grafana :
1. **Taux de requetes** : doit augmenter
2. **Latence** : doit varier (distribution visible dans l'histogramme)
3. **Requetes actives** : doit monter pendant le test
4. **CPU/Memoire** : doit augmenter avec la charge
5. **Logs dans Loki** : flux de logs en temps reel

---

## 2. Simulations de Pannes

### Panne 1 : Service Application Down

```bash
# Arreter l'application
docker compose -f docker/docker-compose.yml stop app

# Attendre 1-2 minutes que l'alerte se declenche
# Verifier dans Prometheus : http://localhost:9090/alerts
# → L'alerte "ServiceDown" doit etre en FIRING

# Redemarrer l'application
docker compose -f docker/docker-compose.yml start app

# Verifier que l'alerte se resout (RESOLVED)
```

**Ce que vous devez capturer :**
- L'alerte `ServiceDown` en etat `FIRING` dans Prometheus
- La notification dans Alertmanager
- Le graphique dans Grafana montrant l'interruption

### Panne 2 : Surcharge CPU

```bash
chmod +x scripts/simulate-failure.sh
./scripts/simulate-failure.sh
```

Ou manuellement :
```bash
# Lancer un conteneur de stress pendant 2 minutes
docker run --rm -d --name stress-test \
  --network docker_observability-net \
  progrium/stress --cpu 4 --timeout 120s
```

**Ce que vous devez capturer :**
- Le pic CPU dans le dashboard infrastructure
- L'alerte `HighCpuUsage` si le seuil est depasse

### Panne 3 : Erreurs en Cascade

```bash
# Envoyer massivement des requetes d'erreur
for i in $(seq 1 500); do
  curl -s http://localhost:5000/api/error > /dev/null &
  if [ $((i % 50)) -eq 0 ]; then
    wait  # Attendre par lots de 50
  fi
done
wait
```

**Ce que vous devez capturer :**
- Le taux d'erreurs qui grimpe dans le dashboard
- L'alerte `HighErrorRate` en FIRING

---

## 3. Verification des Alertes

### Checklist des Alertes

| Alerte | Comment la Declencher | Verification |
|--------|----------------------|--------------|
| `ServiceDown` | `docker compose stop app` | Prometheus Alerts → FIRING |
| `HighErrorRate` | Rafale de requetes sur `/api/error` | Prometheus Alerts → FIRING |
| `HighLatency` | Test de charge intense | Prometheus Alerts → FIRING |
| `HighCpuUsage` | `stress-ng --cpu 4` | Prometheus Alerts → FIRING |
| `HighMemoryUsage` | `stress-ng --vm 2 --vm-bytes 1G` | Prometheus Alerts → FIRING |

### Verification dans Alertmanager

1. Accedez a http://localhost:9093
2. Verifiez que les alertes apparaissent dans l'interface
3. Verifiez le **groupement** : les alertes similaires sont regroupees
4. Testez le **silencing** : creez un silence temporaire pour une alerte

### Verification du Webhook

Si vous utilisez un webhook receiver, vous pouvez lancer un recepteur simple :

```bash
# Recepteur webhook simple (Python)
python3 -c "
from http.server import HTTPServer, BaseHTTPRequestHandler
import json

class Handler(BaseHTTPRequestHandler):
    def do_POST(self):
        content_length = int(self.headers.get('Content-Length', 0))
        body = self.rfile.read(content_length)
        print('=== ALERT RECEIVED ===')
        print(json.dumps(json.loads(body), indent=2))
        self.send_response(200)
        self.end_headers()

HTTPServer(('0.0.0.0', 9095), Handler).serve_forever()
"
```

---

## 4. Verification des Logs dans Loki

### Via Grafana Explore

1. Ouvrez Grafana → **Explore**
2. Selectionnez **Loki** comme datasource
3. Testez ces requetes :

```logql
# Tous les logs
{job="docker"}

# Logs de l'application
{container_name=~".*app.*"}

# Logs d'erreur
{container_name=~".*app.*"} |= "ERROR"

# Volume de logs par minute
sum(rate({job="docker"}[1m])) by (container_name)
```

### Verifier la Completude

- [ ] Les logs de l'application apparaissent
- [ ] Les logs de Prometheus apparaissent
- [ ] Les logs sont au format JSON (parsables)
- [ ] Les labels sont corrects (container_name, etc.)
- [ ] La recherche par mots-cles fonctionne

---

## 5. Evaluation des Performances

### Metriques a Collecter

Pour la section "Analyse" du rapport, collectez ces donnees pendant le test de charge :

| Metrique | Avant Charge | Pendant Charge | Apres Charge |
|----------|-------------|----------------|--------------|
| Requetes/seconde | | | |
| Latence P50 (mediane) | | | |
| Latence P95 | | | |
| Latence P99 | | | |
| Taux d'erreurs | | | |
| CPU (%) | | | |
| Memoire (%) | | | |
| Logs/seconde dans Loki | | | |

### Requetes PromQL pour Collecter les Donnees

```promql
# Requetes par seconde
sum(rate(flask_http_requests_total[5m]))

# Latence P50
histogram_quantile(0.50, sum(rate(flask_http_request_duration_seconds_bucket[5m])) by (le))

# Latence P95
histogram_quantile(0.95, sum(rate(flask_http_request_duration_seconds_bucket[5m])) by (le))

# Latence P99
histogram_quantile(0.99, sum(rate(flask_http_request_duration_seconds_bucket[5m])) by (le))

# Taux d'erreurs (%)
sum(rate(flask_http_requests_total{status=~"5.."}[5m])) / sum(rate(flask_http_requests_total[5m])) * 100

# CPU
100 - (avg(rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)

# Memoire
(1 - (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes)) * 100
```

---

## 6. Documentation des Resultats

### Structure Recommandee pour le Rapport

```
7. Validation et Tests
   7.1 Protocole de test
       - Description de l'environnement
       - Outils utilises
       - Scenarios de test
   7.2 Test de charge
       - Configuration du test
       - Resultats (tableau + graphiques)
       - Analyse
   7.3 Simulation de pannes
       - Scenario 1 : Service down
       - Scenario 2 : Surcharge CPU
       - Scenario 3 : Erreurs en cascade
   7.4 Verification des alertes
       - Liste des alertes testees
       - Temps de detection
       - Captures d'ecran
   7.5 Verification des logs
       - Requetes LogQL testees
       - Completude des logs
```

---

## 7. Points Cles pour le Rapport

- **Documentez le protocole** : quels outils, combien de requetes, quelle duree
- **Incluez des captures d'ecran** avant, pendant et apres les tests
- **Analysez les resultats** : ne vous contentez pas de montrer les graphiques, interpretez-les
- **Mesurez le temps de detection** : combien de temps entre la panne et l'alerte ?
- **Identifiez les limites** : qu'est-ce qui ne fonctionne pas parfaitement ?
- **Proposez des ameliorations** basees sur les observations
