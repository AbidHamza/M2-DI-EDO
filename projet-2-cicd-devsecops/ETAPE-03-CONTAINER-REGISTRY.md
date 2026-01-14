# Etape 03 : GitLab Container Registry

## Objectif

Utiliser GitLab Container Registry pour stocker et gerer vos images Docker de maniere securisee.

## Duree estimee

30-45 minutes

## Instructions pas a pas

### Etape 3.1 : Creer un Dockerfile

Si vous n'avez pas encore de Dockerfile, creez-le :

```dockerfile
FROM python:3.10-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD ["python", "app.py"]
```

### Etape 3.2 : Modifier le pipeline pour utiliser GitLab Container Registry

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

### Etape 3.3 : Activer GitLab Container Registry

1. Allez sur votre projet GitLab
2. Settings → General → Visibility, project features, permissions
3. Activez "Container Registry"
4. Sauvegardez

### Etape 3.4 : Pousser les modifications

```bash
git add .gitlab-ci.yml Dockerfile
git commit -m "Ajout de GitLab Container Registry"
git push origin main
```

### Etape 3.5 : Verifier l'image dans le registry

1. Allez sur votre projet GitLab
2. Cliquez sur "Packages & Registries" → "Container Registry"
3. Vous devriez voir votre image avec le tag du commit

### Etape 3.6 : Utiliser l'image

Vous pouvez maintenant utiliser votre image depuis n'importe ou :

```bash
docker pull registry.gitlab.com/votre-username/votre-projet:latest
```

## Verification

Avant de passer a l'etape suivante, verifiez que :

- [ ] Le Dockerfile existe et est valide
- [ ] Le pipeline construit l'image avec succes
- [ ] L'image est poussee vers GitLab Container Registry
- [ ] L'image est visible dans le registry

## Problemes courants

### Erreur "unauthorized"

**Solution** : Verifiez que les variables $CI_REGISTRY_USER et $CI_REGISTRY_PASSWORD sont bien definies (elles le sont automatiquement par GitLab)

### Erreur lors du push

**Solution** : Verifiez que le Container Registry est active dans les parametres du projet

### L'image n'apparait pas

**Solution** : Attendez quelques secondes et actualisez la page

## Prochaine etape

Une fois cette etape validee, passez a :
[Etape 04 : Deploiement automatique](ETAPE-04-DEPLOIEMENT-AUTO.md)
