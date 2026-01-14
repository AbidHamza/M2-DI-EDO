# Etape 01 : Preparation de l'environnement

## Objectif

Installer et configurer Docker pour pouvoir deployer la stack ELK dans les etapes suivantes. Cette etape est cruciale car sans Docker fonctionnel, vous ne pourrez pas continuer.

## Duree estimee

15-30 minutes selon votre systeme d'exploitation et votre connexion Internet

## Prérequis

- Acces administrateur a votre ordinateur
- Connexion Internet pour telecharger Docker
- Au moins 4 Go de RAM disponible
- Au moins 10 Go d'espace disque libre

## Instructions pas a pas avec tous les details

### Etape 1.1 : Verifier si Docker est deja installe

**Action precise** : Ouvrir un terminal (ou invite de commandes)

**Comment ouvrir un terminal** :
- Windows : Appuyez sur Windows + R, tapez "cmd" ou "powershell", puis Entree
- Linux : Appuyez sur Ctrl + Alt + T
- macOS : Appuyez sur Cmd + Espace, tapez "terminal", puis Entree

**Commande a executer exactement comme ecrit** :
```bash
docker --version
```

**Ce que cette commande fait** :
- Cherche le programme "docker" dans votre systeme
- Affiche la version si trouvee
- Affiche une erreur si non trouvee

**Resultat attendu si Docker est installe** :
```
Docker version 24.0.0, build abc123def456
```
ou une version similaire (les chiffres peuvent varier)

**Resultat attendu si Docker n'est PAS installe** :
Sur Windows :
```
'docker' n'est pas reconnu comme une commande interne ou externe
```

Sur Linux/Mac :
```
bash: docker: command not found
```

**Decision a prendre** :
- Si vous voyez une version : Docker est deja installe, passez directement a l'etape 1.3
- Si vous voyez une erreur : Docker n'est pas installe, continuez avec l'etape 1.2

### Etape 1.2 : Installer Docker

Cette section depend de votre systeme d'exploitation. Choisissez la section correspondante.

#### Option A : Installation sur Windows

**Etape 1.2.1 : Telecharger Docker Desktop**

1. Ouvrez votre navigateur web (Chrome, Firefox, Edge, etc.)
2. Allez a l'adresse suivante : https://www.docker.com/products/docker-desktop
3. Vous verrez une page avec plusieurs boutons
4. Cliquez sur le bouton "Download for Windows"
5. Le telechargement commence automatiquement
6. Attendez que le telechargement se termine (le fichier fait environ 500 Mo, cela peut prendre plusieurs minutes selon votre connexion)

**Ou se trouve le fichier telecharge** :
- Generalement dans le dossier "Telechargements" (Downloads)
- Le nom du fichier sera quelque chose comme "Docker Desktop Installer.exe"

**Etape 1.2.2 : Installer Docker Desktop**

1. Allez dans votre dossier de telechargements
2. Double-cliquez sur le fichier "Docker Desktop Installer.exe"
3. Une fenetre d'installation s'ouvre
4. Si Windows demande une autorisation, cliquez sur "Oui"
5. Dans la fenetre d'installation :
   - Cochez la case "Use WSL 2 instead of Hyper-V" (recommandé)
   - Cliquez sur "OK"
   - Cliquez sur "Close and restart" (Fermer et redemarrer)

**Etape 1.2.3 : Redemarrer l'ordinateur**

1. Fermez toutes vos applications
2. Redemarrez votre ordinateur
3. Apres le redemarrage, Docker Desktop devrait demarrer automatiquement
4. Si ce n'est pas le cas, cherchez "Docker Desktop" dans le menu Demarrer et lancez-le

**Etape 1.2.4 : Attendre que Docker Desktop soit pret**

1. Vous verrez une icone Docker dans la barre des taches (en bas a droite)
2. L'icone peut etre orange ou bleue au debut
3. Attendez que l'icone devienne verte (cela peut prendre 1-2 minutes)
4. Quand l'icone est verte, Docker est pret

**Etape 1.2.5 : Verifier l'installation**

1. Ouvrez un nouveau terminal (important : ouvrez un NOUVEAU terminal apres le redemarrage)
2. Tapez exactement : `docker --version`
3. Appuyez sur Entree
4. Vous devriez voir une version de Docker

#### Option B : Installation sur Linux (Ubuntu/Debian)

**Etape 1.2.1 : Ouvrir un terminal**

Appuyez sur Ctrl + Alt + T pour ouvrir un terminal

**Etape 1.2.2 : Mettre a jour les paquets**

