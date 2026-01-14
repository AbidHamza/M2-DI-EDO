# Phase 9 – Gestion multi-environnements

Le pipeline doit maintenant gérer plusieurs environnements (dev, staging, production) avec des règles de promotion claires et des protections adaptées.

## Objectif concret

- Définir les environnements cibles, leurs variables, leurs secrets.
- Adapter le pipeline GitLab CI pour déployer automatiquement sur dev/staging, et manuellement sur prod avec approbation.
- Documenter le workflow de promotion (feature → dev → staging → prod).

## Plan d’action

1. **Cartographier les environnements**
   - Dev : déploiement automatique sur branches `develop` ou merge requests.
   - Staging : déploiement automatique après merge sur `main`.
   - Prod : déploiement manuel (bouton “Play” + approbation).

2. **Configurer les variables/secrets spécifiques**
   - `DEV_SERVER_HOST`, `STAGING_SERVER_HOST`, `PROD_SERVER_HOST`
   - Clés SSH/credentials par environnement (Protected + Masked).
   - `Terraform` et `Ansible` doivent consommer ces variables via `-var` ou `vars_files`.

3. **Adapter `.gitlab-ci.yml`**
   - Utiliser `environment:` (name, url, deployment_tier).
   - Règles/conditions :
     - `only: ["develop"]` pour `deploy_dev`.
     - `only: ["main"]` pour `deploy_staging` et `deploy_prod`.
     - `when: manual` + approbations pour prod.
   - Ajouter un job de vérification (health check) spécifique à chaque env.

4. **Documentation**
   - Table des environnements avec URL, variables, approbateurs.
   - Schéma de promotion (ex : feature → MR → dev → staging → prod).

## Livrables attendus

- Pipeline multi-environnements fonctionnel.
- Variables/Secrets configurés correctement dans GitLab.
- Procédure de promotion documentée (README ou `docs/multi-env.md`).
- Preuves de déploiement pour chaque environnement (captures, logs).

## Exercice associé

`EXERCICE.md` vous guide pour créer un pipeline minimal avec trois environnements et un job manuel pour la production. Reproduisez-le avant d’adapter votre pipeline final. La **solution expliquée** se trouve dans `corrections/`.

## Checklist

- [ ] Dev déployé automatiquement (branche develop / MR).
- [ ] Staging déployé automatiquement (branche main).
- [ ] Prod déclenché manuellement, avec approbation et environnement protégé.
- [ ] Secrets/variables isolés par environnement.
- [ ] Health checks valident chaque déploiement.

Ensuite, terminez par la **Phase 10 – Analyse et amélioration** pour tirer les enseignements de vos runs multi-environnements.*** End Patch

