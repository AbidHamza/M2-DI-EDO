# Projet M2DI-EDO – Chaîne CI/CD sécurisée (DevSecOps)

Ce guide vous accompagne phase par phase pour construire une pipeline GitLab CI complète intégrant qualité (SonarQube), sécurité (scans, gestion de secrets) et déploiement automatisé (Terraform + Ansible). Gardez ce fichier sous les yeux : il rappelle l’objectif global, l’organisation des ressources et la manière de suivre votre progression.

## Ce que vous allez construire

- Une application FastAPI conteneurisée, testée et livrée automatiquement
- Un pipeline GitLab CI orchestrant tests, analyse, build, publication d’image et déploiement
- SonarQube (ou SonarCloud) branché dans la chaîne pour appliquer des Quality Gates
- Une infrastructure provisionnée par Terraform puis configurée/déployée via Ansible
- Des contrôles DevSecOps : secrets protégés, scans de dépendances, politiques multi-environnements

## Organisation du dépôt

```
projet-2-cicd-devsecops/
├── README.md                    # Ce guide général
├── phases/                      # 10 phases avec README/EXERCICE + solutions chiffrées
├── docs/                        # Architecture pipeline, sécurité, rappels théoriques
├── application-example/         # API FastAPI + tests
├── .gitlab-ci.yml               # Pipeline à compléter
├── scripts/                     # Chiffrement/déchiffrement des corrections
└── COMMENT-ACCEDER-AUX-CORRECTIONS.md
```

Chaque dossier `phases/phase-X` contient :
1. `README.md` – théorie, objectifs, plan de travail
2. `EXERCICE.md` – mise en pratique guidée hors projet principal
3. `corrections/solution-expliquee.encrypted` – à déchiffrer après validation (via `scripts/decrypt.*`)

## Progression par phases

| Phase | Sujet                               | Objectif principal                                 |
|-------|-------------------------------------|----------------------------------------------------|
| 1     | Étude théorique                     | Comprendre DevSecOps, CI/CD, outils requis         |
| 2     | Architecture CI/CD                  | Décrire le pipeline cible et ses flux              |
| 3     | GitLab CI                           | Construire les stages (test, build, deploy)        |
| 4     | SonarQube / SonarCloud              | Intégrer l’analyse de code                         |
| 5     | Terraform                           | Provisionner l’infrastructure                      |
| 6     | Ansible                             | Configurer l’environnement et déployer l’app       |
| 7     | Sécurité de la chaîne               | Gérer secrets, scans, politiques                   |
| 8     | Intégration complète                | Exécuter la pipeline bout en bout                  |
| 9     | Multi-environnements                | Ajouter dev/staging/prod et promotions             |
| 10    | Analyse & amélioration              | Tester, mesurer et proposer des optimisations      |

## Méthodologie recommandée

1. **Préparation**
   - Lisez ce README, vérifiez les prérequis et créez votre dépôt GitLab.
   - Notez vos choix dans un fichier `NOTES.md`.
2. **Pour chaque phase**
   - Lisez le README de la phase.
   - Réalisez l’exercice dédié pour maîtriser l’outil isolément.
   - Implémentez la partie projet (pipeline, code IaC, etc.).
   - Testez, documentez, commitez.
3. **Intégration / soutenance**
   - En phase 8/9, rejouez tout le pipeline et consignez les résultats.
   - Phase 10 : formalisez les métriques, incidents, pistes d’amélioration.

## Prérequis & services gratuits

- **Logiciels** : Git, Docker Desktop, Terraform CLI, Ansible (ou WSL), Python 3.x, éditeur (VS Code).
- **Comptes/services** :
  - GitLab.com (CI/CD 2000 min/mois) + GitLab Runner local ou SaaS
  - SonarCloud (gratuit open source) ou SonarQube Community en local (`docker run -p 9000:9000 sonarqube:community`)
  - Plateformes de déploiement free tier possibles : Railway, Render, Fly.io, Vercel…
