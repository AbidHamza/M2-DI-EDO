# Projet 2 : CI/CD DevSecOps

## Objectif du projet

Creer un pipeline CI/CD securise avec GitLab CI/CD, integrer des outils de scan de securite (Bandit, Trivy, SonarQube), et automatiser le deploiement securise. Ce projet peut etre realise entierement en local pour garantir la confidentialite.

## Duree estimee

3-4 heures (avec GitLab)
4-5 heures (en local avec tous les outils)

## Prérequis

- Compte GitLab avec un projet cree (pour la partie GitLab)
- Docker installe
- Python 3.8+ installe
- Comprendre les concepts de base de Git
- 4 Go de RAM minimum (pour SonarQube et les outils de monitoring locaux)

## Deux approches possibles

Ce projet propose deux approches pour chaque etape :
1. **Avec GitLab CI/CD** : Utilise les fonctionnalites integrees de GitLab
2. **En local** : Tout fonctionne sur votre ordinateur (confidentialite garantie)

Vous pouvez choisir l'approche qui vous convient le mieux, ou combiner les deux selon vos besoins.

## Parcours complet - Etapes du projet

Ce projet est divise en 5 etapes progressives. Suivez-les dans l'ordre pour garantir votre succes.

### Etape 01 : Configuration CI/CD de base

**Objectif** : Creer un pipeline CI/CD basique qui s'execute en local ou avec GitLab

**Duree** : 30-45 minutes

**Ce que vous allez faire** :
- Creer un pipeline CI/CD local avec scripts shell/batch
- Ou configurer GitLab CI/CD avec .gitlab-ci.yml
- Configurer les stages de base (build, test)
- Tester le pipeline

**Outils utilises** :
- Scripts shell (Linux/Mac) ou batch (Windows)
- GitLab CI/CD (optionnel)

