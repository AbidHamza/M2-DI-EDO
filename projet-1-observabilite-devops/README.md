# Projet M2DI-EDO - Observabilité Avancée avec Prometheus, Grafana, Loki et Alertmanager

## Bienvenue dans votre projet d'observabilité DevOps

Ce document est votre guide principal pour réaliser votre projet de Master 2. Vous allez concevoir et mettre en œuvre une solution d'observabilité complète pour des applications conteneurisées en suivant une approche pédagogique progressive, phase par phase.

## Vue d'ensemble du projet

Vous allez créer une **solution d'observabilité complète** pour superviser des applications conteneurisées. Cette solution intégrera la collecte de métriques, l'ingestion de logs, la visualisation et l'alerting, le tout automatisé avec Terraform et Ansible.

### Contexte métier

Dans les environnements modernes basés sur des microservices conteneurisés, la résilience et la performance doivent être mesurées et améliorées en continu. En tant qu'ingénieur SRE (Site Reliability Engineer), vous devez concevoir et industrialiser une solution d'observabilité complète reposant exclusivement sur des technologies open source.

### Technologies utilisées

**Collecte et stockage :**
- **Prometheus** : Système de monitoring et collecte de métriques
- **Loki** : Système d'agrégation et d'indexation des logs

**Visualisation et alerting :**
- **Grafana** : Plateforme de visualisation et création de dashboards
- **Alertmanager** : Gestion et routage des alertes

**Infrastructure as Code :**
- **Terraform** : Provisionnement automatisé de l'infrastructure
- **Ansible** : Configuration et déploiement automatisés

**Conteneurisation :**
- **Docker** : Conteneurisation des applications et des outils d'observabilité

## Objectifs pédagogiques

À la fin de ce projet, vous serez capable de :

### Compétences techniques

1. **Observabilité**
   - Comprendre les principes de l'observabilité moderne (métriques, logs, traces)
   - Configurer Prometheus pour la collecte de métriques
   - Configurer Loki pour l'ingestion et l'indexation des logs
   - Créer des dashboards Grafana pertinents
   - Configurer Alertmanager pour les alertes automatisées

2. **Infrastructure as Code**
   - Utiliser Terraform pour provisionner l'infrastructure
   - Utiliser Ansible pour automatiser la configuration
   - Comprendre les avantages de l'IaC (reproductibilité, cohérence)

3. **Intégration et automatisation**
   - Intégrer tous les composants d'observabilité
   - Automatiser le déploiement complet
   - Tester la solution avec des scénarios réels

### Compétences méthodologiques

- Structurer un projet DevOps de manière professionnelle
- Documenter les choix techniques et l'architecture
- Analyser les performances et proposer des améliorations
- Comprendre les enjeux de scalabilité et haute disponibilité

## Structure du projet

```
projet-1-observabilite-devops/
├── README.md                    # Ce fichier - Guide général
├── phases/                      # Guide pédagogique par phase
│   ├── phase-1-etude-theorique/
│   ├── phase-2-architecture/
│   ├── phase-3-terraform/
│   ├── phase-4-ansible/
│   ├── phase-5-prometheus/
│   ├── phase-6-loki/
│   ├── phase-7-grafana/
│   ├── phase-8-alertmanager/
│   ├── phase-9-integration/
│   └── phase-10-tests-analyse/
├── docs/                        # Documentation et ressources
│   ├── architecture.md
│   ├── prometheus-config.md
│   └── best-practices.md
├── terraform/                   # Scripts Terraform
├── ansible/                     # Playbooks Ansible
├── docker-compose/              # Configuration Docker
└── application-example/         # Application exemple à superviser
```

## Plan des phases - Vue d'ensemble

Le projet est organisé en 10 phases progressives correspondant aux parties du sujet d'examen.

