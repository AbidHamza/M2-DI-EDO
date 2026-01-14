# Etape 07 : Deploiement (OPTIONNEL - Tout peut rester en local)

## Objectif

Cette etape est **OPTIONNELLE**. Vous pouvez deployer votre application sur une plateforme externe si vous le souhaitez, mais **tout peut rester en local** pour garantir la confidentialite.

## Important : Confidentialite

**Vous pouvez sauter cette etape** si :
- Votre projet est confidentiel
- Vous preferez tout garder en local
- Vous n'avez pas besoin d'un acces externe

**Tout fonctionne parfaitement en local** :
- La stack ELK fonctionne sur localhost
- Kibana est accessible sur http://localhost:5601
- Aucune donnee n'est envoyee sur Internet
- Vous pouvez travailler completement hors ligne

## Si vous choisissez de deployer

Cette section explique comment deployer sur des plateformes gratuites, mais **c'est optionnel**.

## Duree estimee

1h-1h30 (si vous choisissez de deployer)

## Options de deploiement gratuites

Si vous decidez de deployer, voici des options gratuites :

1. **Railway.app** : Simple et rapide
2. **Render.com** : Excellent pour les applications web
3. **Fly.io** : Parfait pour les conteneurs Docker

**Note** : Ces plateformes necessitent un compte et peuvent avoir des limitations sur le plan gratuit.

## Instructions pas a pas - Railway.app (OPTIONNEL)

### Etape 7.1 : Creer un compte Railway

**Action** : Creer un compte sur Railway (si vous choisissez de deployer)

1. Ouvrez votre navigateur
2. Allez sur https://railway.app
3. Cliquez sur "Start a New Project" ou "Get Started"
4. Choisissez de vous connecter avec GitHub ou GitLab
5. Autorisez Railway a acceder a votre compte

**Note** : Si vous preferez garder votre projet local, vous pouvez sauter cette etape.

### Etape 7.2 : Creer un nouveau projet

**Action** : Creer un projet sur Railway

1. Dans Railway, cliquez sur "New Project"
2. Selectionnez "Deploy from GitHub repo" (ou GitLab si vous utilisez GitLab)
3. Choisissez votre depot
4. Railway detecte automatiquement le Dockerfile

**Note** : Si votre projet n'est pas sur GitHub/GitLab, vous pouvez creer un depot local et le pousser.

### Etape 7.3 : Configurer les variables d'environnement

**Action** : Ajouter des variables si necessaire

Si votre application utilise des variables d'environnement :

1. Dans Railway, allez dans votre projet
2. Cliquez sur "Variables"
3. Ajoutez les variables necessaires :
   - `NOMBRE_JOURS=100`
   - `VILLES=Paris,Lyon,Marseille,Toulouse`
   - etc.

**Note** : Pour notre application simple, aucune variable n'est necessaire.

### Etape 7.4 : Obtenir l'URL de deploiement

**Action** : Recuperer l'URL de votre application deployee

Railway genere automatiquement une URL :
```
https://votre-app.up.railway.app
```

**Note** : Cette URL est publique. Si votre projet est confidentiel, ne le deployez pas.

### Etape 7.5 : Verifier le deploiement

**Action** : Tester l'application deployee

1. Attendez que le deploiement se termine (2-5 minutes)
2. Cliquez sur l'URL generee
3. Verifiez que l'application fonctionne

**Note** : Pour une application qui genere des fichiers CSV, Railway peut ne pas etre ideal car les fichiers ne sont pas persistes.

## Instructions pas a pas - Render.com (OPTIONNEL)

### Etape 7.1 : Creer un compte Render

**Action** : Creer un compte sur Render

1. Allez sur https://render.com
2. Cliquez sur "Get Started for Free"
3. Creez un compte avec votre email ou connectez-vous avec GitHub/GitLab

### Etape 7.2 : Creer un nouveau service

**Action** : Creer un service web sur Render

1. Cliquez sur "New +" en haut a droite
2. Selectionnez "Web Service"
3. Connectez votre depot GitHub/GitLab
4. Selectionnez votre depot

### Etape 7.3 : Configurer le service

**Action** : Configurer les parametres du service

Remplissez les champs :
- **Name** : Donnez un nom a votre service (ex: pollution-monitor)
- **Environment** : Selectionnez "Docker"
- **Region** : Choisissez la region la plus proche
- **Branch** : Selectionnez la branche a deployer (generalement "main")
- **Build Command** : Laissez vide (Render utilise le Dockerfile)
- **Start Command** : Laissez vide (utilise le CMD du Dockerfile)

### Etape 7.4 : Deployer

**Action** : Lancer le deploiement

1. Cliquez sur "Create Web Service"
2. Render commence a construire et deployer votre application
3. Attendez que le deploiement se termine (3-5 minutes)
4. Votre application est accessible via l'URL fournie

**Note** : Render fournit une URL gratuite mais peut mettre l'application en veille apres 15 minutes d'inactivite.

## Instructions pas a pas - Fly.io (OPTIONNEL)

### Etape 7.1 : Installer Fly CLI

**Action** : Installer l'outil en ligne de commande Fly

