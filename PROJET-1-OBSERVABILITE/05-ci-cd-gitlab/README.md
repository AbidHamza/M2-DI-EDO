# Etape 5 : CI/CD avec GitLab CI/CD

## Objectif de cette etape

Creer un pipeline GitLab CI/CD qui automatise les tests, la construction et le deploiement de votre application.

Duree estimee : 1h-1h30

## Vue d'ensemble

Dans cette etape, vous allez :
1. Comprendre les concepts de CI/CD
2. Creer un fichier .gitlab-ci.yml
3. Configurer les stages du pipeline
4. Configurer les variables d'environnement
5. Tester le pipeline

## Prérequis

- Compte GitLab avec un projet cree
- Code pousse sur GitLab
- Comprendre les concepts de base de Git

## Concepts CI/CD

### CI (Continuous Integration)

L'integration continue consiste a :
- Integrer le code frequemment
- Executer des tests automatiques a chaque commit
- Detector les erreurs tot

### CD (Continuous Deployment)

Le deploiement continu consiste a :
- Deployer automatiquement apres validation
- Mettre en production sans intervention manuelle
- Rollback automatique en cas d'erreur

## Instructions

Pour des instructions detaillees pas a pas, consultez :
- [INSTRUCTIONS-PAS-A-PAS.md](INSTRUCTIONS-PAS-A-PAS.md)

Pour comprendre GitLab CI/CD en detail, consultez :
- [GITLAB-CI-EXPLIQUE.md](GITLAB-CI-EXPLIQUE.md)

Pour comprendre les concepts CI/CD, consultez :
- [CONCEPTS-CI-CD.md](CONCEPTS-CI-CD.md)

## Fichiers de cette etape

- .gitlab-ci.yml : Configuration du pipeline GitLab CI/CD
- INSTRUCTIONS-PAS-A-PAS.md : Guide pas a pas pour creer le pipeline
- GITLAB-CI-EXPLIQUE.md : Explication detaillee de GitLab CI/CD

## Structure du pipeline

Le pipeline est compose de 4 stages :

1. validate : Validation du code (syntaxe, style)
2. build : Construction de l'image Docker
3. test : Execution des tests
4. deploy : Deploiement en production (optionnel)

## Configuration des variables

Pour utiliser le pipeline, vous devez configurer des variables dans GitLab :

1. Allez sur votre projet GitLab
2. Settings → CI/CD → Variables
3. Ajoutez les variables necessaires :
   - RAILWAY_TOKEN (si vous utilisez Railway)
   - RAILWAY_PROJECT_ID (si vous utilisez Railway)
   - RAILWAY_DOMAIN (si vous utilisez Railway)

## Execution du pipeline

Le pipeline s'execute automatiquement :
- A chaque push sur les branches main ou develop
- A chaque merge request
- Manuellement depuis l'interface GitLab

## Verification

Avant de passer a l'etape suivante, verifiez que :
- [ ] Le fichier .gitlab-ci.yml existe a la racine du projet
- [ ] Le pipeline s'execute automatiquement a chaque push
- [ ] Les tests s'executent correctement
- [ ] L'image Docker est construite avec succes
- [ ] Les logs sont accessibles et lisibles

## Problemes courants

Si vous rencontrez des problemes, consultez :
- [PROBLEMES-SOLUTIONS.md](PROBLEMES-SOLUTIONS.md)

## Concepts abordes

Dans cette etape, vous apprendrez :
- Comment creer un pipeline CI/CD avec GitLab
- Comment automatiser les tests
- Comment automatiser le build et le deploiement
- Comment gerer les secrets de maniere securisee

## Prochaine etape

Une fois cette etape validee, passez a :
[Etape 6 : Containerisation](../06-containerisation/README.md)

## Ressources supplementaires

- [Documentation GitLab CI/CD](https://docs.gitlab.com/ee/ci/)
- [Reference .gitlab-ci.yml](https://docs.gitlab.com/ee/ci/yaml/)
- [Variables GitLab CI/CD](https://docs.gitlab.com/ee/ci/variables/)

