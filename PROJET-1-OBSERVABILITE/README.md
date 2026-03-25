# Projet 1 : Observabilite Avancee avec Prometheus, Grafana, Loki, Alertmanager, Ansible et Terraform

## Contexte et Objectifs

Ce projet s'inscrit dans le cadre du **Master 2 Expert DevOps** a ENSITECH. Vous jouez le role d'un **ingenieur SRE (Site Reliability Engineer)** charge de mettre en place une solution d'observabilite complete pour une infrastructure de microservices containerises.

L'objectif est de deployer, configurer et exploiter une stack d'observabilite moderne en utilisant exclusivement des outils open-source, tout en automatisant le provisionnement de l'infrastructure avec **Terraform** et sa configuration avec **Ansible**.

### Objectifs pedagogiques

- Comprendre les **3 piliers de l'observabilite** : metriques, logs, traces
- Maitriser le deploiement et la configuration de **Prometheus**, **Grafana**, **Loki** et **Alertmanager**
- Utiliser **Terraform** pour provisionner l'infrastructure (Infrastructure as Code)
- Utiliser **Ansible** pour configurer les services (Configuration Management)
- Creer des **dashboards** pertinents et des **alertes** operationnelles
- Evaluer les performances et proposer des ameliorations

---

## Architecture Cible

```
+------------------+     +------------------+     +------------------+
|   Application    |     |  Node Exporter   |     |    Promtail      |
|   Flask + metrics|     |  (metriques host)|     | (collecte logs)  |
|   :5000          |     |   :9100          |     |                  |
+--------+---------+     +--------+---------+     +--------+---------+
         |                        |                        |
         |  scrape /metrics       |  scrape /metrics       |  push logs
         v                        v                        v
+--------+---------+     +------------------+     +------------------+
|   Prometheus     |     |   Prometheus     |     |      Loki        |
|   (metriques)    |<----+   (metriques)    |     |   (stockage logs)|
|   :9090          |     |                  |     |   :3100          |
+--------+---------+     +------------------+     +--------+---------+
         |                                                 |
         |  alertes                                        |
         v                                                 |
+--------+---------+                                       |
|  Alertmanager    |                                       |
|  (notifications) |                                       |
|  :9093           |                                       |
+--------+---------+                                       |
         |                                                 |
         |  webhook/email                                  |
         v                                                 |
+------------------+                                       |
|  Notifications   |                                       |
|  (email/webhook) |                                       |
+------------------+                                       |
                                                           |
         +---------------------+---------------------------+
         |                     |
         v                     v
+--------+---------------------+---------+
|              Grafana                   |
|   (visualisation metriques + logs)     |
|   :3000                                |
|   - Dashboard Application             |
|   - Dashboard Infrastructure          |
+----------------------------------------+
```

L'infrastructure est provisionnee par **Terraform** (conteneurs Docker) et configuree par **Ansible** (fichiers de configuration, datasources, dashboards).

---

## Technologies Utilisees

| Outil | Role | Version |
|-------|------|---------|
| **Prometheus** | Collecte et stockage de metriques (modele pull) | 2.51+ |
| **Grafana** | Visualisation de donnees, dashboards | 10.4+ |
| **Loki** | Agregation et stockage de logs | 2.9+ |
| **Promtail** | Collecte de logs vers Loki | 2.9+ |
| **Alertmanager** | Gestion et routage des alertes | 0.27+ |
| **Node Exporter** | Exposition des metriques systeme | 1.7+ |
| **Docker** | Containerisation des services | 24+ |
| **Docker Compose** | Orchestration multi-conteneurs | 2.24+ |
| **Terraform** | Provisionnement d'infrastructure (IaC) | 1.7+ |
| **Ansible** | Configuration automatisee | 2.16+ |
| **Flask** | Application web de demonstration | 3.0+ |
| **Python** | Langage de l'application | 3.11 |

---

## Structure du Projet

