# Etape 05 : CI/CD en local (sans GitLab/GitHub)

## Objectif

Creer un pipeline CI/CD qui s'execute en local sur votre ordinateur pour automatiser les tests et la construction de votre application. Tout se fait en local, aucune donnee n'est envoyee sur Internet.

## Duree estimee

1h-1h30

## Important : Confidentialite

Cette etape est concue pour fonctionner entierement en local. Vous n'avez pas besoin de GitLab, GitHub ou d'aucun service externe. Tout reste sur votre ordinateur.

## Prérequis

- Docker installe et fonctionnel (etape 01 validee)
- Python installe (etape 02 validee)
- Scripts de votre projet crees

## Instructions pas a pas avec tous les details

### Etape 5.1 : Comprendre ce qu'est le CI/CD

**CI (Continuous Integration)** signifie Integration Continue :
- Chaque fois que vous modifiez votre code, vous pouvez executer automatiquement des tests
- Cela permet de detecter les erreurs tot

**CD (Continuous Deployment)** signifie Deploiement Continu :
- Apres validation des tests, vous pouvez deployer automatiquement votre application

**Dans notre cas** :
- Nous allons creer des scripts qui simulent un pipeline CI/CD
- Ces scripts s'executent sur votre ordinateur uniquement
- Aucune donnee n'est envoyee sur Internet

### Etape 5.2 : Creer un script de validation

**Action** : Creer un script qui valide votre code Python

Creez un fichier nomme `validate.py` avec le contenu suivant :

```python
"""
Script de validation du code Python
Execute des verifications de base sur le code
"""

import os
import sys

def verifier_fichiers_python():
    """Verifie que tous les fichiers Python sont valides."""
    print("=" * 60)
    print("VALIDATION DU CODE PYTHON")
    print("=" * 60)
    
    erreurs = []
    fichiers_python = []
    
    # Trouver tous les fichiers Python dans le repertoire courant
    for fichier in os.listdir('.'):
        if fichier.endswith('.py'):
            fichiers_python.append(fichier)
    
    if not fichiers_python:
        print("Aucun fichier Python trouve dans le repertoire courant")
        return False
    
    print(f"Fichiers Python trouves : {len(fichiers_python)}")
    for fichier in fichiers_python:
        print(f"  - {fichier}")
    print()
    
    # Verifier chaque fichier Python
    for fichier in fichiers_python:
        print(f"Verification de {fichier}...")
        
        try:
            # Essayer de compiler le fichier pour detecter les erreurs de syntaxe
            with open(fichier, 'r', encoding='utf-8') as f:
                code = f.read()
                compile(code, fichier, 'exec')
            print(f"  OK : {fichier} est syntaxiquement correct")
        except SyntaxError as e:
            erreur = f"ERREUR dans {fichier} : {e}"
            erreurs.append(erreur)
            print(f"  ERREUR : {erreur}")
        except Exception as e:
            erreur = f"ERREUR lors de la lecture de {fichier} : {e}"
            erreurs.append(erreur)
            print(f"  ERREUR : {erreur}")
    
    print()
    if erreurs:
        print(f"VALIDATION ECHOUE : {len(erreurs)} erreur(s) trouvee(s)")
        for erreur in erreurs:
            print(f"  - {erreur}")
        return False
    else:
        print("VALIDATION REUSSIE : Tous les fichiers Python sont valides")
        return True

if __name__ == "__main__":
    succes = verifier_fichiers_python()
    sys.exit(0 if succes else 1)
```

**Ce que ce script fait** :
- Trouve tous les fichiers Python dans le repertoire courant
- Verifie la syntaxe de chaque fichier
- Affiche les erreurs s'il y en a
- Retourne un code de succes ou d'echec

### Etape 5.3 : Creer un script de test

**Action** : Creer un script qui execute des tests sur votre code

Creez un fichier nomme `test.py` avec le contenu suivant :

```python
"""
Script de test pour valider le fonctionnement du code
"""

import sys
import os

def tester_generation_donnees():
    """Teste que le script de generation de donnees fonctionne."""
    print("=" * 60)
    print("TESTS DE GENERATION DE DONNEES")
    print("=" * 60)
    
    # Verifier que generate_data.py existe
    if not os.path.exists('generate_data.py'):
        print("ERREUR : generate_data.py n'existe pas")
        return False
    
    print("Fichier generate_data.py trouve")
    
    # Importer et tester le script
    try:
        # Sauvegarder le fichier de sortie actuel s'il existe
        fichier_backup = None
        if os.path.exists('pollution_data.csv'):
            fichier_backup = 'pollution_data.csv.backup'
            os.rename('pollution_data.csv', fichier_backup)
        
        # Executer le script de generation
        import generate_data
        
        # Verifier que le fichier a ete cree
        if not os.path.exists('pollution_data.csv'):
            print("ERREUR : Le fichier pollution_data.csv n'a pas ete cree")
            return False
        
        print("Fichier pollution_data.csv cree avec succes")
        
        # Verifier la taille du fichier
        taille = os.path.getsize('pollution_data.csv')
        if taille < 1000:  # Moins de 1 Ko semble suspect
            print(f"ATTENTION : Le fichier est tres petit ({taille} octets)")
        else:
            print(f"Taille du fichier : {taille} octets")
        
        # Restaurer le fichier de backup si necessaire
        if fichier_backup and os.path.exists(fichier_backup):
            os.remove('pollution_data.csv')
            os.rename(fichier_backup, 'pollution_data.csv')
        
        print("Tests de generation reussis")
        return True
        
    except Exception as e:
        print(f"ERREUR lors des tests : {e}")
        return False

if __name__ == "__main__":
    succes = tester_generation_donnees()
    sys.exit(0 if succes else 1)
```

