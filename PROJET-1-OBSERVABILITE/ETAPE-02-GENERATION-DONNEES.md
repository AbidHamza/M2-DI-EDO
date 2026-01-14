# Etape 02 : Generation de donnees

## Objectif

Creer un script Python pour generer des donnees de test realistes qui seront utilisees dans la stack ELK. Ces donnees simulent des mesures de pollution atmospherique pour plusieurs villes.

## Duree estimee

30-45 minutes

## Prérequis

- Python 3.8 ou superieur installe
- Un editeur de texte ou un IDE (VS Code, PyCharm, Notepad++, etc.)
- Aucune connexion Internet necessaire (tout se fait en local)

## Instructions pas a pas avec tous les details

### Etape 2.1 : Verifier que Python est installe

**Commande a executer** :
```bash
python --version
```

**Ou sur certains systemes** :
```bash
python3 --version
```

**Resultat attendu** :
```
Python 3.10.0
```
ou une version similaire (3.8, 3.9, 3.10, 3.11, etc.)

**Si vous voyez une erreur** :
- Windows : Telechargez Python depuis https://www.python.org/downloads/
- Linux : Installez avec `sudo apt-get install python3`
- macOS : Installez avec `brew install python3` ou telechargez depuis python.org

### Etape 2.2 : Creer un dossier pour votre projet

**Action** : Creer un nouveau dossier pour organiser vos fichiers

**Windows** :
1. Ouvrez l'Explorateur de fichiers
2. Naviguez vers votre bureau ou un dossier de votre choix
3. Clic droit → Nouveau → Dossier
4. Nommez-le "projet-observabilite" (ou un autre nom de votre choix)

**Linux/Mac** :
```bash
mkdir projet-observabilite
cd projet-observabilite
```

**Pourquoi creer un dossier** : Pour garder tous vos fichiers organises dans un seul endroit

### Etape 2.3 : Creer le script de generation

**Action** : Creer un nouveau fichier Python

**Avec un editeur de texte** :
1. Ouvrez votre editeur de texte (Notepad++, VS Code, etc.)
2. Creez un nouveau fichier
3. Nommez-le exactement : `generate_data.py`
4. Assurez-vous que l'extension est bien `.py` et non `.py.txt`

**Avec la ligne de commande** :
```bash
# Windows
notepad generate_data.py

# Linux/Mac
nano generate_data.py
# ou
vim generate_data.py
```

**Contenu exact du fichier** :

Copiez-collez exactement ce code dans votre fichier :

```python
import csv
from datetime import datetime, timedelta
import random

# Configuration des donnees a generer
VILLES = ["Paris", "Lyon", "Marseille", "Toulouse"]
POLLUANTS = ["NO2", "O3", "PM10", "SO2"]
DATE_DEBUT = datetime(2023, 1, 1)
NOMBRE_JOURS = 100
FICHIER_SORTIE = "pollution_data.csv"

def generer_valeur_pollution(polluant):
    """
    Genere une valeur de pollution realiste selon le type de polluant.
    
    Arguments:
        polluant (str): Type de polluant (NO2, O3, PM10, SO2)
    
    Retourne:
        float: Valeur de pollution en microgrammes par metre cube
    """
    # Plages de valeurs realistes pour chaque polluant
    # Ces valeurs sont basees sur des observations reelles en France
    plages = {
        "NO2": (20, 80),   # Dioxyde d'azote - valeurs typiques en ville
        "O3": (30, 120),   # Ozone - peut varier beaucoup selon la saison
        "PM10": (10, 50),  # Particules fines de moins de 10 micrometres
        "SO2": (5, 30)     # Dioxyde de soufre - generalement plus faible
    }
    
    # Recuperer la plage pour ce polluant
    # Si le polluant n'est pas dans la liste, utiliser une valeur par defaut
    min_val, max_val = plages.get(polluant, (10, 100))
    
    # Generer une valeur aleatoire dans la plage et l'arrondir a 2 decimales
    return round(random.uniform(min_val, max_val), 2)

# Generation du fichier CSV
print("Debut de la generation des donnees...")
print(f"Villes : {', '.join(VILLES)}")
print(f"Polluants : {', '.join(POLLUANTS)}")
print(f"Nombre de jours : {NOMBRE_JOURS}")
print(f"Fichier de sortie : {FICHIER_SORTIE}")
print()

# Ouvrir le fichier en mode ecriture
# newline="" est necessaire pour eviter les lignes vides supplementaires sur Windows
# encoding="utf-8" assure la compatibilite avec tous les caracteres
with open(FICHIER_SORTIE, mode="w", newline="", encoding="utf-8") as file:
    # Creer un objet writer pour ecrire dans le fichier CSV
    writer = csv.writer(file)
    
    # Ecrire l'en-tete du fichier CSV
    # Cette ligne definit les colonnes du fichier
    writer.writerow(["date", "ville", "polluant", "valeur"])
    
    # Compteur pour afficher la progression
    lignes_generees = 0
    
    # Boucle sur chaque jour
    for jour in range(NOMBRE_JOURS):
        # Calculer la date pour ce jour
        # timedelta(days=jour) ajoute le nombre de jours a la date de debut
        date = (DATE_DEBUT + timedelta(days=jour)).strftime("%Y-%m-%d")
        
        # Pour chaque ville
        for ville in VILLES:
            # Pour chaque polluant
            for polluant in POLLUANTS:
                # Generer une valeur de pollution pour cette combinaison
                valeur = generer_valeur_pollution(polluant)
                
                # Ecrire la ligne dans le fichier CSV
                # Format : date, ville, polluant, valeur
                writer.writerow([date, ville, polluant, valeur])
                lignes_generees += 1
        
        # Afficher la progression tous les 10 jours
        if (jour + 1) % 10 == 0:
            print(f"Progression : {jour + 1}/{NOMBRE_JOURS} jours generes ({lignes_generees} lignes)")

print()
print(f"Generation terminee avec succes !")
print(f"Fichier cree : {FICHIER_SORTIE}")
print(f"Nombre total de lignes generees : {lignes_generees}")
print(f"Nombre de lignes attendu : {NOMBRE_JOURS * len(VILLES) * len(POLLUANTS)}")
```