```
PROJET-1-OBSERVABILITE/
|
|-- README.md                              # Ce fichier
|-- ETAPE-01-ETUDE-THEORIQUE.md           # Guide Partie 1 (30 pts)
|-- ETAPE-02-APPLICATION-DEMO.md          # Guide application Flask
|-- ETAPE-03-INFRASTRUCTURE-TERRAFORM.md  # Guide Terraform
|-- ETAPE-04-CONFIGURATION-ANSIBLE.md     # Guide Ansible
|-- ETAPE-05-STACK-OBSERVABILITE.md       # Guide stack complete
|-- ETAPE-06-DASHBOARDS-ALERTES.md        # Guide dashboards et alertes
|-- ETAPE-07-VALIDATION-TESTS.md          # Guide tests et validation
|-- ETAPE-08-ANALYSE-AMELIORATIONS.md     # Guide analyse (10 pts)
|
|-- app/
|   |-- app.py                            # Application Flask instrumentee
|   |-- requirements.txt                  # Dependances Python
|   |-- Dockerfile                        # Image Docker de l'application
|
|-- docker/
|   |-- docker-compose.yml                # Orchestration de la stack complete
|   |-- promtail-config.yml               # Configuration Promtail
|
|-- prometheus/
|   |-- prometheus.yml                    # Configuration Prometheus
|   |-- alert-rules.yml                   # Regles d'alertes
|
|-- loki/
|   |-- loki-config.yml                   # Configuration Loki
|
|-- alertmanager/
|   |-- alertmanager.yml                  # Configuration Alertmanager
|
|-- grafana/
|   |-- provisioning/
|   |   |-- datasources/
|   |   |   |-- datasources.yml           # Auto-provisioning des sources
|   |   |-- dashboards/
|   |       |-- dashboards.yml            # Auto-provisioning des dashboards
|   |-- dashboards/
|       |-- app-metrics.json              # Dashboard metriques applicatives
|       |-- infra-metrics.json            # Dashboard metriques infrastructure
|
|-- terraform/
|   |-- main.tf                           # Configuration principale Terraform
|   |-- variables.tf                      # Variables Terraform
|   |-- outputs.tf                        # Sorties Terraform
|   |-- providers.tf                      # Configuration des providers
|
|-- ansible/
|   |-- inventory.ini                     # Inventaire des hotes
|   |-- playbook.yml                      # Playbook principal
|   |-- roles/
|       |-- observability/
|           |-- tasks/
|           |   |-- main.yml              # Taches du role
|           |-- templates/
|               |-- prometheus.yml.j2     # Template Prometheus
|               |-- alertmanager.yml.j2   # Template Alertmanager
|
|-- scripts/
|   |-- start.sh                          # Demarrage rapide
|   |-- test-load.sh                      # Test de charge
|   |-- simulate-failure.sh              # Simulation de pannes
|
|-- .gitignore                            # Fichiers a ignorer
```

---

## Prerequis

### Logiciels requis

1. **Docker** (>= 24.0) et **Docker Compose** (>= 2.24)
   ```bash
   docker --version
   docker compose version
   ```

2. **Terraform** (>= 1.7)
   ```bash
   terraform --version
   ```

3. **Ansible** (>= 2.16)
   ```bash
   ansible --version
   ```

4. **Python 3.11+** (pour le developpement local)
   ```bash
   python3 --version
   ```

5. **Git** (pour le versioning)
   ```bash
   git --version
   ```

### Ressources systeme recommandees

- **CPU** : 4 coeurs minimum
- **RAM** : 8 Go minimum (16 Go recommande)
- **Disque** : 20 Go d'espace libre
- **OS** : Linux (Ubuntu 22.04+), macOS, ou Windows avec WSL2

---

## Guide de Demarrage Rapide

### Option 1 : Docker Compose (recommandee)