Tapez exactement cette commande et appuyez sur Entree :
```bash
sudo apt-get update
```

**Ce que cette commande fait** :
- `sudo` : Execute la commande avec les privileges administrateur
- `apt-get` : Gestionnaire de paquets Ubuntu/Debian
- `update` : Met a jour la liste des paquets disponibles

**Vous serez demande de taper votre mot de passe** :
- Tapez votre mot de passe (rien ne s'affiche, c'est normal)
- Appuyez sur Entree

**Resultat attendu** :
```
Hit:1 http://archive.ubuntu.com/ubuntu focal InRelease
...
Reading package lists... Done
```

**Etape 1.2.3 : Installer les prerequis**

Tapez exactement cette commande :
```bash
sudo apt-get install -y ca-certificates curl gnupg lsb-release
```

**Ce que cette commande fait** :
- Installe les outils necessaires pour telecharger Docker
- `-y` : Repond automatiquement "oui" aux questions

**Resultat attendu** :
```
Reading package lists... Done
Building dependency tree... Done
...
Setting up ca-certificates (20210119~20.04.2) ...
```

**Etape 1.2.4 : Ajouter la cle GPG Docker**

Tapez exactement cette commande :
```bash
sudo mkdir -p /etc/apt/keyrings
```

Puis cette commande :
```bash
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
```

