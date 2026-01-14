# Etape 01 : Pipeline CI/CD local (sans GitLab)

## Objectif

Creer un pipeline CI/CD basique qui s'execute en local sur votre ordinateur pour valider et construire votre application. Tout se fait en local, aucune donnee n'est envoyee sur Internet.

## Duree estimee

30-45 minutes

## Prérequis

- Python 3.8+ installe
- Docker installe (optionnel pour cette etape)
- Un editeur de texte

## Important : Confidentialite

Cette etape est concue pour fonctionner entierement en local. Vous n'avez pas besoin de GitLab ou d'aucun service externe. Tout reste sur votre ordinateur.

## Instructions pas a pas avec tous les details

### Etape 1.1 : Comprendre ce qu'est un pipeline CI/CD

**CI (Continuous Integration)** signifie Integration Continue :
- Chaque fois que vous modifiez votre code, vous pouvez executer automatiquement des tests
- Cela permet de detecter les erreurs tot

**CD (Continuous Deployment)** signifie Deploiement Continu :
- Apres validation des tests, vous pouvez deployer automatiquement votre application

**Dans notre cas** :
- Nous allons creer des scripts qui simulent un pipeline CI/CD
- Ces scripts s'executent sur votre ordinateur uniquement
- Aucune donnee n'est envoyee sur Internet

### Etape 1.2 : Creer la structure du projet

**Action** : Creer un dossier pour votre projet

**Avec un terminal** :
```bash
mkdir projet-devsecops
cd projet-devsecops
```

**Avec l'Explorateur de fichiers** :
- Creez un nouveau dossier nomme "projet-devsecops"
- Ouvrez ce dossier

**Pourquoi un dossier separe** : Pour garder tous les fichiers organises

### Etape 1.3 : Creer un script Python simple

**Action** : Creer une application Python de base pour tester

Creez un fichier `app.py` avec le contenu suivant :

```python
"""
Application Python simple pour tester le pipeline CI/CD
"""

def additionner(a, b):
    """
    Additionne deux nombres.
    
    Arguments:
        a (float): Premier nombre
        b (float): Deuxieme nombre
    
    Retourne:
        float: Somme des deux nombres
    """
    return a + b


def multiplier(a, b):
    """
    Multiplie deux nombres.
    
    Arguments:
        a (float): Premier nombre
        b (float): Deuxieme nombre
    
    Retourne:
        float: Produit des deux nombres
    """
    return a * b


if __name__ == "__main__":
    # Test simple
    resultat = additionner(5, 3)
    print(f"5 + 3 = {resultat}")
    
    resultat = multiplier(4, 7)
    print(f"4 * 7 = {resultat}")
```

**Ce que ce script fait** :
- Definit deux fonctions simples : additionner et multiplier
- Execute des tests basiques quand le script est lance directement

### Etape 1.4 : Creer le fichier requirements.txt

**Action** : Creer un fichier listant les dependances

Creez un fichier `requirements.txt` :

```txt
# Dependances de base pour le projet DevSecOps
# Pour l'instant, aucune dependance externe n'est necessaire
# Les modules integres a Python suffisent
```

**Pourquoi creer ce fichier meme s'il est vide** :
- Bonne pratique : Documente qu'il n'y a pas de dependances
- Permet d'ajouter facilement des dependances plus tard
- Les scripts de build s'attendent a ce que ce fichier existe

### Etape 1.5 : Creer un script de build

**Action** : Creer un script qui simule l'etape de build

Creez un fichier `build.sh` (Linux/Mac) ou `build.bat` (Windows) :

**Pour Linux/Mac (build.sh)** :
```bash
#!/bin/bash
# Script de build pour le pipeline CI/CD local

set -e  # Arreter en cas d'erreur

echo "============================================================"
echo "STAGE : BUILD"
echo "============================================================"

# Verifier que Python est installe
if ! command -v python3 &> /dev/null; then
    echo "ERREUR : Python 3 n'est pas installe"
    exit 1
fi

echo "Python trouve : $(python3 --version)"

# Verifier que le fichier requirements.txt existe
if [ ! -f "requirements.txt" ]; then
    echo "ATTENTION : requirements.txt n'existe pas, creation d'un fichier vide..."
    touch requirements.txt
fi

# Installer les dependances (si il y en a)
echo "Installation des dependances..."
if [ -s requirements.txt ]; then
    python3 -m pip install --user -r requirements.txt
    echo "Dependances installees avec succes"
else
    echo "Aucune dependance a installer"
fi

# Verifier que les fichiers Python sont valides
echo "Verification de la syntaxe Python..."
for fichier in *.py; do
    if [ -f "$fichier" ]; then
        echo "  Verification de $fichier..."
        python3 -m py_compile "$fichier"
        echo "  OK : $fichier est syntaxiquement correct"
    fi
done

echo ""
echo "============================================================"
echo "BUILD TERMINE AVEC SUCCES"
echo "============================================================"
```

