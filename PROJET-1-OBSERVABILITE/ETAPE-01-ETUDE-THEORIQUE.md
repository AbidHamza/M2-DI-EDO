# Etape 1 : Etude Theorique (30 points)

## Introduction

Cette premiere partie constitue le socle theorique de votre projet. Elle represente **30 points sur 100** et doit demontrer votre comprehension approfondie des concepts d'observabilite et des outils utilises. Chaque section doit etre traitee dans votre rapport avec des schemas, des exemples concrets et des comparaisons.

---

## 1. Qu'est-ce que l'Observabilite ?

### Definition

L'observabilite est la capacite a comprendre l'etat interne d'un systeme en observant ses sorties externes. Contrairement au simple monitoring (qui repond a "est-ce que ca marche ?"), l'observabilite repond a **"pourquoi ca ne marche pas ?"**.

Le terme vient de la **theorie du controle** en ingenierie : un systeme est dit "observable" si son etat interne peut etre determine a partir de ses sorties.

### Les 3 Piliers de l'Observabilite

```
                    OBSERVABILITE
                         |
          +--------------+--------------+
          |              |              |
     METRIQUES         LOGS          TRACES
     (Prometheus)     (Loki)      (Jaeger/Tempo)
          |              |              |
    "Combien ?"    "Que s'est-il   "Quel chemin ?"
    "A quelle      passe ?"
     frequence ?"
```

#### Pilier 1 : Les Metriques

Les metriques sont des **valeurs numeriques mesurees dans le temps**. Elles repondent aux questions quantitatives.

- **Exemples** : nombre de requetes/seconde, temps de reponse moyen, utilisation CPU, memoire disponible
- **Caracteristiques** : faible cout de stockage, agregables, ideales pour les alertes
- **Outil principal** : **Prometheus**
- **Types de metriques** :
  - **Counter** : valeur qui ne fait qu'augmenter (nombre total de requetes)
  - **Gauge** : valeur qui monte et descend (temperature, memoire utilisee)
  - **Histogram** : distribution de valeurs (latences reparties en buckets)
  - **Summary** : similaire a l'histogramme mais calcule les quantiles cote client

#### Pilier 2 : Les Logs

Les logs sont des **enregistrements textuels horodates** d'evenements. Ils racontent ce qui s'est passe.

- **Exemples** : erreur d'authentification, demarrage d'un service, requete SQL executee
- **Caracteristiques** : riches en contexte, couteux en stockage, difficiles a agreger
- **Outil principal** : **Loki** (alternative : ELK Stack)
- **Bonnes pratiques** :
  - Logs structures (JSON) plutot que texte libre
  - Niveaux de log : DEBUG, INFO, WARNING, ERROR, CRITICAL
  - Inclure un identifiant de correlation (trace_id)

#### Pilier 3 : Les Traces (Distribuees)

Les traces suivent le **parcours d'une requete** a travers les differents services d'un systeme distribue.

- **Exemples** : requete utilisateur → API Gateway → Service Auth → Base de donnees → Reponse
- **Caracteristiques** : visibilite inter-services, identification des goulots d'etranglement
- **Outils** : Jaeger, Zipkin, Tempo
- **Note** : dans ce projet, nous nous concentrons sur les metriques et les logs. Les traces sont mentionnees pour la completude theorique.

### Monitoring vs Observabilite

| Aspect | Monitoring | Observabilite |
|--------|-----------|---------------|
| **Question** | "Ca marche ?" | "Pourquoi ca ne marche pas ?" |
| **Approche** | Reactive (alertes predefinies) | Proactive (exploration libre) |
| **Donnees** | Metriques predefinies | Metriques + Logs + Traces |
| **Problemes** | Connus a l'avance | Inconnus (unknown unknowns) |
| **Complexite** | Systemes simples | Systemes distribues |

---

## 2. Prometheus : Collecte et Stockage de Metriques

### Architecture de Prometheus

