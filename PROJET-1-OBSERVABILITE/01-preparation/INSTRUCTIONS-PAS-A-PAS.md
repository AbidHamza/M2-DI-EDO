# Instructions Pas a Pas - Etape 1 : Preparation

## Objectif

Installer et configurer Docker pour pouvoir deployer la stack ELK dans les etapes suivantes.

Duree estimee : 15-30 minutes selon votre systeme

## Vue d'ensemble

Dans cette etape, vous allez :
1. Verifier si Docker est deja installe
2. Installer Docker si necessaire
3. Verifier que Docker fonctionne correctement
4. Installer Docker Compose si necessaire
5. Valider l'installation complete

## Instructions detaillees

### Instruction 1 : Verifier si Docker est installe

Action : Ouvrir un terminal et executer une commande

Commande a executer :
```bash
docker --version
```

Ce que cette commande fait :
- Affiche la version de Docker si elle est installee
- Affiche une erreur si Docker n'est pas installe

Resultat attendu si Docker est installe :
```
Docker version 24.0.0, build abc123def456
```

Resultat attendu si Docker n'est PAS installe :
```
bash: docker: command not found
```
ou sur Windows :
```
'docker' n'est pas reconnu comme une commande interne ou externe
```

Decision a prendre :
- Si vous voyez une version : Passez a l'Instruction 3 (Verifier Docker)
- Si vous voyez une erreur : Continuez avec l'Instruction 2 (Installer Docker)

---

### Instruction 2 : Installer Docker

Cette instruction depend de votre systeme d'exploitation. Choisissez la section correspondante.

#### Option A : Windows

Etape 2.1 : Telecharger Docker Desktop
1. Allez sur https://www.docker.com/products/docker-desktop
2. Cliquez sur "Download for Windows"
3. Attendez le telechargement (environ 500 Mo)

Etape 2.2 : Installer Docker Desktop
1. Double-cliquez sur le fichier telecharge (Docker Desktop Installer.exe)
2. Suivez l'assistant d'installation
3. Cochez "Use WSL 2 instead of Hyper-V" (recommandé)
4. Cliquez sur "OK" puis "Close and restart"

Etape 2.3 : Redemarrer l'ordinateur
1. Redemarrez votre ordinateur
2. Apres redemarrage, Docker Desktop devrait demarrer automatiquement

Etape 2.4 : Verifier l'installation
```bash
docker --version
```

Resultat attendu :
```
Docker version 24.0.0, build abc123
```

Si vous voyez cette sortie : Docker est installe
Si vous voyez une erreur : Consultez PROBLEMES-SOLUTIONS.md

#### Option B : Linux (Ubuntu/Debian)

Etape 2.1 : Mettre a jour les paquets
```bash
sudo apt-get update
```

Etape 2.2 : Installer les prerequis
```bash
sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
```

Etape 2.3 : Ajouter la cle GPG Docker
```bash
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
```

Etape 2.4 : Ajouter le depot Docker
```bash
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

Etape 2.5 : Installer Docker
```bash
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

Etape 2.6 : Verifier l'installation
```bash
docker --version
```

Resultat attendu :
```
Docker version 24.0.0, build abc123
```

Etape 2.7 : Ajouter votre utilisateur au groupe docker
```bash
sudo usermod -aG docker $USER
```

Important : Deconnectez-vous et reconnectez-vous pour que les changements prennent effet.

#### Option C : macOS

Etape 2.1 : Telecharger Docker Desktop
1. Allez sur https://www.docker.com/products/docker-desktop
2. Cliquez sur "Download for Mac"
3. Choisissez "Mac with Intel chip" ou "Mac with Apple chip" selon votre Mac

Etape 2.2 : Installer Docker Desktop
1. Ouvrez le fichier .dmg telecharge
2. Glissez Docker dans le dossier Applications
3. Ouvrez Docker depuis Applications
4. Autorisez l'installation si demande

Etape 2.3 : Verifier l'installation
```bash
docker --version
```

Resultat attendu :
```
Docker version 24.0.0, build abc123
```

---

### Instruction 3 : Verifier Docker Compose

Commande a executer :
```bash
docker-compose --version
```

Resultat attendu :
```
Docker Compose version v2.20.0
```

Si vous voyez cette sortie : Docker Compose est installe
Si vous voyez une erreur : Consultez PROBLEMES-SOLUTIONS.md

Note : Sur les versions recentes de Docker, Docker Compose peut etre integre. Essayez aussi :
```bash
docker compose version
```

---

### Instruction 4 : Tester Docker

Commande a executer :
```bash
docker run hello-world
```

Resultat attendu :
```
Unable to find image 'hello-world:latest' locally
latest: Pulling from library/hello-world
...
Hello from Docker!
This message shows that your installation appears to be working correctly.
```

Si vous voyez "Hello from Docker!" : Docker fonctionne parfaitement
Si vous voyez une erreur : Consultez PROBLEMES-SOLUTIONS.md

---

### Instruction 5 : Verification automatique complete

Utilisez le script de verification :
```bash
./verify-setup.sh
```

Resultat attendu si tout est OK :
```
Verification de l'environnement
Docker est installe : version 24.0.0
Docker Compose est installe : version v2.20.0
Docker fonctionne correctement
Verification terminee avec succes !

Vous pouvez passer a l'etape suivante : 02-generation-donnees
```

Si vous voyez tous les messages de succes : Vous etes pret pour l'etape suivante
Si vous voyez des erreurs : Consultez PROBLEMES-SOLUTIONS.md pour resoudre les problemes

---

## Validation de l'etape

Avant de passer a l'etape suivante, assurez-vous que :

- [ ] docker --version affiche une version
- [ ] docker-compose --version affiche une version
- [ ] docker run hello-world fonctionne
- [ ] Le script verify-setup.sh passe sans erreur

Si tous les points sont coches : Vous avez reussi cette etape a 100%

---

## Problemes courants

### Probleme 1 : "docker: command not found"

Solution :
- Windows : Redemarrez votre ordinateur apres l'installation
- Linux : Ajoutez votre utilisateur au groupe docker : sudo usermod -aG docker $USER puis deconnectez/reconnectez-vous
- macOS : Verifiez que Docker Desktop est lance

### Probleme 2 : "Cannot connect to the Docker daemon"

Solution :
- Windows : Lancez Docker Desktop manuellement
- Linux : Demarrez le service : sudo systemctl start docker
- macOS : Verifiez que Docker Desktop est lance

### Probleme 3 : "Permission denied" (Linux)

Solution :
```bash
sudo usermod -aG docker $USER
# Deconnectez-vous et reconnectez-vous
```

Pour plus de problemes, consultez PROBLEMES-SOLUTIONS.md

---

## Prochaine etape

Une fois cette etape validee, passez a :
[Etape 2 : Generation de donnees](../02-generation-donnees/README.md)

---

## Ressources supplementaires

- [Documentation Docker](https://docs.docker.com/)
- [Installation Docker](https://docs.docker.com/get-docker/)
- [Depannage Docker](https://docs.docker.com/desktop/troubleshoot/)

Vous avez termine cette etape ? Felicitations !

