# Etape 03 : Deploiement de la stack ELK

## Objectif

Deployer Elasticsearch, Logstash et Kibana avec Docker Compose pour traiter et visualiser les donnees generees.

## Duree estimee

1h-1h30

## Instructions pas a pas

### Etape 3.1 : Creer le fichier docker-compose.yml

Creez un fichier nomme `docker-compose.yml` avec le contenu suivant :

```yaml
version: '3.8'

services:
  elasticsearch:
    image: docker.elastic.co/elasticsearch/elasticsearch:7.17.0
    container_name: elasticsearch
    environment:
      - discovery.type=single-node
      - xpack.security.enabled=false
      - "ES_JAVA_OPTS=-Xms512m -Xmx512m"
    ports:
      - "9200:9200"
    networks:
      - elk
    volumes:
      - elasticsearch_data:/usr/share/elasticsearch/data

  kibana:
    image: docker.elastic.co/kibana/kibana:7.17.0
    container_name: kibana
    ports:
      - "5601:5601"
    environment:
      - ELASTICSEARCH_HOSTS=http://elasticsearch:9200
    depends_on:
      - elasticsearch
    networks:
      - elk

  logstash:
    image: docker.elastic.co/logstash/logstash:7.17.0
    container_name: logstash
    volumes:
      - ./logstash.conf:/usr/share/logstash/pipeline/logstash.conf
      - ../pollution_data.csv:/usr/share/logstash/pollution_data.csv
    depends_on:
      - elasticsearch
    networks:
      - elk

networks:
  elk:
    driver: bridge

volumes:
  elasticsearch_data:
    driver: local
```

### Etape 3.2 : Creer le fichier logstash.conf

Creez un dossier `logstash` et un fichier `logstash/logstash.conf` avec le contenu suivant :

```conf
input {
  file {
    path => "/usr/share/logstash/pollution_data.csv"
    start_position => "beginning"
    sincedb_path => "/dev/null"
  }
}

filter {
  csv {
    separator => ","
    columns => ["date", "ville", "polluant", "valeur"]
  }

  mutate {
    convert => { "valeur" => "float" }
  }

  date {
    match => ["date", "YYYY-MM-dd"]
    target => "@timestamp"
  }

  mutate {
    add_field => { "[@metadata][index_name]" => "%{+YYYY.MM.dd}" }
  }
}

output {
  elasticsearch {
    hosts => ["http://elasticsearch:9200"]
    index => "pollution-%{[@metadata][index_name]}"
  }

  stdout { codec => rubydebug }
}
```

### Etape 3.3 : Copier le fichier de donnees

Assurez-vous que le fichier `pollution_data.csv` est dans le repertoire parent :

```bash
# Si vous etes dans le dossier de l'etape 03
cp ../pollution_data.csv .
# Puis modifiez le chemin dans docker-compose.yml : ./pollution_data.csv
```

Ou modifiez le chemin dans docker-compose.yml pour pointer vers le bon emplacement.

### Etape 3.4 : Demarrer la stack ELK

Executez :

```bash
docker-compose up -d
```

**Resultat attendu** :
```
Creating network "elk_elk" ... done
Creating volume "elk_elasticsearch_data" ... done
Creating elasticsearch ... done
Creating kibana ... done
Creating logstash ... done
```

### Etape 3.5 : Verifier que les services sont demarres

Executez :

```bash
docker-compose ps
```

**Resultat attendu** : Tous les conteneurs doivent etre "Up"

### Etape 3.6 : Verifier Elasticsearch

Attendez 30 secondes, puis executez :

```bash
curl http://localhost:9200
```

**Resultat attendu** : Une reponse JSON avec des informations sur Elasticsearch

### Etape 3.7 : Acceder a Kibana

Ouvrez votre navigateur et allez sur :

http://localhost:5601

Attendez quelques secondes que Kibana se charge completement.

## Verification

Avant de passer a l'etape suivante, verifiez que :

- [ ] Tous les conteneurs sont demarres (docker-compose ps)
- [ ] Elasticsearch est accessible (curl http://localhost:9200)
- [ ] Kibana est accessible (http://localhost:5601)
- [ ] Les donnees sont indexees (voir les logs de Logstash avec `docker-compose logs logstash`)

## Problemes courants

### Les conteneurs ne demarrent pas

**Solution** : Verifiez les logs avec `docker-compose logs`

### Port deja utilise

**Solution** : Changez les ports dans docker-compose.yml (ex: "9201:9200" au lieu de "9200:9200")

### Erreur de memoire

**Solution** : Augmentez la memoire allouee a Docker (Docker Desktop → Settings → Resources)

### Kibana ne se charge pas

**Solution** : Attendez quelques minutes, Kibana peut prendre du temps a demarrer

## Prochaine etape

Une fois cette etape validee, passez a :
[Etape 04 : Visualisation Kibana](ETAPE-04-VISUALISATION-KIBANA.md)
