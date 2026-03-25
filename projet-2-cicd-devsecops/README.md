# Projet 2 : Pipeline CI/CD Securisee DevSecOps

## Application de Gestion Financiere — M2 Expert DevOps (ENSITECH)

---

## Contexte et Objectifs

Ce projet s'inscrit dans le cadre du **M2 Expert DevOps** a ENSITECH. L'objectif est de concevoir et implementer une **pipeline CI/CD securisee** pour une application de gestion financiere, en appliquant les principes **DevSecOps**.

### Objectifs pedagogiques

- Comprendre les enjeux de securite dans un pipeline CI/CD
- Maitriser l'integration de GitLab CI, SonarQube, Ansible et Terraform
- Automatiser le deploiement d'une application dans un contexte critique (finance)
- Garantir la **performance**, la **securite**, la **scalabilite** et la **tracabilite**

### Contraintes techniques

| Contrainte | Implementation |
|---|---|
| Analyse SonarQube sur chaque commit | Stage `quality` dans le pipeline |
| Gestion des secrets | GitLab CI/CD Variables, Ansible Vault, Terraform sensitive |
| Automatisation complete | Pipeline 5 stages automatise |
| Environnements reproductibles | dev / staging / prod via Terraform + tfvars |
| Scalabilite | Architecture conteneurisee Docker |
| Tracabilite | Logs structures, audit trail, versionning |
| Monitoring | Prometheus + Grafana |

---

## Architecture Cible

```
┌─────────────────────────────────────────────────────────────────┐
│                        DEVELOPPEUR                              │
│                    git push → GitLab                            │
└──────────────────────────┬──────────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────────────┐
│                   GITLAB CI PIPELINE                            │
│                                                                 │
│  ┌──────┐  ┌─────────┐  ┌──────────┐  ┌───────┐  ┌────────┐  │
│  │ TEST │→ │ QUALITY │→ │ SECURITY │→ │ BUILD │→ │ DEPLOY │  │
│  │pytest│  │SonarQube│  │Bandit    │  │Docker │  │Ansible │  │
│  │      │  │         │  │Trivy     │  │       │  │Terraform│  │
│  └──────┘  └─────────┘  └──────────┘  └───────┘  └────────┘  │
└─────────────────────────────────────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────────────┐
│               ENVIRONNEMENTS (Terraform)                        │
│                                                                 │
│  ┌─────────┐      ┌───────────┐      ┌────────────┐           │
│  │   DEV   │      │  STAGING  │      │    PROD    │           │
│  │ :5001   │      │  :5002    │      │   :5000    │           │
│  └─────────┘      └───────────┘      └────────────┘           │
└─────────────────────────────────────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────────────┐
│                     MONITORING                                  │
│                                                                 │
│  ┌────────────┐  ┌─────────┐  ┌───────────────┐               │
│  │ Prometheus │→ │ Grafana │  │ Node Exporter │               │
│  │   :9090    │  │  :3000  │  │    :9100      │               │
│  └────────────┘  └─────────┘  └───────────────┘               │
└─────────────────────────────────────────────────────────────────┘
```

---

## Technologies

| Outil | Role | Version recommandee |
|---|---|---|
| **GitLab CI** | Orchestration du pipeline CI/CD | GitLab 16+ |
| **SonarQube** | Analyse statique de code (qualite + securite) | Community 10.x |
| **Ansible** | Deploiement automatise et configuration | 2.15+ |
| **Terraform** | Infrastructure as Code (IaC) | 1.6+ |
| **Docker** | Conteneurisation de l'application | 24+ |
| **Flask** | Framework web Python (application financiere) | 3.0+ |
| **Prometheus** | Collecte de metriques | 2.48+ |
| **Grafana** | Visualisation et dashboards | 10.x |
| **Bandit** | Analyse securite du code Python | 1.7+ |
| **Trivy** | Scan de vulnerabilites des images Docker | 0.48+ |
| **pytest** | Tests unitaires Python | 8.0+ |

---

## Structure du Projet

