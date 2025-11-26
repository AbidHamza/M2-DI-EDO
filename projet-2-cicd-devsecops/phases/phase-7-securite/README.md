# Phase 7 – Sécurisation de la chaîne CI/CD

Cette phase renforce la sécurité : gestion des secrets, scans de dépendances/images et politiques de protection des branches/environnements.

## Objectif concret

- Définir un plan de gestion des secrets (GitLab variables protégées, Vault, Ansible Vault).
- Ajouter au pipeline des jobs de sécurité (Trivy, Snyk, GitLab Security scans).
- S’assurer que les logs pipeline ne divulguent jamais d’informations sensibles.

## Plan d’action

1. **Gestion des secrets**
   - Lister tous les secrets utilisés (tokens Sonar, clés Terraform, SSH, DB, etc.).
   - Stocker ces secrets dans GitLab CI/CD > Variables (Protected + Masked) ou dans Vault.
   - Utiliser `ansible-vault` pour les variables Ansible sensibles.

2. **Politique d’accès**
   - Restreindre les variables protégées aux branches `main`/`prod`.
   - Activer les approvals sur les environnements sensibles.
   - Auditer les permissions (runners, mainteneurs).

3. **Scans de sécurité**
   - Ajouter un job `dependency_scan` (npm audit, pip-audit, etc.).
   - Ajouter un job `container_scan` (Trivy sur l’image Docker).
   - Faire échouer le pipeline si des vulnérabilités critiques sont détectées.

4. **Validation**
   - Vérifier que les secrets n’apparaissent pas dans les logs.
   - Documenter les procédures de rotation de secrets.

## Livrables attendus

- Tableau ou doc listant les secrets + emplacement (GitLab variable, Vault, etc.).
- Jobs de scan intégrés au `.gitlab-ci.yml`.
- Preuves (logs, captures) montrant que les secrets ne sont pas exposés.

## Exercice associé

`EXERCICE.md` vous guide pour créer des variables protégées, utiliser `ansible-vault` et intégrer un job Trivy. Faites-le avant de sécuriser vos propres playbooks/pipelines. La **solution expliquée** se trouve dans `corrections/`.

## Checklist

- [ ] Toutes les clés/API sont stockées de façon chiffrée ou protégée.
- [ ] Les jobs de scan fail en cas de vulnérabilité critique.
- [ ] Aucune donnée sensible dans les logs pipeline.
- [ ] Procédures de rotation documentées.

Ensuite, passez à la **Phase 8 – Intégration complète** pour valider la chaîne bout en bout avec ces garanties de sécurité.*** End Patch

