# Etape 06 : Containerisation avec Docker

## Objectif

Creer un Dockerfile pour containeriser l'application et la preparer pour l'execution dans un conteneur Docker. Tout se fait en local sur votre ordinateur.

## Duree estimee

45 minutes-1h

## Prérequis

- Docker installe et fonctionnel (etape 01 validee)
- Scripts Python crees (etape 02 validee)
- Compréhension de base de Docker

## Important : Tout en local

- L'image Docker est construite sur votre ordinateur
- Aucune donnee n'est envoyee sur Internet
- Vous pouvez tester l'image localement
- Le deploiement externe est optionnel

## Instructions pas a pas avec tous les details

### Etape 6.1 : Comprendre ce qu'est un Dockerfile

**Dockerfile** : Un fichier texte qui contient les instructions pour construire une image Docker.

**Image Docker** : Une image contient tout ce qui est necessaire pour executer votre application (code, dependances, configuration).

**Conteneur Docker** : Une instance en cours d'execution d'une image Docker.

**Pourquoi containeriser** :
- Isolation : L'application fonctionne dans un environnement isole
- Portabilite : Fonctionne de la meme maniere sur differentes machines
- Reproducibilite : Meme environnement a chaque fois

### Etape 6.2 : Creer le Dockerfile

**Action** : Creer un fichier Dockerfile pour votre application

**Avec un editeur de texte** :
1. Ouvrez votre editeur de texte
2. Creez un nouveau fichier
3. Nommez-le exactement : `Dockerfile`
4. **IMPORTANT** : Pas d'extension (.txt, .md, etc.), juste `Dockerfile`

**Contenu exact du Dockerfile** :

Copiez-collez exactement ce contenu :

```dockerfile
# Utiliser une image Python officielle comme base
# python:3.10-slim est une version legere de Python 3.10
FROM python:3.10-slim

# Definir le repertoire de travail dans le conteneur
# Toutes les commandes suivantes s'executent dans ce repertoire
WORKDIR /app

# Copier le fichier requirements.txt dans le conteneur
# Le fichier requirements.txt liste les dependances Python
COPY requirements.txt .

# Installer les dependances Python
# --no-cache-dir : Ne pas mettre en cache les paquets (reduit la taille de l'image)
RUN pip install --no-cache-dir -r requirements.txt

# Copier tous les fichiers de l'application dans le conteneur
# Le point (.) signifie "repertoire courant"
COPY . .

# Exposer le port 8000 (si votre application en a besoin)
# Cette ligne documente quel port l'application utilise
# Elle n'ouvre pas automatiquement le port
EXPOSE 8000

# Commande par defaut a executer quand le conteneur demarre
# Cette commande s'execute quand vous lancez le conteneur
CMD ["python", "generate_data.py"]
```

**Explication ligne par ligne** :

**FROM python:3.10-slim** :
- `FROM` : Specifie l'image de base
- `python:3.10-slim` : Image Python 3.10 officielle, version legere
- Cette image contient Python et les outils de base

**WORKDIR /app** :
- `WORKDIR` : Cree le repertoire et y navigue
- `/app` : Chemin dans le conteneur
- Toutes les commandes suivantes s'executent dans ce repertoire

**COPY requirements.txt .** :
- `COPY` : Copie un fichier du systeme hote vers le conteneur
- `requirements.txt` : Fichier source (sur votre ordinateur)
- `.` : Destination (repertoire courant dans le conteneur, donc /app)

**RUN pip install --no-cache-dir -r requirements.txt** :
- `RUN` : Execute une commande pendant la construction de l'image
- `pip install` : Installe les paquets Python
- `--no-cache-dir` : Ne garde pas le cache (reduit la taille)
- `-r requirements.txt` : Lit les dependances depuis le fichier

**COPY . .** :
- Copie tous les fichiers du repertoire courant vers /app dans le conteneur
- Inclut vos scripts Python

**EXPOSE 8000** :
- Documente que l'application utilise le port 8000
- N'ouvre pas automatiquement le port (il faut le faire avec -p lors du run)

**CMD ["python", "generate_data.py"]** :
- `CMD` : Commande par defaut au demarrage du conteneur
- `["python", "generate_data.py"]` : Format liste pour executer la commande
- Cette commande s'execute quand vous lancez le conteneur

### Etape 6.3 : Creer le fichier requirements.txt

**Action** : Creer un fichier listant les dependances Python

**Avec un editeur de texte** :
1. Creez un nouveau fichier
2. Nommez-le exactement : `requirements.txt`

