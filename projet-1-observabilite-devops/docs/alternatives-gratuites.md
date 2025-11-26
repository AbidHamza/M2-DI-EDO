# Alternatives Gratuites pour le Déploiement

## Services de déploiement gratuits

Tous les services listés ci-dessous offrent des plans gratuits suffisants pour ce projet.

### Railway (Recommandé pour ce projet)

**Avantages :**
- 500 heures gratuites par mois
- Déploiement simple depuis GitHub
- Support Docker natif
- Base de données gratuite incluse
- Parfait pour les applications conteneurisées

**Limites gratuites :**
- 500h/mois de runtime
- 5GB de stockage
- 100GB de bande passante

**Lien :** https://railway.app

**Utilisation avec Terraform :**
- Utiliser le provider Railway (gratuit)
- Ou déployer manuellement via l'interface web

### Render

**Avantages :**
- Plan gratuit permanent
- Déploiement automatique depuis GitHub
- Support Docker
- SSL automatique

**Limites gratuites :**
- Services s'endorment après inactivité
- 750h/mois de runtime
- Parfait pour les démonstrations

**Lien :** https://render.com

### Fly.io

**Avantages :**
- Plan gratuit généreux
- Déploiement global
- Support Docker natif
- CLI puissant

**Limites gratuites :**
- 3 VMs gratuites
- 160GB de bande passante/mois
- Parfait pour les applications distribuées

**Lien :** https://fly.io

### Vercel

**Avantages :**
- Déploiement instantané
- Optimisé pour les applications web
- Support des APIs
- SSL automatique

**Limites gratuites :**
- 100GB de bande passante/mois
- Parfait pour les frontends et APIs simples

**Lien :** https://vercel.com

### GitHub Codespaces

**Avantages :**
- Environnement de développement complet
- 60h gratuites par mois
- Intégration native avec GitHub
- Parfait pour développer et tester

**Limites gratuites :**
- 60h/mois
- 2 cores, 4GB RAM
- 20GB de stockage

**Lien :** https://github.com/features/codespaces

## Comparaison rapide

| Service | Meilleur pour | Limite gratuite |
|---------|---------------|----------------|
| Railway | Applications conteneurisées | 500h/mois |
| Render | Déploiement simple | 750h/mois (avec sleep) |
| Fly.io | Applications distribuées | 3 VMs gratuites |
| Vercel | Applications web/APIs | 100GB/mois |
| Codespaces | Développement | 60h/mois |

## Recommandation pour ce projet

**Pour l'observabilité (Projet 1) :**
- **Développement local** : Docker Desktop (gratuit)
- **Déploiement démo** : Railway ou Render (gratuit)

**Pour CI/CD (Projet 2) :**
- **GitLab CI** : GitLab.com (gratuit, 2000 min/mois)
- **Déploiement** : Railway ou Render (gratuit)
- **SonarQube** : SonarCloud (gratuit pour projets open source) ou local

## Installation locale (100% gratuit)

### Windows

1. **Docker Desktop** : https://www.docker.com/products/docker-desktop
2. **Terraform** : https://www.terraform.io/downloads
3. **Ansible** : `pip install ansible` (nécessite Python)
4. **Git** : https://git-scm.com/download/win

### Linux

```bash
# Docker
sudo apt update
sudo apt install docker.io docker-compose

# Terraform
wget https://releases.hashicorp.com/terraform/1.6.0/terraform_1.6.0_linux_amd64.zip
unzip terraform_1.6.0_linux_amd64.zip
sudo mv terraform /usr/local/bin/

# Ansible
sudo apt install ansible

# Git (généralement déjà installé)
sudo apt install git
```

### Mac

```bash
# Docker Desktop
# Télécharger depuis: https://www.docker.com/products/docker-desktop

# Terraform
brew install terraform

# Ansible
brew install ansible

# Git (généralement déjà installé)
brew install git
```

## Aucun coût requis

Tous les outils et services mentionnés sont **100% gratuits** pour ce projet. Vous n'avez besoin d'aucune carte bancaire ni abonnement payant.