**Explication ligne par ligne** :

**Lignes 1-3** : Import des modules necessaires
- `csv` : Module pour lire et ecrire des fichiers CSV (inclus avec Python)
- `datetime` : Module pour manipuler les dates (inclus avec Python)
- `random` : Module pour generer des nombres aleatoires (inclus avec Python)

**Lignes 5-9** : Configuration
- `VILLES` : Liste des villes pour lesquelles on genere des donnees
- `POLLUANTS` : Liste des polluants mesures
- `DATE_DEBUT` : Date de debut de la periode de donnees
- `NOMBRE_JOURS` : Nombre de jours de donnees a generer
- `FICHIER_SORTIE` : Nom du fichier CSV qui sera cree

**Lignes 11-30** : Fonction pour generer des valeurs
- Cette fonction prend un type de polluant en entree
- Elle retourne une valeur aleatoire dans une plage realiste
- Les plages sont differentes pour chaque polluant

**Lignes 32-35** : Messages informatifs
- Affichent ce qui va etre genere

**Lignes 37-66** : Generation du fichier CSV
- Ouvre le fichier en mode ecriture
- Ecrit l'en-tete (premiere ligne)
- Genere les donnees pour chaque jour, ville et polluant
- Affiche la progression

### Etape 2.4 : Sauvegarder le fichier

**Action** : Sauvegarder le fichier generate_data.py

**Avec un editeur** :
- Appuyez sur Ctrl + S (Windows/Linux) ou Cmd + S (Mac)
- Verifiez que le fichier est sauvegarde dans le bon dossier

**Verification** :
- Le fichier doit s'appeler exactement `generate_data.py`
- L'extension doit etre `.py` et non `.py.txt`
- Le fichier doit etre dans votre dossier de projet

### Etape 2.5 : Executer le script

**Action** : Lancer le script Python

**Avec un terminal** :
1. Ouvrez un terminal
2. Naviguez vers votre dossier de projet :
   ```bash
   cd chemin/vers/votre/dossier/projet-observabilite
   ```
3. Executez le script :
   ```bash
   python generate_data.py
   ```
   ou
   ```bash
   python3 generate_data.py
   ```

**Resultat attendu exact** :
```
Debut de la generation des donnees...
Villes : Paris, Lyon, Marseille, Toulouse
Polluants : NO2, O3, PM10, SO2
Nombre de jours : 100
Fichier de sortie : pollution_data.csv

Progression : 10/100 jours generes (160 lignes)
Progression : 20/100 jours generes (320 lignes)
Progression : 30/100 jours generes (480 lignes)
Progression : 40/100 jours generes (640 lignes)
Progression : 50/100 jours generes (800 lignes)
Progression : 60/100 jours generes (960 lignes)
Progression : 70/100 jours generes (1120 lignes)
Progression : 80/100 jours generes (1280 lignes)
Progression : 90/100 jours generes (1440 lignes)

Generation terminee avec succes !
Fichier cree : pollution_data.csv
Nombre total de lignes generees : 1600
Nombre de lignes attendu : 1600
```

**Temps d'execution** : Quelques secondes seulement

