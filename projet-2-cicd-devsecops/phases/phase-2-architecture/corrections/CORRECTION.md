# Correction Phase 2 : Architecture CI/CD

## Schéma d'architecture du pipeline

```
┌─────────────────────────────────────────────────────────────┐
│                    DEVELOPER WORKFLOW                        │
│  Developer → Git Commit → Push to GitLab                    │
└────────────────────────────┬────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────┐
│                    GITLAB CI PIPELINE                        │
│                                                              │
│  Stage 1: TEST                                              │
│  ┌────────────────────────────────────────┐                │
│  │  Job: test                             │                │
│  │  - Run unit tests                      │                │
│  │  - Generate coverage                   │                │
│  └────────────────────────────────────────┘                │
│                             │                                │
│                             ▼                                │
│  Stage 2: QUALITY                                           │
│  ┌────────────────────────────────────────┐                │
│  │  Job: sonarqube                        │                │
│  │  - Scan code                           │                │
│  │  - Check Quality Gate                  │                │
│  └──────┬─────────────────────────────────┘                │
│         │                                                    │
│         ▼                                                    │
│  ┌────────────────────────────────────────┐                │
│  │  Quality Gate Check                     │                │
│  │  - Pass → Continue                      │                │
│  │  - Fail → Block pipeline                │                │
│  └──────┬─────────────────────────────────┘                │
│         │                                                    │
│         ▼                                                    │
│  Stage 3: BUILD                                             │
│  ┌────────────────────────────────────────┐                │
│  │  Job: build                             │                │
│  │  - Build Docker image                  │                │
│  │  - Push to registry                   │                │
│  └──────┬─────────────────────────────────┘                │
│         │                                                    │
│         ▼                                                    │
│  Stage 4: DEPLOY                                            │
│  ┌────────────────────────────────────────┐                │
│  │  Job: terraform                        │                │
│  │  - Provision infrastructure           │                │
│  └──────┬─────────────────────────────────┘                │
│         │                                                    │
│         ▼                                                    │
│  ┌────────────────────────────────────────┐                │
│  │  Job: ansible                          │                │
│  │  - Configure servers                  │                │
│  │  - Deploy application                │                │
│  └──────┬─────────────────────────────────┘                │
└─────────┼────────────────────────────────────────────────────┘
          │
          ▼
┌─────────────────────────────────────────────────────────────┐
│                    DEPLOYED APPLICATION                      │
│  Application accessible et fonctionnelle                     │
└─────────────────────────────────────────────────────────────┘
```

## Interactions entre outils

**GitLab CI ↔ SonarQube :**
- GitLab CI déclenche SonarQube
- SonarQube analyse et retourne le Quality Gate
- GitLab CI bloque si Quality Gate échoue

**GitLab CI ↔ Terraform :**
- GitLab CI exécute Terraform
- Terraform provisionne l'infrastructure
- Terraform retourne les outputs (IPs, IDs)

**GitLab CI ↔ Ansible :**
- GitLab CI exécute Ansible
- Ansible utilise les outputs Terraform
- Ansible configure et déploie

## Gestion des secrets

```
GitLab Variables (Protected) → Pipeline Jobs → Terraform/Ansible
```