### Etape 5.4 : Creer un script de build Docker

**Action** : Creer un script qui construit l'image Docker

Creez un fichier nomme `build.sh` (Linux/Mac) ou `build.bat` (Windows) :

**Pour Linux/Mac (build.sh)** :
```bash
#!/bin/bash
# Script de build Docker en local

echo "============================================================"
echo "BUILD DE L'IMAGE DOCKER"
echo "============================================================"

# Verifier que Docker est installe
if ! command -v docker &> /dev/null; then
    echo "ERREUR : Docker n'est pas installe"
    exit 1
fi

echo "Docker trouve"

# Verifier que le Dockerfile existe
if [ ! -f "Dockerfile" ]; then
    echo "ATTENTION : Dockerfile n'existe pas, creation d'un Dockerfile basique..."
    cat > Dockerfile << 'EOF'
FROM python:3.10-slim
WORKDIR /app
COPY *.py .
CMD ["python", "generate_data.py"]
EOF
    echo "Dockerfile cree"
fi

# Construire l'image
echo "Construction de l'image Docker..."
docker build -t pollution-monitor:local .

if [ $? -eq 0 ]; then
    echo "Build reussi !"
    echo "Image creee : pollution-monitor:local"
    docker images | grep pollution-monitor
else
    echo "ERREUR : Le build a echoue"
    exit 1
fi
```

**Pour Windows (build.bat)** :
```batch
@echo off
echo ============================================================
echo BUILD DE L'IMAGE DOCKER
echo ============================================================

REM Verifier que Docker est installe
docker --version >nul 2>&1
if errorlevel 1 (
    echo ERREUR : Docker n'est pas installe
    exit /b 1
)

echo Docker trouve

REM Verifier que le Dockerfile existe
if not exist Dockerfile (
    echo ATTENTION : Dockerfile n'existe pas, creation d'un Dockerfile basique...
    (
        echo FROM python:3.10-slim
        echo WORKDIR /app
        echo COPY *.py .
        echo CMD ["python", "generate_data.py"]
    ) > Dockerfile
    echo Dockerfile cree
)

REM Construire l'image
echo Construction de l'image Docker...
docker build -t pollution-monitor:local .

if errorlevel 1 (
    echo ERREUR : Le build a echoue
    exit /b 1
) else (
    echo Build reussi !
    echo Image creee : pollution-monitor:local
    docker images | findstr pollution-monitor
)
```

### Etape 5.5 : Creer un pipeline local complet

**Action** : Creer un script qui execute toutes les etapes du pipeline

Creez un fichier nomme `pipeline-local.sh` (Linux/Mac) ou `pipeline-local.bat` (Windows) :

**Pour Linux/Mac (pipeline-local.sh)** :
```bash
#!/bin/bash
# Pipeline CI/CD local complet

set -e  # Arreter en cas d'erreur

echo "============================================================"
echo "PIPELINE CI/CD LOCAL"
echo "============================================================"
echo "Toutes les etapes s'executent sur votre ordinateur"
echo "Aucune donnee n'est envoyee sur Internet"
echo ""

# Stage 1 : Validation
echo "STAGE 1 : VALIDATION"
echo "-------------------"
python validate.py
if [ $? -ne 0 ]; then
    echo "ERREUR : La validation a echoue"
    exit 1
fi
echo ""

# Stage 2 : Tests
echo "STAGE 2 : TESTS"
echo "----------------"
python test.py
if [ $? -ne 0 ]; then
    echo "ERREUR : Les tests ont echoue"
    exit 1
fi
echo ""

# Stage 3 : Build
echo "STAGE 3 : BUILD"
echo "----------------"
./build.sh
if [ $? -ne 0 ]; then
    echo "ERREUR : Le build a echoue"
    exit 1
fi
echo ""

echo "============================================================"
echo "PIPELINE TERMINE AVEC SUCCES"
echo "============================================================"
```