**Pour Windows (build.bat)** :
```batch
@echo off
echo ============================================================
echo STAGE : BUILD
echo ============================================================

REM Verifier que Python est installe
python --version >nul 2>&1
if errorlevel 1 (
    echo ERREUR : Python n'est pas installe
    exit /b 1
)

echo Python trouve :
python --version

REM Verifier que le fichier requirements.txt existe
if not exist requirements.txt (
    echo ATTENTION : requirements.txt n'existe pas, creation d'un fichier vide...
    echo. > requirements.txt
)

REM Installer les dependances (si il y en a)
echo Installation des dependances...
findstr /V "^#" requirements.txt | findstr /V "^$" >nul 2>&1
if errorlevel 1 (
    echo Aucune dependance a installer
) else (
    python -m pip install --user -r requirements.txt
    echo Dependances installees avec succes
)

REM Verifier que les fichiers Python sont valides
echo Verification de la syntaxe Python...
for %%f in (*.py) do (
    echo   Verification de %%f...
    python -m py_compile "%%f"
    if errorlevel 1 (
        echo   ERREUR : %%f contient des erreurs de syntaxe
        exit /b 1
    ) else (
        echo   OK : %%f est syntaxiquement correct
    )
)

echo.
echo ============================================================
echo BUILD TERMINE AVEC SUCCES
echo ============================================================
```

**Ce que ce script fait** :
- Verifie que Python est installe
- Installe les dependances depuis requirements.txt
- Verifie la syntaxe de tous les fichiers Python
- Affiche un message de succes ou d'erreur

### Etape 1.6 : Creer un script de test

**Action** : Creer un script qui simule l'etape de test

Creez un fichier `test.sh` (Linux/Mac) ou `test.bat` (Windows) :

**Pour Linux/Mac (test.sh)** :
```bash
#!/bin/bash
# Script de test pour le pipeline CI/CD local

set -e  # Arreter en cas d'erreur

echo "============================================================"
echo "STAGE : TEST"
echo "============================================================"

# Verifier que Python est installe
if ! command -v python3 &> /dev/null; then
    echo "ERREUR : Python 3 n'est pas installe"
    exit 1
fi

# Creer un dossier pour les tests s'il n'existe pas
mkdir -p tests

# Creer un fichier de test simple si il n'existe pas
if [ ! -f "tests/test_app.py" ]; then
    echo "Creation d'un fichier de test basique..."
    cat > tests/test_app.py << 'EOF'
"""
Tests unitaires pour l'application
"""

import sys
import os

# Ajouter le repertoire parent au path pour importer app
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

import app

def test_additionner():
    """Test de la fonction additionner"""
    assert app.additionner(2, 3) == 5
    assert app.additionner(0, 0) == 0
    assert app.additionner(-1, 1) == 0
    print("✓ Test additionner reussi")

def test_multiplier():
    """Test de la fonction multiplier"""
    assert app.multiplier(2, 3) == 6
    assert app.multiplier(0, 5) == 0
    assert app.multiplier(-2, 3) == -6
    print("✓ Test multiplier reussi")

if __name__ == "__main__":
    print("Execution des tests...")
    test_additionner()
    test_multiplier()
    print("\nTous les tests sont passes avec succes !")
EOF
    echo "Fichier de test cree"
fi

# Executer les tests
echo "Execution des tests..."
python3 tests/test_app.py

if [ $? -eq 0 ]; then
    echo ""
    echo "============================================================"
    echo "TESTS TERMINES AVEC SUCCES"
    echo "============================================================"
else
    echo ""
    echo "============================================================"
    echo "ERREUR : Les tests ont echoue"
    echo "============================================================"
    exit 1
fi
```

**Pour Windows (test.bat)** :
```batch
@echo off
echo ============================================================
echo STAGE : TEST
echo ============================================================

REM Verifier que Python est installe
python --version >nul 2>&1
if errorlevel 1 (
    echo ERREUR : Python n'est pas installe
    exit /b 1
)

REM Creer un dossier pour les tests s'il n'existe pas
if not exist tests mkdir tests

REM Creer un fichier de test simple si il n'existe pas
if not exist tests\test_app.py (
    echo Creation d'un fichier de test basique...
    (
        echo import sys
        echo import os
        echo sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
        echo import app
        echo.
        echo def test_additionner():
        echo     assert app.additionner(2, 3) == 5
        echo     assert app.additionner(0, 0) == 0
        echo     assert app.additionner(-1, 1) == 0
        echo     print("OK : Test additionner reussi")
        echo.
        echo def test_multiplier():
        echo     assert app.multiplier(2, 3) == 6
        echo     assert app.multiplier(0, 5) == 0
        echo     assert app.multiplier(-2, 3) == -6
        echo     print("OK : Test multiplier reussi")
        echo.
        echo if __name__ == "__main__":
        echo     print("Execution des tests...")
        echo     test_additionner()
        echo     test_multiplier()
        echo     print("")
        echo     print("Tous les tests sont passes avec succes !")
    ) > tests\test_app.py
    echo Fichier de test cree
)

REM Executer les tests
echo Execution des tests...
python tests\test_app.py

if errorlevel 1 (
    echo.
    echo ============================================================
    echo ERREUR : Les tests ont echoue
    echo ============================================================
    exit /b 1
) else (
    echo.
    echo ============================================================
    echo TESTS TERMINES AVEC SUCCES
    echo ============================================================
)
```

