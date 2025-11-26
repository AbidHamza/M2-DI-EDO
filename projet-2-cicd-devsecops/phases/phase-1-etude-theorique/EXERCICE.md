# Exercice Phase 1 : Premier pipeline GitLab CI

## Exercice à réaliser

Créez un pipeline GitLab CI simple pour comprendre les concepts de base.

## Correction complète

```yaml
# .gitlab-ci.yml
stages:
  - build
  - test

build:
  stage: build
  script:
    - echo "Building application..."
    - docker build -t myapp:latest .

test:
  stage: test
  script:
    - echo "Running tests..."
    - npm test
```

## Explications détaillées

**stages** : Définit l'ordre d'exécution des étapes

**build** : Job de build dans le stage build

**script** : Commandes à exécuter

**test** : Job de test dans le stage test

## Vérification

Commitez et poussez le fichier, vérifiez que le pipeline s'exécute dans GitLab.

