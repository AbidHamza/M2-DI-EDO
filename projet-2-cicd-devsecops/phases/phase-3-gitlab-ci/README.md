# Phase 3 : Mise en place du pipeline GitLab CI

## Objectif de la phase

Créer le pipeline GitLab CI avec toutes les étapes nécessaires. Cette phase fait partie de la Partie 3 du sujet d'examen (40 points).

## Rappels techniques essentiels

### Structure d'un pipeline GitLab CI

Un pipeline se compose de :
- **Stages** : Étapes séquentielles
- **Jobs** : Tâches dans chaque stage
- **Variables** : Configuration
- **Artifacts** : Fichiers produits

### Étapes typiques

1. **Test** : Tests unitaires
2. **Build** : Compilation/construction
3. **Quality** : Analyse SonarQube
4. **Package** : Création Docker image
5. **Deploy** : Déploiement (Terraform + Ansible)

## Tâches du projet

### Étape 1 : Fichier .gitlab-ci.yml

Créez le fichier avec :
- Définition des stages
- Jobs pour chaque étape
- Variables nécessaires

### Étape 2 : Stage de tests

Implémentez :
- Tests unitaires
- Génération de rapports

### Étape 3 : Stage de build

Implémentez :
- Build de l'application
- Création d'image Docker
- Push vers registry

### Étape 4 : Stage de déploiement

Implémentez :
- Exécution Terraform
- Exécution Ansible
- Validation du déploiement

## Livrable de la phase

- [ ] Pipeline GitLab CI fonctionnel
- [ ] Toutes les étapes implémentées
- [ ] Pipeline exécuté avec succès

## Prochaine phase

Passez à la **Phase 4 : Intégration de SonarQube**.