```
+-------------------+     +-------------------+     +-------------------+
|   Application 1   |     |   Application 2   |     |  Node Exporter    |
|   /metrics         |     |   /metrics         |     |   /metrics         |
+--------+----------+     +--------+----------+     +--------+----------+
         ^                          ^                          ^
         |    HTTP GET /metrics     |                          |
         |   (pull model)          |                          |
+--------+--------------------------+--------------------------+----------+
|                           PROMETHEUS SERVER                             |
|                                                                         |
|  +----------------+  +----------------+  +------------------+           |
|  |  Retrieval     |  |   TSDB         |  |  HTTP Server     |           |
|  |  (scraping)    |->|  (stockage     |->|  (API + PromQL)  |           |
|  |                |  |   time-series) |  |                  |           |
|  +----------------+  +----------------+  +------------------+           |
|                                                                         |
|  +----------------+  +------------------+                               |
|  | Service        |  |  Rule Manager    |-----> Alertmanager            |
|  | Discovery      |  |  (alertes +      |                               |
|  |                |  |   recording)     |                               |
|  +----------------+  +------------------+                               |
+-------------------------------------------------------------------------+
```

### Le Modele Pull

Prometheus utilise un **modele pull** : c'est Prometheus qui va chercher les metriques aupres des applications, et non les applications qui les envoient.

**Avantages du pull :**
- Prometheus controle la frequence de collecte
- Plus facile a debugger (on peut acceder a `/metrics` manuellement)
- Detection automatique des services down (pas de scrape = alerte)
- Pas besoin de configurer les applications pour savoir ou envoyer

**Inconvenient :**
- Necessite que les applications exposent un endpoint HTTP `/metrics`
- Moins adapte aux jobs ephemeres (solution : Pushgateway)

### PromQL (Prometheus Query Language)

PromQL est le langage de requete de Prometheus. Exemples :

```promql
# Taux de requetes par seconde sur 5 minutes
rate(http_requests_total[5m])

# Latence au 95e percentile
histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m]))

# Pourcentage d'erreurs
sum(rate(http_requests_total{status=~"5.."}[5m])) / sum(rate(http_requests_total[5m])) * 100

# Memoire utilisee en pourcentage
(1 - (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes)) * 100
```

### Stockage TSDB (Time Series Database)

Prometheus stocke les donnees dans une base de donnees temporelles (TSDB) sur disque local :
- **Blocs de 2 heures** compactes periodiquement
- **Retention configurable** (par defaut 15 jours)
- **Compression efficace** pour les donnees temporelles
- **Pas de clustering natif** (voir Thanos/Cortex pour la scalabilite)

### Configuration du Scraping

```yaml
# Exemple de configuration prometheus.yml
scrape_configs:
  - job_name: 'mon-application'
    scrape_interval: 15s        # Frequence de collecte
    metrics_path: '/metrics'    # Chemin de l'endpoint
    static_configs:
      - targets: ['app:5000']   # Adresse de la cible
```

---

## 3. Grafana : Visualisation et Dashboards

### Architecture de Grafana

Grafana est une plateforme de **visualisation de donnees** open-source. Elle ne stocke pas de donnees elle-meme mais se connecte a des **sources de donnees** (datasources).

```
+------------------+     +------------------+     +------------------+
|   Prometheus     |     |     Loki         |     | Autres sources   |
|   (metriques)    |     |   (logs)         |     | (InfluxDB, ES..) |
+--------+---------+     +--------+---------+     +--------+---------+
         |                        |                        |
         +------------+-----------+------------------------+
                      |
                      v
         +------------+------------+
         |        GRAFANA          |
         |                         |
         |  +-------------------+  |
         |  |   Datasources     |  |
         |  | (connexions aux   |  |
         |  |  sources)         |  |
         |  +-------------------+  |
         |                         |
         |  +-------------------+  |
         |  |   Dashboards      |  |
         |  | (panneaux de      |  |
         |  |  visualisation)   |  |
         |  +-------------------+  |
         |                         |
         |  +-------------------+  |
         |  |   Alerting        |  |
         |  | (regles d'alerte  |  |
         |  |  integrees)       |  |
         |  +-------------------+  |
         |                         |
         |  +-------------------+  |
         |  |   Provisioning    |  |
         |  | (config as code)  |  |
         |  +-------------------+  |
         +-------------------------+
```

