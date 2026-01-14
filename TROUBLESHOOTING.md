# Guide de Depannage Global

## Introduction

Ce guide vous aide a resoudre les problemes courants que vous pourriez rencontrer lors de l'utilisation de ce depot. Si vous etes bloque, consultez d'abord ce guide avant de chercher ailleurs.

## Probleme : Git n'est pas installe

### Symptomes
- La commande `git --version` retourne une erreur
- Message "git: command not found"

### Solutions

Windows :
1. Telechargez Git depuis https://git-scm.com/download/win
2. Installez avec les options par defaut
3. Redemarrez votre terminal

Linux :
```bash
sudo apt-get update
sudo apt-get install git
```

macOS :
```bash
brew install git
```

## Probleme : Docker n'est pas installe ou ne fonctionne pas

### Symptomes
- La commande `docker --version` retourne une erreur
- Message "Cannot connect to the Docker daemon"

### Solutions

Consultez le guide detaille :
- [Guide d'installation Docker](PROJET-1-OBSERVABILITE/01-preparation/GUIDE-INSTALLATION.md)

Solutions rapides :

Windows :
- Verifiez que Docker Desktop est lance
- Redemarrez Docker Desktop si necessaire

Linux :
```bash
sudo systemctl start docker
sudo usermod -aG docker $USER
# Deconnectez-vous et reconnectez-vous
```

macOS :
- Verifiez que Docker Desktop est lance
- Redemarrez Docker Desktop si necessaire

## Probleme : Python n'est pas installe ou mauvaise version

### Symptomes
- La commande `python --version` retourne une erreur
- Version de Python inferieure a 3.8

### Solutions

Windows :
1. Telechargez Python depuis https://www.python.org/downloads/
2. Cochez "Add Python to PATH" lors de l'installation
3. Redemarrez votre terminal

Linux :
```bash
sudo apt-get update
sudo apt-get install python3 python3-pip
```

macOS :
```bash
brew install python3
```

## Probleme : Erreurs de permissions (Linux/Mac)

### Symptomes
- "Permission denied" lors de l'execution de scripts
- "Permission denied" avec Docker

### Solutions

Pour les scripts :
```bash
chmod +x nom-du-script.sh
```

Pour Docker :
```bash
sudo usermod -aG docker $USER
# Deconnectez-vous et reconnectez-vous
```

## Probleme : Le depot GitLab n'est pas accessible

### Symptomes
- Erreur lors du clone
- "Repository not found"

### Solutions

1. Verifiez que vous etes connecte a GitLab
2. Verifiez l'URL du depot
3. Verifiez vos permissions d'acces au depot
4. Essayez de cloner avec votre token d'acces personnel

## Probleme : Les scripts ne fonctionnent pas sur Windows

### Symptomes
- Erreur "bash: command not found"
- Les scripts .sh ne s'executent pas

### Solutions

1. Utilisez Git Bash au lieu de PowerShell ou CMD
2. Ou utilisez WSL (Windows Subsystem for Linux)
3. Ou adaptez les commandes pour PowerShell

## Probleme : Ports deja utilises

### Symptomes
- "Port already in use" lors du demarrage de Docker
- Les services ne peuvent pas demarrer

### Solutions

1. Identifiez quel processus utilise le port :
   - Windows : `netstat -ano | findstr :9200`
   - Linux/Mac : `lsof -i :9200`

2. Arretez le processus ou changez le port dans docker-compose.yml

## Probleme : Erreurs de memoire

### Symptomes
- Docker ne peut pas demarrer
- "Out of memory" errors

### Solutions

1. Augmentez la memoire allouee a Docker :
   - Docker Desktop : Settings → Resources → Advanced
   - Augmentez la memoire a au moins 4 Go

2. Fermez les autres applications qui utilisent beaucoup de memoire

## Probleme : Le pipeline GitLab CI/CD ne se declenche pas

### Symptomes
- Pas de pipeline cree apres un push
- Le fichier .gitlab-ci.yml n'est pas detecte

### Solutions

1. Verifiez que le fichier s'appelle exactement `.gitlab-ci.yml`
2. Verifiez qu'il est a la racine du projet
3. Verifiez la syntaxe YAML (pas d'erreurs d'indentation)
4. Verifiez que vous avez pousse sur la bonne branche

## Probleme : Variables GitLab CI/CD non trouvees

### Symptomes
- "Variable not found" dans les logs du pipeline
- Les variables d'environnement sont vides

### Solutions

1. Allez sur votre projet GitLab
2. Settings → CI/CD → Variables
3. Verifiez que les variables sont bien definies
4. Verifiez l'orthographe exacte des noms de variables
5. Verifiez que "Mask variable" n'est pas active si vous avez besoin de voir la valeur

## Probleme : Les tests echouent

### Symptomes
- Le pipeline echoue a l'etape des tests
- Erreurs dans les logs de test

### Solutions

1. Executez les tests localement d'abord :
   ```bash
   python -m pytest tests/
   ```

2. Verifiez que toutes les dependances sont installees
3. Consultez les logs detailles dans GitLab CI/CD
4. Verifiez que les fichiers de test existent et sont corrects

## Probleme : Le deploiement echoue

### Symptomes
- Le pipeline echoue a l'etape de deploiement
- L'application n'est pas accessible apres le deploiement

### Solutions

1. Verifiez que les variables d'environnement sont bien configurees
2. Verifiez que les tokens d'acces sont valides
3. Consultez les logs de deploiement dans GitLab
4. Verifiez que le service de deploiement (Railway, Render, etc.) est accessible

## Probleme : Les donnees ne sont pas generees correctement

### Symptomes
- Le fichier CSV est vide ou mal forme
- Erreurs lors de la generation des donnees

### Solutions

1. Verifiez que Python est installe correctement
2. Verifiez que les modules necessaires sont installes :
   ```bash
   pip install -r requirements.txt
   ```

3. Executez le script avec des messages de debug :
   ```bash
   python generate_data.py --verbose
   ```

4. Consultez le guide PROBLEMES-SOLUTIONS.md de l'etape 02

## Probleme : La stack ELK ne demarre pas

### Symptomes
- Les conteneurs Docker ne demarrent pas
- Erreurs dans les logs Docker

### Solutions

1. Verifiez que Docker fonctionne :
   ```bash
   docker ps
   ```

2. Consultez les logs des conteneurs :
   ```bash
   docker-compose logs
   ```

3. Verifiez que les ports ne sont pas deja utilises
4. Verifiez que vous avez assez de memoire disponible
5. Consultez le guide PROBLEMES-SOLUTIONS.md de l'etape 03

## Probleme : Kibana n'est pas accessible

### Symptomes
- Impossible d'acceder a http://localhost:5601
- Page blanche ou erreur 502

### Solutions

1. Verifiez que Kibana est bien demarre :
   ```bash
   docker-compose ps
   ```

2. Attendez quelques secondes (Kibana peut prendre du temps a demarrer)
3. Verifiez les logs de Kibana :
   ```bash
   docker-compose logs kibana
   ```

4. Verifiez que Elasticsearch est accessible :
   ```bash
   curl http://localhost:9200
   ```

## Obtenir de l'aide supplementaire

Si vous n'avez pas trouve la solution a votre probleme :

1. Consultez le fichier PROBLEMES-SOLUTIONS.md de l'etape concernee
2. Executez les scripts de diagnostic (diagnose.sh)
3. Consultez la documentation officielle des outils utilises
4. Verifiez les logs detailles dans GitLab CI/CD
5. Ouvrez une issue sur GitLab avec les details de votre probleme

## Conseils generaux

1. Lisez toujours les messages d'erreur complets
2. Verifiez que vous avez suivi toutes les etapes dans l'ordre
3. Validez chaque etape avant de passer a la suivante
4. Conservez les logs d'erreur pour faciliter le depannage
5. Testez toujours localement avant de pousser sur GitLab

Bon courage dans la resolution de vos problemes !