**Si vous voyez une erreur** : Consultez la section "Problemes courants" ci-dessous

### Etape 2.6 : Verifier que le fichier a ete cree

**Action** : Verifier que le fichier pollution_data.csv existe

**Avec un terminal** :
```bash
# Windows
dir pollution_data.csv

# Linux/Mac
ls -l pollution_data.csv
```

**Resultat attendu** :
- Le fichier doit exister
- La taille doit etre d'environ 50-100 Ko

**Avec l'Explorateur de fichiers** :
- Ouvrez votre dossier de projet
- Vous devriez voir le fichier `pollution_data.csv`

### Etape 2.7 : Examiner le contenu du fichier

**Action** : Ouvrir et examiner le fichier CSV genere

**Avec un terminal - Afficher les premieres lignes** :

**Windows PowerShell** :
```powershell
Get-Content pollution_data.csv -Head 10
```

**Linux/Mac** :
```bash
head -n 10 pollution_data.csv
```

**Resultat attendu exact** :
```
date,ville,polluant,valeur
2023-01-01,Paris,NO2,45.23
2023-01-01,Paris,O3,67.89
2023-01-01,Paris,PM10,23.45
2023-01-01,Paris,SO2,12.34
2023-01-01,Lyon,NO2,38.56
2023-01-01,Lyon,O3,72.12
2023-01-01,Lyon,PM10,19.87
2023-01-01,Lyon,SO2,9.45
2023-01-01,Marseille,NO2,52.34
```

**Explication de chaque ligne** :
- Ligne 1 : En-tete avec les noms des colonnes
- Lignes suivantes : Donnees au format `date,ville,polluant,valeur`
- Format de date : YYYY-MM-DD (annee-mois-jour)
- Valeurs : Nombres decimaux avec 2 decimales

**Avec un editeur de texte** :
- Ouvrez le fichier `pollution_data.csv` avec Notepad, VS Code, ou Excel
- Verifiez que le format est correct

**Avec Excel ou LibreOffice** :
- Double-cliquez sur le fichier
- Il devrait s'ouvrir comme un tableau avec 4 colonnes

### Etape 2.8 : Verifier le nombre de lignes

**Action** : Compter le nombre total de lignes dans le fichier

**Commande** :

**Windows PowerShell** :
```powershell
(Get-Content pollution_data.csv).Count
```

**Linux/Mac** :
```bash
wc -l pollution_data.csv
```

**Resultat attendu** :
- 1601 lignes au total
- Explication : 1 ligne d'en-tete + 1600 lignes de donnees
- Calcul : 100 jours × 4 villes × 4 polluants = 1600 lignes de donnees

**Verification detaillee** :
- Ligne 1 : En-tete
- Lignes 2-17 : Donnees pour le premier jour (2023-01-01)
  - 4 villes × 4 polluants = 16 lignes par jour
- Ligne 1601 : Derniere ligne de donnees (pour le 100eme jour)

### Etape 2.9 : Verifier la structure des donnees

**Action** : Verifier que toutes les donnees sont au bon format

**Verification manuelle** :
1. Ouvrez le fichier avec un editeur de texte
2. Verifiez que :
   - La premiere ligne est : `date,ville,polluant,valeur`
   - Toutes les dates sont au format YYYY-MM-DD
   - Toutes les villes sont : Paris, Lyon, Marseille, Toulouse
   - Tous les polluants sont : NO2, O3, PM10, SO2
   - Toutes les valeurs sont des nombres avec 2 decimales

**Verification avec Python** :

Creez un fichier `verify_data.py` avec ce contenu :

```python
import csv

fichier = "pollution_data.csv"
erreurs = []

with open(fichier, 'r', encoding='utf-8') as f:
    reader = csv.reader(f)
    lignes = list(reader)
    
    # Verifier l'en-tete
    if lignes[0] != ["date", "ville", "polluant", "valeur"]:
        erreurs.append("En-tete incorrect")
    
    # Verifier les donnees
    villes_attendues = ["Paris", "Lyon", "Marseille", "Toulouse"]
    polluants_attendus = ["NO2", "O3", "PM10", "SO2"]
    
    for i, ligne in enumerate(lignes[1:], start=2):
        if len(ligne) != 4:
            erreurs.append(f"Ligne {i}: Nombre de colonnes incorrect")
        else:
            date, ville, polluant, valeur = ligne
            if ville not in villes_attendues:
                erreurs.append(f"Ligne {i}: Ville inconnue ({ville})")
            if polluant not in polluants_attendus:
                erreurs.append(f"Ligne {i}: Polluant inconnu ({polluant})")
            try:
                float(valeur)
            except ValueError:
                erreurs.append(f"Ligne {i}: Valeur non numerique ({valeur})")

if erreurs:
    print(f"ERREURS TROUVEES ({len(erreurs)}) :")
    for erreur in erreurs[:10]:
        print(f"  - {erreur}")
else:
    print("VALIDATION REUSSIE !")
    print(f"Nombre de lignes : {len(lignes)}")
    print(f"Nombre de donnees : {len(lignes) - 1}")
```

