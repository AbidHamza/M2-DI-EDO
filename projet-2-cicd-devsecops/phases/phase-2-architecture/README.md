# Phase 2 : Conception de l'architecture CI/CD

## Objectif de la phase

Concevoir l'architecture complète du pipeline CI/CD en intégrant tous les composants. Cette phase correspond à la Partie 2 du sujet d'examen (20 points).

## Rappels techniques essentiels

### Architecture de pipeline CI/CD

Un pipeline CI/CD suit un flux séquentiel :
1. **Source** : Commit dans Git
2. **Build** : Compilation/construction
3. **Test** : Tests unitaires, intégration
4. **Quality** : Analyse de code (SonarQube)
5. **Package** : Création d'artifacts (Docker images)
6. **Deploy** : Déploiement (Terraform + Ansible)

### Intégration des outils

**GitLab CI :**
- Orchestre le pipeline
- Exécute les jobs dans l'ordre
- Gère les artifacts
- Déclenche les déploiements

**SonarQube :**
- Analyse le code dans le pipeline
- Bloque si Quality Gate échoue
- Génère des rapports

**Terraform :**
- Provisionne l'infrastructure
- Gère les ressources cloud
- Intégré dans le pipeline

**Ansible :**
- Configure les serveurs
- Déploie l'application
- Exécuté après Terraform

## Tâches du projet

### Étape 1 : Schéma d'architecture du pipeline

Créez un schéma montrant :
- Toutes les étapes du pipeline
- Les interactions entre GitLab CI, SonarQube, Terraform, Ansible
- Les artifacts produits
- Les environnements cibles

### Étape 2 : Diagramme de séquence

Créez un diagramme montrant :
- Le flux d'exécution du pipeline
- Les interactions entre les outils
- Les points de décision (quality gates)
- Les notifications

### Étape 3 : Architecture d'environnement

Créez un schéma montrant :
- Environnements (dev, staging, prod)
- Infrastructure provisionnée
- Configuration des serveurs
- Déploiement de l'application

### Étape 4 : Description des interactions

Documentez :
- Comment GitLab CI déclenche SonarQube
- Comment Terraform provisionne l'infrastructure
- Comment Ansible déploie l'application
- Gestion des secrets

## Livrable de la phase

- [ ] Schéma d'architecture du pipeline
- [ ] Diagramme de séquence
- [ ] Architecture d'environnement
- [ ] Description des interactions
- [ ] Diagrammes UML si nécessaire

## Prochaine phase

Passez à la **Phase 3 : Mise en place du pipeline GitLab CI**.

