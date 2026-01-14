# Etape 03 : Container Registry

## Objectif

Utiliser un Container Registry pour stocker et gerer vos images Docker de maniere securisee. Cette etape couvre GitLab Container Registry (avec GitLab) et un registry Docker local (pour travailler en local).

## Duree estimee

30-45 minutes (avec GitLab)
45 minutes-1h (en local)

## Prérequis

- Docker installe et fonctionnel
- Docker Compose installe (pour la partie locale)
- Compte GitLab avec projet cree (pour la partie GitLab)
- Compréhension de base de Docker

## Deux approches possibles

Cette etape propose deux approches :
1. **Avec GitLab Container Registry** : Utilise le registry integre de GitLab
2. **En local** : Utilise un registry Docker local sur votre ordinateur

Vous pouvez choisir l'approche qui vous convient le mieux.

---

## PARTIE A : Avec GitLab Container Registry

### Etape 3.1 : Comprendre ce qu'est un Container Registry

**Container Registry** : Un depot centralise pour stocker et distribuer des images Docker. Permet de versionner vos images, de les partager entre environnements, et de les deployer facilement.

**GitLab Container Registry** : Registry integre a GitLab, accessible directement depuis votre projet GitLab.

### Etape 3.2 : Creer un Dockerfile

Si vous n'avez pas encore de Dockerfile, creez-le a la racine de votre projet :

```dockerfile
FROM python:3.10-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD ["python", "app.py"]
```

**Explication ligne par ligne** :

**FROM python:3.10-slim** :
- Utilise une image Python officielle legere
- Contient Python 3.10 et les outils de base

**WORKDIR /app** :
- Definit le repertoire de travail dans le conteneur
- Toutes les commandes suivantes s'executent dans ce repertoire

**COPY requirements.txt .** :
- Copie le fichier requirements.txt dans le conteneur
- Permet d'installer les dependances avant de copier le code

**RUN pip install --no-cache-dir -r requirements.txt** :
- Installe les dependances Python
- `--no-cache-dir` reduit la taille de l'image

**COPY . .** :
- Copie tout le code de l'application dans le conteneur
- Le point (.) signifie le repertoire courant

**CMD ["python", "app.py"]** :
- Commande par defaut executee au demarrage du conteneur
- Lance votre application Python

### Etape 3.3 : Modifier le pipeline pour utiliser GitLab Container Registry

Modifiez votre fichier `.gitlab-ci.yml` pour ajouter la construction et le push d'images :

```yaml
image: docker:latest

services:
  - docker:dind

variables:
  DOCKER_DRIVER: overlay2
  DOCKER_TLS_CERTDIR: "/certs"

stages:
  - build
  - security
  - test
  - deploy

build-docker-image:
  stage: build
  before_script:
    - docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY
  script:
    - echo "Construction de l'image Docker"
    - docker build -t $CI_REGISTRY_IMAGE:$CI_COMMIT_SHORT_SHA .
    - docker tag $CI_REGISTRY_IMAGE:$CI_COMMIT_SHORT_SHA $CI_REGISTRY_IMAGE:latest
    - echo "Push de l'image vers GitLab Container Registry"
    - docker push $CI_REGISTRY_IMAGE:$CI_COMMIT_SHORT_SHA
    - docker push $CI_REGISTRY_IMAGE:latest
  after_script:
    - docker logout $CI_REGISTRY
  only:
    - main
    - develop

# ... (gardez les autres stages)
```

**Explication de chaque section** :

**image: docker:latest** :
- Utilise l'image Docker officielle pour executer les commandes Docker

**services: - docker:dind** :
- Docker-in-Docker : Permet d'executer Docker dans le pipeline GitLab
- Necessaire pour construire et pousser des images

**variables** :
- `DOCKER_DRIVER: overlay2` : Pilote de stockage Docker
- `DOCKER_TLS_CERTDIR: "/certs"` : Repertoire pour les certificats TLS

**before_script** :
- Se connecte au registry GitLab avant de construire l'image
- `$CI_REGISTRY_USER` et `$CI_REGISTRY_PASSWORD` sont automatiquement fournis par GitLab

**script** :
- Construit l'image avec un tag base sur le hash du commit
- Tagge aussi l'image comme "latest"
- Pousse les deux versions vers le registry

**after_script** :
- Se deconnecte du registry apres le push

### Etape 3.4 : Activer GitLab Container Registry

**Action** : Activer le Container Registry dans votre projet GitLab

