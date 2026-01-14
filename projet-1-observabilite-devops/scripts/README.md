# Scripts utilitaires

Ce dossier contient les scripts pour gérer les corrections chiffrées.

## Pour les étudiants

### decrypt.sh (Linux/Mac)

Déchiffre toutes les corrections après avoir reçu le mot de passe.

**Utilisation :**
```bash
chmod +x scripts/decrypt.sh
./scripts/decrypt.sh
# Entrez le mot de passe quand demandé
```

### decrypt.sh (Windows)

Utilisez Git Bash ou WSL pour exécuter le script.

## Pour l'enseignant

### encrypt.sh

Chiffre les corrections une par une.

**Utilisation :**
```bash
chmod +x scripts/encrypt.sh
./scripts/encrypt.sh
# Entrez le mot de passe
```

### encrypt-all.sh (Linux/Mac)

Chiffre automatiquement toutes les corrections.

**Utilisation :**
```bash
chmod +x scripts/encrypt-all.sh
./scripts/encrypt-all.sh
```

### encrypt-all.ps1 (Windows)

Chiffre automatiquement toutes les corrections sur Windows.

**Utilisation :**
```powershell
.\scripts\encrypt-all.ps1
```

**Note :** Le mot de passe par défaut est défini dans le script. Changez-le si nécessaire.