### Phase 1 : Étude et présentation théorique (30 points)
**Objectif :** Comprendre les concepts et outils d'observabilité  
**Livrable :** Présentation théorique des outils et concepts  
**Concepts clés :** Observabilité, Prometheus, Grafana, Loki, Alertmanager, IaC

### Phase 2 : Conception de l'architecture (20 points)
**Objectif :** Concevoir l'architecture complète de la solution  
**Livrable :** Schémas d'architecture et diagrammes de flux  
**Concepts clés :** Architecture distribuée, Flux de données, Intégration des composants

### Phase 3 : Provisionnement avec Terraform
**Objectif :** Automatiser le provisionnement de l'infrastructure  
**Livrable :** Scripts Terraform fonctionnels (local ou services gratuits)  
**Concepts clés :** Infrastructure as Code, Terraform, Providers, State management

### Phase 4 : Configuration avec Ansible
**Objectif :** Automatiser la configuration des serveurs  
**Livrable :** Playbooks Ansible pour l'installation et la configuration  
**Concepts clés :** Configuration Management, Playbooks, Roles, Inventories

### Phase 5 : Déploiement de Prometheus
**Objectif :** Configurer Prometheus pour la collecte de métriques  
**Livrable :** Prometheus fonctionnel collectant des métriques applicatives  
**Concepts clés :** Métriques, Scraping, Service Discovery, Exporters

### Phase 6 : Déploiement de Loki
**Objectif :** Configurer Loki pour l'ingestion des logs  
**Livrable :** Loki fonctionnel ingérant les logs applicatifs  
**Concepts clés :** Logs, Ingestion, Indexation, Labels

### Phase 7 : Création de dashboards Grafana
**Objectif :** Créer des dashboards pertinents pour la visualisation  
**Livrable :** Au minimum 2 dashboards personnalisés fonctionnels  
**Concepts clés :** Visualisation, Dashboards, Panels, Queries

### Phase 8 : Configuration d'Alertmanager
**Objectif :** Configurer le système d'alertes automatisées  
**Livrable :** Alertmanager fonctionnel avec notifications (email/webhook)  
**Concepts clés :** Alertes, Routing, Grouping, Notifications

### Phase 9 : Intégration complète
**Objectif :** Intégrer tous les composants et valider le fonctionnement  
**Livrable :** Solution complète fonctionnelle  
**Concepts clés :** Intégration, Validation, Tests end-to-end

### Phase 10 : Tests, analyse et amélioration (10 points)
**Objectif :** Tester la solution et proposer des améliorations  
**Livrable :** Rapport d'analyse avec propositions d'optimisation  
**Concepts clés :** Tests de charge, Analyse de performance, Scalabilité, HA

## Comment utiliser ce guide - Guide complet pas à pas

Ce guide est conçu pour vous accompagner étape par étape. Suivez-le méthodiquement pour réussir votre projet.

### Méthodologie recommandée - Le chemin à suivre

**Étape 0 : Préparation (avant de commencer)**
1. **Lisez ce README en entier** - Ne sautez pas cette étape !
2. **Vérifiez vos prérequis** - Utilisez la checklist ci-dessous
3. **Installez les outils nécessaires** - Suivez les instructions pour votre OS
4. **Créez un dépôt Git** - Pour versionner votre travail
5. **Consultez `docs/alternatives-gratuites.md`** - Pour comprendre vos options

**Étape 1 : Compréhension globale**
1. **Lisez la section "Vue d'ensemble"** - Comprenez ce que vous allez construire
2. **Lisez "Plan des phases"** - Voyez le parcours complet
3. **Lisez "Concepts clés"** - Maîtrisez les notions fondamentales

**Étape 2 : Pour chaque phase (répétez 10 fois)**
1. **Ouvrez le README de la phase** - Lisez les objectifs et rappels techniques
2. **Faites l'exercice pratique** - Fichier EXERCICE.md dans chaque phase
3. **Suivez les instructions étape par étape** - Ne brûlez pas les étapes
4. **Testez votre travail** - Vérifiez que tout fonctionne
5. **Vérifiez les livrables** - Assurez-vous d'avoir tout ce qui est demandé
6. **Commitez votre travail** - Sauvegardez régulièrement dans Git

