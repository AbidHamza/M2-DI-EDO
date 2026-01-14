# Etape 01 : Configuration GitLab CI/CD de base

## Objectif

Creer un pipeline GitLab CI/CD basique qui valide et construit votre application.

## Duree estimee

30-45 minutes

## Instructions pas a pas

### Etape 1.1 : Creer le fichier .gitlab-ci.yml

A la racine de votre projet, creez un fichier nomme `.gitlab-ci.yml` avec le contenu suivant :

```yaml
image: python:3.10

stages:
  - build
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

test-application:
  stage: test
  script:
    - echo "Installation des dependances de test"
    - pip install -r requirements.txt
    - pip install pytest
    - echo "Execution des tests"
    - python -m pytest tests/ || echo "Aucun test trouve"
  only:
    - merge_requests
    - main
```

### Etape 1.2 : Creer un fichier requirements.txt

Si vous n'avez pas encore de fichier requirements.txt, creez-le :

```txt
# Dependances de base
# Ajoutez vos dependances ici
```

### Etape 1.3 : Pousser sur GitLab

```bash
git add .gitlab-ci.yml requirements.txt
git commit -m "Ajout du pipeline GitLab CI/CD de base"
git push origin main
```

### Etape 1.4 : Verifier le pipeline

1. Allez sur votre projet GitLab
2. Cliquez sur "CI/CD" dans le menu de gauche
3. Cliquez sur "Pipelines"
4. Vous devriez voir votre pipeline en cours d'execution

### Etape 1.5 : Consulter les logs

1. Cliquez sur votre pipeline
2. Cliquez sur le job "build-application"
3. Consultez les logs pour voir l'execution

## Verification

Avant de passer a l'etape suivante, verifiez que :

- [ ] Le fichier .gitlab-ci.yml existe a la racine
- [ ] Le pipeline s'execute automatiquement
- [ ] Le stage "build" s'execute avec succes
- [ ] Les logs sont accessibles

## Problemes courants

### Le pipeline ne se declenche pas

**Solution** : Verifiez que le fichier s'appelle exactement `.gitlab-ci.yml` et qu'il est a la racine

### Erreur dans les logs

**Solution** : Consultez les logs detailles pour identifier l'erreur et corrigez-la

## Prochaine etape

Une fois cette etape validee, passez a :
[Etape 02 : Integration des outils de securite](ETAPE-02-SECURITE.md)