### Concepts Cles

- **Datasource** : connexion a une source de donnees (Prometheus, Loki, InfluxDB, etc.)
- **Dashboard** : ensemble de panneaux (panels) organises sur une page
- **Panel** : visualisation individuelle (graphique, jauge, tableau, etc.)
- **Variable** : parametre dynamique pour filtrer les donnees (dropdown dans le dashboard)
- **Provisioning** : configuration automatique via fichiers YAML (datasources, dashboards)

### Types de Visualisation

| Type | Usage |
|------|-------|
| **Time series** | Evolution d'une metrique dans le temps |
| **Stat** | Valeur unique mise en evidence |
| **Gauge** | Jauge avec seuils de couleur |
| **Bar chart** | Comparaison de valeurs |
| **Table** | Donnees tabulaires |
| **Heatmap** | Distribution de valeurs (histogrammes) |
| **Logs** | Affichage de logs (avec Loki) |
| **Alert list** | Liste des alertes actives |

### Auto-provisioning

Grafana peut etre configuree automatiquement au demarrage via des fichiers YAML :
- `/etc/grafana/provisioning/datasources/` : sources de donnees
- `/etc/grafana/provisioning/dashboards/` : dashboards (reference des fichiers JSON)

C'est cette approche que nous utilisons dans ce projet pour une configuration **reproductible** et **versionnable**.

---

## 4. Loki : Agregation de Logs

### Architecture de Loki

Loki est un systeme d'agregation de logs inspire de Prometheus. Sa philosophie : **"like Prometheus, but for logs"**.

```
+------------------+     +------------------+     +------------------+
|  Container 1     |     |  Container 2     |     |  Container 3     |
|  (stdout/stderr) |     |  (stdout/stderr) |     |  (fichiers log)  |
+--------+---------+     +--------+---------+     +--------+---------+
         |                        |                        |
         +------------+-----------+------------------------+
                      |
                      v
         +------------+------------+
         |       PROMTAIL          |
         | (agent de collecte)     |
         | - decouverte de cibles  |
         | - ajout de labels       |
         | - envoi vers Loki       |
         +------------+------------+
                      |
                      | HTTP POST (push)
                      v
         +------------+------------+
         |         LOKI            |
         |                         |
         |  +-------------------+  |
         |  |   Distributor     |  |  <- recoit les logs
         |  +-------------------+  |
         |  |   Ingester        |  |  <- indexe les labels
         |  +-------------------+  |
         |  |   Querier         |  |  <- repond aux requetes
         |  +-------------------+  |
         |  |   Compactor       |  |  <- compacte les index
         |  +-------------------+  |
         |                         |
         |  Stockage: labels       |
         |  indexes seulement      |
         |  (PAS le contenu)       |
         +-------------------------+
```

### Difference Cle avec ELK

| Aspect | Loki | ELK (Elasticsearch) |
|--------|------|---------------------|
| **Indexation** | Labels uniquement | Texte complet (full-text) |
| **Stockage** | Tres economique | Couteux en stockage |
| **Recherche** | Par labels puis grep | Recherche full-text |
| **Ressources** | Leger (~512 Mo RAM) | Gourmand (4+ Go RAM) |
| **Requetes** | LogQL | KQL / Lucene |
| **Integration Grafana** | Native | Via plugin |
| **Complexite** | Simple a deployer | Cluster complexe |

### LogQL (Loki Query Language)

