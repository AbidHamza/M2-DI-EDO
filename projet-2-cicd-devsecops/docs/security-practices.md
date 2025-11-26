# Pratiques de Sécurité DevSecOps

## Principes fondamentaux

### Security as Code
- Sécurité intégrée dans le code
- Configuration sécurisée par défaut
- Validation automatique

### Shift Left
- Détection précoce des vulnérabilités
- Tests de sécurité dans le pipeline
- Formation des développeurs

## Gestion des secrets

### Variables GitLab
- Variables protégées (masquées)
- Variables de fichier (clés SSH)
- Scope par environnement

### Ansible Vault
- Chiffrement des secrets
- Gestion centralisée
- Rotation des clés

### Terraform
- Variables sensibles
- Backend sécurisé
- State chiffré

## Scan de sécurité

### Dans le pipeline
- Scan des dépendances
- Scan des images Docker
- Analyse statique (SonarQube)
- Scan des configurations

### Outils recommandés
- Trivy (images Docker)
- OWASP Dependency Check
- Bandit (Python)
- SonarQube Security

## Bonnes pratiques

### Code
- Pas de secrets en clair
- Validation des entrées
- Gestion d'erreurs sécurisée

### Infrastructure
- Principe du moindre privilège
- Isolation réseau
- Chiffrement en transit et au repos

### Pipeline
- Approbations pour production
- Audit des déploiements
- Traçabilité complète

