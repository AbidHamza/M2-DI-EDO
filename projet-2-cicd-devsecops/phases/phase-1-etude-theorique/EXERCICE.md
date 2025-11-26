# Exercice Phase 1 – Pipeline GitLab CI minimal

## Objectif

Créer un fichier `.gitlab-ci.yml` avec deux stages (`lint`, `test`) pour comprendre le fonctionnement de base d’un pipeline.

## Étapes guidées

1. **Créer le fichier `.gitlab-ci.yml`**
   ```yaml
   stages:
     - lint
     - test
   ```

2. **Ajouter un job `lint`**
   ```yaml
   lint:
     stage: lint
     image: python:3.11
     script:
       - pip install black==23.12.1
       - black --check application-example
   ```

3. **Ajouter un job `test`**
   ```yaml
   test:
     stage: test
     image: python:3.11
     before_script:
       - pip install -r application-example/requirements.txt
     script:
       - pytest application-example/tests
     artifacts:
       paths:
         - junit.xml
       when: always
   ```

4. **Déclarer une variable**
   ```yaml
   variables:
     PIP_CACHE_DIR: "$CI_PROJECT_DIR/.cache/pip"
   ```

5. **Activer le cache (optionnel)**
   ```yaml
   cache:
     paths:
       - .cache/pip
   ```

6. **Commit/push et vérifier**
   - `git add .gitlab-ci.yml`
   - `git commit -m "chore: add minimal pipeline"`
   - `git push`
   - Ouvrez l’onglet *CI/CD > Pipelines* dans GitLab pour suivre l’exécution.

## Vérifications attendues

- Les deux jobs s’exécutent avec succès.
- Les artifacts (rapport de tests) sont disponibles au besoin.
- Les variables/caches apparaissent dans les logs.

## Solution expliquée

Le dossier `corrections/` contient un pipeline commenté et quelques variantes (utilisation de matrices, runners Docker). Déchiffrez-le après vos essais pour comparer votre approche.

## Pour aller plus loin

- Ajouter un stage `build` qui créé une image Docker et la stocke comme artifact.
- Définir des `rules` pour n’exécuter la pipeline que sur `merge_request` et `main`.
- Tester `gitlab-runner exec docker lint` en local pour comprendre le fonctionnement des runners.*** End Patch

