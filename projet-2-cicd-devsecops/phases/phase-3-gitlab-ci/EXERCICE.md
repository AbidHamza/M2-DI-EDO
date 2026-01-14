# Exercice Phase 3 – Pipeline à 4 stages

## Objectif

Écrire un `.gitlab-ci.yml` composé des stages suivants :
1. `lint`
2. `test`
3. `quality`
4. `deploy`

Chaque stage doit contenir au moins un job avec une image adaptée et un minimum de configuration.

## Étapes guidées

1. **Déclarer les stages**
   ```yaml
   stages:
     - lint
     - test
     - quality
     - deploy
   ```

2. **Job `lint`**
   - Image Python ou Node selon le projet.
   - Installation des dépendances nécessaires.
   - Exécution d’un linter (`black`, `flake8`, `eslint`…).

3. **Job `test`**
   - Même image que `lint` ou une image dédiée.
   - Installation des dépendances via `requirements.txt`.
   - Exécution des tests avec génération d’un rapport (junit/cobertura) stocké en artifact.

4. **Job `quality`**
   - Utilisez `sonarsource/sonar-scanner-cli`.
   - Variables `SONARQUBE_URL` et `SONARQUBE_TOKEN` à placer dans GitLab > Settings > CI/CD > Variables.
   - Ajoutez un cache `.sonar/cache`.

5. **Job `deploy`**
   - Job basique qui simule un déploiement (ex : `echo "Deploy step"`).
   - Conditionnez-le (ex : `only: ["main"]`) et marquez-le manuel si nécessaire (`when: manual`).

6. **Tester dans GitLab**
   - Commitez le fichier, poussez et vérifiez que la pipeline passe toutes les étapes.

## Vérification attendue

- Les 4 stages apparaissent dans GitLab.
- Les reports de tests sont disponibles en artifacts.
- Le job SonarQube se connecte et bloque en cas d’échec.
- Le job `deploy` respecte les conditions (`manual` ou `only`).

## Solution expliquée

Le dossier `corrections/` contient un `.gitlab-ci.yml` complet avec commentaires. Déchiffrez-le après votre tentative pour comparer vos choix (images, caches, variables, rules).

## Pour aller plus loin

- Ajouter un stage `scan` (Trivy, Snyk) entre `build` et `deploy`.
- Déclencher Terraform/Ansible dans `deploy`.
- Utiliser `rules` pour limiter la pipeline aux merge requests ou aux tags.*** End Patch

