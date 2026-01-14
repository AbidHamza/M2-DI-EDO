# Etape 02 : Generation de donnees

## Objectif

Creer un script Python pour generer des donnees de test realistes qui seront utilisees dans la stack ELK.

## Duree estimee

30-45 minutes

## Instructions pas a pas

### Etape 2.1 : Creer le script de generation

Creez un fichier nomme `generate_data.py` avec le contenu suivant :

```python
import csv
from datetime import datetime, timedelta
import random

# Configuration
VILLES = ["Paris", "Lyon", "Marseille", "Toulouse"]
POLLUANTS = ["NO2", "O3", "PM10", "SO2"]
DATE_DEBUT = datetime(2023, 1, 1)
NOMBRE_JOURS = 100
FICHIER_SORTIE = "pollution_data.csv"

def generer_valeur_pollution(polluant):
    """Genere une valeur de pollution realiste selon le type de polluant."""
    plages = {
        "NO2": (20, 80),
        "O3": (30, 120),
        "PM10": (10, 50),
        "SO2": (5, 30)
    }
    min_val, max_val = plages.get(polluant, (10, 100))
    return round(random.uniform(min_val, max_val), 2)

# Generation du fichier CSV
with open(FICHIER_SORTIE, mode="w", newline="", encoding="utf-8") as file:
    writer = csv.writer(file)
    writer.writerow(["date", "ville", "polluant", "valeur"])
    
    for jour in range(NOMBRE_JOURS):
        date = (DATE_DEBUT + timedelta(days=jour)).strftime("%Y-%m-%d")
        for ville in VILLES:
            for polluant in POLLUANTS:
                valeur = generer_valeur_pollution(polluant)
                writer.writerow([date, ville, polluant, valeur])
        
        if (jour + 1) % 10 == 0:
            print(f"{jour + 1}/{NOMBRE_JOURS} jours generes...")

print(f"Generation terminee ! Fichier cree : {FICHIER_SORTIE}")
```

### Etape 2.2 : Executer le script

Dans un terminal, executez :

```bash
python generate_data.py
```

**Resultat attendu** :
```
10/100 jours generes...
20/100 jours generes...
...
100/100 jours generes...
Generation terminee ! Fichier cree : pollution_data.csv
```

### Etape 2.3 : Verifier le fichier genere

Examinez les premieres lignes du fichier :

```bash
head -n 10 pollution_data.csv
```

**Resultat attendu** :
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

### Etape 2.4 : Verifier le nombre de lignes

```bash
wc -l pollution_data.csv
```

**Resultat attendu** : 1601 lignes (1 en-tete + 1600 donnees)

## Verification

Avant de passer a l'etape suivante, verifiez que :

- [ ] Le fichier pollution_data.csv existe
- [ ] Le fichier contient exactement 1601 lignes
- [ ] La premiere ligne est l'en-tete : date,ville,polluant,valeur
- [ ] Toutes les dates sont au format YYYY-MM-DD
- [ ] Toutes les villes sont : Paris, Lyon, Marseille, Toulouse
- [ ] Tous les polluants sont : NO2, O3, PM10, SO2

## Problemes courants

### "ModuleNotFoundError: No module named 'csv'"

**Solution** : Le module csv est integre a Python. Verifiez votre installation Python avec `python --version`

### "Permission denied"

**Solution** : Verifiez les permissions d'ecriture dans le dossier

### Le fichier est vide

**Solution** : Verifiez que le script s'est execute sans erreur. Consultez les messages d'erreur

## Prochaine etape

Une fois cette etape validee, passez a :
[Etape 03 : Stack ELK](ETAPE-03-STACK-ELK.md)
