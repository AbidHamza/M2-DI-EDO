# M2-DI-EDO — Projets Expert DevOps (ENSITECH 2025-2026)

## Presentation

Ce depot contient **deux projets complets** pour l'examen du **Master 2 DI — Expert DevOps** de l'ENSITECH.

> **Consigne** : 1 sujet a choisir parmi les 2 proposes. Travail strictement individuel.

Chaque projet comprend :
- Des **guides detailles** (etape par etape) couvrant theorie et pratique
- Tous les **fichiers d'implementation** (code, configs, scripts)
- Une **application demo** conteneurisee et instrumentee
- Des **scripts Terraform** pour le provisionnement d'infrastructure
- Des **playbooks Ansible** pour la configuration automatisee
- Des **dashboards Grafana** pre-configures

---

## Les 2 Sujets

### Sujet 1 — Observabilite Avancee (SRE)

**Stack** : Prometheus + Grafana + Loki + Alertmanager + Ansible + Terraform

Tu joues le role d'un **ingenieur SRE**. Tu dois concevoir et industrialiser une solution d'observabilite complete pour des microservices conteneurises, avec provisionnement Terraform et configuration Ansible.

| Partie | Points | Contenu |
|--------|--------|---------|
| 1. Etude theorique | 30 pts | Prometheus, Grafana, Loki, Alertmanager, IaC |
| 2. Architecture | 20 pts | Schemas, flux de donnees, integration Ansible/Terraform |
| 3. Implementation | 40 pts | Deploy, metriques, logs, dashboards, alertes, tests |
| 4. Analyse | 10 pts | Performance, ameliorations, scalabilite |

[Commencer le Sujet 1](PROJET-1-OBSERVABILITE/README.md)

---

### Sujet 2 — Pipeline CI/CD Securisee (DevSecOps)

**Stack** : GitLab CI + SonarQube + Ansible + Terraform + Prometheus/Grafana

Tu dois concevoir et deployer une **pipeline DevSecOps** complete pour une application de gestion financiere, integrant qualite logicielle et securite des les premieres etapes.

| Partie | Points | Contenu |
|--------|--------|---------|
| 1. Etude theorique | 30 pts | DevSecOps vs DevOps, GitLab CI, SonarQube, IaC |
| 2. Architecture CI/CD | 20 pts | Schema pipeline, interactions entre outils |
| 3. Integration DevOps | 40 pts | Pipeline complete, Terraform, Ansible, demo |
| 4. Analyse | 10 pts | Resultats, limites, ameliorations |

[Commencer le Sujet 2](projet-2-cicd-devsecops/README.md)

---

## Structure du Depot

