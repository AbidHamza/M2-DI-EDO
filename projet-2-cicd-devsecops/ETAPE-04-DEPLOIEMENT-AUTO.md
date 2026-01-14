# Etape 04 : Deploiement automatique

## Objectif

Automatiser le deploiement de l'application apres validation des tests et des scans de securite.

## Duree estimee

45 minutes-1h

## Instructions pas a pas

### Etape 4.1 : Choisir une plateforme de deploiement

Vous avez le choix entre plusieurs options gratuites :
- Railway.app
- Render.com
- Fly.io

Pour cet exemple, nous utiliserons Railway.app.

### Etape 4.2 : Creer un compte Railway

1. Allez sur https://railway.app
2. Cliquez sur "Start a New Project"
3. Connectez votre compte GitHub/GitLab

### Etape 4.3 : Obtenir le token Railway

1. Dans Railway, allez sur votre profil
2. Cliquez sur "New Token"
3. Copiez le token genere

### Etape 4.4 : Configurer la variable dans GitLab

1. Allez sur votre projet GitLab
2. Settings → CI/CD → Variables
3. Ajoutez une variable :
   - Key : `RAILWAY_TOKEN`
   - Value : Votre token Railway
   - Cochez "Mask variable"
4. Sauvegardez

### Etape 4.5 : Ajouter le stage de deploiement

Modifiez votre fichier `.gitlab-ci.yml` pour ajouter le deploiement :

```yaml
# ... (gardez les stages precedents)

stages:
  - build
  - security
  - test
  - deploy

# ... (gardez les jobs precedents)

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
  only:
    - main
  when: on_success  # Deploie automatiquement si les tests passent
```

### Etape 4.6 : Obtenir le PROJECT_ID Railway

1. Dans Railway, allez sur votre projet
2. Cliquez sur "Settings"
3. Copiez le "Project ID"

### Etape 4.7 : Ajouter le PROJECT_ID dans GitLab

1. Dans GitLab, allez sur Settings → CI/CD → Variables
2. Ajoutez une variable :
   - Key : `RAILWAY_PROJECT_ID`
   - Value : Votre Project ID Railway
3. Sauvegardez

### Etape 4.8 : Pousser les modifications

```bash
git add .gitlab-ci.yml
git commit -m "Ajout du deploiement automatique sur Railway"
git push origin main
```

### Etape 4.9 : Verifier le deploiement

1. Allez sur votre projet GitLab
2. CI/CD → Pipelines
3. Attendez que le pipeline se termine
4. Le deploiement devrait se faire automatiquement apres les tests

## Verification

Avant de passer a l'etape suivante, verifiez que :

- [ ] Les variables Railway sont configurees dans GitLab
- [ ] Le stage "deploy" s'execute apres les tests
- [ ] Le deploiement se fait automatiquement
- [ ] L'application est accessible via l'URL Railway

## Problemes courants

### Le deploiement ne se declenche pas

**Solution** : Verifiez que `when: on_success` est present et que les tests precedents passent

### Erreur "RAILWAY_TOKEN not found"

**Solution** : Verifiez que la variable est bien definie dans GitLab CI/CD Variables

### Erreur lors du deploiement

**Solution** : Consultez les logs du job deploy-railway pour identifier l'erreur

## Prochaine etape

Une fois cette etape validee, passez a :
[Etape 05 : Monitoring et alertes](ETAPE-05-MONITORING.md)