```logql
# Tous les logs du job "flask-app"
{job="flask-app"}

# Logs d'erreur uniquement
{job="flask-app"} |= "ERROR"

# Logs avec filtre regex
{job="flask-app"} |~ "status=(4|5)[0-9]{2}"

# Parser les logs JSON et filtrer
{job="flask-app"} | json | status >= 400

# Taux d'erreurs par seconde
rate({job="flask-app"} |= "ERROR" [5m])
```

### Promtail : L'Agent de Collecte

Promtail est l'agent qui collecte les logs et les envoie a Loki. Il :
- **Decouvre** les sources de logs (fichiers, conteneurs Docker, journald)
- **Ajoute des labels** (nom du conteneur, namespace, job)
- **Parse** les logs (regex, JSON, logfmt)
- **Envoie** les logs a Loki via HTTP

---

## 5. Alertmanager : Gestion des Alertes

### Architecture et Fonctionnement

Alertmanager recoit les alertes de Prometheus et gere leur **routage**, **regroupement**, **silencing** et **envoi** vers les bons destinataires.

```
Prometheus                    Alertmanager
+------------+               +---------------------------+
| Alert Rules|               |                           |
| (PromQL)   |--alertes----->|  1. Deduplication         |
|            |               |  2. Groupement            |
+------------+               |  3. Routage               |
                             |  4. Silencing/Inhibition  |
                             |  5. Envoi                 |
                             +--+--------+--------+------+
                                |        |        |
                                v        v        v
                             Email    Slack    Webhook
                             PagerDuty  Teams   etc.
```

### Concepts Cles

#### Routage (Routing)
Les alertes sont dirigees vers differents destinataires selon leurs **labels** :
```yaml
route:
  group_by: ['alertname', 'service']
  receiver: 'default'
  routes:
    - match:
        severity: critical
      receiver: 'pagerduty'
    - match:
        severity: warning
      receiver: 'slack'
```

#### Groupement (Grouping)
Les alertes similaires sont **regroupees** pour eviter le flood de notifications. Par exemple, si 100 instances sont down, une seule notification est envoyee avec la liste des instances.

#### Silencing
Les alertes peuvent etre **silencees** temporairement (pendant une maintenance planifiee, par exemple) via l'interface web d'Alertmanager.

#### Inhibition
Une alerte peut **inhiber** d'autres alertes. Par exemple, si le cluster entier est down, pas besoin de recevoir 100 alertes individuelles pour chaque service.

---

## 6. Infrastructure as Code : Terraform et Ansible

### Terraform : Provisionnement d'Infrastructure

Terraform est un outil **declaratif** de provisionnement d'infrastructure. Vous decrivez l'etat desire et Terraform se charge de l'atteindre.

```
+----------------+     +----------------+     +----------------+
|  Code (.tf)    |---->|  terraform     |---->| Infrastructure |
|  (etat desire) |     |  plan/apply    |     |  (creee/       |
|                |     |                |     |   modifiee)    |
+----------------+     +-------+--------+     +----------------+
                                |
                                v
                        +-------+--------+
                        |  State File    |
                        |  (.tfstate)    |
                        | (etat actuel)  |
                        +----------------+
```

**Concepts fondamentaux :**
- **Provider** : plugin qui interagit avec une API (Docker, AWS, Azure, GCP)
- **Resource** : element d'infrastructure a creer (conteneur, reseau, volume)
- **State** : fichier qui enregistre l'etat actuel de l'infrastructure
- **Plan** : apercu des changements avant application
- **Apply** : application des changements

**Cycle de vie :**
```bash
terraform init    # Telecharge les providers
terraform plan    # Montre les changements prevus
terraform apply   # Applique les changements
terraform destroy # Detruit l'infrastructure
```

### Ansible : Configuration Automatisee

Ansible est un outil de **gestion de configuration** et d'**automatisation**. Il utilise SSH (pas d'agent) et des fichiers YAML.

```
+----------------+     +----------------+     +----------------+
|  Playbook      |---->|   Ansible      |---->|  Serveurs      |
|  (.yml)        |     |  Engine        |     |  (configures)  |
|                |     |                |     |                |
+----------------+     +-------+--------+     +----------------+
                                |
                        +-------+--------+
                        |  Inventory     |
                        |  (liste des    |
                        |   hotes)       |
                        +----------------+
```

