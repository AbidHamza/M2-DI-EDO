# Etape 03 : Deploiement de la stack ELK

## Objectif

Deployer Elasticsearch, Logstash et Kibana avec Docker Compose pour traiter et visualiser les donnees generees. Tout fonctionne en local sur votre ordinateur.

## Duree estimee

1h-1h30

## Prérequis

- Docker installe et fonctionnel (etape 01 validee)
- Docker Compose installe (etape 01 validee)
- Fichier pollution_data.csv genere (etape 02 validee)
- 4 Go de RAM minimum disponibles
- Au moins 5 Go d'espace disque libre

## Important : Tout en local

Tous les services fonctionnent sur votre ordinateur uniquement :
- Elasticsearch : http://localhost:9200
- Kibana : http://localhost:5601
- Aucune donnee n'est envoyee sur Internet
- Tout reste sur votre machine

## Instructions pas a pas avec tous les details

### Etape 3.1 : Creer un dossier pour la stack ELK

**Action** : Creer un dossier pour organiser les fichiers de la stack ELK

**Avec un terminal** :
```bash
mkdir stack-elk
cd stack-elk
```

**Avec l'Explorateur de fichiers** :
- Creez un nouveau dossier nomme "stack-elk"
- Ouvrez ce dossier

**Pourquoi un dossier separe** : Pour garder les fichiers organises et faciles a trouver

### Etape 3.2 : Copier le fichier de donnees

**Action** : Copier le fichier pollution_data.csv dans le dossier stack-elk

**Avec un terminal** :
```bash
# Si vous etes dans le dossier stack-elk
cp ../pollution_data.csv .
```

**Avec l'Explorateur de fichiers** :
- Allez dans le dossier ou se trouve pollution_data.csv
- Copiez le fichier (Ctrl+C)
- Allez dans le dossier stack-elk
- Collez le fichier (Ctrl+V)

**Verification** :
```bash
ls pollution_data.csv
```
ou
```bash
dir pollution_data.csv
```

Le fichier doit exister dans le dossier stack-elk

### Etape 3.3 : Creer le fichier docker-compose.yml

**Action** : Creer le fichier de configuration Docker Compose

**Avec un editeur de texte** :
1. Creez un nouveau fichier
2. Nommez-le exactement : `docker-compose.yml`
3. Assurez-vous que l'extension est `.yml` et non `.yml.txt`

**Contenu exact du fichier** :

Copiez-collez exactement ce contenu :

```yaml
version: '3.8'

services:
  # Service Elasticsearch : Base de donnees de recherche
  elasticsearch:
    image: docker.elastic.co/elasticsearch/elasticsearch:7.17.0
    container_name: elasticsearch
    environment:
      # Configuration pour un seul noeud (developpement local)
      - discovery.type=single-node
      # Desactiver la securite pour simplifier (ne pas faire en production)
      - xpack.security.enabled=false
      # Allocation de memoire pour Elasticsearch (512 Mo minimum, 1 Go recommande)
      - "ES_JAVA_OPTS=-Xms512m -Xmx512m"
    ports:
      # Port HTTP pour acceder a Elasticsearch depuis votre ordinateur
      - "9200:9200"
    networks:
      - elk
    volumes:
      # Volume pour persister les donnees Elasticsearch
      # Les donnees restent sur votre ordinateur meme apres l'arrete des conteneurs
      - elasticsearch_data:/usr/share/elasticsearch/data
    healthcheck:
      # Verification automatique de la sante d'Elasticsearch
      test: ["CMD-SHELL", "curl -f http://localhost:9200/_cluster/health || exit 1"]
      interval: 30s
      timeout: 10s
      retries: 5

  # Service Kibana : Interface de visualisation
  kibana:
    image: docker.elastic.co/kibana/kibana:7.17.0
    container_name: kibana
    ports:
      # Port HTTP pour acceder a Kibana depuis votre navigateur
      - "5601:5601"
    environment:
      # URL d'Elasticsearch (utilise le nom du service Docker)
      - ELASTICSEARCH_HOSTS=http://elasticsearch:9200
    depends_on:
      # Kibana attend qu'Elasticsearch soit pret avant de demarrer
      elasticsearch:
        condition: service_healthy
    networks:
      - elk
    healthcheck:
      # Verification automatique de la sante de Kibana
      test: ["CMD-SHELL", "curl -f http://localhost:5601/api/status || exit 1"]
      interval: 30s
      timeout: 10s
      retries: 5

  # Service Logstash : Pipeline de traitement de donnees
  logstash:
    image: docker.elastic.co/logstash/logstash:7.17.0
    container_name: logstash
    volumes:
      # Configuration du pipeline Logstash
      - ./logstash.conf:/usr/share/logstash/pipeline/logstash.conf
      # Fichier CSV de donnees (chemin relatif depuis ce dossier)
      - ./pollution_data.csv:/usr/share/logstash/pollution_data.csv
    depends_on:
      # Logstash attend qu'Elasticsearch soit pret
      elasticsearch:
        condition: service_healthy
    networks:
      - elk
    environment:
      # Configuration de la memoire pour Logstash
      - "LS_JAVA_OPTS=-Xmx256m -Xms256m"

# Reseau Docker pour connecter les services entre eux
networks:
  elk:
    driver: bridge

# Volumes pour la persistance des donnees
volumes:
  elasticsearch_data:
    driver: local
```

