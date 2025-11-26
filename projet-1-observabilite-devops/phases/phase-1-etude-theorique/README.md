# Phase 1 – Étude et présentation théorique

Cette phase lance le projet en posant toutes les bases théoriques. Vous devez être capable d’expliquer clairement l’observabilité moderne, les outils utilisés dans la suite du projet et la logique Infrastructure as Code. Les notions clarifiées ici seront réutilisées dans chaque phase pratique.

## Pourquoi cette phase est cruciale

- Sans vision globale, les choix d’architecture des phases 2 et 3 seront flous.
- Les explications théoriques constituent 30 % de l’évaluation finale.
- Les erreurs les plus courantes (confusion métriques/logs, Prometheus vs Grafana, Terraform vs Ansible) se corrigent dès maintenant.

## Résultat attendu

Un support de présentation (≈20 diapositives) qui couvre :
- les trois piliers de l’observabilité et la différence monitoring/observabilité ;
- Prometheus, Grafana, Loki, Alertmanager : rôle, architecture simplifiée, cas d’usage concret ;
- l’approche Infrastructure as Code avec Terraform (provisionnement) et Ansible (configuration) ;
- comment ces briques formeront la solution à construire dans les phases suivantes.

## Préparation rapide

1. Lisez le README racine du projet pour comprendre l’objectif global.
2. Créez un fichier `NOTES.md` ou un document pour vos résumés et sources.
3. Ouvrez les rappels techniques dans `docs/rappels-theoriques/` (Docker, Prometheus, Grafana).

## Plan guidé

### 1. Comprendre l’observabilité moderne
- Reformulez la différence monitoring vs observabilité avec vos mots.
- Listez les trois piliers (métriques, logs, traces) + un exemple concret par pilier.
- Notez pourquoi l’observabilité permet de répondre à des questions imprévues.

### 2. Décortiquer chaque outil
Pour chaque composant (Prometheus, Grafana, Loki, Alertmanager) :
1. Quel problème résout-il ?
2. Quels sont ses principaux blocs (schéma simple suffisant) ?
3. Comment l’outil interagira avec l’application exemple fournie ?
4. Quelles sont les erreurs fréquentes à éviter ?

Servez-vous des documents dans `docs/` et de la documentation officielle (liens présents dans le README racine). Gardez des illustrations simples : tableau, liste de flux, capture schématique.

### 3. Relier la théorie à l’IaC
- Décrivez en 2-3 diapositives ce qu’est l’Infrastructure as Code.
- Expliquez ce que Terraform fera dans ce projet (créer les ressources) et ce qu’Ansible fera (configurer/déployer).
- Ajoutez un mini workflow : « Terraform → machines disponibles → Ansible → outils installés ».

### 4. Préparer le fil conducteur du projet
- Résumez l’application exemple (`application-example/app.py`) en deux phrases.
- Expliquez comment elle sera supervisée : métriques exposées, logs collectés, dashboards nécessaires, alertes envisagées.
- Présentez les 10 phases en une ligne chacune pour montrer la progression.

### 5. Structurer la présentation finale
Un ordre possible :
1. Objectifs et enjeux de l’observabilité
2. Monitoring vs observabilité, trois piliers
3. Zoom Prometheus
4. Zoom Grafana
5. Zoom Loki
6. Zoom Alertmanager
7. Infrastructure as Code (Terraform + Ansible)
8. Aperçu de l’application et vision globale du projet
9. Plan des phases
10. Questions ouvertes / prochaines étapes

### 6. Vérifications rapides
- Chaque slide répond-elle à une question claire ?
- Avez-vous noté vos sources et définitions (utile pour la soutenance) ?
- Êtes-vous capable d’expliquer en moins de 2 minutes comment Prometheus et Grafana coopèrent ?

## Exercice pratique associé

Avant (ou pendant) la préparation de votre présentation, réalisez l’exercice décrit dans `EXERCICE.md`. Il vous guide pour :
- installer Prometheus localement ;
- vérifier le scraping d’une cible simple ;
- relire les métriques exposées par l’application exemple.

L’objectif est d’illustrer vos slides par une démonstration que vous avez déjà testée. La **solution expliquée** se trouve dans `corrections/solution-expliquee.encrypted` (déchiffrable une fois votre travail soumis).

## Livrables de la phase

- Présentation (PDF, PPTX, etc.) avec au moins :
  - Observabilité et trois piliers
  - Détails sur Prometheus, Grafana, Loki, Alertmanager
  - Rôle de Terraform et Ansible
  - Plan global du projet et application cible
- Notes personnelles / références (format libre)
- Exercice exécuté + observations notées

## Checklist avant de passer à la Phase 2

- [ ] Je peux expliquer la différence monitoring / observabilité avec un exemple
- [ ] Je sais comment Prometheus collecte les métriques de l’application exemple
- [ ] Je comprends ce que Grafana affichera et d’où viennent ses données
- [ ] Je vois pourquoi Loki est complémentaire aux métriques
- [ ] Je peux résumer en une phrase le rôle d’Alertmanager
- [ ] Je distingue clairement Terraform (provisionnement) et Ansible (configuration)
- [ ] Mon exercice Prometheus fonctionne localement

Si tout est validé, commitez puis ouvrez `phase-2-architecture/README.md` pour concevoir l’architecture détaillée.

