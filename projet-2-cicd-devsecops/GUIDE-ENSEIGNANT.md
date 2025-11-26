# Guide pour l'enseignant - Gestion des corrections

## Vue d'ensemble

Ce guide explique comment gérer les corrections chiffrées pour vos étudiants.

## Chiffrement des corrections

### Étape 1 : Créer les corrections

Créez les fichiers de correction dans chaque phase :
```
phases/phase-X/corrections/
├── CORRECTION.md
├── SOLUTION.yml (si applicable)
└── EXPLICATIONS.md
```

### Étape 2 : Chiffrer les corrections

**Méthode 1 : Script automatique (recommandé)**

```bash
# Sur Linux/Mac
./scripts/encrypt.sh

# Entrez le mot de passe quand demandé
# Le script chiffre automatiquement tous les fichiers de correction
```

**Méthode 2 : Chiffrement manuel**

```bash
# Pour chaque fichier
openssl enc -aes-256-cbc -salt -pbkdf2 \
  -in phases/phase-X/corrections/CORRECTION.md \
  -out phases/phase-X/corrections/CORRECTION.md.encrypted \
  -pass pass:VOTRE_MOT_DE_PASSE
```

### Étape 3 : Vérifier

Vérifiez que les fichiers `.encrypted` sont créés et que les fichiers originaux sont toujours présents (ou supprimés selon votre choix).

## Gestion du mot de passe

### Recommandations

1. **Mot de passe unique** : Utilisez un mot de passe différent pour chaque promotion
2. **Stockage sécurisé** : Stockez le mot de passe dans un gestionnaire de mots de passe
3. **Partage contrôlé** : Ne partagez le mot de passe qu'après validation des travaux

### Options de partage

**Option A : Mot de passe unique pour tous**
- Simple à gérer
- Partage après la deadline
- Moins sécurisé

**Option B : Mot de passe par étudiant**
- Plus sécurisé
- Plus de travail de gestion
- Meilleur pour le suivi individuel

**Option C : Mot de passe par phase**
- Contrôle progressif
- Les étudiants débloquent phase par phase
- Bon compromis

## Workflow recommandé

### 1. Préparation

1. Créez toutes les corrections
2. Chiffrez-les avec le script
3. Commitez les fichiers `.encrypted` dans Git
4. **Ne commitez PAS les fichiers non chiffrés**

### 2. Pendant le projet

1. Les étudiants travaillent sur les exercices
2. Ils soumettent leurs réponses (GitHub Issues, PR, email)
3. Vous validez leurs travaux

### 3. Partage des corrections

1. Une fois validé, donnez le mot de passe :
   - Par email individuel
   - Via message GitHub
   - En cours (oralement)
   - Via un système de révélation automatique

2. Les étudiants déchiffrent avec `./scripts/decrypt.sh`

## Sécurité

### Bonnes pratiques

1. **Ne commitez jamais** les fichiers non chiffrés
2. **Utilisez un mot de passe fort** (minimum 16 caractères)
3. **Changez le mot de passe** chaque année/promotion
4. **Stockez le mot de passe** dans un gestionnaire sécurisé
5. **Limitez l'accès** au dépôt si nécessaire

## Support

Pour toute question ou problème, consultez la documentation OpenSSL ou contactez l'administrateur système.