**Étape 3 : Intégration et tests**
1. **Testez l'intégration complète** - Phase 9
2. **Analysez les résultats** - Phase 10
3. **Documentez vos choix** - Pour le rapport final

### Conseils pour réussir - Les secrets de la réussite

**1. Comprenez avant d'implémenter**
- ❌ **Mauvaise approche** : Copier-coller le code sans comprendre
- ✅ **Bonne approche** : Lire la documentation, comprendre le "pourquoi", puis implémenter
- **Astuce** : Si vous ne comprenez pas un concept, relisez les rappels théoriques dans `docs/rappels-theoriques/`

**2. Testez progressivement**
- ❌ **Mauvaise approche** : Tout construire puis tester à la fin
- ✅ **Bonne approche** : Tester chaque composant individuellement avant de passer au suivant
- **Astuce** : Utilisez `docker ps` pour vérifier que vos conteneurs tournent

**3. Documentez au fur et à mesure**
- ❌ **Mauvaise approche** : Documenter à la fin (vous oublierez des choses)
- ✅ **Bonne approche** : Noter vos choix et configurations au moment où vous les faites
- **Astuce** : Créez un fichier `NOTES.md` dans votre projet pour vos observations

**4. Expérimentez et apprenez de vos erreurs**
- ❌ **Mauvaise approche** : Avoir peur de casser quelque chose
- ✅ **Bonne approche** : Tester différents scénarios, c'est comme ça qu'on apprend
- **Astuce** : Utilisez `docker-compose down` pour tout nettoyer et recommencer

**5. Utilisez les ressources disponibles**
- Consultez la documentation officielle (liens dans "Ressources utiles")
- Lisez les rappels théoriques dans `docs/rappels-theoriques/`
- Regardez les exemples dans `application-example/`
- Demandez de l'aide si vous êtes bloqué (voir section "Aide et support")

### Structure d'apprentissage recommandée

```
Jour 1-2 : Phase 1 (Étude théorique)
  └─> Lisez, comprenez, préparez votre présentation

Jour 3-4 : Phase 2 (Architecture)
  └─> Concevez, dessinez, documentez

Jour 5-7 : Phases 3-4 (Terraform + Ansible)
  └─> Automatisez l'infrastructure

Jour 8-12 : Phases 5-8 (Outils d'observabilité)
  └─> Déployez et configurez chaque outil

Jour 13-14 : Phase 9 (Intégration)
  └─> Tout connecter et tester

Jour 15 : Phase 10 (Analyse)
  └─> Analyser et proposer des améliorations
```

**Note :** Ces durées sont indicatives. Prenez le temps nécessaire pour bien comprendre chaque phase.

## Prérequis

Avant de commencer, assurez-vous d'avoir :

### Logiciels installés (tous gratuits)

