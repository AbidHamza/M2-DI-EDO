# Phase 3 : Provisionnement avec Terraform

## Objectif de la phase

Automatiser le provisionnement de l'infrastructure avec Terraform. Cette phase fait partie de la Partie 3 du sujet d'examen (40 points).

## Rappels techniques essentiels

### Infrastructure as Code avec Terraform

Terraform permet de définir l'infrastructure en code :
- Déclaratif : décrit l'état désiré
- Idempotent : peut être exécuté plusieurs fois
- Versionné : infrastructure dans Git
- Multi-cloud : supporte AWS, Azure, GCP, etc.

### Concepts Terraform

- **Providers** : Plugins pour différentes plateformes
- **Resources** : Composants d'infrastructure à créer
- **Variables** : Paramètres configurables
- **Outputs** : Valeurs exportées
- **State** : État actuel de l'infrastructure
- **Modules** : Réutilisation de code

## Tâches du projet

### Étape 1 : Configuration Terraform de base

Créez la structure :
```
terraform/
├── main.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars
└── providers.tf
```

### Étape 2 : Provider et ressources

Configurez :
- Provider (local, AWS, Azure, ou GCP)
- Variables pour la configuration
- Resources nécessaires (serveurs, réseaux)

### Étape 3 : Modules (optionnel)

Créez des modules réutilisables si nécessaire.

### Étape 4 : Validation

Testez avec :
```bash
terraform init
terraform plan
terraform apply
```

## Livrable de la phase

- [ ] Scripts Terraform fonctionnels
- [ ] Infrastructure provisionnée (local ou cloud)
- [ ] Documentation des ressources créées

## Prochaine phase

Passez à la **Phase 4 : Configuration avec Ansible**.

