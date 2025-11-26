# Phase 6 – Configuration et déploiement avec Ansible

Après le provisionnement, Ansible prend le relais pour installer les dépendances, déployer l’application et valider que tout fonctionne. Cette phase doit aboutir à des playbooks rejouables et intégrés dans GitLab CI.

## Objectif concret

- Structurer un dossier `ansible/` (inventaires, roles, playbooks).
- Automatiser l’installation (Docker, dépendances) et le déploiement de l’application.
- Relier Ansible à la pipeline (job `deploy`/`post-deploy`).

## Plan d’action

1. **Structure recommandée**
   ```
   ansible/
   ├── playbooks/
   │   ├── setup.yml        # installation de base
   │   └── deploy.yml       # déploiement applicatif
   ├── roles/
   │   ├── docker/
   │   └── app/
   ├── inventories/
   │   ├── dev/hosts
   │   └── prod/hosts
   ├── group_vars/
   └── ansible.cfg
   ```

2. **Rôles essentiels**
   - `docker` : installe Docker/compose, configure le service.
   - `app` : déploie l’image depuis le registry, gère les variables et health checks.

3. **Inventaires et variables**
   - `inventories/dev/hosts` (VM Terraform ou Docker local).
   - Variables pour ports, images, secrets (utiliser `ansible-vault` si besoin).

4. **Playbooks**
   - `setup.yml` : appliquer le rôle `docker` + prérequis.
   - `deploy.yml` : récupérer l’image (`docker_login`), lancer conteneur ou `docker-compose`, vérifier `/health`.

5. **Intégration GitLab CI**
   - Job `deploy_dev` lancer `ansible-playbook` via SSH (utiliser `SSH_PRIVATE_KEY` dans les variables).
   - Export des outputs Terraform → inventaire dynamique (option bonus).

6. **Validation**
   - `ansible-playbook -i inventories/dev playbooks/deploy.yml`.
   - Health check automatisé (module `uri`).

## Livrables attendus

- Dossier Ansible propre + documentation d’exécution.
- Playbooks rejouables (idempotents).
- Job pipeline utilisant Ansible (log d’exécution).
- Preuve de déploiement (capture, endpoint accessible).

## Exercice associé

`EXERCICE.md` vous guide pour écrire un playbook `deploy.yml` qui installe Docker, récupère l’image et lance le conteneur. Réalisez-le avant d’industrialiser votre propre rôle. La **solution expliquée** est dans `corrections/`.

## Checklist

- [ ] Inventaires pour au moins dev/staging.
- [ ] Rôles découpés (docker/app).
- [ ] Déploiement automatisé et vérifié (health check).
- [ ] Intégration pipeline (job `deploy_*`).
- [ ] Secrets Ansible sécurisés (Vault ou variables GitLab).

Vous pouvez maintenant passer à la **Phase 7 – Sécurisation de la chaîne** pour renforcer la gestion des secrets et des contrôles de sécurité.*** End Patch