**Contenu du fichier** :

Pour notre application simple, nous n'avons pas besoin de dependances externes :

```txt
# Fichier requirements.txt pour le projet de pollution
# Les modules csv, datetime et random sont integres a Python
# Aucune dependance externe necessaire pour generate_data.py
```

**Si vous avez des dependances** (par exemple numpy, pandas), ajoutez-les :

```txt
numpy==1.24.0
pandas==2.0.0
```

**Pourquoi creer ce fichier meme s'il est vide** :
- Bonne pratique : Documente qu'il n'y a pas de dependances
- Permet d'ajouter facilement des dependances plus tard
- Le Dockerfile s'attend a ce que ce fichier existe

### Etape 6.4 : Creer un fichier .dockerignore

**Action** : Creer un fichier pour exclure des fichiers de l'image Docker

**Pourquoi .dockerignore** :
- Reduit la taille de l'image
- Accelere la construction
- Evite de copier des fichiers inutiles

**Avec un editeur de texte** :
1. Creez un nouveau fichier
2. Nommez-le exactement : `.dockerignore`

**Contenu du fichier** :

```dockerignore
# Fichiers et dossiers a exclure de l'image Docker

# Fichiers Python compiles
__pycache__/
*.py[cod]
*$py.class
*.so

# Fichiers de donnees generees (seront generes dans le conteneur)
*.csv

# Fichiers d'environnement virtuel
venv/
env/
ENV/

# Fichiers Git
.git/
.gitignore

# Fichiers IDE
.vscode/
.idea/
*.swp
*.swo

# Fichiers de documentation
*.md
docs/

# Fichiers Docker
Dockerfile
.dockerignore
docker-compose.yml

# Fichiers de logs
*.log
```

**Ce que ce fichier fait** :
- Quand Docker copie les fichiers avec `COPY . .`, il ignore les fichiers listes
- Reduit la taille de l'image
- Accelere la construction

### Etape 6.5 : Verifier la structure des fichiers

**Action** : Verifier que tous les fichiers sont au bon endroit

Votre structure doit etre :

```
votre-dossier-projet/
├── Dockerfile
├── .dockerignore
├── requirements.txt
├── generate_data.py
└── (autres fichiers Python si necessaire)
```

**Verification avec un terminal** :
```bash
# Windows
dir

# Linux/Mac
ls -la
```

**Verification avec l'Explorateur de fichiers** :
- Ouvrez votre dossier de projet
- Vous devriez voir Dockerfile, requirements.txt, generate_data.py

### Etape 6.6 : Construire l'image Docker

**Action** : Construire l'image Docker a partir du Dockerfile

**Commande a executer** :
```bash
docker build -t pollution-monitor:latest .
```

**Explication de la commande** :
- `docker build` : Commande pour construire une image
- `-t pollution-monitor:latest` : Tag (nom) de l'image
  - `pollution-monitor` : Nom de l'image
  - `latest` : Tag (version)
- `.` : Chemin vers le Dockerfile (repertoire courant)

**Premiere execution - Resultat attendu** :
```
Sending build context to Docker daemon...
Step 1/6 : FROM python:3.10-slim
 ---> abc123def456
Step 2/6 : WORKDIR /app
 ---> Running in xyz789
 ---> abc123def456
Step 3/6 : COPY requirements.txt .
 ---> abc123def456
Step 4/6 : RUN pip install --no-cache-dir -r requirements.txt
 ---> Running in xyz789
 ---> abc123def456
Step 5/6 : COPY . .
 ---> abc123def456
Step 6/6 : CMD ["python", "generate_data.py"]
 ---> Running in xyz789
 ---> abc123def456
Successfully built abc123def456
Successfully tagged pollution-monitor:latest
```

**Ce qui se passe** :
1. Docker lit le Dockerfile
2. Pour chaque instruction, Docker cree une couche (layer)
3. Les couches sont mises en cache pour accelerer les builds suivants
4. L'image finale est creee et taggee

