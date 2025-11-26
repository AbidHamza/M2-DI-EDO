# Comment accéder aux corrections des exercices

## Pour les étudiants

Ce guide vous explique comment accéder aux corrections détaillées des exercices après avoir soumis votre travail.

## Étape 1 : Soumettre votre réponse

Avant d'accéder aux corrections, vous devez soumettre votre travail :

### Option A : Via GitHub Issues (recommandé)
1. Allez dans l'onglet "Issues" du dépôt
2. Créez une nouvelle issue avec le titre : `[Phase X] Ma réponse - Votre Nom`
3. Dans le corps de l'issue, décrivez votre solution ou joignez vos fichiers
4. Mentionnez votre enseignant : `@nom-enseignant`

### Option B : Via Pull Request
1. Créez une branche : `git checkout -b phase-X-votre-nom`
2. Commitez vos fichiers de solution
3. Créez une Pull Request vers la branche principale
4. Attendez la validation de votre enseignant

### Option C : Via email
Envoyez votre solution par email à votre enseignant avec :
- Sujet : `[M2DI-EDO] Phase X - Votre Nom`
- Corps : Description de votre solution ou fichiers joints

## Étape 2 : Obtenir le mot de passe

Une fois votre travail soumis et validé par votre enseignant, vous recevrez :
- Le **mot de passe de déchiffrement** (par email, message GitHub, ou en cours)
- Les instructions pour déchiffrer les corrections

**Important** : Le mot de passe ne sera donné qu'après soumission de votre travail.

## Étape 3 : Déchiffrer les corrections

### Prérequis
- Avoir `openssl` installé sur votre machine
  - Linux/Mac : généralement déjà installé
  - Windows : installez via Git Bash ou WSL

### Méthode 1 : Script automatique (recommandé)

1. **Téléchargez le script de déchiffrement** :
   ```bash
   # Le script se trouve dans : scripts/decrypt.sh
   ```

2. **Rendez-le exécutable** (Linux/Mac) :
   ```bash
   chmod +x scripts/decrypt.sh
   ```

3. **Exécutez le script** :
   ```bash
   ./scripts/decrypt.sh
   ```

4. **Entrez le mot de passe** quand demandé

5. **Les corrections seront déchiffrées** dans les dossiers `corrections/` de chaque phase

### Méthode 2 : Déchiffrement manuel

Si le script ne fonctionne pas, vous pouvez déchiffrer manuellement :

```bash
# Pour chaque fichier chiffré
openssl enc -d -aes-256-cbc -salt -pbkdf2 \
  -in phases/phase-X/corrections/CORRECTION.md.encrypted \
  -out phases/phase-X/corrections/CORRECTION.md \
  -pass pass:VOTRE_MOT_DE_PASSE
```

## Structure des corrections

Après déchiffrement, vous trouverez dans chaque phase :

```
phases/phase-X/corrections/
├── CORRECTION.md          # Correction détaillée de l'exercice
├── SOLUTION.yml           # Fichiers de solution (si applicable)
└── EXPLICATIONS.md        # Explications approfondies
```

## Utilisation des corrections

Les corrections sont conçues pour :
- **Vérifier** votre solution
- **Comprendre** les bonnes pratiques
- **Apprendre** des approches alternatives
- **Améliorer** votre compréhension

**Important** : Utilisez les corrections pour apprendre, pas pour copier. L'objectif est de comprendre les concepts.

## Problèmes courants

### Le script ne s'exécute pas
- Vérifiez que vous avez les permissions : `chmod +x scripts/decrypt.sh`
- Sur Windows, utilisez Git Bash ou WSL

### Erreur "openssl not found"
- Installez OpenSSL sur votre système
- Ou utilisez la méthode manuelle avec le chemin complet vers openssl

### Mot de passe incorrect
- Vérifiez que vous avez bien reçu le mot de passe de votre enseignant
- Le mot de passe est sensible à la casse (majuscules/minuscules)

### Fichiers non déchiffrés
- Vérifiez que vous êtes dans le bon répertoire
- Vérifiez que les fichiers `.encrypted` existent

## Aide

Si vous rencontrez des problèmes :
1. Vérifiez ce guide
2. Contactez votre enseignant
3. Consultez la documentation OpenSSL

## Bonne chance avec vos exercices !