```bash
# 1. Cloner le repository
git clone <votre-repo> && cd PROJET-1-OBSERVABILITE

# 2. Construire et demarrer la stack
cd docker
docker compose up -d --build

# 3. Verifier les services
docker compose ps

# 4. Acceder aux interfaces
# - Application : http://localhost:5000
# - Prometheus  : http://localhost:9090
# - Grafana     : http://localhost:3000 (admin/admin)
# - Alertmanager: http://localhost:9093
```

### Option 2 : Script rapide

```bash
chmod +x scripts/start.sh
./scripts/start.sh
```

### Option 3 : Terraform

```bash
cd terraform
terraform init
terraform plan
terraform apply -auto-approve
```

### Option 4 : Ansible

```bash
cd ansible
ansible-playbook -i inventory.ini playbook.yml
```

---

## Bareme de Notation (100 points)

| Partie | Contenu | Points |
|--------|---------|--------|
| **Partie 1** | Etude theorique (observabilite, Prometheus, Grafana, Loki, Alertmanager, IaC) | **30 pts** |
| **Partie 2** | Architecture (schema, flux de donnees, integration Ansible/Terraform) | **20 pts** |
| **Partie 3** | Implementation (deploiement, metriques, logs, dashboards, alertes, tests) | **40 pts** |
| **Partie 4** | Analyse (evaluation des performances, propositions d'amelioration) | **10 pts** |
| **Total** | | **100 pts** |

### Detail Partie 3 (40 pts)

| Element | Points |
|---------|--------|
| Deploiement Terraform + Ansible fonctionnel | 10 |
| Metriques Prometheus collectees et exploitables | 8 |
| Logs centralises dans Loki via Promtail | 7 |
| Minimum 2 dashboards Grafana complets | 8 |
| Alertes configurees et testees (Alertmanager) | 7 |

---

## Livrables Attendus

1. **Rapport technique** : 45 pages minimum (PDF)
   - Couverture, sommaire, introduction
   - Parties 1 a 4 detaillees
   - Captures d'ecran des dashboards et alertes
   - Conclusion et bibliographie

2. **Presentation** : 20+ slides (PowerPoint/PDF)
   - Resume du projet et de l'architecture
   - Demo des dashboards et alertes
   - Analyse et ameliorations

3. **Code source** : Repository Git documente
   - Tous les fichiers de configuration
   - Scripts Terraform et Ansible
   - Application instrumentee
   - README et documentation

4. **Schemas** : Architecture et flux de donnees
   - Schema d'architecture globale
   - Schema des flux de metriques
   - Schema des flux de logs

---

## Guide des Etapes

Suivez les etapes dans l'ordre pour construire progressivement votre solution :

1. **[Etape 1 - Etude Theorique](ETAPE-01-ETUDE-THEORIQUE.md)** : Comprendre les concepts fondamentaux
2. **[Etape 2 - Application Demo](ETAPE-02-APPLICATION-DEMO.md)** : Creer l'application instrumentee
3. **[Etape 3 - Terraform](ETAPE-03-INFRASTRUCTURE-TERRAFORM.md)** : Provisionner l'infrastructure
4. **[Etape 4 - Ansible](ETAPE-04-CONFIGURATION-ANSIBLE.md)** : Configurer les services
5. **[Etape 5 - Stack Observabilite](ETAPE-05-STACK-OBSERVABILITE.md)** : Deployer la stack complete
6. **[Etape 6 - Dashboards et Alertes](ETAPE-06-DASHBOARDS-ALERTES.md)** : Creer les visualisations
7. **[Etape 7 - Validation et Tests](ETAPE-07-VALIDATION-TESTS.md)** : Valider le fonctionnement
8. **[Etape 8 - Analyse](ETAPE-08-ANALYSE-AMELIORATIONS.md)** : Evaluer et proposer des ameliorations

---

## Auteur

Projet realise dans le cadre du **M2 Expert DevOps - ENSITECH**

---

## Licence

Ce projet est a usage pedagogique uniquement.
