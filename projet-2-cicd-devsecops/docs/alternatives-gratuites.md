# Alternatives Gratuites pour CI/CD et Déploiement

## Services gratuits pour CI/CD

Tous les services listés ci-dessous offrent des plans gratuits suffisants pour ce projet.

### GitLab.com (Recommandé pour ce projet)

**Avantages :**
- Plan gratuit complet
- 2000 minutes de CI/CD par mois (gratuit)
- Runner partagés gratuits
- Intégration native avec Git
- Parfait pour ce projet

**Limites gratuites :**
- 2000 minutes CI/CD/mois
- 5GB de stockage
- 10GB de transfert/mois
- Suffisant pour plusieurs projets

**Lien :** https://gitlab.com

### GitHub Actions (Alternative)

**Avantages :**
- 2000 minutes gratuites par mois
- Intégration native avec GitHub
- Large écosystème

**Limites gratuites :**
- 2000 min/mois (public repos)
- 500 min/mois (private repos)

**Lien :** https://github.com/features/actions

## Services de déploiement gratuits

### Railway (Recommandé)

**Avantages :**
- 500 heures gratuites par mois
- Déploiement automatique depuis Git
- Support Docker natif
- Base de données gratuite
- Parfait pour les APIs

**Limites gratuites :**
- 500h/mois
- 5GB stockage
- 100GB bande passante

**Lien :** https://railway.app

**Intégration GitLab CI :**
```yaml
deploy:
  script:
    - railway login
    - railway up
```

### Render

**Avantages :**
- Plan gratuit permanent
- Déploiement automatique
- Support Docker
- SSL automatique

**Limites gratuites :**
- Services s'endorment après inactivité
- 750h/mois
- Parfait pour les démonstrations

**Lien :** https://render.com

### Fly.io

**Avantages :**
- Plan gratuit généreux
- Déploiement global
- Support Docker
- CLI puissant

**Limites gratuites :**
- 3 VMs gratuites
- 160GB bande passante/mois

**Lien :** https://fly.io

### Vercel

**Avantages :**
- Déploiement instantané
- Optimisé pour web/APIs
- SSL automatique
- Parfait pour FastAPI/Flask

**Limites gratuites :**
- 100GB bande passante/mois
- Fonctions serverless

**Lien :** https://vercel.com

## SonarQube gratuit

### SonarCloud (Recommandé)

**Avantages :**
- Gratuit pour projets open source
- Intégration native avec GitLab/GitHub
- Analyses automatiques
- Rapports détaillés

**Lien :** https://sonarcloud.io

### SonarQube Community Edition (Local)

**Avantages :**
- 100% gratuit
- Installation locale
- Contrôle total

**Installation :**
```bash
# Via Docker (le plus simple)
docker run -d --name sonarqube -p 9000:9000 sonarqube:community
```

## Comparaison rapide

| Service | Type | Limite gratuite |
|---------|------|----------------|
| GitLab.com | CI/CD | 2000 min/mois |
| Railway | Déploiement | 500h/mois |
| Render | Déploiement | 750h/mois |
| Fly.io | Déploiement | 3 VMs |
| Vercel | Déploiement | 100GB/mois |
| SonarCloud | Code Quality | Illimité (open source) |

## Stack recommandée (100% gratuit)

**Pour ce projet :**
1. **CI/CD** : GitLab.com (gratuit)
2. **Code Quality** : SonarCloud (gratuit) ou SonarQube local
3. **Déploiement** : Railway ou Render (gratuit)
4. **Développement** : Local avec Docker (gratuit)

## Installation locale

### Windows

1. **Docker Desktop** : https://www.docker.com/products/docker-desktop
2. **Git** : https://git-scm.com/download/win
3. **Python** : https://www.python.org/downloads/ (pour Ansible)
4. **Terraform** : https://www.terraform.io/downloads

### Linux

```bash
# Docker
sudo apt update
sudo apt install docker.io docker-compose

# Git
sudo apt install git

# Python et Ansible
sudo apt install python3 python3-pip
pip3 install ansible

# Terraform
wget https://releases.hashicorp.com/terraform/1.6.0/terraform_1.6.0_linux_amd64.zip
unzip terraform_1.6.0_linux_amd64.zip
sudo mv terraform /usr/local/bin/
```

### Mac

```bash
# Docker Desktop
# Télécharger depuis: https://www.docker.com/products/docker-desktop

# Git (généralement déjà installé)
brew install git

# Python et Ansible
brew install python3
pip3 install ansible

# Terraform
brew install terraform
```

## Aucun coût requis

Tous les outils et services mentionnés sont **100% gratuits** pour ce projet. Vous n'avez besoin d'aucune carte bancaire ni abonnement payant.

## Exemple de pipeline GitLab CI avec Railway

```yaml
deploy:
  stage: deploy
  script:
    - npm install -g @railway/cli
    - railway login --token $RAILWAY_TOKEN
    - railway up
  only:
    - main
```

**Note :** Créez un token Railway et ajoutez-le comme variable protégée dans GitLab.

