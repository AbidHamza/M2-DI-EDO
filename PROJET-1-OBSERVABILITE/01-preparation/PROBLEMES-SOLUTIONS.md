# Problemes Courants et Solutions - Etape 1

## Introduction

Ce document liste les problemes courants rencontres lors de l'installation de Docker et leurs solutions.

## Probleme 1 : "docker: command not found"

### Symptomes
```bash
$ docker --version
docker: command not found
```

### Causes possibles
1. Docker n'est pas installe
2. Docker n'est pas dans le PATH
3. Docker Desktop n'est pas lance (Windows/Mac)

### Solutions

#### Solution 1 : Verifier l'installation
Windows :
1. Ouvrez le menu Demarrer
2. Recherchez "Docker Desktop"
3. Si trouve : Lancez-le et attendez qu'il demarre
4. Si non trouve : Installez Docker Desktop (voir GUIDE-INSTALLATION.md)

Linux :
```bash
# Verifier si Docker est installe
which docker

# Si rien n'est retourne, installer Docker
# Voir GUIDE-INSTALLATION.md pour les instructions d'installation
```

macOS :
1. Ouvrez Applications
2. Cherchez Docker
3. Si trouve : Double-cliquez pour lancer
4. Si non trouve : Installez Docker Desktop

#### Solution 2 : Redemarrer le terminal
Parfois, le PATH n'est pas mis a jour. Fermez et rouvrez votre terminal.

## Probleme 2 : "Cannot connect to the Docker daemon"

### Symptomes
```bash
$ docker run hello-world
Cannot connect to the Docker daemon. Is the docker daemon running on this host?
```

### Causes possibles
1. Docker Desktop n'est pas lance (Windows/Mac)
2. Service Docker non demarre (Linux)
3. Permissions insuffisantes (Linux)

### Solutions

#### Solution 1 : Windows/Mac - Lancer Docker Desktop
1. Ouvrez Docker Desktop
2. Attendez que l'icone dans la barre des taches soit verte
3. Reessayez la commande

#### Solution 2 : Linux - Demarrer le service
```bash
# Demarrer le service Docker
sudo systemctl start docker

# Verifier le statut
sudo systemctl status docker

# Activer au demarrage (optionnel)
sudo systemctl enable docker
```

#### Solution 3 : Linux - Verifier les permissions
```bash
# Ajouter votre utilisateur au groupe docker
sudo usermod -aG docker $USER

# Deconnectez-vous et reconnectez-vous
# Ou utilisez :
newgrp docker
```

## Probleme 3 : "Permission denied" (Linux)

### Symptomes
```bash
$ docker run hello-world
permission denied while trying to connect to the Docker daemon socket
```

### Cause
Votre utilisateur n'a pas les permissions pour acceder a Docker.

### Solution
```bash
# Ajouter votre utilisateur au groupe docker
sudo usermod -aG docker $USER

# Appliquer les changements (choisir une option)
# Option 1 : Deconnecter/reconnecter
# Option 2 : Utiliser newgrp
newgrp docker

# Verifier
docker run hello-world
```

### Alternative : Utiliser sudo (non recommande)
```bash
sudo docker run hello-world
```
Note : Utiliser sudo avec Docker n'est pas recommande pour la securite.

## Probleme 4 : Docker Desktop ne demarre pas (Windows)

### Symptomes
- Docker Desktop ne s'ouvre pas
- Message d'erreur au demarrage
- L'icone reste orange/rouge

### Solutions

#### Solution 1 : Verifier WSL 2
Docker Desktop necessite WSL 2 sur Windows.

```powershell
# Verifier la version de WSL
wsl --list --verbose

# Si version 1, mettre a jour vers WSL 2
wsl --set-version Ubuntu 2
```

#### Solution 2 : Reinitialiser Docker Desktop
1. Ouvrez Docker Desktop
2. Settings → Troubleshoot → Reset to factory defaults
3. Redemarrez Docker Desktop

#### Solution 3 : Reinstaller Docker Desktop
1. Desinstallez Docker Desktop
2. Redemarrez l'ordinateur
3. Reinstallez Docker Desktop
4. Redemarrez a nouveau

## Probleme 5 : "docker-compose: command not found"

### Symptomes
```bash
$ docker-compose --version
docker-compose: command not found
```

### Causes
1. Docker Compose n'est pas installe
2. Utilisation de Docker Compose v2 (plugin)

### Solutions

#### Solution 1 : Utiliser Docker Compose v2 (plugin)
Docker Compose v2 est integre a Docker.

```bash
# Au lieu de docker-compose, utilisez :
docker compose version

# Notez l'absence du tiret
```

#### Solution 2 : Installer Docker Compose v1
```bash
# Linux
sudo curl -L "https://github.com/docker/compose/releases/download/v2.20.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Verifier
docker-compose --version
```

## Probleme 6 : Erreur de memoire (Windows)

### Symptomes
```
Error: failed to start: failed to start vm: exit status 1
```

### Cause
Memoire insuffisante allouee a Docker.

### Solution
1. Ouvrez Docker Desktop
2. Settings → Resources → Advanced
3. Augmentez la memoire allouee (minimum 4 Go recommande)
4. Cliquez sur "Apply & Restart"

## Si rien ne fonctionne

1. Executez le diagnostic automatique :
   ```bash
   ./diagnose.sh
   ```

2. Consultez les alternatives :
   Voir ALTERNATIVES.md pour d'autres methodes d'installation

3. Verifiez les logs :
   - Windows : %LOCALAPPDATA%\Docker\log.txt
   - Linux : journalctl -u docker
   - macOS : ~/Library/Containers/com.docker.docker/Data/log/

4. Demandez de l'aide :
   - Ouvrez une issue sur GitLab
   - Incluez la sortie de ./diagnose.sh

## Verification finale

Apres avoir resolu votre probleme, executez :
```bash
./verify-setup.sh
```

Tous les tests doivent passer avant de continuer.