**Ce que ces commandes font** :
- Creent un dossier pour stocker les cles de securite
- Telechargent et installent la cle GPG de Docker (necessaire pour verifier l'authenticite des paquets)

**Resultat attendu** : Aucune sortie (c'est normal)

**Etape 1.2.5 : Ajouter le depot Docker**

Tapez exactement cette commande :
```bash
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

**Ce que cette commande fait** :
- Ajoute le depot officiel Docker a votre liste de depots
- Permet a votre systeme de savoir ou telecharger Docker

**Resultat attendu** : Aucune sortie (c'est normal)

**Etape 1.2.6 : Installer Docker**

Tapez exactement cette commande :
```bash
sudo apt-get update
```

Puis cette commande :
```bash
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

**Ce que cette commande fait** :
- Met a jour la liste des paquets avec le nouveau depot Docker
- Installe Docker et tous ses composants

**Resultat attendu** :
```
Reading package lists... Done
Building dependency tree... Done
...
Setting up docker-ce (5:24.0.0-1~ubuntu.20.04~focal) ...
```

**Etape 1.2.7 : Ajouter votre utilisateur au groupe docker**

Tapez exactement cette commande :
```bash
sudo usermod -aG docker $USER
```

**Ce que cette commande fait** :
- Ajoute votre utilisateur au groupe "docker"
- Permet d'utiliser Docker sans sudo

**IMPORTANT** : Deconnectez-vous et reconnectez-vous pour que les changements prennent effet

**Etape 1.2.8 : Verifier l'installation**

1. Deconnectez-vous de votre session
2. Reconnectez-vous
3. Ouvrez un nouveau terminal
4. Tapez : `docker --version`
5. Vous devriez voir une version

#### Option C : Installation sur macOS

**Etape 1.2.1 : Determiner votre type de Mac**

1. Cliquez sur le menu Apple (en haut a gauche)
2. Cliquez sur "A propos de ce Mac"
3. Regardez "Processeur" :
   - Si vous voyez "Intel" : Vous avez un Mac Intel
   - Si vous voyez "Apple" ou "M1", "M2", etc. : Vous avez un Mac Apple Silicon

**Etape 1.2.2 : Telecharger Docker Desktop**

1. Ouvrez votre navigateur web
2. Allez sur https://www.docker.com/products/docker-desktop
3. Cliquez sur "Download for Mac"
4. Choisissez :
   - "Mac with Intel chip" si vous avez un Mac Intel
   - "Mac with Apple chip" si vous avez un Mac Apple Silicon
5. Le telechargement commence

**Etape 1.2.3 : Installer Docker Desktop**

1. Allez dans votre dossier "Telechargements"
2. Double-cliquez sur le fichier .dmg telecharge
3. Une fenetre s'ouvre avec une icone Docker
4. Glissez l'icone Docker vers le dossier "Applications"
5. Allez dans Applications et double-cliquez sur Docker
6. Si macOS demande une autorisation, cliquez sur "Ouvrir"
7. Attendez que Docker Desktop demarre (quelques secondes)

**Etape 1.2.4 : Verifier l'installation**

1. Ouvrez un terminal (Cmd + Espace, tapez "terminal")
2. Tapez : `docker --version`
3. Vous devriez voir une version

### Etape 1.3 : Verifier Docker Compose

**Commande a executer** :
```bash
docker-compose --version
```

**Resultat attendu** :
```
Docker Compose version v2.20.0
```

**Si vous voyez une erreur**, essayez aussi :
```bash
docker compose version
```

**Pourquoi deux commandes** :
- Sur les anciennes versions : `docker-compose` (avec tiret)
- Sur les nouvelles versions : `docker compose` (sans tiret, integre a Docker)

**Si aucune des deux ne fonctionne** :
- Sur Linux : Installez Docker Compose separement
- Sur Windows/Mac : Docker Compose devrait etre inclus avec Docker Desktop

### Etape 1.4 : Tester Docker avec un conteneur simple

**Commande a executer** :
```bash
docker run hello-world
```

**Ce que cette commande fait** :
- `docker run` : Lance un conteneur Docker
- `hello-world` : Nom d'une image Docker de test officielle
- Docker telecharge automatiquement l'image si elle n'est pas presente localement

**Premiere execution - Resultat attendu** :
```
Unable to find image 'hello-world:latest' locally
latest: Pulling from library/hello-world
...
Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub registry.
 3. The Docker daemon created a new container from that image.
 4. The Docker daemon ran that container.
 5. The container produced the output you are currently reading.
```

**Si vous voyez "Hello from Docker!"** : Docker fonctionne parfaitement

**Si vous voyez une erreur** : Consultez la section "Problemes courants" ci-dessous

### Etape 1.5 : Verification complete

Avant de passer a l'etape suivante, executez ces trois commandes et verifiez les resultats :

**Commande 1** :
```bash
docker --version
```
**Verification** : Doit afficher une version (ex: Docker version 24.0.0)

**Commande 2** :
```bash
docker-compose --version
```
ou
```bash
docker compose version
```
**Verification** : Doit afficher une version (ex: Docker Compose version v2.20.0)

**Commande 3** :
```bash
docker run hello-world
```
**Verification** : Doit afficher "Hello from Docker!"

## Checklist de validation

Avant de passer a l'etape suivante, cochez chaque point :

- [ ] docker --version affiche une version
- [ ] docker-compose --version (ou docker compose version) affiche une version
- [ ] docker run hello-world fonctionne et affiche "Hello from Docker!"
- [ ] Docker Desktop est lance (Windows/Mac) ou le service Docker est actif (Linux)

**Si tous les points sont coches** : Vous etes pret pour l'etape suivante

## Problemes courants et solutions detaillees

### Probleme 1 : "docker: command not found"

**Symptomes** :
- La commande `docker --version` retourne "command not found"
- Le message d'erreur varie selon le systeme

**Solutions par systeme** :

**Windows** :
1. Verifiez que Docker Desktop est lance
2. Cherchez l'icone Docker dans la barre des taches (en bas a droite)
3. Si l'icone n'est pas la, lancez Docker Desktop depuis le menu Demarrer
4. Attendez que l'icone devienne verte
5. Fermez votre terminal actuel
6. Ouvrez un NOUVEAU terminal
7. Reessayez la commande

**Linux** :
1. Verifiez que Docker est bien installe : `which docker`
2. Si rien ne s'affiche, Docker n'est pas installe, refaites l'installation
3. Si un chemin s'affiche mais la commande ne fonctionne pas :
   - Verifiez que vous etes dans le groupe docker : `groups`
   - Si "docker" n'apparait pas dans la liste, executez : `sudo usermod -aG docker $USER`
   - Deconnectez-vous et reconnectez-vous
   - Ouvrez un nouveau terminal

**macOS** :
1. Verifiez que Docker Desktop est lance
2. Cherchez l'icone Docker dans la barre de menu (en haut)
3. Si l'icone n'est pas la, lancez Docker Desktop depuis Applications
4. Attendez quelques secondes
5. Ouvrez un nouveau terminal
6. Reessayez la commande

### Probleme 2 : "Cannot connect to the Docker daemon"

**Symptomes** :
- La commande `docker run hello-world` retourne "Cannot connect to the Docker daemon"
- Le message indique que Docker ne peut pas communiquer avec son service

**Solutions par systeme** :

**Windows** :
1. Ouvrez Docker Desktop
2. Attendez que l'icone dans la barre des taches soit verte
3. Si l'icone reste orange ou rouge :
   - Cliquez droit sur l'icone Docker
   - Cliquez sur "Troubleshoot"
   - Suivez les instructions

**Linux** :
1. Verifiez que le service Docker est demarre :
   ```bash
   sudo systemctl status docker
   ```
2. Si le service n'est pas actif, demarrez-le :
   ```bash
   sudo systemctl start docker
   ```
3. Activez le service au demarrage (optionnel) :
   ```bash
   sudo systemctl enable docker
   ```

**macOS** :
1. Ouvrez Docker Desktop
2. Attendez que l'icone dans la barre de menu soit verte
3. Si l'icone reste orange :
   - Cliquez sur l'icone Docker
   - Cliquez sur "Restart"
   - Attendez que Docker redemarre

### Probleme 3 : "Permission denied" (Linux uniquement)

**Symptomes** :
- La commande `docker run hello-world` retourne "permission denied"
- Vous devez utiliser `sudo docker` pour que ca fonctionne

**Solution** :
1. Ajoutez votre utilisateur au groupe docker :
   ```bash
   sudo usermod -aG docker $USER
   ```
2. Verifiez que vous etes dans le groupe :
   ```bash
   groups
   ```
   Vous devriez voir "docker" dans la liste
3. **IMPORTANT** : Deconnectez-vous completement de votre session
4. Reconnectez-vous
5. Ouvrez un nouveau terminal
6. Essayez `docker run hello-world` sans sudo

**Pourquoi cette etape est importante** :
- Les changements de groupe ne prennent effet qu'apres une nouvelle connexion
- Utiliser `sudo` avec Docker n'est pas recommande pour la securite

### Probleme 4 : Docker Desktop ne demarre pas (Windows)

**Symptomes** :
- Docker Desktop ne s'ouvre pas
- Message d'erreur au demarrage
- L'icone reste orange ou rouge

**Solutions** :

**Solution 1 : Verifier WSL 2**
Docker Desktop sur Windows necessite WSL 2.

1. Ouvrez PowerShell en tant qu'administrateur (clic droit → Executer en tant qu'administrateur)
2. Verifiez la version de WSL :
   ```powershell
   wsl --list --verbose
   ```
3. Si vous voyez "VERSION 1", mettez a jour vers WSL 2 :
   ```powershell
   wsl --set-version Ubuntu 2
   ```
   (Remplacez "Ubuntu" par le nom de votre distribution WSL si different)

**Solution 2 : Reinitialiser Docker Desktop**
1. Ouvrez Docker Desktop
2. Cliquez sur l'icone d'engrenage (Settings)
3. Allez dans "Troubleshoot"
4. Cliquez sur "Reset to factory defaults"
5. Confirmez
6. Redemarrez Docker Desktop

**Solution 3 : Reinstaller Docker Desktop**
1. Desinstallez Docker Desktop depuis le Panneau de configuration
2. Redemarrez votre ordinateur
3. Reinstallez Docker Desktop
4. Redemarrez a nouveau

### Probleme 5 : Erreur de memoire (Windows/Mac)

**Symptomes** :
- Message d'erreur mentionnant la memoire
- Docker ne peut pas demarrer

**Solution** :
1. Ouvrez Docker Desktop
2. Cliquez sur Settings (icone d'engrenage)
3. Allez dans "Resources" → "Advanced"
4. Augmentez la memoire allouee a Docker :
   - Minimum recommande : 4 Go
   - Ideal : 6-8 Go si vous avez assez de RAM
5. Cliquez sur "Apply & Restart"
6. Attendez que Docker redemarre

## Verification finale avant de continuer

Executez ces commandes dans l'ordre et verifiez chaque resultat :

**Test 1** :
```bash
docker --version
```
**Attendu** : Une version de Docker (ex: Docker version 24.0.0)

**Test 2** :
```bash
docker-compose --version
```
ou
```bash
docker compose version
```
**Attendu** : Une version de Docker Compose (ex: Docker Compose version v2.20.0)

**Test 3** :
```bash
docker run hello-world
```
**Attendu** : Message "Hello from Docker!" avec des informations sur Docker

**Test 4** :
```bash
docker ps
```
**Attendu** : Une liste de conteneurs (peut etre vide, c'est normal)

**Si tous les tests passent** : Docker est correctement installe et configure

## Prochaine etape

Une fois cette etape validee avec tous les tests qui passent, vous pouvez passer a :
[Etape 02 : Generation de donnees](ETAPE-02-GENERATION-DONNEES.md)

## Notes importantes

- Gardez Docker Desktop lance pendant tout le projet (Windows/Mac)
- Sur Linux, le service Docker doit etre actif
- Si vous fermez votre ordinateur, vous devrez peut-etre relancer Docker Desktop au redemarrage
- Tous les travaux se font en local, rien n'est envoye sur Internet (confidentialite garantie)