**Concepts fondamentaux :**
- **Playbook** : fichier YAML decrivant les taches a executer
- **Inventory** : liste des machines cibles
- **Role** : ensemble reutilisable de taches, templates, handlers
- **Task** : action unitaire (installer un paquet, copier un fichier, demarrer un service)
- **Template** : fichier Jinja2 avec variables (`.j2`)
- **Handler** : tache declenchee par un changement (redemarrer un service apres modification de config)
- **Idempotence** : executer le playbook N fois produit le meme resultat

### Terraform vs Ansible : Complementarite

| Aspect | Terraform | Ansible |
|--------|-----------|---------|
| **Role** | Provisionner l'infra | Configurer les services |
| **Approche** | Declaratif pur | Imperatif et declaratif |
| **State** | Fichier d'etat (.tfstate) | Pas de state (idempotent) |
| **Quand** | Creer VMs, reseaux, conteneurs | Installer, configurer, deployer |
| **Protocole** | API providers | SSH (sans agent) |
| **Langage** | HCL | YAML + Jinja2 |

**Pourquoi les deux ensemble ?**
1. **Terraform** cree l'infrastructure (conteneurs Docker, reseaux, volumes)
2. **Ansible** configure les services (copie les fichiers de config, demarre les services, verifie l'etat)

C'est la separation classique **provisionnement vs configuration** dans le monde DevOps.

---

## 7. Cas d'Usage de l'Observabilite

### Monitoring Applicatif
- Suivi du **taux de requetes**, **latence**, **taux d'erreurs** (les RED metrics)
- Detection des **degradations de performance** avant impact utilisateur
- Correlation entre **deployements** et **changements de metriques**

### Analyse de Logs
- **Investigation d'incidents** : retrouver la sequence d'evenements
- **Audit de securite** : detecter les tentatives d'intrusion
- **Debug** : comprendre le comportement de l'application

### Supervision de Microservices
- Vue globale de la **sante de chaque service**
- Detection des **effets de cascade** (un service impacte les autres)
- **Capacity planning** : anticiper les besoins en ressources

---

## 8. Conseils pour le Rapport et la Presentation

### Pour le Rapport (Partie 1)

- **Structurez clairement** : un chapitre par outil/concept
- **Incluez des schemas** : l'architecture de chaque outil, les flux de donnees
- **Donnez des exemples concrets** : requetes PromQL, extraits de config
- **Comparez** : Loki vs ELK, Terraform vs Ansible, Pull vs Push
- **Citez vos sources** : documentation officielle, articles techniques
- **Montrez votre comprehension** : ne paraphrasez pas la documentation, expliquez avec vos mots

### Pour la Presentation

- **Slide 1-3** : Introduction et contexte (role SRE, problematique)
- **Slide 4-6** : Les 3 piliers de l'observabilite (schema visuel)
- **Slide 7-9** : Prometheus et Grafana (architecture, PromQL, dashboards)
- **Slide 10-11** : Loki et les logs (comparaison ELK)
- **Slide 12-13** : Alertmanager (routing, exemple d'alerte)
- **Slide 14-15** : IaC avec Terraform + Ansible (complementarite)

### Bibliographie Recommandee

1. [Prometheus Documentation](https://prometheus.io/docs/)
2. [Grafana Documentation](https://grafana.com/docs/grafana/latest/)
3. [Loki Documentation](https://grafana.com/docs/loki/latest/)
4. [Terraform Documentation](https://developer.hashicorp.com/terraform/docs)
5. [Ansible Documentation](https://docs.ansible.com/)
6. Google SRE Book - [sre.google/sre-book/table-of-contents/](https://sre.google/sre-book/table-of-contents/)
7. "Observability Engineering" - Charity Majors, Liz Fong-Jones, George Miranda (O'Reilly)
