# Etape 3 : Stack ELK

## Objectif de cette etape

Deployer une stack ELK (Elasticsearch, Logstash, Kibana) avec Docker Compose pour traiter et visualiser les donnees generees.

Duree estimee : 1h-1h30

## Vue d'ensemble

Dans cette etape, vous allez :
1. Comprendre l'architecture de la stack ELK
2. Configurer Docker Compose pour deployer les services
3. Configurer Logstash pour traiter les donnees CSV
4. Indexer les donnees dans Elasticsearch
5. Acceder a Kibana pour visualiser les donnees

## Prérequis

- Docker installe et fonctionnel (etape 1 validee)
- Docker Compose installe
- Fichier pollution_data.csv genere (etape 2 validee)
- 4 Go de RAM minimum disponibles

## Architecture

La stack ELK est composee de trois composants principaux :

- Elasticsearch : Base de donnees de recherche et d'analyse
- Logstash : Pipeline de traitement de donnees
- Kibana : Interface de visualisation et d'analyse

Flux de donnees :
1. Logstash lit le fichier CSV
2. Logstash transforme les donnees
3. Logstash envoie les donnees a Elasticsearch
4. Kibana lit les donnees depuis Elasticsearch
5. Vous visualisez les donnees dans Kibana

## Instructions

Pour des instructions detaillees pas a pas, consultez :
- [INSTRUCTIONS-PAS-A-PAS.md](INSTRUCTIONS-PAS-A-PAS.md)

Pour comprendre l'architecture, consultez :
- [ARCHITECTURE.md](ARCHITECTURE.md)

Pour comprendre Docker Compose, consultez :
- [DOCKER-EXPLIQUE.md](DOCKER-EXPLIQUE.md)

Pour comprendre Logstash, consultez :
- [LOGSTASH-EXPLIQUE.md](LOGSTASH-EXPLIQUE.md)

## Fichiers de cette etape

- docker-compose.yml : Configuration Docker Compose pour la stack ELK
- logstash/logstash.conf : Configuration du pipeline Logstash
- scripts/start.sh : Script de demarrage de la stack
- scripts/stop.sh : Script d'arret de la stack
- scripts/verify-health.sh : Script de verification de la sante des services

## Demarrage rapide

Pour demarrer la stack ELK :

```bash
cd PROJET-1-OBSERVABILITE/03-stack-elk
docker-compose up -d
```

Pour arreter la stack ELK :

```bash
docker-compose down
```

Pour voir les logs :

```bash
docker-compose logs -f
```

## Acces aux services

Une fois la stack demarree, vous pouvez acceder a :

- Elasticsearch : http://localhost:9200
- Kibana : http://localhost:5601
- Logstash : Port 5044 (pour recevoir des donnees)

## Verification

Avant de passer a l'etape suivante, verifiez que :
- [ ] Tous les conteneurs sont demarres (docker-compose ps)
- [ ] Elasticsearch est accessible (curl http://localhost:9200)
- [ ] Kibana est accessible (http://localhost:5601)
- [ ] Les donnees sont indexees dans Elasticsearch
- [ ] Le script verify-health.sh passe sans erreur

## Problemes courants

Si vous rencontrez des problemes, consultez :
- [PROBLEMES-SOLUTIONS.md](PROBLEMES-SOLUTIONS.md)

## Concepts abordes

Dans cette etape, vous apprendrez :
- Comment deployer plusieurs services avec Docker Compose
- Comment configurer un pipeline de traitement de donnees
- Comment indexer des donnees dans Elasticsearch
- Comment utiliser Kibana pour explorer les donnees

## Prochaine etape

Une fois cette etape validee, passez a :
[Etape 4 : Visualisation Kibana](../04-visualisation-kibana/README.md)

