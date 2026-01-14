# Projet 2 : CI/CD DevSecOps

## Objectif du projet

Creer un pipeline CI/CD securise avec GitLab CI/CD, integrer des outils de scan de securite, et automatiser le deploiement securise.

## Duree estimee

3-4 heures

## Prérequis

- Compte GitLab avec un projet cree
- Docker installe
- Python 3.8+ installe
- Comprendre les concepts de base de Git

## Parcours complet - Etapes du projet

Ce projet est divise en 5 etapes progressives. Suivez-les dans l'ordre pour garantir votre succes.

### Etape 01 : Configuration GitLab CI/CD de base

**Objectif** : Creer un pipeline GitLab CI/CD basique

**Duree** : 30-45 minutes

**Ce que vous allez faire** :
- Creer un fichier .gitlab-ci.yml
- Configurer les stages de base (build, test)
- Tester le pipeline

[Guide complet de l'etape 01](ETAPE-01-GITLAB-CI-BASE.md)

### Etape 02 : Integration des outils de securite

**Objectif** : Integrer des outils de scan de securite dans le pipeline

**Duree** : 45 minutes-1h

**Ce que vous allez faire** :
- Configurer Trivy pour scanner les vulnerabilites
- Configurer Bandit pour scanner le code Python
- Integrer les scans dans le pipeline CI/CD

[Guide complet de l'etape 02](ETAPE-02-SECURITE.md)

### Etape 03 : GitLab Container Registry

**Objectif** : Utiliser GitLab Container Registry pour stocker les images Docker

**Duree** : 30-45 minutes

**Ce que vous allez faire** :
- Configurer GitLab Container Registry
- Pousser des images Docker vers le registry
- Utiliser les images depuis le registry

[Guide complet de l'etape 03](ETAPE-03-CONTAINER-REGISTRY.md)

### Etape 04 : Deploiement automatique

**Objectif** : Automatiser le deploiement apres validation des tests

**Duree** : 45 minutes-1h

**Ce que vous allez faire** :
- Configurer le deploiement automatique
- Ajouter des conditions de deploiement
- Tester le deploiement automatique

[Guide complet de l'etape 04](ETAPE-04-DEPLOIEMENT-AUTO.md)

### Etape 05 : Monitoring et alertes

**Objectif** : Mettre en place le monitoring et les alertes

**Duree** : 30-45 minutes

**Ce que vous allez faire** :
- Configurer le monitoring de l'application
- Mettre en place des alertes
- Visualiser les metriques

[Guide complet de l'etape 05](ETAPE-05-MONITORING.md)

## Validation finale

Apres avoir termine toutes les etapes, vous devriez avoir :
- Un pipeline CI/CD complet et securise
- Des scans de securite automatiques
- Un deploiement automatique fonctionnel
- Un monitoring en place

## Ressources supplementaires

- [Documentation GitLab CI/CD](https://docs.gitlab.com/ee/ci/)
- [Documentation Trivy](https://aquasecurity.github.io/trivy/)
- [Documentation Bandit](https://bandit.readthedocs.io/)

Bon apprentissage !
