# Etape 04 : Deploiement automatique

## Objectif

Automatiser le deploiement de l'application apres validation des tests et des scans de securite. Cette etape couvre le deploiement automatique avec GitLab CI/CD vers des plateformes externes, ainsi que le deploiement local optionnel.

## Duree estimee

45 minutes-1h (avec GitLab et plateforme externe)
30-45 minutes (deploiement local)

## Prérequis

- Pipeline CI/CD fonctionnel (etapes precedentes validees)
- Compte GitLab avec projet cree (pour la partie GitLab)
- Compte sur une plateforme de deploiement (Railway, Render, Fly.io) - optionnel
- Docker installe (pour la partie locale)
- Compréhension de base du deploiement

## Important : Deploiement optionnel

Le deploiement externe est optionnel. Vous pouvez tout garder en local pour garantir la confidentialite. Cette etape explique les deux approches.

---

## PARTIE A : Deploiement automatique avec GitLab CI/CD

### Etape 4.1 : Comprendre le deploiement automatique

**Deploiement automatique** : Le processus qui deploye automatiquement votre application apres que les tests et les scans de securite ont reussi. Cela permet de deployer rapidement et de maniere fiable.

**Conditions de deploiement** : Le deploiement ne se fait que si :
- Les tests passent
- Les scans de securite ne trouvent pas de vulnerabilites critiques
- Le code est sur la branche principale (main)

### Etape 4.2 : Choisir une plateforme de deploiement

Vous avez le choix entre plusieurs options gratuites :

**Railway.app** :
- Simple et rapide a configurer
- Support Docker natif
- Plan gratuit avec limitations

**Render.com** :
- Excellent pour les applications web
- Support Docker et deploiement depuis Git
- Plan gratuit avec limitations

**Fly.io** :
- Parfait pour les conteneurs Docker
- Deploiement global
- Plan gratuit avec limitations

Pour cet exemple, nous utiliserons Railway.app.

### Etape 4.3 : Creer un compte Railway

**Action** : Creer un compte sur Railway

1. Ouvrez votre navigateur
2. Allez sur https://railway.app
3. Cliquez sur "Start a New Project" ou "Get Started"
4. Choisissez de vous connecter avec GitHub ou GitLab
5. Autorisez Railway a acceder a votre compte
6. Votre compte Railway est cree

**Note** : Railway offre un plan gratuit avec des credits limites. Pour un usage intensif, vous devrez peut-etre passer a un plan payant.

### Etape 4.4 : Creer un projet sur Railway

**Action** : Creer un nouveau projet sur Railway

1. Dans Railway, cliquez sur "New Project"
2. Selectionnez "Deploy from GitHub repo" (ou GitLab si vous utilisez GitLab)
3. Choisissez votre depot
4. Railway detecte automatiquement le Dockerfile
5. Cliquez sur "Deploy Now"

**Note** : Railway va automatiquement deployer votre application. Vous pouvez aussi le faire manuellement depuis GitLab CI/CD.

### Etape 4.5 : Obtenir le token Railway

**Action** : Generer un token d'authentification pour Railway

1. Dans Railway, cliquez sur votre profil (en haut a droite)
2. Allez dans "Account Settings"
3. Cliquez sur "New Token"
4. Donnez un nom au token (ex: "gitlab-ci-cd")
5. Cliquez sur "Create"
6. **IMPORTANT** : Copiez le token immediatement (il ne sera plus visible)

**Note** : Gardez ce token secret. Ne le partagez pas publiquement.

### Etape 4.6 : Obtenir le PROJECT_ID Railway

**Action** : Recuperer l'identifiant du projet Railway

