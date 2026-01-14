# Projet M2DI-EDO – Observabilité avancée

Ce dossier vous guide pas à pas pour construire une plateforme d’observabilité complète autour d’une application conteneurisée. Chaque phase précise ce que vous devez comprendre, pratiquer et livrer avant de passer à la suivante. Gardez ce README comme fil conducteur : il présente l’objectif global, l’organisation et les ressources indispensables.

## Ce que vous allez réaliser

À la fin du parcours vous disposerez d’un socle observabilité prêt à être déployé :

- Collecte de métriques avec Prometheus et exporters adaptés
- Agrégation des logs applicatifs avec Loki
- Visualisation et corrélation métriques/logs dans Grafana
- Alertes fiables avec Alertmanager
- Provisionnement et configuration automatisés par Terraform + Ansible
- Application Flask fournie (`application-example/`) supervisée de bout en bout

Le travail est structuré pour reproduire un vrai projet SRE : cadrage théorique, architecture, IaC, déploiement par composant, intégration puis tests/optimisation.

## Comment le dépôt est organisé

```
projet-1-observabilite-devops/
├── README.md                  # Ce guide général
├── phases/                    # 10 phases pédagogiques (README + EXERCICE + solution chiffrée)
├── docs/                      # Aides détaillées (architecture, rappels, alternatives gratuites, etc.)
├── scripts/                   # Chiffrement/déchiffrement des solutions expliquées
├── application-example/       # Application Flask instrumentée + Docker
└── COMMENT-ACCEDER-AUX-CORRECTIONS.md
```

Chaque dossier de `phases/` contient :
1. `README.md` : théorie synthétique + ce que l’étudiant doit produire
2. `EXERCICE.md` : mise en pratique guidée (hors projet principal)
3. `corrections/solution-expliquee.encrypted` : résultat détaillé à déchiffrer après soumission

## Progression pédagogique

| Phase | Intitulé | Objectif concret |
| ----- | -------- | ---------------- |
| 1 | Étude théorique | Comprendre observabilité, outils et IaC (30 pts) |
| 2 | Architecture | Définir les flux et la topologie cible (20 pts) |
| 3 | Terraform | Provisionner les ressources (machines, réseaux) |
| 4 | Ansible | Industrialiser l’installation et la config |
| 5 | Prometheus | Collecter les métriques applicatives |
| 6 | Loki | Centraliser et indexer les logs |
| 7 | Grafana | Construire des dashboards exploitables |
| 8 | Alertmanager | Mettre en place les scénarios d’alertes |
| 9 | Intégration | Valider l’écosystème complet |
| 10 | Tests & analyse | Mesurer, documenter, proposer des optimisations (10 pts) |

Le README de chaque phase suit la même trame : contexte, compétences ciblées, erreurs fréquentes, plan d’action guidé, livrables et checklist de vérification. L’exercice associé permet de pratiquer la notion isolément avant de l’appliquer au projet.

## Méthode de travail recommandée

1. **Préparation**
   - Lisez entièrement ce README
   - Vérifiez les prérequis matériels et logiciels
   - Créez votre dépôt Git pour tracer chaque phase
2. **Pour chaque phase**
   - Lisez le README de la phase
   - Faites l’exercice pratique hors projet et comparez avec la solution expliquée (après avoir tenté seul)
   - Réalisez la partie projet décrite dans le README
   - Validez la checklist livrables/tests
   - Commitez vos avancées
3. **Intégration finale**
   - Phase 9 : branchez tous les composants et testez des scénarios réalistes
   - Phase 10 : mesurez, documentez et proposez des axes d’amélioration

## Prérequis indispensables

- **Compétences** : bases Linux, notions Docker, Git, réseaux, principes IaC
- **Logiciels** (tous gratuits) :
  - Docker Desktop (ou Docker Engine + Compose)
  - Terraform CLI
  - Python + pip (pour Ansible sous Windows)
  - Ansible (ou WSL pour Windows)
  - Git
  - Un éditeur de code (VS Code conseillé)
- **Matériel** : poste avec 8 Go RAM minimum
- **Option cloud gratuite** : consultez `docs/alternatives-gratuites.md` si vous préférez déployer hors local

## Compétences développées

- **Observabilité** : métriques/logs, Prometheus, Loki, Grafana, Alertmanager, PromQL, LogQL
- **IaC** : Terraform (provisionnement) + Ansible (configuration), séparation des responsabilités, reproductibilité
- **Automatisation** : scripts, pipelines de tests manuels, validation progressive
- **Méthodologie** : documentation, analyse d’incidents, communication des résultats

## Bonnes pratiques pour chaque phase