**Pour Windows (pipeline-local.bat)** :
```batch
@echo off
echo ============================================================
echo PIPELINE CI/CD LOCAL
echo ============================================================
echo Toutes les etapes s'executent sur votre ordinateur
echo Aucune donnee n'est envoyee sur Internet
echo.

REM Stage 1 : Validation
echo STAGE 1 : VALIDATION
echo -------------------
python validate.py
if errorlevel 1 (
    echo ERREUR : La validation a echoue
    exit /b 1
)
echo.

REM Stage 2 : Tests
echo STAGE 2 : TESTS
echo ----------------
python test.py
if errorlevel 1 (
    echo ERREUR : Les tests ont echoue
    exit /b 1
)
echo.

REM Stage 3 : Build
echo STAGE 3 : BUILD
echo ----------------
call build.bat
if errorlevel 1 (
    echo ERREUR : Le build a echoue
    exit /b 1
)
echo.

echo ============================================================
echo PIPELINE TERMINE AVEC SUCCES
echo ============================================================
```

### Etape 5.6 : Rendre les scripts executables (Linux/Mac uniquement)

**Action** : Donner les permissions d'execution aux scripts

```bash
chmod +x build.sh pipeline-local.sh
```

**Ce que cette commande fait** :
- Donne la permission d'execution aux fichiers
- Permet de les executer directement avec `./build.sh`

**Windows** : Pas necessaire, les fichiers .bat sont executables par defaut

### Etape 5.7 : Executer le pipeline local

**Action** : Lancer le pipeline complet

**Linux/Mac** :
```bash
./pipeline-local.sh
```

**Windows** :
```batch
pipeline-local.bat
```

**Resultat attendu** :
```
============================================================
PIPELINE CI/CD LOCAL
============================================================
Toutes les etapes s'executent sur votre ordinateur
Aucune donnee n'est envoyee sur Internet

STAGE 1 : VALIDATION
-------------------
============================================================
VALIDATION DU CODE PYTHON
============================================================
Fichiers Python trouves : 2
  - generate_data.py
  - validate.py
Verification de generate_data.py...
  OK : generate_data.py est syntaxiquement correct
Verification de validate.py...
  OK : validate.py est syntaxiquement correct

VALIDATION REUSSIE : Tous les fichiers Python sont valides

STAGE 2 : TESTS
----------------
============================================================
TESTS DE GENERATION DE DONNEES
============================================================
Fichier generate_data.py trouve
Fichier pollution_data.csv cree avec succes
Taille du fichier : 52341 octets
Tests de generation reussis

STAGE 3 : BUILD
----------------
============================================================
BUILD DE L'IMAGE DOCKER
============================================================
Docker trouve
Construction de l'image Docker...
Sending build context to Docker daemon...
Step 1/3 : FROM python:3.10-slim
...
Successfully built abc123def456
Successfully tagged pollution-monitor:local
Build reussi !
Image creee : pollution-monitor:local

============================================================
PIPELINE TERMINE AVEC SUCCES
============================================================
```

### Etape 5.8 : Automatiser le pipeline (optionnel)

**Action** : Creer un script qui surveille les changements et execute le pipeline automatiquement

Vous pouvez utiliser des outils comme `watch` (Linux) ou creer un script qui surveille les fichiers.

**Exemple simple avec watch (Linux)** :
```bash
# Executer le pipeline toutes les 30 secondes si les fichiers changent
watch -n 30 ./pipeline-local.sh
```

## Verification

Avant de passer a l'etape suivante, verifiez que :

- [ ] Le script validate.py existe et fonctionne
- [ ] Le script test.py existe et fonctionne
- [ ] Le script build.sh (ou build.bat) existe et fonctionne
- [ ] Le script pipeline-local.sh (ou pipeline-local.bat) existe et fonctionne
- [ ] Le pipeline complet s'execute sans erreur
- [ ] L'image Docker est construite avec succes

## Avantages de cette approche locale

- Confidentialite totale : Aucune donnee n'est envoyee sur Internet
- Controle complet : Vous decidez quand executer le pipeline
- Pas de dependance externe : Fonctionne sans GitLab, GitHub ou autre service
- Gratuit : Aucun cout
- Rapide : Execution immediate sur votre machine

## Problemes courants

### Les scripts ne s'executent pas (Linux/Mac)

**Solution** : Donnez les permissions d'execution :
```bash
chmod +x *.sh
```

### Erreur "python: command not found"

**Solution** : Utilisez `python3` au lieu de `python` :
```bash
python3 validate.py
```

### Erreur lors du build Docker

**Solution** : Verifiez que Docker est lance et fonctionne :
```bash
docker ps
```

## Prochaine etape

Une fois cette etape validee, passez a :
[Etape 06 : Containerisation](ETAPE-06-CONTAINERISATION.md)

## Notes importantes

- Tout se fait en local sur votre ordinateur
- Aucune connexion Internet n'est necessaire
- Aucune donnee n'est envoyee sur Internet
- Vous pouvez modifier les scripts selon vos besoins
- Vous pouvez ajouter d'autres etapes au pipeline
