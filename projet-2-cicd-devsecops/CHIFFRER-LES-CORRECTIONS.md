# Guide pour chiffrer les corrections

## Pour l'enseignant

Ce guide explique comment chiffrer toutes les corrections avant de les mettre dans le dépôt.

## Méthode 1 : Script automatique (recommandé)

### Sur Linux/Mac

```bash
cd projet-2-cicd-devsecops
chmod +x scripts/encrypt-all.sh
./scripts/encrypt-all.sh
```

Le script chiffre automatiquement tous les fichiers `CORRECTION.md` dans les dossiers `corrections/`.

**Mot de passe par défaut :** `M2DI-EDO-2025`

Pour changer le mot de passe, éditez le script et modifiez la variable `PASSWORD`.

### Sur Windows

```powershell
cd projet-2-cicd-devsecops
.\scripts\encrypt-all.ps1
```

**Note :** Assurez-vous d'avoir OpenSSL installé. Si ce n'est pas le cas :
- Installez Git Bash (qui inclut OpenSSL)
- Ou installez OpenSSL via Chocolatey : `choco install openssl`

## Méthode 2 : Chiffrement manuel

### Pour chaque fichier de correction

**Linux/Mac :**
```bash
openssl enc -aes-256-cbc -salt -pbkdf2 \
  -in phases/phase-X/corrections/CORRECTION.md \
  -out phases/phase-X/corrections/CORRECTION.md.encrypted \
  -pass pass:M2DI-EDO-2025

# Supprimer le fichier original
rm phases/phase-X/corrections/CORRECTION.md
```

**Windows (Git Bash) :**
```bash
openssl enc -aes-256-cbc -salt -pbkdf2 \
  -in phases/phase-X/corrections/CORRECTION.md \
  -out phases/phase-X/corrections/CORRECTION.md.encrypted \
  -pass pass:M2DI-EDO-2025

# Supprimer le fichier original
rm phases/phase-X/corrections/CORRECTION.md
```

## Vérification

Après chiffrement, vérifiez que :
1. Les fichiers `.encrypted` existent
2. Les fichiers `.md` originaux sont supprimés (ou ignorés par .gitignore)
3. Vous pouvez déchiffrer avec le script `decrypt.sh`

## Test de déchiffrement

Pour tester que le chiffrement fonctionne :

```bash
# Linux/Mac
./scripts/decrypt.sh
# Entrez le mot de passe : M2DI-EDO-2025

# Windows (Git Bash)
bash scripts/decrypt.sh
# Entrez le mot de passe : M2DI-EDO-2025
```

## Important

- **Ne commitez JAMAIS** les fichiers non chiffrés
- **Changez le mot de passe** si nécessaire
- **Notez le mot de passe** dans un endroit sûr
- **Partagez le mot de passe** uniquement après validation des travaux étudiants