1. Dans Railway, allez sur votre projet
2. Cliquez sur "Settings" (icone d'engrenage)
3. Trouvez "Project ID"
4. Copiez le Project ID

**Note** : Le Project ID est un identifiant unique pour votre projet Railway.

### Etape 4.7 : Configurer les variables dans GitLab

**Action** : Ajouter les variables d'environnement dans GitLab

1. Allez sur votre projet GitLab
2. Cliquez sur "Settings" dans le menu de gauche
3. Allez dans "CI/CD"
4. Developpez la section "Variables"
5. Cliquez sur "Add variable"

**Ajouter RAILWAY_TOKEN** :
- Key : `RAILWAY_TOKEN`
- Value : Le token Railway que vous avez copie
- Cochez "Mask variable" (masque la valeur dans les logs)
- Cochez "Protect variable" (disponible seulement sur les branches protegees)
- Cliquez sur "Add variable"

**Ajouter RAILWAY_PROJECT_ID** :
- Key : `RAILWAY_PROJECT_ID`
- Value : Le Project ID Railway que vous avez copie
- Cochez "Mask variable"
- Cliquez sur "Add variable"

**Ajouter RAILWAY_DOMAIN** (optionnel) :
- Key : `RAILWAY_DOMAIN`
- Value : Le domaine Railway de votre application (ex: mon-app.up.railway.app)
- Cliquez sur "Add variable"

### Etape 4.8 : Ajouter le stage de deploiement dans GitLab CI/CD

**Action** : Modifier le pipeline pour ajouter le deploiement automatique

Modifiez votre fichier `.gitlab-ci.yml` pour ajouter le stage de deploiement :

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
    - echo "Deploiement termine avec succes"
  environment:
    name: production
    url: https://$RAILWAY_DOMAIN
  only:
    - main
  when: on_success  # Deploie automatiquement si les tests passent
```

**Explication de chaque section** :

**stage: deploy** :
- S'execute apres les stages build, security et test
- Ne s'execute que si tous les stages precedents reussissent

**image: node:16** :
- Utilise Node.js pour executer Railway CLI
- Railway CLI est un outil Node.js

**before_script** :
- Installe Railway CLI globalement
- Permet d'utiliser la commande `railway` dans le script

**script** :
- Se connecte a Railway avec le token
- Lie le projet au Project ID
- Deploie l'application avec `railway up`
- `--detach` : Lance le deploiement en arriere-plan

**environment** :
- Definit l'environnement de deploiement
- `name: production` : Nom de l'environnement
- `url` : URL publique de l'application deployee

**only: - main** :
- Le deploiement ne se fait que sur la branche main
- Evite de deployer depuis d'autres branches

**when: on_success** :
- Le deploiement se fait automatiquement si tous les jobs precedents reussissent
- Si un test echoue, le deploiement ne se fait pas

### Etape 4.9 : Ajouter un job de rollback (optionnel)

**Action** : Creer un job pour annuler le deploiement si necessaire

Ajoutez ce job dans votre `.gitlab-ci.yml` :

```yaml
rollback-railway:
  stage: deploy
  image: node:16
  before_script:
    - npm install -g @railway/cli
  script:
    - echo "Rollback sur Railway"
    - railway login --token $RAILWAY_TOKEN
    - railway link $RAILWAY_PROJECT_ID
    - railway rollback
    - echo "Rollback termine"
  environment:
    name: production
    action: rollback
  only:
    - main
  when: manual  # Execution manuelle uniquement
```

**Explication** :
- `when: manual` : Le job ne s'execute que manuellement
- Permet de faire un rollback si le deploiement cause des problemes

### Etape 4.10 : Pousser les modifications

```bash
git add .gitlab-ci.yml
git commit -m "Ajout du deploiement automatique sur Railway"
git push origin main
```

### Etape 4.11 : Verifier le deploiement

**Action** : Verifier que le deploiement s'est bien passe

1. Allez sur votre projet GitLab
2. Cliquez sur "CI/CD" → "Pipelines"
3. Cliquez sur le pipeline en cours d'execution
4. Attendez que tous les stages se terminent :
   - build
   - security
   - test
   - deploy
5. Verifiez que le job "deploy-railway" a reussi (icone verte)

**Si le deploiement reussit** :
- Vous verrez "deploy-railway" avec une icone verte
- L'URL de l'environnement sera disponible dans GitLab
- Votre application sera accessible sur Railway

**Si le deploiement echoue** :
- Consultez les logs du job "deploy-railway"
- Verifiez que les variables sont bien configurees
- Verifiez que Railway CLI fonctionne correctement

### Etape 4.12 : Acceder a l'application deployee

**Action** : Tester l'application deployee

1. Dans GitLab, allez sur "Operations" → "Environments"
2. Cliquez sur "production"
3. Cliquez sur l'URL de l'environnement
4. Votre application devrait s'afficher

**Ou directement** :
- Allez sur Railway
- Cliquez sur votre projet
- Cliquez sur "Settings"
- Trouvez "Public Domain"
- Cliquez sur l'URL

---

## PARTIE B : Deploiement local (confidentialite garantie)

Cette partie permet de deployer votre application localement sur votre ordinateur, sans envoyer de donnees sur Internet.

### Etape 4.13 : Comprendre le deploiement local

**Deploiement local** : Executer votre application dans un conteneur Docker sur votre ordinateur. Tout reste local, aucune donnee n'est envoyee sur Internet.

### Etape 4.14 : Creer un fichier docker-compose pour le deploiement local

**Action** : Creer un fichier Docker Compose pour deployer l'application localement

Creez un fichier `docker-compose-deploy.yml` :

```yaml
version: '3.8'

services:
  app:
    image: localhost:5000/mon-app:latest
    container_name: mon-app-deployed
    ports:
      - "8000:8000"
    environment:
      - ENV=production
      - DEBUG=false
    networks:
      - app-net
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8000/health"]
      interval: 30s
      timeout: 10s
      retries: 3

networks:
  app-net:
    driver: bridge
```

**Explication** :
- `image: localhost:5000/mon-app:latest` : Image depuis le registry local
- `ports: - "8000:8000"` : Expose le port 8000
- `environment` : Variables d'environnement pour l'application
- `healthcheck` : Verification automatique de la sante de l'application

### Etape 4.15 : Creer un script de deploiement local

**Action** : Creer un script qui automatise le deploiement local

Creez un fichier `deploy-local.sh` (Linux/Mac) ou `deploy-local.bat` (Windows) :

**Pour Linux/Mac (deploy-local.sh)** :
```bash
#!/bin/bash
# Script de deploiement local

set -e

echo "============================================================"
echo "DEPLOIEMENT LOCAL"
echo "============================================================"
echo "Tout se fait sur votre ordinateur"
echo "Aucune donnee n'est envoyee sur Internet"
echo ""

# Verifier que Docker fonctionne
if ! command -v docker &> /dev/null; then
    echo "ERREUR : Docker n'est pas installe"
    exit 1
fi

# Verifier que l'image existe dans le registry local
if ! curl -s http://localhost:5000/v2/mon-app/tags/list > /dev/null; then
    echo "ATTENTION : L'image n'existe pas dans le registry local"
    echo "Construisez et poussez l'image d'abord avec build-and-push-local.sh"
    exit 1
fi

# Arreter l'ancienne version si elle existe
echo "Arret de l'ancienne version..."
docker-compose -f docker-compose-deploy.yml down || true

# Recuperer la derniere version de l'image
echo "Recuperation de la derniere version de l'image..."
docker pull localhost:5000/mon-app:latest

# Deployer la nouvelle version
echo "Deploiement de la nouvelle version..."
docker-compose -f docker-compose-deploy.yml up -d

# Attendre que l'application demarre
echo "Attente du demarrage de l'application..."
sleep 5

# Verifier que l'application fonctionne
if curl -f http://localhost:8000/health > /dev/null 2>&1; then
    echo ""
    echo "============================================================"
    echo "DEPLOIEMENT REUSSI"
    echo "============================================================"
    echo "Application accessible sur : http://localhost:8000"
else
    echo ""
    echo "ATTENTION : L'application ne repond pas correctement"
    echo "Consultez les logs avec : docker-compose -f docker-compose-deploy.yml logs"
fi
```

**Pour Windows (deploy-local.bat)** :
```batch
@echo off
echo ============================================================
echo DEPLOIEMENT LOCAL
echo ============================================================
echo Tout se fait sur votre ordinateur
echo Aucune donnee n'est envoyee sur Internet
echo.

REM Verifier que Docker fonctionne
docker --version >nul 2>&1
if errorlevel 1 (
    echo ERREUR : Docker n'est pas installe
    exit /b 1
)

REM Arreter l'ancienne version si elle existe
echo Arret de l'ancienne version...
docker-compose -f docker-compose-deploy.yml down

REM Recuperer la derniere version de l'image
echo Recuperation de la derniere version de l'image...
docker pull localhost:5000/mon-app:latest

REM Deployer la nouvelle version
echo Deploiement de la nouvelle version...
docker-compose -f docker-compose-deploy.yml up -d

REM Attendre que l'application demarre
echo Attente du demarrage de l'application...
timeout /t 5 /nobreak >nul

REM Verifier que l'application fonctionne
curl -f http://localhost:8000/health >nul 2>&1
if errorlevel 1 (
    echo.
    echo ATTENTION : L'application ne repond pas correctement
    echo Consultez les logs avec : docker-compose -f docker-compose-deploy.yml logs
) else (
    echo.
    echo ============================================================
    echo DEPLOIEMENT REUSSI
    echo ============================================================
    echo Application accessible sur : http://localhost:8000
)
```

**Rendre executable (Linux/Mac)** :
```bash
chmod +x deploy-local.sh
```

### Etape 4.16 : Executer le deploiement local

**Action** : Lancer le deploiement local

```bash
# Linux/Mac
./deploy-local.sh

# Windows
deploy-local.bat
```

**Resultat attendu** :
```
============================================================
DEPLOIEMENT LOCAL
============================================================
Tout se fait sur votre ordinateur
Aucune donnee n'est envoyee sur Internet

Arret de l'ancienne version...
Recuperation de la derniere version de l'image...
Deploiement de la nouvelle version...
Attente du demarrage de l'application...

============================================================
DEPLOIEMENT REUSSI
============================================================
Application accessible sur : http://localhost:8000
```

### Etape 4.17 : Verifier le deploiement local

**Action** : Tester que l'application fonctionne

1. Ouvrez votre navigateur
2. Allez sur http://localhost:8000
3. Votre application devrait s'afficher

**Verifier les logs** :
```bash
docker-compose -f docker-compose-deploy.yml logs -f
```

**Verifier le statut** :
```bash
docker-compose -f docker-compose-deploy.yml ps
```

### Etape 4.18 : Integrer le deploiement local dans le pipeline local

**Action** : Ajouter le deploiement au pipeline local

Modifiez votre fichier `pipeline-local.sh` (ou `pipeline-local.bat`) pour ajouter le deploiement :

**Pour Linux/Mac** :
```bash
#!/bin/bash
# Pipeline CI/CD local complet avec deploiement

set -e

echo "============================================================"
echo "PIPELINE CI/CD LOCAL COMPLET"
echo "============================================================"
echo ""

# Stage 1 : Build
echo "STAGE 1 : BUILD"
echo "----------------"
./build.sh
if [ $? -ne 0 ]; then
    echo "ERREUR : Le build a echoue"
    exit 1
fi
echo ""

# Stage 2 : Security (optionnel)
echo "STAGE 2 : SECURITY"
echo "-------------------"
if [ -f "scan-security.sh" ]; then
    ./scan-security.sh || echo "ATTENTION : Certains scans ont echoue"
else
    echo "Script de scan de securite non trouve, etape sautee"
fi
echo ""

# Stage 3 : Test
echo "STAGE 3 : TEST"
echo "---------------"
./test.sh
if [ $? -ne 0 ]; then
    echo "ERREUR : Les tests ont echoue"
    exit 1
fi
echo ""

# Stage 4 : Build et Push Docker
echo "STAGE 4 : BUILD ET PUSH DOCKER"
echo "-------------------------------"
if [ -f "build-and-push-local.sh" ]; then
    ./build-and-push-local.sh
else
    echo "Script de build Docker non trouve, etape sautee"
fi
echo ""

# Stage 5 : Deploy
echo "STAGE 5 : DEPLOY"
echo "----------------"
if [ -f "deploy-local.sh" ]; then
    ./deploy-local.sh
else
    echo "Script de deploiement non trouve, etape sautee"
fi
echo ""

echo "============================================================"
echo "PIPELINE TERMINE AVEC SUCCES"
echo "============================================================"
```

---

## Verification

Avant de passer a l'etape suivante, verifiez que :

**Avec GitLab et Railway** :
- [ ] Les variables Railway sont configurees dans GitLab
- [ ] Le stage "deploy" est ajoute au pipeline
- [ ] Le deploiement se fait automatiquement apres les tests
- [ ] L'application est accessible via l'URL Railway
- [ ] Les logs de deploiement sont accessibles dans GitLab

**En local** :
- [ ] Le script de deploiement local existe et fonctionne
- [ ] L'application est deployee et accessible sur http://localhost:8000
- [ ] Les logs montrent que l'application fonctionne correctement
- [ ] Le deploiement peut etre relance avec le script

## Problemes courants

### Le deploiement ne se declenche pas dans GitLab

**Solution** :
- Verifiez que `when: on_success` est present dans le job deploy
- Verifiez que tous les jobs precedents (build, security, test) ont reussi
- Verifiez que vous etes sur la branche main

### Erreur "RAILWAY_TOKEN not found"

**Solution** :
- Verifiez que la variable RAILWAY_TOKEN est bien definie dans GitLab CI/CD Variables
- Verifiez que la variable n'est pas protegee si vous deployez depuis une branche non protegee
- Verifiez l'orthographe de la variable (sensible a la casse)

### Erreur lors du deploiement Railway

**Solution** :
- Consultez les logs du job deploy-railway dans GitLab
- Verifiez que Railway CLI est correctement installe
- Verifiez que le Project ID est correct
- Verifiez que vous avez des credits Railway disponibles

### L'application ne demarre pas localement

**Solution** :
- Verifiez les logs : `docker-compose -f docker-compose-deploy.yml logs`
- Verifiez que l'image existe dans le registry local
- Verifiez que le port 8000 n'est pas deja utilise
- Verifiez que l'application ecoute bien sur le port 8000

### Erreur "connection refused" pour le registry local

**Solution** :
- Verifiez que le registry local est demarre : `docker ps | grep registry`
- Verifiez que l'image existe : `curl http://localhost:5000/v2/mon-app/tags/list`
- Construisez et poussez l'image d'abord avec build-and-push-local.sh

## Commandes utiles

**Voir les environnements dans GitLab** :
- Allez sur "Operations" → "Environments"

**Voir les logs de deploiement Railway** :
- Dans Railway, allez sur votre projet → "Deployments" → Cliquez sur un deploiement

**Arreter l'application locale** :
```bash
docker-compose -f docker-compose-deploy.yml down
```

**Redemarrer l'application locale** :
```bash
docker-compose -f docker-compose-deploy.yml restart
```

**Voir les logs de l'application locale** :
```bash
docker-compose -f docker-compose-deploy.yml logs -f
```

## Notes importantes

- Le deploiement automatique permet de deployer rapidement apres validation
- Le deploiement ne se fait que si tous les tests et scans passent
- Le deploiement externe est optionnel, vous pouvez tout garder en local
- Le deploiement local garantit la confidentialite totale
- Vous pouvez combiner les deux approches selon vos besoins

## Prochaine etape

Une fois cette etape validee, passez a :
[Etape 05 : Monitoring et alertes](ETAPE-05-MONITORING.md)