### Etape 1.7 : Creer un pipeline local complet

**Action** : Creer un script qui execute toutes les etapes du pipeline

Creez un fichier `pipeline-local.sh` (Linux/Mac) ou `pipeline-local.bat` (Windows) :

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

# Stage 1 : Build
echo "STAGE 1 : BUILD"
echo "----------------"
./build.sh
if [ $? -ne 0 ]; then
    echo "ERREUR : Le build a echoue"
    exit 1
fi
echo ""

# Stage 2 : Test
echo "STAGE 2 : TEST"
echo "---------------"
./test.sh
if [ $? -ne 0 ]; then
    echo "ERREUR : Les tests ont echoue"
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

REM Stage 1 : Build
echo STAGE 1 : BUILD
echo ----------------
call build.bat
if errorlevel 1 (
    echo ERREUR : Le build a echoue
    exit /b 1
)
echo.

REM Stage 2 : Test
echo STAGE 2 : TEST
echo ---------------
call test.bat
if errorlevel 1 (
    echo ERREUR : Les tests ont echoue
    exit /b 1
)
echo.

echo ============================================================
echo PIPELINE TERMINE AVEC SUCCES
echo ============================================================
```

### Etape 1.8 : Rendre les scripts executables (Linux/Mac uniquement)

**Action** : Donner les permissions d'execution aux scripts

```bash
chmod +x build.sh test.sh pipeline-local.sh
```

**Ce que cette commande fait** :
- Donne la permission d'execution aux fichiers
- Permet de les executer directement avec `./build.sh`

**Windows** : Pas necessaire, les fichiers .bat sont executables par defaut

### Etape 1.9 : Executer le pipeline local

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

STAGE 1 : BUILD
----------------
============================================================
STAGE : BUILD
============================================================
Python trouve : Python 3.10.0
Installation des dependances...
Aucune dependance a installer
Verification de la syntaxe Python...
  Verification de app.py...
  OK : app.py est syntaxiquement correct

============================================================
BUILD TERMINE AVEC SUCCES
============================================================

STAGE 2 : TEST
---------------
============================================================
STAGE : TEST
============================================================
Execution des tests...
OK : Test additionner reussi
OK : Test multiplier reussi

Tous les tests sont passes avec succes !

============================================================
TESTS TERMINES AVEC SUCCES
============================================================

============================================================
PIPELINE TERMINE AVEC SUCCES
============================================================
```

## Verification

Avant de passer a l'etape suivante, verifiez que :

- [ ] Le fichier app.py existe et fonctionne
- [ ] Le fichier requirements.txt existe
- [ ] Le script build.sh (ou build.bat) existe et fonctionne
- [ ] Le script test.sh (ou test.bat) existe et fonctionne
- [ ] Le script pipeline-local.sh (ou pipeline-local.bat) existe et fonctionne
- [ ] Le pipeline complet s'execute sans erreur
- [ ] Les tests passent avec succes

## Structure finale du projet

Votre projet devrait avoir cette structure :

```
projet-devsecops/
├── app.py
├── requirements.txt
├── build.sh (ou build.bat)
├── test.sh (ou test.bat)
├── pipeline-local.sh (ou pipeline-local.bat)
└── tests/
    └── test_app.py
```

## Problemes courants

### Les scripts ne s'executent pas (Linux/Mac)

**Solution** : Donnez les permissions d'execution :
```bash
chmod +x *.sh
```

### Erreur "python: command not found"

**Solution** : Utilisez `python3` au lieu de `python` :
```bash
python3 app.py
```

### Erreur lors de l'execution des tests

**Solution** : Verifiez que app.py est dans le meme repertoire et que les fonctions existent

## Avantages de cette approche locale

- Confidentialite totale : Aucune donnee n'est envoyee sur Internet
- Controle complet : Vous decidez quand executer le pipeline
- Pas de dependance externe : Fonctionne sans GitLab ou autre service
- Gratuit : Aucun cout
- Rapide : Execution immediate sur votre machine

## Prochaine etape

Une fois cette etape validee, passez a :
[Etape 02 : Integration des outils de securite](ETAPE-02-SECURITE.md)

## Notes importantes

- Tout se fait en local sur votre ordinateur
- Aucune connexion Internet n'est necessaire
- Aucune donnee n'est envoyee sur Internet
- Vous pouvez modifier les scripts selon vos besoins
- Vous pouvez ajouter d'autres etapes au pipeline
