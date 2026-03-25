# Etape 6 : Dashboards Grafana et Alertes

## Objectif

Dans cette etape, nous creons les **dashboards Grafana** et configurons les **alertes**. Le sujet exige au minimum **2 dashboards** et des alertes fonctionnelles via Alertmanager.

---

## 1. Acces a Grafana

1. Ouvrez http://localhost:3000 dans votre navigateur
2. Connectez-vous avec **admin / admin**
3. Grafana vous propose de changer le mot de passe (vous pouvez skipper pour le dev)

### Verifier les Datasources

Allez dans **Connections → Data sources**. Vous devriez voir :
- **Prometheus** (http://prometheus:9090) — status: `Working`
- **Loki** (http://loki:3100) — status: `Working`

> Si les datasources ne sont pas presentes, verifiez le fichier `grafana/provisioning/datasources/datasources.yml`.

---

## 2. Dashboard 1 : Metriques Applicatives

Ce dashboard presente les metriques de notre application Flask. Il suit la methode **RED** (Rate, Errors, Duration).

### Panneaux du Dashboard

#### Panel 1 : Taux de Requetes (Rate)

**PromQL :**
```promql
sum(rate(flask_http_requests_total[5m])) by (endpoint)
```

**Explication :**
- `rate()` calcule le taux par seconde sur 5 minutes
- `sum() by (endpoint)` regroupe par endpoint
- Resultat : nombre de requetes/seconde par endpoint

**Type de visualisation :** Time Series (graphique temporel)

#### Panel 2 : Taux d'Erreurs (Errors)

**PromQL :**
```promql
sum(rate(flask_http_requests_total{status=~"5.."}[5m]))
/
sum(rate(flask_http_requests_total[5m]))
* 100
```

**Explication :**
- Numerateur : taux de requetes avec status 5xx
- Denominateur : taux total de requetes
- Resultat : pourcentage d'erreurs

**Type de visualisation :** Stat (valeur unique avec seuils de couleur)
- Vert : < 1%
- Orange : 1-5%
- Rouge : > 5%

#### Panel 3 : Latence P95 (Duration)

**PromQL :**
```promql
histogram_quantile(0.95,
  sum(rate(flask_http_request_duration_seconds_bucket[5m])) by (le, endpoint)
)
```

**Explication :**
- `histogram_quantile(0.95, ...)` calcule le 95e percentile
- 95% des requetes sont plus rapides que cette valeur
- C'est plus representatif que la moyenne (qui masque les outliers)

**Type de visualisation :** Time Series avec seuils
- Vert : < 0.5s
- Orange : 0.5-1s
- Rouge : > 1s

#### Panel 4 : Requetes Actives

**PromQL :**
```promql
flask_active_requests
```

**Type de visualisation :** Gauge (jauge)

#### Panel 5 : Distribution des Latences

**PromQL :**
```promql
sum(rate(flask_http_request_duration_seconds_bucket[5m])) by (le)
```

**Type de visualisation :** Heatmap

#### Panel 6 : Requetes par Status Code

**PromQL :**
```promql
sum(increase(flask_http_requests_total[1h])) by (status)
```

**Type de visualisation :** Pie Chart ou Bar Chart

---

## 3. Dashboard 2 : Metriques Infrastructure

Ce dashboard utilise les metriques de **Node Exporter** pour surveiller les ressources systeme.

### Panneaux du Dashboard

#### Panel 1 : Utilisation CPU

**PromQL :**
```promql
100 - (avg(rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)
```

**Explication :**
- On prend le temps CPU en mode "idle" (inactif)
- On soustrait de 100 pour obtenir l'utilisation
- `avg()` fait la moyenne de tous les coeurs

**Type :** Gauge avec seuils (vert < 60%, orange < 80%, rouge > 80%)

#### Panel 2 : Memoire Utilisee

**PromQL :**
```promql
(1 - (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes)) * 100
```

**Type :** Gauge avec seuils

#### Panel 3 : Espace Disque

**PromQL :**
```promql
(1 - (node_filesystem_avail_bytes{mountpoint="/"} / node_filesystem_size_bytes{mountpoint="/"})) * 100
```

**Type :** Gauge

#### Panel 4 : Trafic Reseau (Entrant/Sortant)

**PromQL :**
```promql
# Entrant
rate(node_network_receive_bytes_total{device!="lo"}[5m]) * 8

# Sortant
rate(node_network_transmit_bytes_total{device!="lo"}[5m]) * 8
```

**Type :** Time Series (deux courbes)

#### Panel 5 : Uptime

**PromQL :**
```promql
node_time_seconds - node_boot_time_seconds
```

**Type :** Stat (format: duree)

#### Panel 6 : Load Average

**PromQL :**
```promql
node_load1
node_load5
node_load15
```

**Type :** Time Series (trois courbes)

---

## 4. Dashboards Auto-provisionnes

Les dashboards sont **auto-provisionnes** au demarrage de Grafana grace aux fichiers :

- `grafana/provisioning/dashboards/dashboards.yml` : reference le dossier des dashboards
- `grafana/dashboards/app-metrics.json` : dashboard applicatif
- `grafana/dashboards/infra-metrics.json` : dashboard infrastructure

**Avantage** : pas besoin de creer les dashboards manuellement a chaque redemarrage.

---

## 5. Regles d'Alerte

### Alertes Configurees dans Prometheus

Les alertes sont definies dans `prometheus/alert-rules.yml` :

| Alerte | Expression PromQL | Seuil | Duree | Severite |
|--------|-------------------|-------|-------|----------|
| **HighErrorRate** | Taux d'erreurs 5xx | > 5% | 5 min | critical |
| **HighLatency** | Latence P95 | > 1s | 5 min | warning |
| **ServiceDown** | Target Prometheus down | == 0 | 1 min | critical |
| **HighCpuUsage** | Utilisation CPU | > 80% | 5 min | warning |
| **HighMemoryUsage** | Utilisation memoire | > 85% | 5 min | warning |

### Routage dans Alertmanager

Les alertes sont routees selon leur severite :

```
                    Alerte declenchee
                          |
                    +-----v------+
                    | Alertmanager|
                    +-----+------+
                          |
              +-----------+-----------+
              |                       |
        severity=critical      severity=warning
              |                       |
        +-----v------+         +-----v------+
        |  Webhook   |         |  Webhook   |
        |  (immediat)|         |  (groupe)  |
        +------------+         +------------+
```

---

## 6. Tester les Alertes

### Simuler un Taux d'Erreurs Eleve

```bash
# Envoyer 100 requetes sur l'endpoint d'erreur
for i in $(seq 1 100); do
  curl -s http://localhost:5000/api/error > /dev/null &
done
wait

# Envoyer quelques requetes normales
for i in $(seq 1 20); do
  curl -s http://localhost:5000/api/data > /dev/null &
done
wait
```

Attendez 5 minutes et verifiez :
1. **Prometheus** (http://localhost:9090/alerts) : l'alerte `HighErrorRate` devrait etre `FIRING`
2. **Alertmanager** (http://localhost:9093) : l'alerte devrait apparaitre

### Simuler un Service Down

```bash
# Arreter l'application
docker compose stop app

# Attendre 1-2 minutes
# Verifier l'alerte ServiceDown dans Prometheus
```

Puis redemarrer :
```bash
docker compose start app
```

### Simuler une Surcharge CPU

```bash
# Avec stress-ng (a installer: apt install stress-ng)
docker run --rm -it --name stress progrium/stress --cpu 4 --timeout 120s
```

---

## 7. Explorer les Logs dans Grafana

### Via le Panel Explore

1. Allez dans **Explore** (icone boussole)
2. Selectionnez la datasource **Loki**
3. Entrez une requete LogQL :

```logql
# Tous les logs de l'application
{container_name=~".*app.*"}

# Uniquement les erreurs
{container_name=~".*app.*"} |= "ERROR"

# Logs parses en JSON, filtres par niveau
{container_name=~".*app.*"} | json | levelname="ERROR"

# Taux de logs d'erreur par minute
rate({container_name=~".*app.*"} |= "ERROR" [1m])
```

### Correler Metriques et Logs

La puissance de Grafana reside dans la **correlation** :
1. Observez un pic de latence dans le dashboard applicatif
2. Cliquez sur le graphique a l'instant du pic
3. Basculez vers **Explore** avec Loki
4. Recherchez les logs correspondant a ce moment precis

---

## 8. Guide pour les Captures d'Ecran

Pour votre rapport, capturez :

1. **Dashboard Applicatif complet** (vue d'ensemble)
2. **Dashboard Infrastructure complet** (vue d'ensemble)
3. **Panel latence** en zoom pendant un test de charge
4. **Panel taux d'erreurs** en rouge apres simulation
5. **Prometheus Targets** (tous les targets UP)
6. **Prometheus Alerts** (alertes en FIRING)
7. **Alertmanager** (alertes recues)
8. **Grafana Explore** avec des logs Loki
9. **Correlation** metriques/logs sur le meme timestamp

> **Conseil** : prenez les captures d'ecran pendant un test de charge pour avoir des graphiques interessants (pas des lignes plates).

---

## 9. Points Cles pour le Rapport

- Expliquez la **methode RED** (Rate, Errors, Duration) et pourquoi elle est standard
- Detaillez chaque **requete PromQL** avec une explication pedagogique
- Montrez la **correlation** entre metriques et logs
- Expliquez les **seuils d'alerte** choisis et pourquoi
- Discutez de l'**auto-provisioning** vs la configuration manuelle
- Incluez toutes les **captures d'ecran** demandees
