# Exercice Phase 1 : Installation et première configuration Prometheus

## Exercice à réaliser

Installez et configurez Prometheus localement pour comprendre son fonctionnement de base.

## Correction complète

```yaml
# prometheus.yml
global:
  scrape_interval: 15s
  evaluation_interval: 15s

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']
```

## Explications détaillées

**global.scrape_interval** : Fréquence de collecte des métriques (15 secondes)

**scrape_configs** : Configuration des targets à scraper

**job_name** : Nom du job de scraping

**static_configs** : Configuration statique des targets

## Vérification

Démarrez Prometheus et vérifiez :
- Interface accessible sur http://localhost:9090
- Métriques collectées visibles
- Targets UP dans Status > Targets