```
projet-2-cicd-devsecops/
│
├── README.md                          # Ce fichier
├── ETAPE-01-ETUDE-THEORIQUE.md       # Partie 1 : Theorie DevSecOps (30pts)
├── ETAPE-02-APPLICATION-FINANCE.md   # Guide : Application Flask
├── ETAPE-03-PIPELINE-GITLAB-CI.md    # Guide : Pipeline CI/CD
├── ETAPE-04-SONARQUBE.md             # Guide : SonarQube
├── ETAPE-05-TERRAFORM-INFRA.md       # Guide : Terraform
├── ETAPE-06-ANSIBLE-DEPLOIEMENT.md   # Guide : Ansible
├── ETAPE-07-MONITORING.md            # Guide : Monitoring
├── ETAPE-08-SECURITE-SECRETS.md      # Guide : Securite & Secrets
├── ETAPE-09-ANALYSE-AMELIORATIONS.md # Partie 4 : Analyse (10pts)
│
├── .gitlab-ci.yml                     # Pipeline GitLab CI complet
├── .gitignore                         # Fichiers a ignorer
│
├── app/                               # Application Flask
│   ├── app.py                         # Code principal
│   ├── requirements.txt               # Dependances Python
│   ├── Dockerfile                     # Image Docker multi-stage
│   ├── .dockerignore                  # Exclusions Docker
│   └── tests/                         # Tests unitaires
│       ├── __init__.py
│       └── test_app.py
│
├── sonarqube/                         # Configuration SonarQube
│   ├── docker-compose-sonarqube.yml
│   └── sonar-project.properties
│
├── terraform/                         # Infrastructure as Code
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── providers.tf
│   └── environments/
│       ├── dev.tfvars
│       ├── staging.tfvars
│       └── prod.tfvars
│
├── ansible/                           # Deploiement automatise
│   ├── ansible.cfg
│   ├── playbook.yml
│   ├── inventory/
│   │   ├── dev.ini
│   │   ├── staging.ini
│   │   └── prod.ini
│   └── roles/
│       └── deploy/
│           ├── tasks/
│           │   └── main.yml
│           └── templates/
│               └── docker-compose.yml.j2
│
├── monitoring/                        # Prometheus + Grafana
│   ├── docker-compose-monitoring.yml
│   ├── prometheus/
│   │   └── prometheus.yml
│   └── grafana/
│       └── dashboards/
│           └── finance-app.json
│
└── scripts/                           # Scripts utilitaires
    ├── pipeline-local.sh              # Pipeline complet en local
    ├── scan-security.sh               # Scans securite
    ├── deploy-local.sh                # Deploiement local
    └── start-monitoring.sh            # Demarrage monitoring
```

---

## Prerequis

### Logiciels requis

```bash
# Docker et Docker Compose
docker --version        # >= 24.0
docker compose version  # >= 2.20

# Python 3.11+
python3 --version

# Terraform
terraform --version     # >= 1.6

# Ansible
ansible --version       # >= 2.15

# Git
git --version
```

### Installation rapide (Ubuntu/Debian)

```bash
# Docker
curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker $USER

# Python + pip
sudo apt install python3 python3-pip python3-venv -y

# Terraform
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform -y

# Ansible
pip3 install ansible

# SonarScanner
# Telecharger depuis https://docs.sonarqube.org/latest/analyzing-source-code/scanners/sonarscanner/
```

---

## Guide de Demarrage Rapide

### 1. Cloner le projet

```bash
git clone <url-du-repo>
cd projet-2-cicd-devsecops
```

### 2. Lancer l'application en local

```bash
cd app
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
python app.py
# → http://localhost:5000/health
```

### 3. Lancer les tests

```bash
cd app
pytest tests/ -v --tb=short
```

### 4. Lancer SonarQube

```bash
cd sonarqube
docker compose -f docker-compose-sonarqube.yml up -d
# → http://localhost:9000 (admin/admin)
```

### 5. Deployer avec Terraform

```bash
cd terraform
terraform init
terraform plan -var-file=environments/dev.tfvars
terraform apply -var-file=environments/dev.tfvars
```

### 6. Deployer avec Ansible

```bash
cd ansible
ansible-playbook -i inventory/dev.ini playbook.yml
```

### 7. Lancer le monitoring

```bash
cd monitoring
docker compose -f docker-compose-monitoring.yml up -d
# Prometheus → http://localhost:9090
# Grafana    → http://localhost:3000 (admin/admin)
```

### 8. Pipeline complet en local

```bash
chmod +x scripts/*.sh
./scripts/pipeline-local.sh
```

---

## Bareme de Notation

| Partie | Points | Contenu |
|---|---|---|
| **Partie 1** : Theorie DevSecOps | **30 pts** | Definitions, comparaisons, architecture, enjeux securite |
| **Partie 2** : Architecture CI/CD | **20 pts** | Schema pipeline, interactions outils, flux de donnees |
| **Partie 3** : Integration DevOps | **40 pts** | Pipeline GitLab CI fonctionnel, tests, SonarQube, Docker, Ansible, Terraform |
| **Partie 4** : Analyse | **10 pts** | Evaluation resultats, limites, ameliorations |
| **TOTAL** | **100 pts** | |

---

## Livrables Attendus

1. **Rapport detaille** (PDF, **45 pages minimum**) — Theorie, conception, implementation, analyse
2. **Presentation PowerPoint** (**20+ slides minimum**) — Synthese du projet pour la soutenance
3. **Schemas d'architecture** — Pipeline CI/CD + infrastructure
4. **Code source** — Application Flask + tests
5. **Scripts IaC** — Terraform + Ansible
6. **Pipeline GitLab CI** — `.gitlab-ci.yml` + captures d'ecran
7. **Repository Git** — Documente, structure, commits propres

---

## Auteurs

- **Etudiants M2 Expert DevOps** — ENSITECH
- **Annee** : 2025-2026

---

## Licence

Projet academique — Usage pedagogique uniquement.
