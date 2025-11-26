# Phase 4 – Intégration de SonarQube / SonarCloud

Cette phase consiste à brancher l’analyse statique dans votre pipeline GitLab CI pour que chaque commit passe par un Quality Gate. Vous pouvez utiliser SonarQube Community (Docker) ou SonarCloud.

## Objectif concret

- Disposer d’un serveur SonarQube (ou d’un projet SonarCloud) configuré.
- Ajouter un job `quality` dans `.gitlab-ci.yml` qui exécute `sonar-scanner`.
- Bloquer la pipeline si le Quality Gate échoue.

## Plan d’action

1. **Déployer ou choisir votre instance**
   - Option locale : `docker run -d -p 9000:9000 sonarqube:community`.
   - Option cloud : SonarCloud (gratuit pour repo public).

2. **Créer le projet Sonar**
   - Générez le token (Administrateur > Security).
   - Configurez les Quality Gates (couverture minimale, pas de vulnérabilités critiques, etc.).

3. **Configurer `sonar-project.properties` (si besoin)**
   - `sonar.projectKey`, `sonar.sources`, exclusions tests/venv, chemin du rapport de tests.

4. **Ajouter le job `sonarqube` dans GitLab CI**
   - Image `sonarsource/sonar-scanner-cli`.
   - Variables `SONARQUBE_URL`, `SONARQUBE_TOKEN` dans GitLab (protégées).
   - Cache `.sonar/cache`.
   - `allow_failure: false`.

5. **Consommer les rapports**
   - Vérifiez les issues, dettes techniques, couverture.
   - Ajoutez un badge Quality Gate dans le README si souhaité.

## Livrables attendus

- SonarQube opérationnel et accessible.
- Job `quality` exécuté automatiquement.
- Quality Gate configuré avec des seuils pertinents.
- Capture ou lien prouvant l’exécution de l’analyse.

## Exercice associé

`EXERCICE.md` détaille un exemple de pipeline avec SonarQube ainsi qu’un fichier `sonar-project.properties`. Reproduisez-le avant d’adapter la configuration à votre application. La **solution expliquée** se trouve dans `corrections/`.

## Checklist

- [ ] Token et URL stockés dans les variables GitLab.
- [ ] Job `sonarqube` présent dans `.gitlab-ci.yml`.
- [ ] Quality Gate empêche le déploiement en cas d’échec.
- [ ] Rapport Sonar consultable et partagé.

Ensuite, passez à la **Phase 5 – Terraform** pour provisionner l’infrastructure cible.*** End Patch

