# Rappels théoriques : Docker Avancé pour CI/CD

## Multi-stage builds pour CI/CD

### Optimisation des builds

**Exemple pour une application Python** :
```dockerfile
# Stage 1: Dependencies
FROM python:3.11-slim AS deps
WORKDIR /app
COPY requirements.txt .
RUN pip install --user -r requirements.txt

# Stage 2: Tests
FROM python:3.11-slim AS test
WORKDIR /app
COPY --from=deps /root/.local /root/.local
COPY . .
RUN pip install pytest && pytest

# Stage 3: Production
FROM python:3.11-slim AS production
WORKDIR /app
COPY --from=deps /root/.local /root/.local
COPY --from=test /app /app
ENV PATH=/root/.local/bin:$PATH
CMD ["python", "main.py"]
```

## Build arguments et secrets

### Build arguments

```dockerfile
ARG BUILD_VERSION
ARG GIT_COMMIT
LABEL version=$BUILD_VERSION
LABEL commit=$GIT_COMMIT
```

**Utilisation** :
```bash
docker build --build-arg BUILD_VERSION=1.0.0 -t myapp:1.0.0 .
```

### Secrets (BuildKit)

```dockerfile
# syntax=docker/dockerfile:1
FROM python:3.11
RUN --mount=type=secret,id=api_key \
    echo $API_KEY > /app/key.txt
```

**Utilisation** :
```bash
docker build --secret id=api_key,src=./api_key.txt .
```

## Intégration dans GitLab CI

### Build et push

```yaml
build:
  stage: build
  image: docker:latest
  services:
    - docker:dind
  script:
    - docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY
    - docker build -t $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA .
    - docker push $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA
```

### Cache Docker

```yaml
build:
  script:
    - docker build --cache-from $CI_REGISTRY_IMAGE:latest -t $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA .
```

## Exercices pratiques

### Exercice 1 : Multi-stage dans CI/CD

**Objectif** : Optimiser le build dans le pipeline.

**Tâches** :
1. Créez un Dockerfile multi-stage
2. Intégrez-le dans GitLab CI
3. Optimisez avec cache

**Solution** : Voir `corrections/EXERCICE-1-DOCKER-CICD.md.encrypted`

## Ressources supplémentaires

- [Docker Best Practices](https://docs.docker.com/develop/dev-best-practices/)
- [Docker BuildKit](https://docs.docker.com/develop/develop-images/build_enhancements/)

