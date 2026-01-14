# Phase 8 – Intégration complète du pipeline

Vous assemblez maintenant tous les composants : pipeline GitLab CI, contrôles qualité, provisionnement Terraform, déploiement Ansible, scans de sécurité. L’objectif est d’exécuter un run “du commit à la prod” et de collecter les preuves.

## Objectif concret

- Déclencher une pipeline complète à partir d’un commit ou d’une merge request.
- Vérifier que chaque stage s’exécute et que l’application est déployée sur l’environnement cible.
- Documenter les résultats (captures, rapports, logs).

## Plan d’action

1. **Pipeline complet**
   - Confirmez que `.gitlab-ci.yml` contient tous les stages (lint/test → quality → build → provision → deploy → verify).
   - Assurez-vous que les variables/secrets nécessaires sont définis.

2. **Run end-to-end**
   - Créez une branche de test, poussez un commit.
   - Suivez le pipeline dans GitLab (CI/CD > Pipelines).
   - Vérifiez les stages un par un (test, SonarQube, build Docker, Terraform, Ansible, health check).

3. **Preuves**
   - Captures du pipeline vert, du Quality Gate, de l’application accessible.
   - Export des logs clés (Terraform plan/apply, Ansible deploy).

4. **Rapport**
   - Documentez les scénarios testés (ex : pipeline sur MR, sur main, rollback).
   - Mentionnez les incidents rencontrés et comment ils ont été résolus.

## Livrables attendus

- Pipeline fonctionnelle bout en bout (lien GitLab ou capture).
- Tableau de tests end-to-end (scénario, résultat, date).
- Dossier `evidence/` ou section du rapport avec les captures (pipeline, SonarQube, application).

## Exercice associé

`EXERCICE.md` propose un scénario d’intégration guidé (pipeline exemple + checklist). Suivez-le pour valider votre environment avant de lancer les tests officiels. La **solution expliquée** se trouve dans `corrections/`.

## Checklist

- [ ] Commit → pipeline → déploiement → application accessible.
- [ ] Quality Gate respecté (pipeline bloque sinon).
- [ ] Terraform applique sans erreur et Ansible déploie l’image générée.
- [ ] Scans de sécurité exécutés.
- [ ] Preuves collectées (captures + logs).

Ensuite, passez à la **Phase 9 – Multi-environnements** pour gérer dev/staging/prod et la promotion entre ces environnements.*** End Patch

