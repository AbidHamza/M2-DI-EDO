# Correction Phase 1 : Premier pipeline GitLab CI

## Correction complète

### Fichier .gitlab-ci.yml

```yaml
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

### Explications

**stages** : Définit l'ordre d'exécution (build puis test)

**build** : Job dans le stage build
- Exécute les commandes dans `script`
- Construit l'image Docker

**test** : Job dans le stage test
- S'exécute après build
- Lance les tests

### Vérification

1. Commitez et poussez le fichier
2. Allez dans GitLab → CI/CD → Pipelines
3. Vérifiez que le pipeline s'exécute
4. Vérifiez que les jobs passent