- **Clarifier l’objectif** : commencez toujours par reformuler ce que vous devez livrer
- **Découper les tâches** : travaillez par sous-étapes committées régulièrement
- **Tester tôt et souvent** : `terraform validate`, `ansible-playbook --syntax-check`, `docker ps`, requêtes PromQL/LogQL
- **Documenter vos choix** : pourquoi ce paramètre, comment reproduire la configuration
- **Comparer avec l’exercice** : l’exercice hors projet doit éclairer la mise en œuvre réelle

## Ressources du dossier `docs/`

- `architecture.md` : exemple de schéma cible + explications des flux
- `prometheus-config.md` : démarrage rapide et pièges classiques
- `alternatives-gratuites.md` : liste de services free-tier exploitables
- `rappels-theoriques/` : modules détaillés (Docker, Kubernetes, Prometheus, Grafana) avec mini-exercices

Consultez ces fichiers avant de chercher une solution sur Internet : ils sont pensés pour répondre aux questions les plus fréquentes.

## Scripts de chiffrement/déchiffrement

- `scripts/decrypt.sh` ou `scripts/decrypt.ps1` : pour lire une solution expliquée après validation par l’enseignant
- `scripts/encrypt.sh` et variantes : réservés à l’équipe pédagogique
- `COMMENT-ACCEDER-AUX-CORRECTIONS.md` détaille la marche à suivre (soumission → mot de passe → déchiffrement)

## Checklist avant de démarrer la Phase 1

- [ ] Outils installés (Docker, Terraform, Ansible, Git)
- [ ] Dépôt Git initialisé
- [ ] Lecture complète de ce README
- [ ] Compréhension du découpage en 10 phases
- [ ] Choix de l’environnement (local ou cloud gratuit)
- [ ] Notes personnelles prêtes (fichier `NOTES.md` recommandé)

## Suivre et publier votre progression

1. **Initialisez et reliez votre dépôt**
   ```bash
   git init
   git remote add origin <url-de-votre-depot>
   ```
2. **Travaillez avec une branche par phase**
   ```bash
   git checkout -b phase-5-prometheus
   ```
   Cela facilite les revues et vous permet de revenir facilement en arrière.
3. **Commitez et poussez régulièrement**
   ```bash
   git add .
   git commit -m "Phase 5 : configuration Prometheus"
   git push origin phase-5-prometheus
   ```
   Utilisez des messages courts mais explicites (phase + livrable + test).
4. **Documentez votre avancement**
   Ajoutez un tableau dans `PROGRESSION.md` ou dans ce README, par exemple :

   | Phase | Branche              | Statut        | Dernier commit |
   |-------|----------------------|---------------|----------------|
   | 1     | `phase-1-theorie`    | ✅ terminée   | `abc1234`      |
   | 2     | `phase-2-architecture` | 🔄 en cours | `def5678`      |
   | 3     | `phase-3-terraform`  | ⏳ à démarrer |                |

   Mettez-le à jour à chaque livraison pour que votre encadrant visualise immédiatement votre progression.

## Évaluation et livrables attendus

- **30 pts** – Phase 1 : clarté de la restitution théorique
- **20 pts** – Phase 2 : pertinence des choix d’architecture
- **40 pts** – Phases 3 à 8 : qualité technique (Terraform, Ansible, Prometheus, Loki, Grafana, Alertmanager) + tests démontrant la supervision de l’application exemple
- **10 pts** – Phase 10 : analyse critique, indicateurs mesurés, pistes d’amélioration

Chaque phase doit aboutir à :
- des artefacts versionnés (code, fichiers de configuration, schémas, scripts)
- une courte documentation décrivant ce qui a été réalisé, comment tester et comment résoudre les problèmes rencontrés

## Conseils pour poser une question efficace

Incluez systématiquement :
1. Phase concernée et objectif précis
2. Ce que vous avez déjà essayé
3. Commandes exécutées et sorties (ou erreurs) pertinentes
4. Environnement (OS, versions des outils, exécution Docker ou bare metal)

Exemple :
```
Phase 5 – Prometheus
Objectif : scraper l’application Flask locale.
Étapes réalisées : docker-compose up, création de prometheus.yml (ci-joint).
Problème : Target DOWN, message "connection refused".
Environnement : Windows 11, Docker Desktop, test local.
```

## Prochaines étapes

1. Ouvrez `phases/phase-1-etude-theorique/README.md`
2. Lisez la partie “Ce que vous allez maîtriser” puis suivez le plan proposé
3. Réalisez l’exercice associé avant de passer au projet
4. Validez la checklist et commitez

Vous pouvez maintenant démarrer la Phase 1 en toute clarté. Bonne progression !

