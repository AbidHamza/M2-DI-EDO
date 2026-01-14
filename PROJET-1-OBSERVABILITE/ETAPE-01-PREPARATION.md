# Etape 01 : Preparation de l'environnement

## Objectif

Installer et configurer Docker pour pouvoir deployer la stack ELK dans les etapes suivantes.

## Duree estimee

15-30 minutes selon votre systeme

## Instructions pas a pas

### Etape 1.1 : Verifier si Docker est installe

Ouvrez un terminal et executez :

```bash
docker --version
```

**Si vous voyez une version** (exemple : Docker version 24.0.0) :
- Docker est deja installe
- Passez directement a l'etape 1.3

**Si vous voyez une erreur** (exemple : command not found) :
- Docker n'est pas installe
- Continuez avec l'etape 1.2

### Etape 1.2 : Installer Docker

#### Option A : Windows

1. Allez sur https://www.docker.com/products/docker-desktop
2. Cliquez sur "Download for Windows"
3. Installez Docker Desktop avec les options par defaut
4. Redemarrez votre ordinateur
5. Lancez Docker Desktop et attendez qu'il demarre

#### Option B : Linux (Ubuntu/Debian)

Executez ces commandes dans l'ordre :

```bash
# Mettre a jour les paquets
sudo apt-get update

# Installer les prerequis
sudo apt-get install -y ca-certificates curl gnupg lsb-release

# Ajouter la cle GPG Docker
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Ajouter le depot Docker
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Installer Docker
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Ajouter votre utilisateur au groupe docker
sudo usermod -aG docker $USER
```

**Important** : Deconnectez-vous et reconnectez-vous pour que les changements prennent effet.

#### Option C : macOS

1. Allez sur https://www.docker.com/products/docker-desktop
2. Cliquez sur "Download for Mac"
3. Choisissez la version selon votre processeur (Intel ou Apple Silicon)
4. Installez Docker Desktop
5. Lancez Docker Desktop depuis Applications

### Etape 1.3 : Verifier Docker Compose

Executez :

```bash
docker-compose --version
```

**Si vous voyez une version** : Docker Compose est installe

**Si vous voyez une erreur** : Essayez aussi :
```bash
docker compose version
```
(Sur les versions recentes, Docker Compose est integre)

### Etape 1.4 : Tester Docker

Executez :

```bash
docker run hello-world
```

**Resultat attendu** :
```
Hello from Docker!
This message shows that your installation appears to be working correctly.
```

Si vous voyez ce message : Docker fonctionne parfaitement

## Verification

Avant de passer a l'etape suivante, verifiez que :

- [ ] docker --version affiche une version
- [ ] docker-compose --version affiche une version (ou docker compose version)
- [ ] docker run hello-world fonctionne

## Problemes courants

### "docker: command not found"

**Solution** :
- Windows/Mac : Verifiez que Docker Desktop est lance
- Linux : Redemarrez votre terminal ou reconnectez-vous

### "Cannot connect to the Docker daemon"

**Solution** :
- Windows/Mac : Lancez Docker Desktop
- Linux : Executez `sudo systemctl start docker`

### "Permission denied" (Linux)

**Solution** :
```bash
sudo usermod -aG docker $USER
# Deconnectez-vous et reconnectez-vous
```

## Prochaine etape

Une fois cette etape validee, passez a :
[Etape 02 : Generation de donnees](ETAPE-02-GENERATION-DONNEES.md)
