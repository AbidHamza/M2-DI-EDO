# Phase 4 : Configuration avec Ansible

## Objectif de la phase

Automatiser l'installation et la configuration des serveurs avec Ansible. Cette phase fait partie de la Partie 3 du sujet d'examen (40 points).

## Rappels techniques essentiels

### Configuration Management avec Ansible

Ansible automatise la configuration :
- Agentless : pas d'agent à installer
- Idempotent : résultat identique à chaque exécution
- Simple : syntaxe YAML
- Puissant : large écosystème de modules

### Concepts Ansible

- **Playbooks** : Fichiers YAML décrivant les tâches
- **Roles** : Réutilisation de configurations
- **Tasks** : Actions individuelles
- **Modules** : Tâches prédéfinies
- **Inventories** : Liste des serveurs
- **Variables** : Configuration

## Tâches du projet

### Étape 1 : Structure Ansible

Créez :
```
ansible/
├── playbooks/
│   ├── prometheus.yml
│   ├── grafana.yml
│   ├── loki.yml
│   └── alertmanager.yml
├── roles/
├── inventories/
│   └── hosts
└── group_vars/
```

### Étape 2 : Playbooks

Créez des playbooks pour :
- Installation de Docker
- Déploiement de Prometheus
- Déploiement de Grafana
- Déploiement de Loki
- Déploiement d'Alertmanager

### Étape 3 : Validation

Testez avec :
```bash
ansible-playbook -i inventory playbook.yml
```

## Livrable de la phase

- [ ] Playbooks Ansible fonctionnels
- [ ] Configuration automatisée
- [ ] Documentation des playbooks

## Prochaine phase

Passez à la **Phase 5 : Déploiement de Prometheus**.

