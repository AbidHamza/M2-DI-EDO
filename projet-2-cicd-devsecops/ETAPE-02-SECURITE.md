# Etape 02 : Integration des outils de securite

## Objectif

Integrer des outils de scan de securite dans le pipeline CI/CD pour detecter les vulnerabilites automatiquement.

## Duree estimee

45 minutes-1h

## Instructions pas a pas

### Etape 2.1 : Ajouter le stage de securite

Modifiez votre fichier `.gitlab-ci.yml` pour ajouter un stage de securite :

```yaml
image: python:3.10

stages:
  - build
  - security
  - test

build-application:
  stage: build
  script:
    - echo "Installation des dependances"
    - pip install -r requirements.txt
    - echo "Build termine avec succes"
  only:
    - main
    - develop

# Scan de securite avec Bandit (code Python)
security-bandit:
  stage: security
  script:
    - echo "Installation de Bandit"
    - pip install bandit
    - echo "Scan du code Python avec Bandit"
    - bandit -r . -f json -o bandit-report.json || true
    - cat bandit-report.json
  artifacts:
    reports:
      sast: bandit-report.json
    paths:
      - bandit-report.json
    expire_in: 1 week
  only:
    - merge_requests
    - main

# Scan de vulnerabilites avec Trivy (images Docker)
security-trivy:
  stage: security
  image: aquasec/trivy:latest
  script:
    - echo "Scan des vulnerabilites avec Trivy"
    - trivy fs --exit-code 0 --severity HIGH,CRITICAL --format json -o trivy-report.json . || true
    - cat trivy-report.json
  artifacts:
    reports:
      container_scanning: trivy-report.json
    paths:
      - trivy-report.json
    expire_in: 1 week
  only:
    - merge_requests
    - main
  allow_failure: true

test-application:
  stage: test
  script:
    - echo "Execution des tests"
    - pip install -r requirements.txt
    - pip install pytest
    - python -m pytest tests/ || echo "Aucun test trouve"
  only:
    - merge_requests
    - main
```

### Etape 2.2 : Pousser les modifications

```bash
git add .gitlab-ci.yml
git commit -m "Ajout des scans de securite au pipeline"
git push origin main
```

### Etape 2.3 : Verifier les scans

1. Allez sur votre projet GitLab
2. Cliquez sur "CI/CD" → "Pipelines"
3. Cliquez sur votre pipeline
4. Verifiez que les jobs de securite s'executent
5. Consultez les rapports generes

### Etape 2.4 : Consulter les rapports de securite

1. Dans GitLab, allez sur "Security" → "Vulnerability Report"
2. Vous devriez voir les vulnerabilites detectees (s'il y en a)
3. Analysez les resultats et corrigez les problemes critiques

## Verification

Avant de passer a l'etape suivante, verifiez que :

- [ ] Le stage "security" est ajoute au pipeline
- [ ] Les scans Bandit et Trivy s'executent
- [ ] Les rapports sont generes et accessibles
- [ ] Les vulnerabilites sont visibles dans GitLab Security

## Problemes courants

### Bandit ne trouve pas de fichiers

**Solution** : Verifiez que vous avez des fichiers Python dans votre projet

### Trivy echoue

**Solution** : C'est normal si vous n'avez pas de Dockerfile. Le job est configure avec `allow_failure: true`

### Les rapports ne s'affichent pas

**Solution** : Attendez quelques minutes et actualisez la page. Verifiez aussi le format des rapports (JSON)

## Prochaine etape

Une fois cette etape validee, passez a :
[Etape 03 : GitLab Container Registry](ETAPE-03-CONTAINER-REGISTRY.md)