1. Allez sur votre projet GitLab
2. Cliquez sur "Settings" dans le menu de gauche
3. Dans "General", trouvez "Visibility, project features, permissions"
4. Developpez cette section
5. Trouvez "Container Registry"
6. Activez le bouton toggle a cote de "Container Registry"
7. Cliquez sur "Save changes"

**Verification** :
- Apres activation, vous devriez voir "Packages & Registries" → "Container Registry" dans le menu de gauche

### Etape 3.5 : Pousser les modifications

```bash
git add .gitlab-ci.yml Dockerfile
git commit -m "Ajout de GitLab Container Registry"
git push origin main
```

### Etape 3.6 : Verifier l'image dans le registry

**Action** : Verifier que l'image a ete poussee avec succes

1. Allez sur votre projet GitLab
2. Cliquez sur "Packages & Registries" → "Container Registry" dans le menu de gauche
3. Vous devriez voir votre image avec :
   - Le tag du commit (ex: abc123def456)
   - Le tag "latest"
   - La date de creation
   - La taille de l'image

**Si l'image n'apparait pas** :
- Attendez quelques secondes et actualisez la page
- Verifiez les logs du pipeline pour voir s'il y a des erreurs
- Verifiez que le Container Registry est bien active

### Etape 3.7 : Utiliser l'image depuis le registry

**Action** : Tester de recuperer l'image depuis le registry

Vous pouvez maintenant utiliser votre image depuis n'importe ou :

```bash
docker pull registry.gitlab.com/votre-username/votre-projet:latest
```

**Remplacez** :
- `votre-username` : Votre nom d'utilisateur GitLab
- `votre-projet` : Le nom de votre projet GitLab

**Exemple** :
```bash
docker pull registry.gitlab.com/john.doe/mon-projet-devsecops:latest
```

**Executer l'image** :
```bash
docker run --rm registry.gitlab.com/votre-username/votre-projet:latest
```

---

## PARTIE B : En local (confidentialite garantie)

Cette partie permet de creer et gerer un registry Docker local sur votre ordinateur, sans envoyer d'images sur Internet.

### Etape 3.8 : Comprendre le registry Docker local

**Registry Docker local** : Un registry Docker que vous deployez sur votre ordinateur. Toutes les images restent locales, aucune donnee n'est envoyee sur Internet.

### Etape 3.9 : Creer un Dockerfile (si pas deja fait)

Si vous n'avez pas encore de Dockerfile, creez-le comme explique a l'etape 3.2.

### Etape 3.10 : Deployer un registry Docker local

**Action** : Creer un registry Docker local avec Docker Compose

Creez un fichier `docker-compose-registry.yml` :

```yaml
version: '3.8'

services:
  registry:
    image: registry:2
    container_name: local-registry
    ports:
      - "5000:5000"
    volumes:
      - registry_data:/var/lib/registry
    networks:
      - registry-net
    restart: unless-stopped

networks:
  registry-net:
    driver: bridge

volumes:
  registry_data:
    driver: local
```

**Explication** :
- `registry:2` : Image officielle du registry Docker
- Port `5000` : Port par defaut du registry Docker
- Volume `registry_data` : Stockage persistant pour les images
- Reseau `registry-net` : Reseau isole pour le registry

### Etape 3.11 : Demarrer le registry local

**Action** : Lancer le registry Docker local

```bash
docker-compose -f docker-compose-registry.yml up -d
```

**Verification** :
```bash
docker ps | grep registry
```

**Resultat attendu** :
```
CONTAINER ID   IMAGE         STATUS         PORTS                    NAMES
abc123def456   registry:2    Up 2 minutes   0.0.0.0:5000->5000/tcp   local-registry
```

**Tester le registry** :
```bash
curl http://localhost:5000/v2/
```

**Resultat attendu** :
```
{}
```

### Etape 3.12 : Construire l'image localement

**Action** : Construire votre image Docker

```bash
docker build -t mon-app:latest .
```

**Explication** :
- `-t mon-app:latest` : Tag de l'image (nom:version)
- `.` : Repertoire courant (ou se trouve le Dockerfile)

**Verification** :
```bash
docker images | grep mon-app
```

### Etape 3.13 : Tagger l'image pour le registry local

**Action** : Preparer l'image pour le registry local

```bash
docker tag mon-app:latest localhost:5000/mon-app:latest
```

**Explication** :
- `localhost:5000` : Adresse du registry local
- `mon-app:latest` : Nom et version de l'image dans le registry

**Verification** :
```bash
docker images | grep localhost:5000
```

### Etape 3.14 : Pousser l'image vers le registry local