**Explication de chaque section** :

**version: '3.8'** :
- Specifie la version du format Docker Compose
- 3.8 est une version stable et largement supportee

**services:** :
- Liste de tous les services (conteneurs) a deployer
- Chaque service est un conteneur Docker

**elasticsearch:** :
- Nom du service (vous pouvez le changer)
- `image:` : Image Docker a utiliser
- `container_name:` : Nom du conteneur (facilite l'identification)
- `environment:` : Variables d'environnement pour configurer Elasticsearch
- `ports:` : Mappage des ports (port_local:port_conteneur)
- `networks:` : Reseau auquel le service appartient
- `volumes:` : Stockage persistant pour les donnees
- `healthcheck:` : Verification automatique que le service fonctionne

**kibana:** :
- Service pour l'interface de visualisation
- `depends_on:` : Attend qu'Elasticsearch soit pret
- `ELASTICSEARCH_HOSTS:` : URL pour se connecter a Elasticsearch

**logstash:** :
- Service pour traiter les donnees
- `volumes:` : Monte les fichiers de configuration et de donnees

**networks:** :
- Reseau Docker pour que les services puissent communiquer
- Les services peuvent se parler en utilisant leur nom (ex: elasticsearch)

**volumes:** :
- Stockage persistant pour les donnees
- Les donnees restent meme si vous arretez les conteneurs

### Etape 3.4 : Creer le dossier logstash

**Action** : Creer un dossier pour la configuration Logstash

```bash
mkdir logstash
```

**Pourquoi un dossier separe** : Pour organiser les fichiers de configuration

### Etape 3.5 : Creer le fichier logstash.conf

**Action** : Creer le fichier de configuration Logstash

Creez un fichier `logstash/logstash.conf` avec le contenu suivant :

```conf
# Configuration du pipeline Logstash
# Ce fichier definit comment Logstash traite les donnees

# Section INPUT : D'ou viennent les donnees
input {
  # Lecture d'un fichier CSV
  file {
    # Chemin vers le fichier CSV dans le conteneur
    path => "/usr/share/logstash/pollution_data.csv"
    # Commencer a lire depuis le debut du fichier
    start_position => "beginning"
    # Ne pas utiliser de fichier de suivi (pour relire le fichier a chaque fois)
    sincedb_path => "/dev/null"
  }
}

# Section FILTER : Comment transformer les donnees
filter {
  # Parser le fichier CSV
  csv {
    # Separateur utilise dans le CSV (virgule)
    separator => ","
    # Noms des colonnes dans l'ordre
    columns => ["date", "ville", "polluant", "valeur"]
  }

  # Convertir la valeur en nombre flottant
  mutate {
    # Convertir le champ "valeur" de texte en nombre decimal
    convert => { "valeur" => "float" }
  }

  # Convertir la date en timestamp
  date {
    # Parser le champ "date" au format YYYY-MM-DD
    match => ["date", "YYYY-MM-dd"]
    # Stocker le resultat dans le champ @timestamp (standard Elasticsearch)
    target => "@timestamp"
  }

  # Ajouter un champ pour le nom d'index
  mutate {
    # Creer un champ metadata avec le nom d'index base sur la date
    # Format : pollution-2023.01.01
    add_field => { "[@metadata][index_name]" => "%{+YYYY.MM.dd}" }
  }
}

# Section OUTPUT : Ou envoyer les donnees
output {
  # Envoyer vers Elasticsearch
  elasticsearch {
    # URL d'Elasticsearch (utilise le nom du service Docker)
    hosts => ["http://elasticsearch:9200"]
    # Nom de l'index avec la date
    # Exemple : pollution-2023.01.01
    index => "pollution-%{[@metadata][index_name]}"
  }

  # Afficher aussi dans la console pour debug
  stdout { 
    codec => rubydebug 
  }
}
```

**Explication de chaque section** :

**input { file { } }** :
- Lit le fichier CSV ligne par ligne
- `start_position => "beginning"` : Commence depuis le debut
- `sincedb_path => "/dev/null"` : Ne sauvegarde pas la position (relit tout a chaque fois)

**filter { csv { } }** :
- Parse chaque ligne du CSV
- Separe les colonnes avec la virgule
- Assigne les noms de colonnes

**filter { mutate { convert } }** :
- Convertit le champ "valeur" en nombre
- Permet de faire des calculs et des aggregations dans Elasticsearch

**filter { date { } }** :
- Convertit la date texte en timestamp
- Elasticsearch utilise les timestamps pour les recherches temporelles

**filter { mutate { add_field } }** :
- Ajoute un champ metadata avec le nom d'index
- Permet de creer un index par jour

**output { elasticsearch { } }** :
- Envoie les donnees vers Elasticsearch
- Cree un index par jour (ex: pollution-2023.01.01)

**output { stdout { } }** :
- Affiche aussi les donnees dans les logs
- Utile pour debugger

### Etape 3.6 : Verifier la structure des fichiers

**Action** : Verifier que tous les fichiers sont au bon endroit

Votre structure doit etre :

```
stack-elk/
├── docker-compose.yml
├── pollution_data.csv
└── logstash/
    └── logstash.conf
```

**Verification avec un terminal** :
```bash
# Windows
dir
dir logstash

# Linux/Mac
ls -la
ls -la logstash/
```

**Verification avec l'Explorateur de fichiers** :
- Ouvrez le dossier stack-elk
- Vous devriez voir docker-compose.yml et pollution_data.csv
- Ouvrez le dossier logstash
- Vous devriez voir logstash.conf

### Etape 3.7 : Demarrer la stack ELK

**Action** : Lancer tous les services avec Docker Compose

**Commande a executer** :
```bash
docker-compose up -d
```

**Ce que cette commande fait** :
- `docker-compose` : Utilise Docker Compose pour gerer plusieurs conteneurs
- `up` : Demarre les conteneurs
- `-d` : Mode detache (en arriere-plan), vous pouvez continuer a utiliser le terminal

**Premiere execution - Resultat attendu** :
```
Creating network "stack-elk_elk" ... done
Creating volume "stack-elk_elasticsearch_data" ... done
Creating elasticsearch ... done
Creating kibana ... done
Creating logstash ... done
```

**Ce qui se passe** :
1. Docker Compose cree un reseau pour les services
2. Docker Compose cree un volume pour les donnees Elasticsearch
3. Docker telecharge les images si necessaire (premiere fois seulement)
4. Docker demarre les trois conteneurs

**Temps d'execution** :
- Premiere fois : 2-5 minutes (telechargement des images)
- Fois suivantes : 30-60 secondes

### Etape 3.8 : Attendre que les services soient prets

**Action** : Attendre que tous les services soient demarres

**Temps d'attente** : 1-2 minutes

**Pourquoi attendre** :
- Elasticsearch doit demarrer completement
- Kibana doit se connecter a Elasticsearch
- Logstash doit commencer a traiter les donnees

**Verification pendant l'attente** :
```bash
docker-compose ps
```

**Resultat attendu apres quelques secondes** :
```
NAME                STATUS
elasticsearch      Up (healthy)
kibana             Up (healthy)
logstash           Up
```

**Si vous voyez "Up (healthy)"** : Les services sont prets

**Si vous voyez "Up" sans healthy** : Attendez encore quelques secondes

### Etape 3.9 : Verifier Elasticsearch

**Action** : Tester qu'Elasticsearch fonctionne

**Attendez 30 secondes** apres le demarrage, puis executez :

```bash
curl http://localhost:9200
```

**Sur Windows sans curl** :
- Ouvrez votre navigateur
- Allez sur http://localhost:9200
- Vous devriez voir une reponse JSON

**Resultat attendu** :
```json
{
  "name" : "elasticsearch",
  "cluster_name" : "docker-cluster",
  "cluster_uuid" : "abc123...",
  "version" : {
    "number" : "7.17.0",
    ...
  }
}
```

**Si vous voyez cette reponse JSON** : Elasticsearch fonctionne correctement

**Si vous voyez une erreur** :
- Verifiez que le conteneur est demarre : `docker-compose ps`
- Consultez les logs : `docker-compose logs elasticsearch`

### Etape 3.10 : Verifier que les donnees sont indexees

**Action** : Verifier que Logstash a traite les donnees

**Commande** :
```bash
curl http://localhost:9200/_cat/indices?v
```

**Resultat attendu** :
```
health status index                uuid                   pri rep docs.count
green  open   pollution-2023.01.01 abc123...              1   0        16
green  open   pollution-2023.01.02 def456...              1   0        16
...
```

**Explication** :
- `health` : Etat de sante de l'index (green = bon)
- `index` : Nom de l'index (un par jour)
- `docs.count` : Nombre de documents dans l'index (16 par jour = 4 villes × 4 polluants)

**Si vous voyez des index pollution-*** : Les donnees sont bien indexees

**Si vous ne voyez pas d'index** :
- Attendez encore 1-2 minutes
- Verifiez les logs de Logstash : `docker-compose logs logstash`

### Etape 3.11 : Acceder a Kibana

**Action** : Ouvrir Kibana dans votre navigateur

1. Ouvrez votre navigateur web (Chrome, Firefox, Edge, etc.)
2. Allez a l'adresse suivante : http://localhost:5601
3. Attendez que Kibana se charge (30-60 secondes la premiere fois)

**Premier chargement - Ce que vous verrez** :
- Une page de chargement Kibana
- Puis eventuellement une page d'accueil Kibana

**Si la page ne se charge pas** :
- Attendez encore 1-2 minutes (Kibana peut etre lent au demarrage)
- Verifiez que le conteneur est demarre : `docker-compose ps`
- Consultez les logs : `docker-compose logs kibana`

### Etape 3.12 : Verifier les logs des services

**Action** : Consulter les logs pour verifier que tout fonctionne

**Voir tous les logs** :
```bash
docker-compose logs
```

**Voir les logs d'un service specifique** :
```bash
docker-compose logs elasticsearch
docker-compose logs kibana
docker-compose logs logstash
```

**Voir les logs en temps reel** :
```bash
docker-compose logs -f
```
(Appuyez sur Ctrl+C pour arreter)

**Ce que vous devriez voir dans les logs de Logstash** :
- Des messages indiquant la lecture du fichier CSV
- Des messages indiquant l'envoi vers Elasticsearch
- Des donnees affichees (si stdout est active)

## Verification complete

Avant de passer a l'etape suivante, verifiez que :

- [ ] Tous les conteneurs sont demarres : `docker-compose ps` montre "Up"
- [ ] Elasticsearch est accessible : `curl http://localhost:9200` retourne du JSON
- [ ] Les donnees sont indexees : `curl http://localhost:9200/_cat/indices?v` montre des index pollution-*
- [ ] Kibana est accessible : http://localhost:5601 se charge dans le navigateur
- [ ] Les logs ne montrent pas d'erreurs critiques

## Commandes utiles pour gerer la stack

**Arreter la stack** :
```bash
docker-compose down
```

**Arreter et supprimer les volumes** (supprime les donnees) :
```bash
docker-compose down -v
```

**Redemarrer la stack** :
```bash
docker-compose restart
```

**Voir l'utilisation des ressources** :
```bash
docker stats
```

**Entrer dans un conteneur** :
```bash
docker exec -it elasticsearch bash
```

## Problemes courants et solutions detaillees

### Probleme 1 : Les conteneurs ne demarrent pas

**Symptomes** :
- `docker-compose up -d` echoue
- Les conteneurs ne sont pas dans la liste avec `docker-compose ps`

**Solutions** :

1. Verifiez les logs :
   ```bash
   docker-compose logs
   ```
   Les logs indiqueront l'erreur exacte

2. Verifiez que Docker fonctionne :
   ```bash
   docker ps
   ```

3. Verifiez que les ports ne sont pas deja utilises :
   ```bash
   # Windows
   netstat -ano | findstr :9200
   
   # Linux/Mac
   lsof -i :9200
   ```
   Si quelque chose utilise le port, arretez-le ou changez le port dans docker-compose.yml

### Probleme 2 : Port deja utilise

**Symptomes** :
- Erreur "port is already allocated"
- Les conteneurs ne peuvent pas demarrer

**Solutions** :

**Solution 1 : Arreter ce qui utilise le port**
```bash
# Trouver le processus
# Windows
netstat -ano | findstr :9200

# Linux/Mac
lsof -i :9200

# Arreter le processus (remplacez PID par le numero trouve)
# Windows
taskkill /PID <PID> /F

# Linux/Mac
kill <PID>
```

**Solution 2 : Changer les ports dans docker-compose.yml**
Modifiez les ports :
```yaml
ports:
  - "9201:9200"  # Au lieu de 9200:9200
```
Puis accedez a Elasticsearch sur http://localhost:9201

### Probleme 3 : Erreur de memoire

**Symptomes** :
- Elasticsearch ne demarre pas
- Message d'erreur concernant la memoire

**Solutions** :

1. Augmentez la memoire allouee a Docker :
   - Docker Desktop → Settings → Resources → Advanced
   - Augmentez la memoire a au moins 4 Go
   - Cliquez sur "Apply & Restart"

2. Reduisez la memoire d'Elasticsearch dans docker-compose.yml :
   ```yaml
   - "ES_JAVA_OPTS=-Xms256m -Xmx256m"  # Au lieu de 512m
   ```

### Probleme 4 : Kibana ne se charge pas

**Symptomes** :
- La page http://localhost:5601 ne se charge pas
- Erreur 502 ou page blanche

**Solutions** :

1. Attendez plus longtemps (Kibana peut prendre 2-3 minutes au demarrage)

2. Verifiez que Kibana est pret :
   ```bash
   docker-compose logs kibana | tail -20
   ```
   Cherchez "Server running" dans les logs

3. Verifiez qu'Elasticsearch fonctionne :
   ```bash
   curl http://localhost:9200
   ```

4. Redemarrez Kibana :
   ```bash
   docker-compose restart kibana
   ```

### Probleme 5 : Les donnees ne sont pas indexees

**Symptomes** :
- Pas d'index dans Elasticsearch
- Logstash ne traite pas les donnees

**Solutions** :

1. Verifiez que le fichier CSV existe dans le conteneur :
   ```bash
   docker exec logstash ls -la /usr/share/logstash/pollution_data.csv
   ```

2. Verifiez les logs de Logstash :
   ```bash
   docker-compose logs logstash
   ```
   Cherchez les erreurs

3. Verifiez que le chemin dans docker-compose.yml est correct :
   - Le chemin doit etre relatif au dossier ou se trouve docker-compose.yml
   - Exemple : `./pollution_data.csv` si le fichier est dans le meme dossier

4. Redemarrez Logstash :
   ```bash
   docker-compose restart logstash
   ```

### Probleme 6 : Erreur "Cannot connect to Elasticsearch" dans Kibana

**Symptomes** :
- Kibana affiche une erreur de connexion
- Les logs de Kibana montrent des erreurs de connexion

**Solutions** :

1. Verifiez qu'Elasticsearch fonctionne :
   ```bash
   curl http://localhost:9200
   ```

2. Verifiez que les deux services sont sur le meme reseau :
   ```bash
   docker network inspect stack-elk_elk
   ```
   Les deux services doivent etre dans la liste

3. Redemarrez Kibana :
   ```bash
   docker-compose restart kibana
   ```

## Verification finale

Executez ces commandes et verifiez chaque resultat :

**Test 1** :
```bash
docker-compose ps
```
**Attendu** : Tous les conteneurs sont "Up" et "healthy"

**Test 2** :
```bash
curl http://localhost:9200
```
**Attendu** : Reponse JSON avec des informations sur Elasticsearch

**Test 3** :
```bash
curl http://localhost:9200/_cat/indices?v
```
**Attendu** : Liste d'index commencant par "pollution-"

**Test 4** :
- Ouvrez http://localhost:5601 dans votre navigateur
**Attendu** : Page Kibana se charge (peut prendre 1-2 minutes)

**Si tous les tests passent** : La stack ELK est correctement deployee

## Notes importantes

- Tous les services fonctionnent sur votre ordinateur uniquement
- Aucune donnee n'est envoyee sur Internet
- Les donnees Elasticsearch sont stockees dans un volume Docker sur votre machine
- Vous pouvez arreter la stack avec `docker-compose down` sans perdre les donnees
- Pour supprimer les donnees, utilisez `docker-compose down -v`

## Prochaine etape

Une fois cette etape validee avec tous les tests qui passent, vous pouvez passer a :
[Etape 04 : Visualisation Kibana](ETAPE-04-VISUALISATION-KIBANA.md)
