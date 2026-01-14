# Projet 1 : Observabilite DevOps avec ELK Stack

## Objectif du projet

Mettre en place une infrastructure complete d'observabilite avec la stack ELK (Elasticsearch, Logstash, Kibana) pour monitorer et analyser des donnees de pollution atmospherique.

## Duree estimee

- Debutant : 5-6 heures
- Intermediaire : 3-4 heures

## Prérequis

- Docker installe et fonctionnel
- Docker Compose installe
- Python 3.8+ installe
- 4 Go de RAM minimum disponibles

## Parcours complet - Etapes du projet

Ce projet est divise en 7 etapes progressives. Suivez-les dans l'ordre pour garantir votre succes.

### Etape 01 : Preparation de l'environnement

**Objectif** : Installer et configurer Docker pour deployer la stack ELK

**Duree** : 15-30 minutes

**Ce que vous allez faire** :
- Verifier l'installation de Docker
- Installer Docker si necessaire
- Tester que Docker fonctionne correctement

[Guide complet de l'etape 01](ETAPE-01-PREPARATION.md)

### Etape 02 : Generation de donnees

**Objectif** : Creer un script Python pour generer des donnees de test realistes

**Duree** : 30-45 minutes

**Ce que vous allez faire** :
- Creer un script Python pour generer des donnees CSV
- Generer des donnees de pollution pour plusieurs villes
- Valider la structure des donnees generees

[Guide complet de l'etape 02](ETAPE-02-GENERATION-DONNEES.md)

### Etape 03 : Deploiement de la stack ELK

**Objectif** : Deployer Elasticsearch, Logstash et Kibana avec Docker Compose

**Duree** : 1h-1h30

**Ce que vous allez faire** :
- Configurer Docker Compose pour la stack ELK
- Configurer Logstash pour traiter les donnees CSV
- Indexer les donnees dans Elasticsearch
- Acceder a Kibana

[Guide complet de l'etape 03](ETAPE-03-STACK-ELK.md)

### Etape 04 : Visualisation avec Kibana

**Objectif** : Creer des visualisations et des dashboards dans Kibana

**Duree** : 45 minutes-1h

**Ce que vous allez faire** :
- Explorer les donnees indexees dans Elasticsearch
- Creer des visualisations dans Kibana
- Construire des dashboards de monitoring

[Guide complet de l'etape 04](ETAPE-04-VISUALISATION-KIBANA.md)

### Etape 05 : CI/CD avec GitLab

**Objectif** : Creer un pipeline GitLab CI/CD pour automatiser les tests et le deploiement

**Duree** : 1h-1h30

**Ce que vous allez faire** :
- Creer un fichier .gitlab-ci.yml
- Configurer les stages du pipeline (validate, build, test, deploy)
- Automatiser les tests et le build
- Configurer le deploiement automatique

[Guide complet de l'etape 05](ETAPE-05-CICD-GITLAB.md)

### Etape 06 : Containerisation

**Objectif** : Creer un Dockerfile pour containeriser l'application

**Duree** : 45 minutes-1h

**Ce que vous allez faire** :
- Creer un Dockerfile optimise
- Construire une image Docker
- Tester l'image localement

[Guide complet de l'etape 06](ETAPE-06-CONTAINERISATION.md)

### Etape 07 : Deploiement gratuit

**Objectif** : Deployer l'application sur une plateforme gratuite

**Duree** : 1h-1h30

**Ce que vous allez faire** :
- Choisir une plateforme de deploiement gratuite (Railway, Render, Fly.io)
- Configurer le deploiement
- Deployer l'application
- Verifier que l'application fonctionne

[Guide complet de l'etape 07](ETAPE-07-DEPLOIEMENT.md)

## Validation finale

Apres avoir termine toutes les etapes, vous devriez avoir :
- Une application de monitoring fonctionnelle
- Une stack ELK deployee et operationnelle
- Des dashboards Kibana crees
- Un pipeline CI/CD fonctionnel
- Une application deployee en production

## Ressources supplementaires

- [Documentation Elasticsearch](https://www.elastic.co/guide/en/elasticsearch/reference/current/index.html)
- [Documentation Logstash](https://www.elastic.co/guide/en/logstash/current/index.html)
- [Documentation Kibana](https://www.elastic.co/guide/en/kibana/current/index.html)
- [Documentation GitLab CI/CD](https://docs.gitlab.com/ee/ci/)

Bon apprentissage !