[Guide complet de l'etape 01](ETAPE-01-GITLAB-CI-BASE.md)

### Etape 02 : Integration des outils de securite

**Objectif** : Integrer des outils de scan de securite dans le pipeline

**Duree** : 45 minutes-1h (avec GitLab), 1h-1h30 (en local avec SonarQube)

**Ce que vous allez faire** :
- Configurer Bandit pour scanner le code Python
- Configurer Trivy pour scanner les vulnerabilites Docker
- Configurer SonarQube pour l'analyse de qualite de code
- Integrer les scans dans le pipeline CI/CD (GitLab ou local)
- Consulter et analyser les rapports generes

**Outils utilises** :
- Bandit (scan de securite Python)
- Trivy (scan de vulnerabilites)
- SonarQube (analyse de qualite de code)

[Guide complet de l'etape 02](ETAPE-02-SECURITE.md)

### Etape 03 : Container Registry

**Objectif** : Utiliser un Container Registry pour stocker les images Docker

**Duree** : 30-45 minutes (avec GitLab), 45 minutes-1h (en local)

**Ce que vous allez faire** :
- Configurer GitLab Container Registry (optionnel)
- Ou deployer un registry Docker local
- Construire des images Docker
- Pousser et recuperer des images depuis le registry
- Gerer les versions d'images avec des tags

**Outils utilises** :
- GitLab Container Registry (optionnel)
- Registry Docker local
- Docker et Docker Compose

[Guide complet de l'etape 03](ETAPE-03-CONTAINER-REGISTRY.md)

### Etape 04 : Deploiement automatique

**Objectif** : Automatiser le deploiement apres validation des tests

**Duree** : 45 minutes-1h (avec GitLab et plateforme externe), 30-45 minutes (deploiement local)

**Ce que vous allez faire** :
- Configurer le deploiement automatique avec GitLab CI/CD (optionnel)
- Ou creer un script de deploiement local
- Deployer sur Railway, Render, ou Fly.io (optionnel)
- Ou deployer localement avec Docker Compose
- Configurer les conditions de deploiement

**Outils utilises** :
- GitLab CI/CD (optionnel)
- Railway.app, Render.com, ou Fly.io (optionnel)
- Docker Compose (pour deploiement local)

[Guide complet de l'etape 04](ETAPE-04-DEPLOIEMENT-AUTO.md)

### Etape 05 : Monitoring et alertes

**Objectif** : Mettre en place le monitoring et les alertes

**Duree** : 30-45 minutes (avec GitLab), 45 minutes-1h (monitoring local complet)

**Ce que vous allez faire** :
- Configurer le monitoring GitLab integre (optionnel)
- Ou deployer Prometheus et Grafana localement
- Configurer Uptime Kuma pour le monitoring de disponibilite
- Creer des dashboards de visualisation
- Configurer des alertes (email, webhook, etc.)

**Outils utilises** :
- GitLab Monitoring (optionnel)
- Prometheus (collecte de metriques)
- Grafana (visualisation)
- Uptime Kuma (monitoring de disponibilite)

[Guide complet de l'etape 05](ETAPE-05-MONITORING.md)

## Validation finale

Apres avoir termine toutes les etapes, vous devriez avoir :

**Avec GitLab** :
- Un pipeline CI/CD complet et securise
- Des scans de securite automatiques (Bandit, Trivy, SonarQube)
- Un Container Registry avec vos images Docker
- Un deploiement automatique fonctionnel
- Un monitoring en place avec alertes

**En local** :
- Un pipeline CI/CD local complet avec scripts
- Des scans de securite locaux (Bandit, Trivy, SonarQube)
- Un registry Docker local avec vos images
- Un deploiement local fonctionnel
- Un monitoring local complet (Prometheus, Grafana, Uptime Kuma)

## Structure du projet

Votre projet devrait avoir cette structure apres toutes les etapes :

```
projet-devsecops/
├── app.py                          # Application Python principale
├── requirements.txt                # Dependances Python
├── Dockerfile                      # Configuration Docker
├── docker-compose.yml              # Configuration Docker Compose
├── docker-compose-registry.yml     # Registry Docker local
├── docker-compose-monitoring.yml   # Monitoring local
├── docker-compose-deploy.yml       # Deploiement local
├── prometheus.yml                  # Configuration Prometheus
├── sonar-project.properties        # Configuration SonarQube
├── .gitlab-ci.yml                  # Pipeline GitLab CI/CD (optionnel)
├── build.sh / build.bat            # Script de build local
├── test.sh / test.bat              # Script de test local
├── scan-security.sh / scan-security.bat  # Script de scan securite
├── build-and-push-local.sh / build-and-push-local.bat  # Build et push Docker
├── deploy-local.sh / deploy-local.bat     # Deploiement local
├── start-monitoring.sh / start-monitoring.bat  # Demarrage monitoring
├── pipeline-local.sh / pipeline-local.bat     # Pipeline local complet
└── tests/
    └── test_app.py                 # Tests unitaires
```

## Ressources supplementaires

**Documentation officielle** :
- [Documentation GitLab CI/CD](https://docs.gitlab.com/ee/ci/)
- [Documentation Trivy](https://aquasecurity.github.io/trivy/)
- [Documentation Bandit](https://bandit.readthedocs.io/)
- [Documentation SonarQube](https://docs.sonarqube.org/)
- [Documentation Prometheus](https://prometheus.io/docs/)
- [Documentation Grafana](https://grafana.com/docs/)

**Outils gratuits utilises** :
- Bandit : Scanner de securite Python (gratuit et open source)
- Trivy : Scanner de vulnerabilites (gratuit et open source)
- SonarQube Community Edition : Analyse de qualite de code (gratuit et open source)
- Prometheus : Systeme de monitoring (gratuit et open source)
- Grafana : Visualisation de metriques (gratuit et open source)
- Uptime Kuma : Monitoring de disponibilite (gratuit et open source)

## Notes importantes

- Toutes les etapes peuvent etre realisees en local pour garantir la confidentialite
- Les outils utilises sont tous gratuits et open source
- Le deploiement externe est optionnel, vous pouvez tout garder en local
- Les guides sont detailles avec des explications pas a pas
- Chaque etape inclut des solutions aux problemes courants

## Confidentialite

Si vous choisissez l'approche locale :
- Aucune donnee n'est envoyee sur Internet
- Tout fonctionne sur votre ordinateur
- Les images Docker restent dans votre registry local
- Les metriques sont collectees localement
- La confidentialite est garantie a 100%

Bon apprentissage !