**Action** : Envoyer l'image au registry local

```bash
docker push localhost:5000/mon-app:latest
```

**Resultat attendu** :
```
The push refers to repository [localhost:5000/mon-app]
abc123def456: Pushed
latest: digest: sha256:def456abc123... size: 1234
```

### Etape 3.15 : Verifier l'image dans le registry local

**Action** : Lister les images dans le registry local

```bash
curl http://localhost:5000/v2/_catalog
```

**Resultat attendu** :
```json
{"repositories":["mon-app"]}
```

**Lister les tags** :
```bash
curl http://localhost:5000/v2/mon-app/tags/list
```

**Resultat attendu** :
```json
{"name":"mon-app","tags":["latest"]}
```

### Etape 3.16 : Recuperer l'image depuis le registry local

**Action** : Tester de recuperer l'image depuis le registry local

**Supprimer l'image locale d'abord** :
```bash
docker rmi localhost:5000/mon-app:latest
docker rmi mon-app:latest
```

**Recuperer depuis le registry** :
```bash
docker pull localhost:5000/mon-app:latest
```

**Executer l'image** :
```bash
docker run --rm localhost:5000/mon-app:latest
```

### Etape 3.17 : Creer un script pour automatiser le processus

**Action** : Creer un script qui automatise build, tag et push

Creez un fichier `build-and-push-local.sh` (Linux/Mac) ou `build-and-push-local.bat` (Windows) :

**Pour Linux/Mac (build-and-push-local.sh)** :
```bash
#!/bin/bash
# Script pour construire et pousser une image vers le registry local

set -e

IMAGE_NAME="mon-app"
IMAGE_TAG="latest"
REGISTRY_URL="localhost:5000"

echo "============================================================"
echo "BUILD ET PUSH VERS REGISTRY LOCAL"
echo "============================================================"

# Verifier que le registry est demarre
if ! curl -s http://localhost:5000/v2/ > /dev/null; then
    echo "ERREUR : Le registry local n'est pas accessible"
    echo "Demarrez-le avec : docker-compose -f docker-compose-registry.yml up -d"
    exit 1
fi

echo "Registry local accessible"

# Construire l'image
echo "Construction de l'image..."
docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .

# Tagger pour le registry
echo "Tag de l'image pour le registry..."
docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${REGISTRY_URL}/${IMAGE_NAME}:${IMAGE_TAG}

# Pousser vers le registry
echo "Push vers le registry local..."
docker push ${REGISTRY_URL}/${IMAGE_NAME}:${IMAGE_TAG}

echo ""
echo "============================================================"
echo "SUCCES"
echo "============================================================"
echo "Image disponible sur : ${REGISTRY_URL}/${IMAGE_NAME}:${IMAGE_TAG}"
echo "Pour recuperer : docker pull ${REGISTRY_URL}/${IMAGE_NAME}:${IMAGE_TAG}"
```

**Pour Windows (build-and-push-local.bat)** :
```batch
@echo off
set IMAGE_NAME=mon-app
set IMAGE_TAG=latest
set REGISTRY_URL=localhost:5000

echo ============================================================
echo BUILD ET PUSH VERS REGISTRY LOCAL
echo ============================================================

REM Verifier que le registry est demarre
curl -s http://localhost:5000/v2/ >nul 2>&1
if errorlevel 1 (
    echo ERREUR : Le registry local n'est pas accessible
    echo Demarrez-le avec : docker-compose -f docker-compose-registry.yml up -d
    exit /b 1
)

echo Registry local accessible

REM Construire l'image
echo Construction de l'image...
docker build -t %IMAGE_NAME%:%IMAGE_TAG% .

REM Tagger pour le registry
echo Tag de l'image pour le registry...
docker tag %IMAGE_NAME%:%IMAGE_TAG% %REGISTRY_URL%/%IMAGE_NAME%:%IMAGE_TAG%

REM Pousser vers le registry
echo Push vers le registry local...
docker push %REGISTRY_URL%/%IMAGE_NAME%:%IMAGE_TAG%

echo.
echo ============================================================
echo SUCCES
echo ============================================================
echo Image disponible sur : %REGISTRY_URL%/%IMAGE_NAME%:%IMAGE_TAG%
echo Pour recuperer : docker pull %REGISTRY_URL%/%IMAGE_NAME%:%IMAGE_TAG%
```

**Rendre executable (Linux/Mac)** :
```bash
chmod +x build-and-push-local.sh
```

**Executer** :
```bash
# Linux/Mac
./build-and-push-local.sh

# Windows
build-and-push-local.bat
```

