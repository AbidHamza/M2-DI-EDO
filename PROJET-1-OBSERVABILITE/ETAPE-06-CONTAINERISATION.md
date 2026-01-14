# Etape 06 : Containerisation

## Objectif

Creer un Dockerfile pour containeriser l'application et la preparer pour le deploiement.

## Duree estimee

45 minutes-1h

## Instructions pas a pas

### Etape 6.1 : Creer le Dockerfile

Creez un fichier nomme `Dockerfile` avec le contenu suivant :

```dockerfile
# Utiliser une image Python officielle
FROM python:3.10-slim

# Definir le repertoire de travail
WORKDIR /app

# Copier les fichiers de requirements
COPY requirements.txt .

# Installer les dependances
RUN pip install --no-cache-dir -r requirements.txt

# Copier le reste de l'application
COPY . .

# Exposer le port (si votre application en a besoin)
EXPOSE 8000

# Commande par defaut
CMD ["python", "generate_data.py"]
```

### Etape 6.2 : Creer le fichier requirements.txt

Si vous n'avez pas encore de fichier requirements.txt, creez-le :

```txt
# Aucune dependance externe necessaire pour generate_data.py
# Les modules csv, datetime et random sont integres a Python
```

### Etape 6.3 : Construire l'image Docker

Executez :

```bash
docker build -t pollution-monitor:latest .
```

**Resultat attendu** :
```
Sending build context to Docker daemon...
Step 1/6 : FROM python:3.10-slim
...
Successfully built abc123def456
Successfully tagged pollution-monitor:latest
```

### Etape 6.4 : Tester l'image localement

Executez :

```bash
docker run --rm pollution-monitor:latest
```

**Resultat attendu** : Le script s'execute et genere les donnees

### Etape 6.5 : Optimiser le Dockerfile (optionnel)

Pour une image plus optimisee, vous pouvez utiliser un build multi-stage :

```dockerfile
# Stage de build
FROM python:3.10-slim as builder
WORKDIR /app
COPY requirements.txt .
RUN pip install --user -r requirements.txt

# Stage final
FROM python:3.10-slim
WORKDIR /app
COPY --from=builder /root/.local /root/.local
COPY . .
ENV PATH=/root/.local/bin:$PATH
CMD ["python", "generate_data.py"]
```

## Verification

Avant de passer a l'etape suivante, verifiez que :

- [ ] Le Dockerfile existe et est valide
- [ ] L'image Docker est construite avec succes
- [ ] L'image fonctionne localement
- [ ] La taille de l'image est raisonnable

## Problemes courants

### Erreur lors du build

**Solution** : Verifiez les logs d'erreur et corrigez le Dockerfile

### Image trop volumineuse

**Solution** : Utilisez une image de base plus legere (python:3.10-slim au lieu de python:3.10)

### L'application ne fonctionne pas dans le conteneur

**Solution** : Verifiez les chemins de fichiers et les permissions

## Prochaine etape

Une fois cette etape validee, passez a :
[Etape 07 : Deploiement](ETAPE-07-DEPLOIEMENT.md)
