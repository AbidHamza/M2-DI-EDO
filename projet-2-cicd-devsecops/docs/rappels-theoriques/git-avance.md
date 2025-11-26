# Rappels théoriques : Git Avancé

## Workflows Git

### Git Flow

**Branches principales** :
- `main` : Production
- `develop` : Développement

**Branches de support** :
- `feature/*` : Nouvelles fonctionnalités
- `release/*` : Préparation de release
- `hotfix/*` : Corrections urgentes

**Workflow** :
```
feature → develop → release → main
```

### GitHub Flow

Workflow simplifié :
1. Créer une branche depuis `main`
2. Développer et commiter
3. Créer une Pull Request
4. Review et merge
5. Déployer depuis `main`

## Commandes Git avancées

### Rebasing

**Rebase interactif** :
```bash
git rebase -i HEAD~3  # Rebase les 3 derniers commits
```

**Options** :
- `pick` : Garder le commit
- `squash` : Fusionner avec le précédent
- `edit` : Modifier le commit
- `drop` : Supprimer le commit

### Cherry-pick

Appliquer un commit spécifique :
```bash
git cherry-pick <commit-hash>
```

### Stash

Sauvegarder temporairement les changements :
```bash
git stash                    # Sauvegarder
git stash list               # Lister
git stash apply              # Appliquer
git stash pop                # Appliquer et supprimer
```

## Hooks Git

### Pre-commit hook

Exécuté avant chaque commit :
```bash
#!/bin/bash
# .git/hooks/pre-commit
npm run lint
npm run test
```

### Post-commit hook

Exécuté après chaque commit :
```bash
#!/bin/bash
# .git/hooks/post-commit
echo "Commit effectué : $(git log -1 --pretty=%B)"
```

## Intégration avec CI/CD

### GitHub Actions

**Workflow basique** :
```yaml
name: CI
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Run tests
        run: npm test
```

### GitLab CI

Déjà couvert dans le projet, voir les phases du projet 2.

## Exercices pratiques

### Exercice 1 : Git Flow

**Objectif** : Mettre en place un workflow Git Flow.

**Tâches** :
1. Créez les branches `main` et `develop`
2. Créez une branche `feature/test`
3. Faites des commits
4. Mergez dans `develop`

**Solution** : Voir `corrections/EXERCICE-1-GIT-FLOW.md.encrypted`

### Exercice 2 : Rebase interactif

**Objectif** : Nettoyer l'historique avec rebase.

**Tâches** :
1. Créez plusieurs commits
2. Utilisez rebase interactif pour les fusionner
3. Vérifiez l'historique

**Solution** : Voir `corrections/EXERCICE-2-REBASE.md.encrypted`

## Ressources supplémentaires

- [Git Documentation](https://git-scm.com/doc)
- [Git Flow](https://nvie.com/posts/a-successful-git-branching-model/)
- [GitHub Flow](https://guides.github.com/introduction/flow/)