**Temps d'execution** :
- Premiere fois : 2-5 minutes (telechargement de l'image Python)
- Fois suivantes : 10-30 secondes (utilisation du cache)

**Si vous voyez "Successfully built"** : L'image est construite avec succes

### Etape 6.7 : Verifier que l'image est creee

**Action** : Lister les images Docker pour verifier

**Commande** :
```bash
docker images
```

**Resultat attendu** :
```
REPOSITORY          TAG       IMAGE ID       CREATED         SIZE
pollution-monitor   latest    abc123def456   2 minutes ago   150MB
python              3.10-slim def456abc123   1 week ago      120MB
```

**Explication** :
- `REPOSITORY` : Nom de l'image
- `TAG` : Version (latest)
- `IMAGE ID` : Identifiant unique
- `CREATED` : Date de creation
- `SIZE` : Taille de l'image

**Si vous voyez pollution-monitor:latest** : L'image est bien creee

### Etape 6.8 : Tester l'image localement

**Action** : Executer l'image dans un conteneur pour tester

**Commande** :
```bash
docker run --rm pollution-monitor:latest
```

**Explication de la commande** :
- `docker run` : Lance un conteneur
- `--rm` : Supprime automatiquement le conteneur apres l'execution
- `pollution-monitor:latest` : Nom de l'image a executer

**Resultat attendu** :
```
Debut de la generation des donnees...
Villes : Paris, Lyon, Marseille, Toulouse
Polluants : NO2, O3, PM10, SO2
Nombre de jours : 100
Fichier de sortie : pollution_data.csv

Progression : 10/100 jours generes (160 lignes)
...
Generation terminee avec succes !
Fichier cree : pollution_data.csv
Nombre total de lignes generees : 1600
```

**Si vous voyez ce resultat** : L'image fonctionne correctement

**Note** : Le fichier CSV est cree dans le conteneur, pas sur votre ordinateur. Pour le recuperer, voir l'etape suivante.

### Etape 6.9 : Tester avec un volume (recuperer les donnees)

**Action** : Executer le conteneur avec un volume pour recuperer les donnees

**Commande** :
```bash
docker run --rm -v ${PWD}:/app/output pollution-monitor:latest
```

**Ou sur Windows PowerShell** :
```powershell
docker run --rm -v ${PWD}:/app/output pollution-monitor:latest
```

**Explication** :
- `-v ${PWD}:/app/output` : Monte le repertoire courant dans /app/output du conteneur
- Les fichiers crees dans /app/output seront accessibles sur votre ordinateur

**Modifiez le Dockerfile pour utiliser le volume** :

Changez la derniere ligne :
```dockerfile
CMD ["python", "generate_data.py"]
```

En :
```dockerfile
CMD ["sh", "-c", "python generate_data.py && cp pollution_data.csv /app/output/"]
```

**Ou modifiez generate_data.py pour ecrire dans /app/output** :
```python
FICHIER_SORTIE = "/app/output/pollution_data.csv"
```

### Etape 6.10 : Optimiser le Dockerfile (optionnel)

**Action** : Creer une version optimisee du Dockerfile

**Pourquoi optimiser** :
- Reduire la taille de l'image
- Accelerer la construction
- Ameliorer la securite

**Version optimisee avec build multi-stage** :

```dockerfile
# Stage 1 : Build (construction des dependances)
FROM python:3.10-slim as builder

WORKDIR /app

# Copier seulement requirements.txt d'abord (pour le cache Docker)
COPY requirements.txt .

# Installer les dependances dans un repertoire utilisateur
RUN pip install --user --no-cache-dir -r requirements.txt

# Stage 2 : Runtime (image finale)
FROM python:3.10-slim

WORKDIR /app

# Copier les dependances installees depuis le stage builder
COPY --from=builder /root/.local /root/.local

# Ajouter le repertoire local au PATH
ENV PATH=/root/.local/bin:$PATH

# Copier l'application
COPY . .

# Exposer le port
EXPOSE 8000

# Commande par defaut
CMD ["python", "generate_data.py"]
```

**Avantages de cette approche** :
- Image finale plus legere (ne contient pas les outils de build)
- Cache Docker plus efficace
- Separation des etapes de build et runtime

**Construire l'image optimisee** :
```bash
docker build -t pollution-monitor:optimized .
```

### Etape 6.11 : Voir la taille de l'image

**Action** : Comparer les tailles des images

**Commande** :
```bash
docker images pollution-monitor
```

**Resultat attendu** :
```
REPOSITORY          TAG         SIZE
pollution-monitor   latest      150MB
pollution-monitor   optimized   145MB
```

**Pourquoi la taille est importante** :
- Images plus petites = telechargement plus rapide
- Moins d'espace disque utilise
- Deploiement plus rapide

## Verification complete

Avant de passer a l'etape suivante, verifiez que :

- [ ] Le Dockerfile existe et est valide
- [ ] Le fichier requirements.txt existe
- [ ] Le fichier .dockerignore existe (optionnel mais recommande)
- [ ] L'image Docker est construite avec succes : `docker images` montre pollution-monitor:latest
- [ ] L'image fonctionne localement : `docker run --rm pollution-monitor:latest` execute le script
- [ ] La taille de l'image est raisonnable (< 200 MB pour une application simple)

## Commandes utiles

**Construire l'image** :
```bash
docker build -t pollution-monitor:latest .
```

**Construire sans cache** :
```bash
docker build --no-cache -t pollution-monitor:latest .
```

**Voir l'historique de construction** :
```bash
docker history pollution-monitor:latest
```

**Supprimer l'image** :
```bash
docker rmi pollution-monitor:latest
```

**Executer avec un shell interactif** :
```bash
docker run -it --rm pollution-monitor:latest /bin/bash
```

**Executer avec des variables d'environnement** :
```bash
docker run --rm -e NOMBRE_JOURS=50 pollution-monitor:latest
```

## Problemes courants et solutions detaillees

### Probleme 1 : Erreur lors du build

**Symptomes** :
- `docker build` echoue avec une erreur
- Message d'erreur dans la sortie

**Solutions** :

1. Verifiez que le Dockerfile existe :
   ```bash
   ls Dockerfile
   ```

2. Verifiez la syntaxe du Dockerfile :
   - Chaque instruction doit etre sur une nouvelle ligne
   - Pas d'espaces avant les instructions
   - Les chemins doivent etre corrects

3. Verifiez les logs d'erreur :
   - L'erreur indique generalement la ligne problematique
   - Corrigez l'erreur et reessayez

4. Verifiez que Docker fonctionne :
   ```bash
   docker ps
   ```

### Probleme 2 : Image trop volumineuse

**Symptomes** :
- L'image fait plus de 500 MB
- Temps de construction tres long

**Solutions** :

1. Utilisez une image de base plus legere :
   ```dockerfile
   FROM python:3.10-slim  # Au lieu de python:3.10
   ```

2. Utilisez un build multi-stage (voir etape 6.10)

3. Ajoutez plus de fichiers au .dockerignore

4. Utilisez `--no-cache-dir` avec pip

### Probleme 3 : L'application ne fonctionne pas dans le conteneur

**Symptomes** :
- Le conteneur demarre mais l'application echoue
- Erreurs dans les logs

**Solutions** :

1. Verifiez les logs du conteneur :
   ```bash
   docker logs <container_id>
   ```

2. Verifiez les chemins de fichiers :
   - Les chemins dans le conteneur peuvent etre differents
   - Utilisez des chemins absolus si possible

3. Verifiez les permissions :
   - Les fichiers doivent etre accessibles
   - Utilisez `chmod` si necessaire

4. Testez en mode interactif :
   ```bash
   docker run -it --rm pollution-monitor:latest /bin/bash
   ```
   Puis executez les commandes manuellement pour debugger

### Probleme 4 : Les fichiers ne sont pas copies

**Symptomes** :
- L'application ne trouve pas les fichiers
- Erreur "File not found"

**Solutions** :

1. Verifiez que les fichiers existent avant le COPY :
   ```bash
   ls -la
   ```

2. Verifiez le .dockerignore :
   - Assurez-vous que les fichiers ne sont pas ignores

3. Verifiez les chemins dans le Dockerfile :
   - Les chemins sont relatifs au contexte de build (repertoire courant)

### Probleme 5 : Les dependances ne s'installent pas

**Symptomes** :
- Erreur lors de `pip install`
- Module non trouve dans le conteneur

**Solutions** :

1. Verifiez le fichier requirements.txt :
   ```bash
   cat requirements.txt
   ```

2. Testez l'installation localement :
   ```bash
   pip install -r requirements.txt
   ```

3. Verifiez la connexion Internet dans le conteneur :
   - Docker doit pouvoir acceder a Internet pour telecharger les paquets

## Notes importantes

- L'image Docker est construite sur votre ordinateur uniquement
- Aucune donnee n'est envoyee sur Internet pendant la construction
- Les images sont stockees localement dans Docker
- Vous pouvez tester l'image localement avant tout deploiement
- Le deploiement externe est optionnel et peut etre fait plus tard

## Prochaine etape

Une fois cette etape validee avec une image Docker fonctionnelle, vous pouvez :
- Continuer avec l'etape 07 pour un deploiement optionnel
- Ou considerer le projet termine si vous travaillez uniquement en local

[Etape 07 : Deploiement optionnel](ETAPE-07-DEPLOIEMENT.md)
