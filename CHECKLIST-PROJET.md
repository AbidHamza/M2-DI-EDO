# Checklist Complete du Projet

## Introduction

Cette checklist vous permet de suivre votre progression dans chaque projet. Cochez chaque element au fur et a mesure pour vous assurer de ne rien oublier.

## Projet 1 : Observabilite DevOps

### Etape 1 : Preparation

- [ ] Compte GitLab cree et verifie
- [ ] Git installe et configure
- [ ] Docker installe et fonctionnel
- [ ] Docker Compose installe
- [ ] Python 3.8+ installe
- [ ] Terminal/Shell fonctionnel
- [ ] Depot clone localement
- [ ] Script verify-setup.sh execute avec succes

### Etape 2 : Generation de donnees

- [ ] Script generate_data.py execute
- [ ] Fichier pollution_data.csv genere
- [ ] Fichier contient 1601 lignes (1 en-tete + 1600 donnees)
- [ ] Format CSV correct (date, ville, polluant, valeur)
- [ ] Toutes les villes presentes (Paris, Lyon, Marseille, Toulouse)
- [ ] Tous les polluants presents (NO2, O3, PM10, SO2)
- [ ] Script verify_data.py execute avec succes
- [ ] Aucune erreur dans la generation

### Etape 3 : Stack ELK

- [ ] Docker Compose fonctionne
- [ ] Fichier docker-compose.yml valide
- [ ] Conteneur Elasticsearch demarre
- [ ] Conteneur Kibana demarre
- [ ] Conteneur Logstash demarre
- [ ] Elasticsearch accessible sur http://localhost:9200
- [ ] Kibana accessible sur http://localhost:5601
- [ ] Logstash traite les donnees CSV
- [ ] Donnees indexees dans Elasticsearch
- [ ] Script verify-health.sh execute avec succes
- [ ] Aucune erreur dans les logs

### Etape 4 : Visualisation Kibana

- [ ] Kibana ouvert dans le navigateur
- [ ] Index "pollution-*" visible dans Kibana
- [ ] Au moins une visualisation creee
- [ ] Au moins un dashboard cree
- [ ] Donnees affichees correctement
- [ ] Requetes Elasticsearch fonctionnent
- [ ] Dashboard sauvegarde et exporte

### Etape 5 : CI/CD GitLab

- [ ] Fichier .gitlab-ci.yml cree
- [ ] Pipeline GitLab CI/CD configure
- [ ] Stage "validate" fonctionne
- [ ] Stage "build" fonctionne
- [ ] Stage "test" fonctionne
- [ ] Stage "deploy" configure (optionnel)
- [ ] Pipeline s'execute automatiquement
- [ ] Tous les jobs passent avec succes
- [ ] Variables GitLab CI/CD configurees si necessaire

### Etape 6 : Containerisation

- [ ] Dockerfile cree
- [ ] Dockerfile valide (pas d'erreurs)
- [ ] Image Docker construite avec succes
- [ ] Image Docker testee localement
- [ ] Docker Compose pour production cree
- [ ] Configuration de production valide

### Etape 7 : Deploiement gratuit

- [ ] Compte cree sur une plateforme de deploiement (Railway, Render, Fly.io)
- [ ] Application deployee avec succes
- [ ] Application accessible via URL publique
- [ ] Variables d'environnement configurees
- [ ] Application fonctionne en production
- [ ] Monitoring configure (optionnel)
- [ ] Domaine personnalise configure (optionnel)

### Validation finale Projet 1

- [ ] Toutes les etapes precedentes completees
- [ ] Application fonctionnelle en local
- [ ] Application deployee en production
- [ ] Pipeline CI/CD fonctionnel
- [ ] Documentation lue et comprise
- [ ] Tous les scripts de verification passent

## Projet 2 : CI/CD DevSecOps

### Etape 1 : GitLab CI/CD Basics

- [ ] Comprendre les concepts CI/CD
- [ ] Fichier .gitlab-ci.yml cree
- [ ] Premier pipeline execute avec succes
- [ ] Stages du pipeline compris

### Etape 2 : Security Scanning

- [ ] Outils de scan de securite installes
- [ ] Scan automatique configure dans le pipeline
- [ ] Vulnerabilites identifiees et corrigees
- [ ] Rapports de securite generes

### Etape 3 : Container Registry GitLab

- [ ] GitLab Container Registry configure
- [ ] Images Docker poussees vers le registry
- [ ] Images accessibles depuis le registry
- [ ] Images utilisees dans le deploiement

### Etape 4 : Deploiement automatique

- [ ] Pipeline de deploiement automatique configure
- [ ] Deploiement teste avec succes
- [ ] Rollback automatique configure (optionnel)

### Etape 5 : Monitoring gratuit

- [ ] Outils de monitoring installes
- [ ] Monitoring configure
- [ ] Alertes configurees (optionnel)
- [ ] Dashboards de monitoring crees

### Validation finale Projet 2

- [ ] Pipeline CI/CD complet fonctionnel
- [ ] Securite integree au pipeline
- [ ] Deploiement automatique fonctionnel
- [ ] Monitoring en place

## Lab0 : Equations differentielles

### Preparation

- [ ] Python installe
- [ ] Environnement virtuel cree
- [ ] Dependances installees
- [ ] Code lab0.py ouvert

### Exercices

- [ ] Exercice 1 complete
- [ ] Exercice 2 complete
- [ ] Exercice 3 complete
- [ ] Tous les exercices testes
- [ ] Resultats visualises

### Validation finale Lab0

- [ ] Tous les exercices completes
- [ ] Code fonctionne correctement
- [ ] Visualisations generees
- [ ] Comprends les concepts abordes

## Notes generales

- Cochez chaque element au fur et a mesure
- Ne passez pas a l'etape suivante si l'etape actuelle n'est pas complete
- Consultez les guides de depannage si vous etes bloque
- Validez toujours avec les scripts de verification avant de continuer

Bon apprentissage !

