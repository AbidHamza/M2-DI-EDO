# Phase 4 – Configuration avec Ansible

Vous disposez désormais d’une infrastructure provisionnée. Cette phase consiste à industrialiser l’installation et la configuration des composants (application, Prometheus, Loki, Grafana, Alertmanager) à l’aide d’Ansible.

## Objectif concret

- Définir une hiérarchie Ansible propre (`playbooks/`, `roles/`, `inventories/`, `group_vars/`).
- Automatiser l’installation des prérequis (Docker, dépendances système).
- Déployer les conteneurs/services nécessaires avec la configuration adéquate.
- Préparer la réutilisation (environnements multiples, variables).

## Plan d’action recommandé

1. **Connecter Ansible aux ressources Terraform**
   - Récupérez les IPs/hosts depuis les outputs Terraform.
   - Créez un inventaire `inventories/dev/hosts` (et `staging`/`prod` si nécessaire).
   - Documentez le mode d’authentification (SSH key, user).

2. **Définir la structure de base**
   ```
   ansible/
   ├── playbooks/
   │   ├── setup.yml            # installation de base (Docker, utilisateurs…)
   │   └── observability.yml    # déploiement Prometheus/Grafana/Loki/Alertmanager
   ├── roles/
   │   ├── docker/
   │   ├── prometheus/
   │   ├── grafana/
   │   ├── loki/
   │   └── alertmanager/
   ├── inventories/
   │   ├── dev/hosts
   │   └── group_vars/
   └── ansible.cfg
   ```

3. **Créer les rôles**
   - `docker` : installation du moteur, configuration du daemon, redémarrage.
   - `prometheus`, `grafana`, `loki`, `alertmanager`, `app` : templates des fichiers de configuration, lancement de conteneurs, gestion des volumes/répertoires.
   - Utilisez les modules `docker_container`, `template`, `copy`, `file`, `systemd`.

4. **Gérer les variables**
   - `group_vars/all.yml` pour les paramètres globaux (versions, ports).
   - `host_vars` si certains serveurs ont des configurations spécifiques.
   - Variables sensibles via `ansible-vault` ou `.env`.

5. **Exécuter et tester**
   ```bash
   ansible-galaxy install -r requirements.yml   # si vous utilisez des rôles externes
   ansible-playbook -i inventories/dev/hosts playbooks/setup.yml
   ansible-playbook -i inventories/dev/hosts playbooks/observability.yml
   ```
   - Vérifiez l’idempotence : relancez le playbook et assurez-vous que les tâches sont `ok` (pas `changed` inutilement).

## Livrables attendus

- Dossier `ansible/` complet, structuré et versionné.
- Playbooks exécutables pour préparer les serveurs et déployer les composants.
- Documentation d’exécution (README dans `ansible/` indiquant prérequis, commandes, inventaires, variables).
- Preuve d’exécution (logs ou capture) montrant que les services tournent réellement.

## Exercice associé

`EXERCICE.md` propose de créer un playbook minimal pour installer Docker et déployer Prometheus. Réalisez-le sur une VM locale ou via Docker Desktop (mode SSH). La **solution expliquée** est située dans `corrections/`, à consulter après votre tentative.

## Checklist de fin de phase

- [ ] L’inventaire reflète les machines/VM créées via Terraform.
- [ ] Les playbooks peuvent être rejoués sans erreur (idempotence).
- [ ] Les rôles sont isolés et réutilisables (pas de gros playbook monolithique).
- [ ] Les fichiers sensibles sont gérés (vault, variables d’environnement).
- [ ] La documentation précise comment ajouter une nouvelle machine.

Quand tout est validé, passez aux phases 5 à 8 pour configurer chaque composant d’observabilité en détail (Prometheus, Loki, Grafana, Alertmanager) en vous appuyant sur les rôles Ansible créés ici.