**Windows (PowerShell)** :
```powershell
iwr https://fly.io/install.ps1 -useb | iex
```

**Linux/Mac** :
```bash
curl -L https://fly.io/install.sh | sh
```

**Verification** :
```bash
fly version
```

### Etape 7.2 : Se connecter

**Action** : Se connecter a Fly.io

```bash
fly auth login
```

Cette commande ouvre votre navigateur pour vous connecter.

### Etape 7.3 : Initialiser l'application

**Action** : Creer la configuration Fly.io

```bash
fly launch
```

Suivez les instructions :
- Nom de l'application : Donnez un nom unique
- Region : Choisissez la region la plus proche
- Configuration : Fly detecte automatiquement le Dockerfile

### Etape 7.4 : Deployer

**Action** : Deployer l'application

```bash
fly deploy
```

Cette commande :
1. Construit l'image Docker
2. La pousse vers Fly.io
3. Deploie l'application
4. Fournit une URL publique

**Note** : Fly.io fournit une URL gratuite mais avec des limitations sur le plan gratuit.

## Alternative : Rester en local

**Si vous preferez tout garder en local**, voici comment acceder a votre application :

### Acces local a Kibana

1. Demarrez la stack ELK :
   ```bash
   cd stack-elk
   docker-compose up -d
   ```

2. Attendez que les services soient prets (1-2 minutes)

3. Ouvrez votre navigateur :
   ```
   http://localhost:5601
   ```

4. Vous avez acces a toutes les fonctionnalites de Kibana

### Acces local a l'application

1. Executez votre script Python :
   ```bash
   python generate_data.py
   ```

2. Les donnees sont generees localement

3. Traitez-les avec la stack ELK

**Avantages de rester en local** :
- Confidentialite totale
- Pas de dependance externe
- Fonctionne hors ligne
- Pas de limitations
- Gratuit

## Verification (si vous avez deploye)

Si vous avez choisi de deployer, verifiez que :

- [ ] L'application est deployee avec succes
- [ ] L'application est accessible via l'URL publique
- [ ] Les fonctionnalites principales fonctionnent
- [ ] Les logs sont accessibles sur la plateforme

## Verification (si vous restez en local)

Si vous restez en local, verifiez que :

- [ ] La stack ELK fonctionne : `docker-compose ps` montre tous les services "Up"
- [ ] Kibana est accessible : http://localhost:5601 se charge
- [ ] Les donnees sont generees : `python generate_data.py` fonctionne
- [ ] Les visualisations fonctionnent dans Kibana

## Problemes courants (si vous deployez)

### Le deploiement echoue

**Solutions** :
1. Consultez les logs de deploiement sur la plateforme
2. Verifiez que le Dockerfile est valide
3. Verifiez que toutes les dependances sont dans requirements.txt
4. Testez l'image localement avant de deployer

### L'application ne demarre pas

**Solutions** :
1. Verifiez les logs de l'application sur la plateforme
2. Verifiez les variables d'environnement
3. Verifiez que les ports sont correctement exposes
4. Testez l'image localement avec `docker run`

### Erreur de memoire

**Solutions** :
1. Augmentez les ressources allouees sur la plateforme (si possible)
2. Optimisez votre Dockerfile (voir etape 06)
3. Reduisez la taille de l'image

## Felicitations !

Vous avez termine le Projet 1 ! Vous avez maintenant :

- ✅ Une infrastructure d'observabilite complete (ELK Stack)
- ✅ Un pipeline CI/CD local fonctionnel
- ✅ Une application containerisee avec Docker
- ✅ Des visualisations et dashboards dans Kibana
- ✅ Tout fonctionne en local avec confidentialite garantie

**Prochaines etapes** :

1. **Si vous voulez continuer** : Passez au [Projet 2 : CI/CD DevSecOps](../../PROJET-2-CICD-DEVSECOPS/README.md)

2. **Si vous preferez approfondir** :
   - Ajoutez plus de visualisations dans Kibana
   - Experimentez avec d'autres types de graphiques
   - Ajoutez des alertes dans Kibana
   - Optimisez votre Dockerfile

3. **Si vous voulez partager** :
   - Documentez votre projet
   - Creez un README avec des captures d'ecran
   - Partagez votre code (si autorise)

## Notes importantes

- **Le deploiement externe est optionnel** : Votre projet fonctionne parfaitement en local
- **La confidentialite est garantie** : Aucune donnee n'est envoyee sur Internet si vous restez en local
- **Tout est gratuit** : Aucun cout pour travailler en local
- **Vous pouvez deployer plus tard** : Rien ne vous empeche de deployer plus tard si besoin

## Resume du projet

Vous avez appris a :

1. ✅ Installer et configurer Docker
2. ✅ Generer des donnees avec Python
3. ✅ Deployer une stack ELK avec Docker Compose
4. ✅ Visualiser des donnees avec Kibana
5. ✅ Creer un pipeline CI/CD local
6. ✅ Containeriser une application avec Docker
7. ✅ (Optionnel) Deployer sur une plateforme externe

**Bravo pour avoir termine ce projet !** 🎉