```
M2-DI-EDO/
│
├── PROJET-1-OBSERVABILITE/          # Sujet 1 — SRE / Observabilite
│   ├── README.md                     # Vue d'ensemble du projet
│   ├── ETAPE-01 → 08                # Guides detailles (8 etapes)
│   ├── app/                          # Application Flask instrumentee
│   │   ├── app.py                    # Code source + /metrics + /health
│   │   ├── Dockerfile                # Build multi-stage
│   │   └── requirements.txt
│   ├── docker/                       # Stack complète
│   │   ├── docker-compose.yml        # 7 services (app, prometheus, grafana, loki, promtail, alertmanager, node-exporter)
│   │   └── promtail-config.yml
│   ├── prometheus/                   # Configuration Prometheus
│   │   ├── prometheus.yml            # Scrape configs
│   │   └── alert-rules.yml           # 5 regles d'alertes
│   ├── grafana/                      # Dashboards + provisioning
│   │   ├── dashboards/               # 2 dashboards JSON (app + infra)
│   │   └── provisioning/             # Auto-config datasources + dashboards
│   ├── loki/                         # Configuration Loki
│   ├── alertmanager/                 # Configuration Alertmanager
│   ├── terraform/                    # IaC — provisionnement Docker
│   │   ├── main.tf, variables.tf, outputs.tf, providers.tf
│   ├── ansible/                      # Configuration automatisee
│   │   ├── playbook.yml, inventory.ini
│   │   └── roles/observability/      # Role Ansible complet
│   └── scripts/                      # start.sh, test-load.sh, simulate-failure.sh
│
├── projet-2-cicd-devsecops/          # Sujet 2 — DevSecOps / CI/CD
│   ├── README.md                     # Vue d'ensemble du projet
│   ├── ETAPE-01 → 09                # Guides detailles (9 etapes)
│   ├── app/                          # Application Flask financiere
│   │   ├── app.py                    # API transactions/balance/transfer
│   │   ├── tests/test_app.py         # 20+ tests pytest
│   │   ├── Dockerfile                # Build multi-stage securise
│   │   └── requirements.txt
│   ├── .gitlab-ci.yml                # Pipeline 5 stages (test→quality→security→build→deploy)
│   ├── sonarqube/                    # SonarQube + PostgreSQL
│   │   ├── docker-compose-sonarqube.yml
│   │   └── sonar-project.properties
│   ├── terraform/                    # IaC multi-environnement
│   │   ├── main.tf, variables.tf, outputs.tf, providers.tf
│   │   └── environments/             # dev.tfvars, staging.tfvars, prod.tfvars
│   ├── ansible/                      # Deploiement automatise
│   │   ├── playbook.yml, ansible.cfg
│   │   ├── inventory/                # dev.ini, staging.ini, prod.ini
│   │   └── roles/deploy/             # Role avec template Jinja2
│   ├── monitoring/                   # Prometheus + Grafana
│   │   ├── docker-compose-monitoring.yml
│   │   ├── prometheus/prometheus.yml
│   │   └── grafana/dashboards/       # Dashboard JSON
│   └── scripts/                      # pipeline-local.sh, scan-security.sh, deploy-local.sh
│
└── README.md                         # Ce fichier
```

---

## Prerequis

| Outil | Version min. | Installation |
|-------|-------------|-------------|
| **Docker** | 20.x | [docs.docker.com](https://docs.docker.com/get-docker/) |
| **Docker Compose** | 2.x | Inclus avec Docker Desktop |
| **Python** | 3.10+ | [python.org](https://www.python.org/) |
| **Terraform** | 1.5+ | [terraform.io](https://developer.hashicorp.com/terraform/install) |
| **Ansible** | 2.14+ | `pip install ansible` |
| **Git** | 2.x | [git-scm.com](https://git-scm.com/) |
| **VS Code** | Derniere | Recommande avec extensions Docker, Python, Terraform |

---

## Livrables Attendus (pour les deux sujets)

- **Rapport detaille** : 45 pages minimum (theorie + conception + implementation + analyse)
- **Presentation PowerPoint** : 20 slides minimum
- **Schemas d'architecture** : diagrammes UML, flux de donnees
- **Scripts Terraform et Ansible** : fichiers de configuration fonctionnels
- **Captures d'ecran** : dashboards, pipeline, alertes
- **Repository Git documente** : ce depot avec tout le code et les configs

## Soutenance

- **Duree** : 60 minutes (30 min presentation + 30 min questions techniques)
- **Note** : /100 points, ramenee a /20 avec **coefficient 3**

---

## Comment Utiliser ce Depot

```bash
# 1. Cloner le depot
git clone https://github.com/AbidHamza/M2-DI-EDO.git
cd M2-DI-EDO

# 2. Choisir un sujet et suivre les etapes dans l'ordre
cd PROJET-1-OBSERVABILITE/   # ou projet-2-cicd-devsecops/

# 3. Lire le README du projet choisi
# 4. Suivre les ETAPE-01, ETAPE-02, etc.
# 5. Executer les scripts et configs fournis
```

---

*ENSITECH — Ecole Nationale Superieure de l'Informatique et des Technologies*
*M2-DI Expert DevOps — 2025-2026*
