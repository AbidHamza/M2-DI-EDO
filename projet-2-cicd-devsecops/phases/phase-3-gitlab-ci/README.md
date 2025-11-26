# Phase 3 – Construction du pipeline GitLab CI

Vous allez créer le fichier `.gitlab-ci.yml` qui orchestrera l’ensemble de la chaîne DevSecOps. Cette phase est le socle des suivantes : un pipeline bien structuré facilite l’intégration de SonarQube, Terraform, Ansible et la gestion multi-environnements.

## Objectif concret

- Définir les stages (lint/test → quality → build/package → déploiement).
- Configurer les jobs avec images, variables, caches, artifacts et conditions (`only/when`).
- Préparer les hooks nécessaires pour exécuter SonarQube, Terraform et Ansible dans les phases suivantes.

## Plan d’action

1. **Structurer le pipeline**
   - Listez les stages nécessaires (ex : lint, test, quality, build, deploy, smoke).
   - Ajoutez des `variables` globales (versions, image Docker, chemin couverture).

2. **Stage QA (lint/test)**
   - Jobs utilisant une image Python/Node selon l’app.
   - Rapports junit/cobertura stockés en artifacts.
   - Calcul de la couverture (regex `coverage:`) si GitLab doit l’afficher.

3. **Stage Quality (SonarQube)**
   - Job `sonarqube` qui utilisera `sonarsource/sonar-scanner-cli`.
   - Cache `.sonar/cache` pour accélérer.
   - Variables `SONARQUBE_URL` et `SONARQUBE_TOKEN` (protégées).
   - `allow_failure: false` pour bloquer sur Quality Gate.

4. **Stage Build & Package**
   - Job Docker avec service `docker:dind`.
   - Login au registry GitLab (`CI_REGISTRY_USER/PASSWORD`).
   - Build + push de l’image taggée avec `CI_COMMIT_SHA` ou `CI_COMMIT_REF_SLUG`.

5. **Stage Deploy**
   - Job `deploy_dev` automatique (environnement `development`).
   - Job `deploy_prod` manuel (bouton, approbation).
   - Préparez l’appel à Terraform/Ansible (par exemple script shell ou déclenchement remote).

6. **Sécurité & conditions**
   - Utilisez `rules` ou `only/except` pour cibler `merge_requests`, `main`, `tags`.
   - Définissez des variables protégées pour secrets (SSH, tokens).

## Livrables attendus

- Fichier `.gitlab-ci.yml` versionné et documenté.
- Pipeline exécuté au moins une fois (preuve via screenshot ou lien).
- Artifacts de tests et logs disponibles dans GitLab.

## Exercice associé

`EXERCICE.md` décrit un pipeline minimal (lint/test/build/deploy) à réaliser avant d’implémenter la version complète. Faites-le pour valider vos runners et comprendre la structure. La **solution expliquée** est accessible dans `corrections/`.

## Checklist

- [ ] Tous les stages sont définis et ordonnés.
- [ ] Les jobs utilisent les bonnes images et variables.
- [ ] Les rapports de tests/coverage sont archivés.
- [ ] Les déploiements sont conditionnés (auto sur dev, manuel sur prod).
- [ ] Les secrets sont stockés côté GitLab Variables, pas dans le repo.

Une fois cette étape validée, passez à la **Phase 4 – Intégration de SonarQube** pour renforcer le contrôle qualité.*** End Patch

