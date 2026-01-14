# Rappels théoriques : Docker Avancé

## Multi-stage builds

### Concept

Permet d'utiliser plusieurs images dans un seul Dockerfile pour optimiser la taille finale.

**Avantages** :
- Image finale plus petite
- Pas d'outils de build dans l'image finale
- Sécurité améliorée

**Exemple** :
```dockerfile
# Stage 1: Build
FROM node:18 AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# Stage 2: Production
FROM node:18-alpine
WORKDIR /app
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
COPY package*.json ./
CMD ["node", "dist/index.js"]
```

## Docker Networking

### Réseaux Docker

**Types de réseaux** :
- **bridge** : Réseau par défaut (isolé)
- **host** : Utilise le réseau de l'hôte
- **overlay** : Pour Docker Swarm
- **macvlan** : Interface réseau physique

**Créer un réseau personnalisé** :
```bash
docker network create --driver bridge mynetwork
```

**Connecter un conteneur** :
```bash
docker run --network mynetwork nginx
```

### Communication entre conteneurs

**Par nom de conteneur** :
```bash
# Conteneur 1
docker run --name app nginx

# Conteneur 2 (même réseau)
docker run --name db --network bridge mysql
# Peut accéder à 'app' par son nom
```

## Docker Compose avancé

### Variables d'environnement

```yaml
version: '3.8'
services:
  app:
    image: myapp:latest
    environment:
      - DATABASE_URL=${DATABASE_URL}
      - DEBUG=${DEBUG:-false}
    env_file:
      - .env
```

### Volumes et bind mounts

```yaml
services:
  app:
    volumes:
      # Volume nommé
      - db-data:/var/lib/db
      # Bind mount
      - ./config:/app/config
      # Volume anonyme
      - /tmp

volumes:
  db-data:
```

### Health checks

```yaml
services:
  app:
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:5000/health"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 40s
```

## Sécurité Docker

### Best practices

1. **Utiliser des images officielles** : Images maintenues et sécurisées
2. **Scannage des vulnérabilités** : Utiliser Trivy, Clair, etc.
3. **Non-root user** : Ne pas exécuter en root
4. **Secrets** : Utiliser Docker Secrets ou variables d'environnement
5. **Limites de ressources** : CPU et mémoire

**Exemple non-root** :
```dockerfile
FROM node:18-alpine
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nodejs -u 1001
USER nodejs
```

## Optimisation des images

### Réduction de la taille

1. **Utiliser des images Alpine** : Plus petites
2. **Multi-stage builds** : Supprimer les outils de build
3. **Layer caching** : Optimiser l'ordre des instructions
4. **.dockerignore** : Exclure les fichiers inutiles

**Exemple .dockerignore** :
```
node_modules
.git
.env
*.log
```

## Exercices pratiques

### Exercice 1 : Multi-stage build

**Objectif** : Créer une image optimisée avec multi-stage build.

**Tâches** :
1. Créez un Dockerfile avec deux stages
2. Stage 1 : Build l'application
3. Stage 2 : Image finale minimale
4. Comparez la taille avec une build simple

**Solution** : Voir `corrections/EXERCICE-1-MULTISTAGE.md.encrypted`

### Exercice 2 : Réseau Docker personnalisé

**Objectif** : Créer un réseau et connecter plusieurs conteneurs.

**Tâches** :
1. Créez un réseau personnalisé
2. Déployez une application et une base de données
3. Vérifiez la communication entre conteneurs

**Solution** : Voir `corrections/EXERCICE-2-NETWORKING.md.encrypted`

### Exercice 3 : Docker Compose avec health checks

**Objectif** : Créer un docker-compose avec health checks et dépendances.

**Tâches** :
1. Créez un docker-compose.yml
2. Ajoutez des health checks
3. Configurez les dépendances entre services

**Solution** : Voir `corrections/EXERCICE-3-HEALTHCHECKS.md.encrypted`

## Commandes Docker avancées

```bash
# Inspecter un réseau
docker network inspect mynetwork

# Voir les logs d'un conteneur
docker logs -f <container>

# Exécuter une commande dans un conteneur en cours
docker exec -it <container> /bin/sh

# Voir l'utilisation des ressources
docker stats

# Nettoyer les ressources inutilisées
docker system prune -a

# Construire avec cache
docker build --cache-from myimage:latest -t myimage:latest .
```

## Intégration avec Prometheus

### Exposer les métriques

**Option 1 : Node Exporter dans un conteneur**
```yaml
services:
  node-exporter:
    image: prom/node-exporter:latest
    volumes:
      - /proc:/host/proc:ro
      - /sys:/host/sys:ro
    command:
      - '--path.procfs=/host/proc'
      - '--path.sysfs=/host/sys'
```

**Option 2 : Métriques applicatives**
```python
# Dans l'application
from prometheus_client import start_http_server
start_http_server(9090)
```

## Ressources supplémentaires

- [Docker Best Practices](https://docs.docker.com/develop/dev-best-practices/)
- [Docker Security](https://docs.docker.com/engine/security/)
- [Docker Compose Reference](https://docs.docker.com/compose/compose-file/)