Executez-le :
```bash
python verify_data.py
```

**Resultat attendu** :
```
VALIDATION REUSSIE !
Nombre de lignes : 1601
Nombre de donnees : 1600
```

## Verification complete

Avant de passer a l'etape suivante, verifiez que :

- [ ] Le fichier pollution_data.csv existe dans votre dossier
- [ ] Le fichier contient exactement 1601 lignes
- [ ] La premiere ligne est l'en-tete : date,ville,polluant,valeur
- [ ] Toutes les dates sont au format YYYY-MM-DD (ex: 2023-01-01)
- [ ] Toutes les villes sont : Paris, Lyon, Marseille, Toulouse
- [ ] Tous les polluants sont : NO2, O3, PM10, SO2
- [ ] Toutes les valeurs sont des nombres avec 2 decimales (ex: 45.23)
- [ ] Le script verify_data.py (si cree) confirme que tout est correct

**Si tous les points sont coches** : Vous etes pret pour l'etape suivante

## Problemes courants et solutions detaillees

### Probleme 1 : "ModuleNotFoundError: No module named 'csv'"

**Symptomes** :
- Erreur lors de l'execution du script
- Message indiquant que le module csv n'est pas trouve

**Solution** :
- Le module `csv` est integre a Python depuis la version 2.3
- Si vous voyez cette erreur, votre installation Python est probablement corrompue
- Reinstallez Python depuis python.org

**Verification** :
```bash
python --version
```
Vous devriez voir Python 3.8 ou superieur

### Probleme 2 : "Permission denied"

**Symptomes** :
- Erreur lors de l'execution du script
- Message "Permission denied" ou "Acces refuse"

**Solutions** :

**Windows** :
1. Verifiez que vous avez les droits d'ecriture dans le dossier
2. Essayez d'executer le script depuis un autre dossier
3. Creez le fichier dans votre dossier Documents ou Bureau

**Linux/Mac** :
1. Verifiez les permissions du dossier :
   ```bash
   ls -ld .
   ```
2. Si necessaire, changez les permissions :
   ```bash
   chmod 755 .
   ```

### Probleme 3 : Le fichier est vide ou n'existe pas

**Symptomes** :
- Le script s'execute sans erreur
- Mais le fichier pollution_data.csv n'existe pas ou est vide

**Solutions** :

1. Verifiez que vous etes dans le bon dossier :
   ```bash
   pwd  # Linux/Mac
   cd   # Windows
   ```

2. Verifiez que le script s'est bien execute :
   - Vous devriez voir les messages de progression
   - Si vous ne voyez rien, il y a peut-etre une erreur silencieuse

3. Verifiez les erreurs Python :
   ```bash
   python generate_data.py 2>&1
   ```
   Cela affichera toutes les erreurs

4. Verifiez que le fichier n'est pas dans un autre dossier :
   - Cherchez "pollution_data.csv" sur votre ordinateur

### Probleme 4 : Les valeurs sont toutes identiques

**Symptomes** :
- Le fichier est cree mais toutes les valeurs sont les memes

**Solution** :
- C'est normal si vous utilisez `random.seed()` quelque part
- Verifiez que vous n'avez pas ajoute `random.seed(123)` dans votre code
- Si vous l'avez ajoute, supprimez cette ligne

### Probleme 5 : Erreur de format de date

**Symptomes** :
- Les dates ne sont pas au format YYYY-MM-DD
- Format incorrect dans le fichier CSV

**Solution** :
- Verifiez la ligne qui genere la date dans le script
- Elle doit etre exactement : `date = (DATE_DEBUT + timedelta(days=jour)).strftime("%Y-%m-%d")`
- Le format "%Y-%m-%d" signifie : annee sur 4 chiffres, mois sur 2 chiffres, jour sur 2 chiffres

## Notes importantes

- Tout se fait en local sur votre ordinateur
- Aucune connexion Internet n'est necessaire
- Aucune donnee n'est envoyee sur Internet
- Le fichier CSV reste sur votre ordinateur
- Vous pouvez modifier le script pour generer plus ou moins de donnees
- Vous pouvez ajouter d'autres villes ou polluants dans la configuration

## Prochaine etape

Une fois cette etape validee avec tous les tests qui passent, vous pouvez passer a :
[Etape 03 : Stack ELK](ETAPE-03-STACK-ELK.md)
