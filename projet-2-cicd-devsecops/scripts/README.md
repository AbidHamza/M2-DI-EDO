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
# Utilise le mot de passe par défaut : M2DI-EDO-2025
# Ou spécifiez un mot de passe : ./scripts/encrypt-all.sh MON_MOT_DE_PASSE
```

### encrypt-all.ps1 (Windows)

Chiffre automatiquement toutes les corrections sur Windows.

**Utilisation :**
```powershell
.\scripts\encrypt-all.ps1
# Utilise le mot de passe par défaut : M2DI-EDO-2025
# Ou spécifiez un mot de passe : .\scripts\encrypt-all.ps1 MON_MOT_DE_PASSE
```

**Note :** Le mot de passe par défaut est `M2DI-EDO-2025`. Changez-le si nécessaire en modifiant le script ou en passant un paramètre.

