# Etape 05 : Monitoring et alertes

## Objectif

Mettre en place le monitoring de l'application et configurer des alertes pour etre notifie en cas de probleme.

## Duree estimee

30-45 minutes

## Instructions pas a pas

### Etape 5.1 : Utiliser GitLab Monitoring (integre)

GitLab fournit un monitoring integre pour les applications deployees.

### Etape 5.2 : Ajouter des metriques au pipeline

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
    - railway down
  environment:
    name: production
    action: stop
  when: manual
  only:
    - main
```

### Etape 5.3 : Configurer les alertes dans GitLab

1. Allez sur votre projet GitLab
2. Settings → Monitor
3. Configurez les alertes selon vos besoins :
   - Alertes sur les echecs de pipeline
   - Alertes sur les vulnerabilites critiques
   - Alertes sur les deploiements

### Etape 5.4 : Utiliser Uptime Kuma (optionnel - gratuit)

Pour un monitoring plus avance, vous pouvez utiliser Uptime Kuma :

1. Allez sur https://uptime.kuma.pet
2. Suivez les instructions pour deployer votre propre instance
3. Ajoutez votre application comme service a monitorer
4. Configurez les alertes (email, Telegram, etc.)

### Etape 5.5 : Ajouter des health checks

Dans votre application, ajoutez un endpoint de health check :

```python
# app.py
from flask import Flask, jsonify

app = Flask(__name__)

@app.route('/health')
def health():
    return jsonify({"status": "healthy"}), 200
```

### Etape 5.6 : Configurer le monitoring dans Railway

1. Dans Railway, allez sur votre service
2. Cliquez sur "Settings"
3. Configurez le "Healthcheck Path" : `/health`
4. Railway monitorera automatiquement votre application

## Verification

Avant de considerer le projet termine, verifiez que :

- [ ] Le monitoring est configure dans GitLab
- [ ] Les alertes sont configurees
- [ ] L'endpoint de health check fonctionne
- [ ] Les metriques sont visibles

## Problemes courants

### Les metriques ne s'affichent pas

**Solution** : Verifiez que l'URL de l'environnement est bien configuree dans GitLab

### Les alertes ne fonctionnent pas

**Solution** : Verifiez la configuration des notifications dans GitLab Settings

## Felicitations !

Vous avez termine le Projet 2 ! Vous avez maintenant :
- Un pipeline CI/CD complet et securise
- Des scans de securite automatiques
- Un deploiement automatique fonctionnel
- Un monitoring en place

Vous maitrisez maintenant les concepts de CI/CD et DevSecOps avec GitLab !