**Windows :**
- **Docker Desktop** : [docker.com/products/docker-desktop](https://www.docker.com/products/docker-desktop) (gratuit)
- **Terraform** : [terraform.io/downloads](https://www.terraform.io/downloads) (gratuit)
- **Ansible** : `pip install ansible` (nécessite Python, gratuit)
- **Git** : [git-scm.com/download/win](https://git-scm.com/download/win) (gratuit)
- **Un éditeur de code** : VS Code recommandé (gratuit)

**Linux :**
- **Docker** : `sudo apt install docker.io docker-compose` (gratuit)
- **Terraform** : Voir [terraform.io/downloads](https://www.terraform.io/downloads) (gratuit)
- **Ansible** : `sudo apt install ansible` (gratuit)
- **Git** : Généralement déjà installé, sinon `sudo apt install git` (gratuit)

**Mac :**
- **Docker Desktop** : [docker.com/products/docker-desktop](https://www.docker.com/products/docker-desktop) (gratuit)
- **Terraform** : `brew install terraform` (gratuit)
- **Ansible** : `brew install ansible` (gratuit)
- **Git** : Généralement déjà installé, sinon `brew install git` (gratuit)

**Note :** Tous les outils sont 100% gratuits. Consultez `docs/alternatives-gratuites.md` pour plus de détails.

### Environnement

**Option 1 : Local (recommandé - 100% gratuit)**
- Machine avec au moins 8GB RAM
- Docker Desktop installé (gratuit)
- Développement et tests en local
- Pas de coût, fonctionne sur Windows, Linux et Mac

**Option 2 : Services gratuits pour déploiement**
- **Railway** : Déploiement gratuit (500h/mois)
- **Render** : Déploiement gratuit (limite de temps)
- **Fly.io** : Déploiement gratuit (limites généreuses)
- **Vercel** : Déploiement gratuit pour applications web
- **GitHub Codespaces** : Environnement de développement gratuit (60h/mois)

**Option 3 : Hybride**
- Développement local (gratuit)
- Déploiement sur services gratuits pour la démonstration

### Connaissances préalables

- Bases de Linux (commandes, fichiers de configuration)
- Notions de conteneurisation (Docker)
- Compréhension des concepts réseau (ports, protocoles)
- Utilisation basique de Git

## Concepts clés à maîtriser

### Observabilité - Qu'est-ce que c'est ?

L'observabilité est la capacité à comprendre l'état interne d'un système à partir de ses sorties externes. C'est comme avoir un tableau de bord de voiture qui vous montre non seulement la vitesse (métrique), mais aussi les messages d'erreur (logs) et le chemin parcouru (traces).

**Les trois piliers de l'observabilité :**

1. **Métriques (Metrics)**
   - **Définition** : Mesures numériques collectées dans le temps
   - **Exemples** : CPU à 75%, mémoire utilisée 2GB, 100 requêtes/seconde
   - **Avantage** : Stockage efficace, agrégation facile
   - **Utilisation** : Détecter les tendances, créer des alertes

2. **Logs**
   - **Définition** : Événements textuels avec timestamp détaillant ce qui s'est passé
   - **Exemples** : "Erreur 404 sur /api/users à 14:32:15", "Utilisateur connecté: john@example.com"
   - **Avantage** : Contexte détaillé, recherche précise
   - **Utilisation** : Déboguer, auditer, comprendre les erreurs

3. **Traces (optionnel pour ce projet)**
   - **Définition** : Chemins d'exécution à travers plusieurs services
   - **Exemple** : Une requête passe par API → Base de données → Cache → API
   - **Avantage** : Comprendre les dépendances et la latence
   - **Utilisation** : Analyser les performances distribuées

**Pourquoi l'observabilité est importante ?**
- Détecter les problèmes avant qu'ils n'affectent les utilisateurs
- Comprendre le comportement de l'application en production
- Optimiser les performances
- Améliorer la fiabilité

### Infrastructure as Code (IaC) - Automatisation de l'infrastructure

L'IaC permet de gérer l'infrastructure (serveurs, réseaux, configurations) via du code plutôt que manuellement. C'est comme avoir une recette de cuisine : vous pouvez recréer exactement le même plat à chaque fois.

**Pourquoi utiliser l'IaC ?**
- **Reproductibilité** : Même infrastructure à chaque fois
- **Versioning** : Suivre les changements comme du code
- **Rapidité** : Déployer en minutes au lieu d'heures
- **Cohérence** : Pas d'erreurs humaines

**Les deux outils principaux :**

1. **Terraform** : Le "constructeur"
   - **Rôle** : Crée les ressources (serveurs, réseaux, bases de données)
   - **Exemple** : "Crée un serveur avec 2 CPU et 4GB RAM"
   - **Avantage** : Multi-cloud, déclaratif (vous décrivez ce que vous voulez)

2. **Ansible** : Le "configurateur"
   - **Rôle** : Configure ce qui existe (installe Docker, configure Nginx)
   - **Exemple** : "Installe Docker et démarre le conteneur Prometheus"
   - **Avantage** : Idempotent (peut être exécuté plusieurs fois sans problème)

**Workflow typique :**
```
1. Terraform crée les serveurs → Infrastructure prête
2. Ansible configure les serveurs → Applications installées
3. Résultat : Système complet et fonctionnel
```

### Monitoring vs Observabilité - La différence

**Monitoring traditionnel :**
- **Approche** : Surveillance passive avec alertes prédéfinies
- **Exemple** : "Alerte si CPU > 80%"
- **Limite** : Vous ne voyez que ce que vous avez prévu de voir

**Observabilité moderne :**
- **Approche** : Capacité active à explorer et comprendre le système
- **Exemple** : "Pourquoi la latence a augmenté ?" → Vous explorez les métriques, logs, traces
- **Avantage** : Vous pouvez répondre à des questions inattendues

**En résumé :**
- **Monitoring** : "Je surveille ce que je connais"
- **Observabilité** : "Je peux comprendre ce qui se passe, même si c'est nouveau"

## Commandes essentielles

### Terraform

**Windows (PowerShell ou Git Bash) :**
```powershell
# Initialiser Terraform
terraform init

# Planifier les changements
terraform plan

# Appliquer les changements
terraform apply

# Détruire l'infrastructure
terraform destroy
```

**Linux/Mac :**
```bash
# Initialiser Terraform
terraform init

# Planifier les changements
terraform plan

# Appliquer les changements
terraform apply

# Détruire l'infrastructure
terraform destroy
```

### Ansible

**Windows :**
```powershell
# Installer Ansible (via WSL ou pip)
pip install ansible

# Tester la connexion
ansible all -i inventory -m ping

# Exécuter un playbook
ansible-playbook -i inventory playbook.yml

# Vérifier la syntaxe
ansible-playbook --syntax-check playbook.yml
```

**Linux/Mac :**
```bash
# Installer Ansible
sudo apt install ansible  # Linux
brew install ansible      # Mac

# Tester la connexion
ansible all -i inventory -m ping

# Exécuter un playbook
ansible-playbook -i inventory playbook.yml

# Vérifier la syntaxe
ansible-playbook --syntax-check playbook.yml
```

### Docker

**Windows (PowerShell) :**
```powershell
# Démarrer les services
docker-compose up -d

# Voir les logs
docker-compose logs -f

# Arrêter les services
docker-compose down

# Voir les conteneurs
docker ps
```

**Linux/Mac :**
```bash
# Démarrer les services
docker-compose up -d

# Voir les logs
docker-compose logs -f

# Arrêter les services
docker-compose down

# Voir les conteneurs
docker ps
```

## Bonnes pratiques à suivre

### Sécurité

- Ne jamais commiter les secrets dans Git
- Utiliser des variables d'environnement ou un gestionnaire de secrets
- Limiter les accès réseau (firewall, security groups)
- Utiliser des images Docker officielles et à jour

### Code et configuration

- Versionner tous les scripts Terraform et Ansible
- Utiliser des modules Terraform réutilisables
- Créer des roles Ansible modulaires
- Documenter les variables et paramètres

### Monitoring

- Collecter uniquement les métriques pertinentes
- Configurer des rétentions appropriées
- Créer des dashboards orientés action
- Configurer des alertes utiles (pas trop, pas trop peu)

## Ressources utiles

### Documentation officielle

- [Prometheus Documentation](https://prometheus.io/docs/)
- [Grafana Documentation](https://grafana.com/docs/)
- [Loki Documentation](https://grafana.com/docs/loki/)
- [Terraform Documentation](https://www.terraform.io/docs)
- [Ansible Documentation](https://docs.ansible.com/)

### Tutoriels et guides

- [Prometheus Getting Started](https://prometheus.io/docs/introduction/overview/)
- [Grafana Tutorials](https://grafana.com/tutorials/)
- [Terraform Learn](https://learn.hashicorp.com/terraform)

## Aide et support - Résolution de problèmes

### Problèmes courants et solutions détaillées

#### Problème 1 : Erreur de connexion Prometheus

**Symptômes :**
- Les targets apparaissent comme "DOWN" dans Prometheus
- Erreur "connection refused" dans les logs
- Aucune métrique collectée

**Solutions étape par étape :**

1. **Vérifiez que l'application expose bien les métriques**
   ```bash
   # Windows (PowerShell)
   curl http://localhost:5000/metrics
   
   # Linux/Mac
   curl http://localhost:5000/metrics
   ```
   - Si vous voyez du texte avec des métriques → L'application fonctionne
   - Si erreur → Vérifiez que l'application est démarrée

2. **Vérifiez la configuration Prometheus**
   - Ouvrez `prometheus.yml`
   - Vérifiez que l'URL dans `static_configs` est correcte
   - Vérifiez le port (5000 pour l'app, 9090 pour Prometheus)

3. **Vérifiez les ports et firewall**
   ```bash
   # Vérifier qu'un port est ouvert
   # Windows
   netstat -an | findstr :5000
   
   # Linux/Mac
   netstat -an | grep 5000
   # ou
   lsof -i :5000
   ```

4. **Vérifiez la connectivité réseau (si Docker)**
   ```bash
   # Vérifier que les conteneurs sont sur le même réseau
   docker network ls
   docker network inspect <network-name>
   ```

#### Problème 2 : Alertes non déclenchées

**Symptômes :**
- Les règles d'alerte sont configurées mais rien ne se passe
- Alertmanager ne reçoit pas les alertes

**Solutions étape par étape :**

1. **Vérifiez que Prometheus évalue les règles**
   - Allez dans Prometheus → Alerts
   - Vérifiez que vos règles apparaissent
   - Vérifiez l'état : "Pending" ou "Firing"

2. **Vérifiez la syntaxe PromQL**
   - Testez votre requête dans Prometheus → Graph
   - Si la requête ne retourne rien, l'alerte ne se déclenchera pas

3. **Vérifiez la configuration Alertmanager**
   - Vérifiez que Prometheus pointe vers Alertmanager
   - Vérifiez l'URL dans `prometheus.yml` → `alerting.alertmanagers`

4. **Vérifiez les routes dans Alertmanager**
   - Ouvrez `alertmanager.yml`
   - Vérifiez que les routes correspondent aux labels de vos alertes

#### Problème 3 : Terraform échoue

**Symptômes :**
- Erreur lors de `terraform apply`
- Messages d'erreur cryptiques

**Solutions étape par étape :**

1. **Vérifiez la syntaxe**
   ```bash
   terraform validate
   ```
   - Corrigez les erreurs de syntaxe

2. **Vérifiez les credentials (si cloud)**
   - Si vous utilisez un service cloud, vérifiez vos credentials
   - Pour les services gratuits (Railway, Render), utilisez leurs APIs

3. **Vérifiez les permissions**
   - Assurez-vous d'avoir les droits nécessaires
   - Pour le local, vérifiez les permissions Docker

4. **Consultez les logs détaillés**
   ```bash
   terraform apply -debug
   ```
   - Les logs détaillés vous diront exactement où ça bloque

#### Problème 4 : Docker ne démarre pas

**Symptômes :**
- `docker-compose up` échoue
- Conteneurs qui redémarrent en boucle

**Solutions :**

1. **Vérifiez les logs**
   ```bash
   docker-compose logs <service-name>
   ```
   - Les logs vous diront pourquoi le service échoue

2. **Vérifiez les ports**
   - Un port peut être déjà utilisé
   - Changez le port dans `docker-compose.yml`

3. **Vérifiez les volumes**
   - Les chemins de volumes doivent exister
   - Sur Windows, utilisez des chemins relatifs ou absolus corrects

### Où trouver de l'aide - Ressources par niveau

**Niveau 1 : Auto-assistance (essayez d'abord)**
1. **Ce guide** - Relisez la section concernée
2. **Documentation officielle** - Liens dans "Ressources utiles"
3. **Rappels théoriques** - `docs/rappels-theoriques/`
4. **Exercices** - Les corrections (après soumission) contiennent des explications

**Niveau 2 : Communautés en ligne**
1. **Stack Overflow** - Recherchez votre erreur exacte
2. **GitHub Issues** - Pour les projets open source (Prometheus, Grafana)
3. **Discord/Slack** - Communautés Prometheus et Grafana

**Niveau 3 : Aide pédagogique**
1. **Votre enseignant** - N'hésitez pas à poser des questions
2. **Vos camarades** - Discutez des problèmes (mais faites votre propre travail)
3. **Tutorat** - Si disponible dans votre établissement

### Comment poser une bonne question

Quand vous demandez de l'aide, incluez :

1. **Le contexte** : Quelle phase, quel outil
2. **Ce que vous essayez de faire** : Objectif
3. **Ce que vous avez fait** : Étapes déjà effectuées
4. **Le message d'erreur exact** : Copiez-collez l'erreur complète
5. **Votre environnement** : OS, versions des outils

**Exemple de bonne question :**
```
Phase 5 - Prometheus
Je veux configurer Prometheus pour scraper mon application Flask.
J'ai créé prometheus.yml avec la configuration, démarré Prometheus.
Erreur : "Get http://app:5000/metrics: dial tcp: lookup app on 127.0.0.1:53: no such host"
Environnement : Windows 10, Docker Desktop, Prometheus dans Docker
```

Cette question contient tout ce qu'il faut pour vous aider rapidement !

## Checklist de démarrage

Avant de commencer la Phase 1, vérifiez que vous avez :

- [ ] Docker et Docker Compose installés
- [ ] Terraform installé (`terraform --version`)
- [ ] Ansible installé (`ansible --version`)
- [ ] Git installé et configuré
- [ ] Un éditeur de code installé
- [ ] Accès à un environnement (local ou cloud)
- [ ] Lu et compris ce README
- [ ] Créé un dépôt Git pour votre projet

## Prochaines étapes

1. **Créez votre dépôt Git** (si ce n'est pas déjà fait)
2. **Allez dans le dossier `phases/phase-1-etude-theorique/`**
3. **Lisez le README de la Phase 1**
4. **Commencez par l'exercice pratique** (fichier EXERCICE.md)
5. **Suivez les instructions étape par étape**

## Critères d'évaluation du projet

Votre projet sera évalué sur 100 points selon les critères suivants :

- **Compréhension théorique et clarté des explications (30 points)**
  - Qualité de la présentation des outils
  - Compréhension des concepts IaC
  - Clarté des explications

- **Cohérence et pertinence de l'architecture proposée (20 points)**
  - Qualité du schéma d'architecture
  - Pertinence des choix techniques
  - Description des flux de données

- **Qualité de l'implémentation et maîtrise des outils (40 points)**
  - Fonctionnement de Terraform et Ansible
  - Configuration correcte des outils
  - Dashboards pertinents
  - Système d'alertes fonctionnel
  - Tests de validation

- **Analyse critique et rigueur du rapport (10 points)**
  - Évaluation des performances
  - Propositions d'amélioration pertinentes
  - Qualité de la réflexion

## Conclusion

Ce projet vous permettra de maîtriser les outils essentiels de l'observabilité moderne et de comprendre comment automatiser le déploiement d'infrastructure. Vous acquerrez des compétences directement applicables dans un contexte professionnel d'ingénierie SRE.

Bon courage pour votre projet !

---

*Note : Ce guide est évolutif. N'hésitez pas à le consulter régulièrement et à prendre des notes sur vos apprentissages.*