- **Matériel** : machine 8 Go RAM min. (Docker + SonarQube peuvent être gourmands).

Consultez `docs/alternatives-gratuites.md` pour choisir vos environnements (local, cloud, hybride).

## Compétences développées

- **CI/CD & DevSecOps** : conception de pipelines GitLab, gestion des artefacts, secrets, quality gates.
- **Qualité & Sécurité** : configuration SonarQube, scans de dépendances, politiques de release.
- **Infrastructure as Code** : Terraform pour créer l’infra, Ansible pour configurer/déployer.
- **Méthodologie** : traçabilité Git, documentation, tests multi-environnements.

## Ressources et scripts

- `docs/pipeline-design.md`, `docs/security-practices.md`, `docs/rappels-theoriques/`
- `scripts/decrypt.sh` / `.ps1` pour accéder aux solutions après validation
- `COMMENT-ACCEDER-AUX-CORRECTIONS.md` pour connaître la procédure de déchiffrement

## Commandes utiles (rappel rapide)

| Outil        | Commandes clés                                                                 |
|--------------|-------------------------------------------------------------------------------|
| GitLab CI    | `gitlab-runner exec docker <job>` pour tester un job localement               |
| SonarQube    | `sonar-scanner -Dsonar.projectKey=…` ou utilisation de l’image `sonarsource/sonar-scanner-cli` |
| Terraform    | `terraform fmt/init/plan/apply/destroy`                                       |
| Ansible      | `ansible-playbook -i inventories/dev playbooks/deploy.yml` + `--syntax-check` |

Les détails restent dans les READMEs de phase correspondants.

## Suivre et publier votre progression

1. **Initialisez et reliez votre dépôt**
   ```bash
   git init
   git remote add origin <url-de-votre-depot>
   ```
2. **Travaillez avec une branche par phase**
   ```bash
   git checkout -b phase-3-gitlab-ci
   ```
3. **Commitez et poussez régulièrement**
   ```bash
   git add .
   git commit -m "Phase 3 : pipeline initial GitLab CI"
   git push origin phase-3-gitlab-ci
   ```
4. **Tenez un tableau de suivi**

| Phase | Branche             | Statut      | Dernier commit |
|-------|---------------------|-------------|----------------|
| 1     | `phase-1-theorie`   | ✅ terminé  | `abc1234`      |
| 2     | `phase-2-archi`     | 🔄 en cours | `def5678`      |
| 3     | `phase-3-gitlab-ci` | ⏳ à venir  |                |

Mettre à jour ce tableau (dans `PROGRESSION.md` ou dans ce README) facilite les revues et la soutenance.

## Checklist avant de démarrer la Phase 1

- [ ] Compte GitLab actif et dépôt créé
- [ ] Docker Desktop opérationnel
- [ ] Terraform & Ansible installés
- [ ] SonarQube/SonarCloud accessible
- [ ] GitLab Runner configuré (local ou partagé)
- [ ] Lecture complète de ce README
- [ ] Notes personnelles prêtes

## Évaluation (rappel)

- 30 pts – Phase 1 (théorie DevSecOps)
- 20 pts – Phase 2 (architecture pipeline)
- 40 pts – Phases 3 à 9 (implémentation CI/CD + sécurité)
- 10 pts – Phase 10 (analyse, amélioration continue)

Chaque phase doit produire :
- du code/versionning (pipelines, IaC, scripts)
- des preuves de tests (captures, logs)
- une documentation courte expliquant comment rejouer et vérifier

## Prochaines étapes

1. Ouvrez `phases/phase-1-etude-theorique/README.md`
2. Suivez le plan guidé et réalisez l’exercice associé
3. Documentez vos conclusions, commitez et poussez la branche dédiée
4. Passez ensuite à la phase 2

Bon projet ! Vous aurez, à la fin de ce parcours, une chaîne DevSecOps prête à être démontrée en conditions quasi-réelles.*** End Patch

