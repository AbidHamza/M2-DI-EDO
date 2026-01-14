# Etape 07 : Deploiement gratuit

## Objectif

Deployer l'application sur une plateforme gratuite pour la rendre accessible publiquement.

## Duree estimee

1h-1h30

## Options de deploiement gratuites

Vous avez le choix entre plusieurs plateformes gratuites :

1. **Railway.app** : Simple et rapide
2. **Render.com** : Excellent pour les applications web
3. **Fly.io** : Parfait pour les conteneurs Docker

## Instructions pas a pas - Railway.app

### Etape 7.1 : Creer un compte Railway

1. Allez sur https://railway.app
2. Cliquez sur "Start a New Project"
3. Connectez votre compte GitHub/GitLab

### Etape 7.2 : Creer un nouveau projet

1. Dans Railway, cliquez sur "New Project"
2. Selectionnez "Deploy from GitHub repo" (ou GitLab)
3. Choisissez votre depot
4. Railway detecte automatiquement le Dockerfile

### Etape 7.3 : Configurer les variables d'environnement

Si necessaire, dans Railway → Variables, ajoutez :
- `ELASTICSEARCH_URL=http://elasticsearch:9200`
- `KIBANA_URL=http://localhost:5601`

### Etape 7.4 : Obtenir l'URL de deploiement

Railway genere automatiquement une URL :
```
https://votre-app.up.railway.app
```

### Etape 7.5 : Verifier le deploiement

1. Attendez que le deploiement se termine
2. Cliquez sur l'URL genere
3. Verifiez que l'application fonctionne

## Instructions pas a pas - Render.com

### Etape 7.1 : Creer un compte Render

1. Allez sur https://render.com
2. Cliquez sur "Get Started for Free"
3. Creez un compte

### Etape 7.2 : Creer un nouveau service

1. Cliquez sur "New +"
2. Selectionnez "Web Service"
3. Connectez votre depot GitHub/GitLab
4. Selectionnez votre depot

### Etape 7.3 : Configurer le service

- Name : Donnez un nom a votre service
- Environment : Docker
- Build Command : (laissez vide, Render utilise le Dockerfile)
- Start Command : (laissez vide)

### Etape 7.4 : Deployer

1. Cliquez sur "Create Web Service"
2. Attendez que le deploiement se termine
3. Votre application est accessible via l'URL fournie

## Instructions pas a pas - Fly.io

### Etape 7.1 : Installer Fly CLI

```bash
# Windows (PowerShell)
iwr https://fly.io/install.ps1 -useb | iex

# Linux/Mac
curl -L https://fly.io/install.sh | sh
```

### Etape 7.2 : Se connecter

```bash
fly auth login
```

### Etape 7.3 : Initialiser l'application

```bash
fly launch
```

Suivez les instructions pour configurer votre application.

### Etape 7.4 : Deployer

```bash
fly deploy
```

## Verification

Avant de considerer le projet termine, verifiez que :

- [ ] L'application est deployee avec succes
- [ ] L'application est accessible via l'URL publique
- [ ] Les fonctionnalites principales fonctionnent
- [ ] Les logs sont accessibles

## Problemes courants

### Le deploiement echoue

**Solution** : Consultez les logs de deploiement pour identifier l'erreur

### L'application ne demarre pas

**Solution** : Verifiez les variables d'environnement et les ports exposes

### Erreur de memoire

**Solution** : Augmentez les ressources allouees ou optimisez votre application

## Felicitations !

Vous avez termine le Projet 1 ! Vous avez maintenant :
- Une infrastructure d'observabilite complete
- Un pipeline CI/CD fonctionnel
- Une application deployee en production

Vous pouvez maintenant passer au [Projet 2 : CI/CD DevSecOps](../../PROJET-2-CICD-DEVSECOPS/README.md)
