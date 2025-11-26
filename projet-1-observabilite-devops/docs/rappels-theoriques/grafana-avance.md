# Rappels théoriques : Grafana Avancé

## Variables de Dashboard

### Concept

Les variables permettent de créer des dashboards dynamiques et réutilisables.

### Types de variables

1. **Query** : Depuis une requête Prometheus
2. **Custom** : Valeurs personnalisées
3. **Text** : Texte libre
4. **Constant** : Valeur fixe
5. **Interval** : Intervalle de temps

### Exemple de variable Query

**Configuration** :
- Name: `service`
- Type: Query
- Data source: Prometheus
- Query: `label_values(http_requests_total, service)`

**Utilisation dans un panel** :
```promql
rate(http_requests_total{service="$service"}[5m])
```

### Variables imbriquées

```promql
# Variable: namespace
label_values(http_requests_total, namespace)

# Variable: service (dépend de namespace)
label_values(http_requests_total{namespace="$namespace"}, service)

# Utilisation
rate(http_requests_total{namespace="$namespace", service="$service"}[5m])
```

## Templating avancé

### Formatage des valeurs

**Options de format** :
- `$service` : Valeur brute
- `${service:queryparam}` : Pour les URLs
- `$__interval` : Intervalle automatique
- `$__range` : Plage de temps

### All values

Permet de sélectionner toutes les valeurs :
```promql
rate(http_requests_total{service=~"$service"}[5m])
```

## Panels avancés

### Types de panels

1. **Time series** : Graphiques temporels
2. **Stat** : Valeur unique avec seuils
3. **Table** : Tableau de données
4. **Gauge** : Jauge circulaire
5. **Bar gauge** : Barres horizontales
6. **Heatmap** : Carte de chaleur

### Transformations

Permettent de transformer les données avant affichage.

**Exemples** :
- **Group by** : Grouper par label
- **Calculate field** : Calculer un nouveau champ
- **Merge** : Fusionner plusieurs requêtes
- **Filter** : Filtrer les données

## Alerting dans Grafana

### Alertes de dashboard

**Configuration** :
1. Créez un panel avec une métrique
2. Ajoutez une alerte dans les options du panel
3. Configurez les conditions et notifications

**Exemple de condition** :
```
WHEN last() OF query(A, 5m, now) IS ABOVE 100
```

### Canaux de notification

- Email
- Slack
- Webhook
- PagerDuty
- Teams

## Provisioning

### Dashboards automatiques

Créez des dashboards via fichiers JSON dans :
```
/etc/grafana/provisioning/dashboards/
```

**Exemple** :
```yaml
apiVersion: 1
providers:
  - name: 'default'
    orgId: 1
    folder: ''
    type: file
    disableDeletion: false
    updateIntervalSeconds: 10
    allowUiUpdates: true
    options:
      path: /var/lib/grafana/dashboards
```

### Datasources automatiques

```yaml
apiVersion: 1
datasources:
  - name: Prometheus
    type: prometheus
    access: proxy
    url: http://prometheus:9090
    isDefault: true
```

## Logs avec Loki

### Requêtes LogQL

**Requêtes de base** :
```logql
{service="example-app"}
{service="example-app", level="ERROR"}
{service="example-app"} |= "error"
```

**Agrégations** :
```logql
sum(count_over_time({service="example-app"}[5m])) by (level)
rate({service="example-app", level="ERROR"}[5m])
```

**Fonctions** :
```logql
# Top 10
topk(10, sum(count_over_time({service="example-app"}[5m])) by (level))

# Quantile
quantile_over_time(0.95, {service="example-app"} | unwrap duration [5m])
```

### Panels de logs

1. Créez un panel de type "Logs"
2. Sélectionnez Loki comme datasource
3. Utilisez LogQL pour filtrer

## Exercices pratiques

### Exercice 1 : Dashboard avec variables

**Objectif** : Créer un dashboard dynamique avec variables.

**Tâches** :
1. Créez une variable `service` depuis Prometheus
2. Créez une variable `environment` personnalisée
3. Utilisez ces variables dans les panels

**Solution** : Voir `corrections/EXERCICE-1-VARIABLES.md.encrypted`

### Exercice 2 : Alerting Grafana

**Objectif** : Configurer des alertes dans Grafana.

**Tâches** :
1. Créez un panel avec une métrique
2. Configurez une alerte
3. Testez le déclenchement

**Solution** : Voir `corrections/EXERCICE-2-ALERTING.md.encrypted`

### Exercice 3 : Dashboard de logs

**Objectif** : Créer un dashboard pour visualiser les logs Loki.

**Tâches** :
1. Créez un panel de logs
2. Utilisez LogQL pour filtrer
3. Ajoutez des transformations

**Solution** : Voir `corrections/EXERCICE-3-LOGS.md.encrypted`

## Bonnes pratiques

1. **Variables** : Utilisez des variables pour la réutilisabilité
2. **Organisation** : Groupez les dashboards par dossier
3. **Performance** : Utilisez recording rules pour les requêtes complexes
4. **Annotations** : Ajoutez des annotations pour les événements
5. **Documentation** : Documentez vos dashboards

## Ressources supplémentaires

- [Grafana Documentation](https://grafana.com/docs/)
- [Dashboard Variables](https://grafana.com/docs/grafana/latest/variables/)
- [LogQL](https://grafana.com/docs/loki/latest/logql/)

