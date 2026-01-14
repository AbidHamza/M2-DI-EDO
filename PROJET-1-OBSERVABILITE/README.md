# Projet 1 : Observabilite DevOps avec ELK Stack

## Objectifs pedagogiques

A la fin de ce projet, vous saurez :
- Generer et structurer des donnees pour l'analyse
- Deployer une stack ELK avec Docker Compose
- Configurer Logstash pour traiter des donnees CSV
- Visualiser des donnees dans Kibana
- Creer un pipeline CI/CD avec GitLab CI/CD
- Containeriser une application avec Docker
- Deployer une application sur une plateforme gratuite

## Duree estimee

- Debutant : 5-6 heures
- Intermediaire : 3-4 heures

## Prérequis

- Compte GitLab cree et verifie
- Docker installe et fonctionnel
- Docker Compose installe
- Python 3.8+ installe
- 4 Go de RAM minimum disponibles
- Terminal/Shell fonctionnel

## Parcours d'apprentissage

### Etape 1 : Preparation (15-30 minutes)

Objectifs :
- Verifier l'installation de Docker
- Comprendre l'architecture du projet
- Preparer l'environnement de developpement

[Commencer l'etape 1](01-preparation/README.md)

### Etape 2 : Generation de donnees (30-45 minutes)

Objectifs :
- Creer un script Python pour generer des donnees
- Comprendre le format de donnees attendu
- Valider la structure des donnees generees

[Commencer l'etape 2](02-generation-donnees/README.md)

### Etape 3 : Stack ELK (1h-1h30)

Objectifs :
- Deployer Elasticsearch, Logstash et Kibana
- Configurer le pipeline de traitement
- Indexer les donnees dans Elasticsearch

[Commencer l'etape 3](03-stack-elk/README.md)

### Etape 4 : Visualisation Kibana (45 minutes-1h)

Objectifs :
- Creer des visualisations dans Kibana
- Explorer les donnees indexees
- Construire des dashboards de monitoring

[Commencer l'etape 4](04-visualisation-kibana/README.md)

### Etape 5 : CI/CD GitLab (1h-1h30)

Objectifs :
- Creer un pipeline GitLab CI/CD
- Automatiser les tests et le build
- Configurer le deploiement automatique

[Commencer l'etape 5](05-ci-cd-gitlab/README.md)

### Etape 6 : Containerisation (45 minutes-1h)

Objectifs :
- Creer un Dockerfile pour l'application
- Construire des images Docker optimisees
- Configurer Docker Compose pour la production

[Commencer l'etape 6](06-containerisation/README.md)

### Etape 7 : Deploiement gratuit (1h-1h30)

Objectifs :
- Deployer l'application sur une plateforme gratuite
- Configurer les variables d'environnement
- Mettre en place le monitoring

[Commencer l'etape 7](07-deploiement-gratuit/README.md)

## Structure du projet

Ce projet est organise en 7 etapes progressives. Chaque etape contient :

- README.md : Vue d'ensemble et objectifs de l'etape
- INSTRUCTIONS-PAS-A-PAS.md : Instructions detaillees numerotees
- VERIFICATION.md : Comment verifier que tout fonctionne
- PROBLEMES-SOLUTIONS.md : Solutions a tous les problemes courants
- SORTIE-ATTENDUE.md : Exemples de ce que vous devriez voir
- Scripts : Scripts automatises pour installation et verification

## Comment utiliser ce projet

1. Lisez ce README pour comprendre les objectifs
2. Suivez les etapes dans l'ordre (01, 02, 03...)
3. Lisez le README de chaque etape avant de commencer
4. Suivez les INSTRUCTIONS-PAS-A-PAS.md pour chaque etape
5. Validez chaque etape avec les scripts de verification avant de continuer
6. Consultez PROBLEMES-SOLUTIONS.md si vous rencontrez un probleme

## Validation finale

Une fois toutes les etapes terminees, vous devriez pouvoir :
- Generer des donnees de pollution
- Voir les donnees dans Elasticsearch
- Visualiser les donnees dans Kibana avec des dashboards
- Executer un pipeline GitLab CI/CD qui fonctionne
- Deployer l'application sur une plateforme gratuite

## Prochaines etapes

Apres ce projet, vous pouvez :
- Passer au Projet 2 : CI/CD DevSecOps
- Approfondir avec la documentation
- Personnaliser votre stack ELK
- Ajouter plus de fonctionnalites

## Ressources supplementaires

- [Architecture complete](docs/ARCHITECTURE-COMPLETE.md)
- [Concepts DevOps](docs/CONCEPTS-DEVOPS.md)
- [FAQ](docs/FAQ.md)

Bon apprentissage !