### Etape 3.18 : Gerer le registry local

**Voir les images dans le registry** :
```bash
curl http://localhost:5000/v2/_catalog
```

**Supprimer une image du registry** :
```bash
# Obtenir le digest de l'image
DIGEST=$(curl -s -I -H "Accept: application/vnd.docker.distribution.manifest.v2+json" \
  http://localhost:5000/v2/mon-app/manifests/latest | \
  grep Docker-Content-Digest | cut -d ' ' -f 2 | tr -d '\r')

# Supprimer l'image
curl -X DELETE http://localhost:5000/v2/mon-app/manifests/$DIGEST
```

**Arreter le registry** :
```bash
docker-compose -f docker-compose-registry.yml down
```

**Arreter et supprimer les donnees** :
```bash
docker-compose -f docker-compose-registry.yml down -v
```

---

## Verification

Avant de passer a l'etape suivante, verifiez que :

**Avec GitLab** :
- [ ] Le Dockerfile existe et est valide
- [ ] Le pipeline construit l'image avec succes
- [ ] L'image est poussee vers GitLab Container Registry
- [ ] L'image est visible dans le registry GitLab
- [ ] Vous pouvez recuperer l'image avec docker pull

**En local** :
- [ ] Le registry Docker local est demarre et accessible
- [ ] L'image est construite avec succes
- [ ] L'image est taggee pour le registry local
- [ ] L'image est poussee vers le registry local
- [ ] L'image est visible dans le registry (curl http://localhost:5000/v2/_catalog)
- [ ] Vous pouvez recuperer l'image depuis le registry local

## Problemes courants

### Erreur "unauthorized" lors du push vers GitLab

**Solution** :
- Verifiez que les variables $CI_REGISTRY_USER et $CI_REGISTRY_PASSWORD sont bien definies (elles le sont automatiquement par GitLab)
- Verifiez que le Container Registry est active dans les parametres du projet
- Verifiez que vous avez les permissions sur le projet

### Erreur lors du push vers le registry local

**Solution** :
- Verifiez que le registry est demarre : `docker ps | grep registry`
- Verifiez que le registry est accessible : `curl http://localhost:5000/v2/`
- Sur certains systemes, vous devrez peut-etre configurer Docker pour permettre les registries non securises :
  - Creer ou modifier `/etc/docker/daemon.json` :
    ```json
    {
      "insecure-registries": ["localhost:5000"]
    }
    ```
  - Redemarrer Docker

### L'image n'apparait pas dans GitLab Container Registry

**Solution** :
- Attendez quelques secondes et actualisez la page
- Verifiez les logs du pipeline pour voir s'il y a des erreurs
- Verifiez que le job build-docker-image a reussi

### Erreur "connection refused" pour le registry local

**Solution** :
- Verifiez que le registry est demarre : `docker-compose -f docker-compose-registry.yml ps`
- Verifiez que le port 5000 n'est pas deja utilise
- Consultez les logs : `docker-compose -f docker-compose-registry.yml logs`

### Erreur lors de la construction de l'image

**Solution** :
- Verifiez que le Dockerfile existe et est valide
- Verifiez que tous les fichiers necessaires sont presents (requirements.txt, app.py, etc.)
- Consultez les logs de construction : `docker build -t mon-app:latest .`

## Commandes utiles

**Construire une image** :
```bash
docker build -t mon-app:latest .
```

**Lister les images** :
```bash
docker images
```

**Tagger une image** :
```bash
docker tag mon-app:latest registry.gitlab.com/user/project:latest
```

**Pousser une image** :
```bash
docker push registry.gitlab.com/user/project:latest
```

**Recuperer une image** :
```bash
docker pull registry.gitlab.com/user/project:latest
```

**Supprimer une image** :
```bash
docker rmi mon-app:latest
```

**Voir les images dans le registry local** :
```bash
curl http://localhost:5000/v2/_catalog
```

**Voir les tags d'une image** :
```bash
curl http://localhost:5000/v2/mon-app/tags/list
```

## Notes importantes

- Le Container Registry permet de versionner et partager vos images Docker
- GitLab Container Registry est integre et facile a utiliser
- Un registry local permet de tout garder sur votre ordinateur (confidentialite)
- Les images sont versionnees avec des tags (latest, commit hash, etc.)
- Le registry local est utile pour le developpement et les tests

## Prochaine etape

Une fois cette etape validee, passez a :
[Etape 04 : Deploiement automatique](ETAPE-04-DEPLOIEMENT-AUTO.md)
