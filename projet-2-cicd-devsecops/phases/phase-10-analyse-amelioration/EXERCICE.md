# Exercice Phase 10 – Rapport d’analyse et d’amélioration

## Objectif

Produire un rapport synthétique qui :
1. présente les métriques clés du pipeline,
2. récapitule les incidents/limitations,
3. propose des améliorations classées par priorité.

## Étapes guidées

1. **Collecter les données**
   - Temps moyen d’exécution (GitLab > CI/CD > Analytics).
   - Couverture SonarQube, dette technique, issues critiques.
   - Nombre de déploiements réussis/échoués par environnement.
   - Résultats des scans (Trivy, dependency scan, etc.).

2. **Compléter la fiche d’incident**
   | Incident / Limite | Impact | Cause | Action corrective |
   |-------------------|--------|-------|-------------------|
   | Pipeline bloqué sur quality gate | Blocage des merges | Couverture insuffisante | Ajouter des tests + seuil adaptatif |

3. **Remplir la checklist**
   - [ ] Temps de pipeline < X minutes
   - [ ] Quality Gate passé sur last run
   - [ ] Scans sécurité sans vulnérabilité critique
   - [ ] Déploiements documentés (log + health check)
   - [ ] Aucun secret exposé

4. **Proposer des axes d’amélioration**
   | Horizon | Idée | Bénéfice | Pré-requis |
   |---------|------|----------|------------|
   | Court terme | Ajouter SAST GitLab | Détecter vulnérabilités plus tôt | Activer Security scans |
   | Moyen terme | Migrer infra sur Kubernetes | Scalabilité, rolling updates | Cluster K8s, Helm |
   | Long terme | Observabilité centralisée (Prom/Graf/Grafana) | Suivi temps réel | Stack monitoring |

5. **Rédiger le rapport**
   - 1 page de résumé (résultats, points forts, limites).
   - 1 page de recommandations (tableaux ci-dessus).

## Livrable

- Fichier `rapport-phase10.md` ou slides.
- Tableaux + checklist complétés.
- Capture(s) des métriques utilisées.

## Solution expliquée

Disponible dans `corrections/` (exemple de rapport avec métriques fictives). Inspirez-vous-en pour la structure, mais utilisez vos propres résultats.***

