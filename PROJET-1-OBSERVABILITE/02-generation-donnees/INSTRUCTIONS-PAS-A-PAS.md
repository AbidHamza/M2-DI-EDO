# Instructions Pas a Pas - Etape 2 : Generation de donnees

## Objectif

Creer un script Python pour generer des donnees de test realistes qui seront utilisees dans la stack ELK.

Duree estimee : 30-45 minutes

## Vue d'ensemble

Dans cette etape, vous allez :
1. Examiner le script existant
2. Comprendre la configuration
3. Generer les donnees
4. Verifier le resultat

## Instructions detaillees

### Instruction 1 : Examiner le script existant

Action : Ouvrir et examiner le fichier generate_data.py

Commande a executer :
```bash
cd PROJET-1-OBSERVABILITE/02-generation-donnees
cat generate_data.py
```

Ou ouvrez le fichier avec votre editeur de code.

Ce que vous devriez voir :
- Des imports de modules Python
- Une section de configuration
- Des fonctions pour generer les donnees
- Un point d'entree principal

Pour comprendre le code en detail, consultez :
- [CODE-EXPLIQUE.md](CODE-EXPLIQUE.md)

### Instruction 2 : Comprendre la configuration

Action : Examiner le fichier config.py

Le fichier config.py contient :
- Les villes surveillees
- Les polluants mesures
- La periode de donnees
- Les plages de valeurs pour chaque polluant

Vous pouvez modifier ces valeurs pour personnaliser les donnees generees.

### Instruction 3 : Generer les donnees

Action : Executer le script de generation

Commande a executer :
```bash
python generate_data.py
```

Ce que cette commande fait :
- Genere un fichier CSV avec les donnees de pollution
- Affiche la progression de la generation
- Verifie que le fichier est valide

Resultat attendu :
```
============================================================
GENERATEUR DE DONNEES DE POLLUTION
============================================================
Generation de 100 jours de donnees...
Villes : Paris, Lyon, Marseille, Toulouse
Polluants : NO2, O3, PM10, SO2
Total de lignes a generer : 1600

  10/100 jours generes...
  20/100 jours generes...
  ...
  100/100 jours generes...

Generation terminee !
Fichier cree : /chemin/vers/pollution_data.csv
Lignes generees : 1600

Verification du fichier...
Fichier valide : 1600 lignes de donnees

Echantillon des premieres lignes :
   0: ['date', 'ville', 'polluant', 'valeur']
   1: ['2023-01-01', 'Paris', 'NO2', '45.23']
   2: ['2023-01-01', 'Paris', 'O3', '67.89']
   ...
```

### Instruction 4 : Verifier le resultat

Action : Examiner le fichier genere

Commande a executer :
```bash
head -n 20 pollution_data.csv
```

Ou sur Windows PowerShell :
```powershell
Get-Content pollution_data.csv -Head 20
```

Resultat attendu :
```
date,ville,polluant,valeur
2023-01-01,Paris,NO2,45.23
2023-01-01,Paris,O3,67.89
2023-01-01,Paris,PM10,23.45
2023-01-01,Paris,SO2,12.34
2023-01-01,Lyon,NO2,38.56
2023-01-01,Lyon,O3,72.12
...
```

### Instruction 5 : Verification automatique

Action : Executer le script de verification

Commande a executer :
```bash
python verify_data.py
```

Ce que ce script verifie :
- Le fichier existe
- L'en-tete est correct
- Le nombre de lignes est correct
- Le format des donnees est valide
- Les valeurs sont dans les plages attendues

Resultat attendu si tout est OK :
```
Verification du fichier de donnees...
Fichier trouve : pollution_data.csv
En-tete correct : ['date', 'ville', 'polluant', 'valeur']
Nombre de lignes correct : 1600
Format de date correct pour toutes les lignes
Villes valides : ['Paris', 'Lyon', 'Marseille', 'Toulouse']
Polluants valides : ['NO2', 'O3', 'PM10', 'SO2']
Valeurs numeriques valides (toutes entre 5 et 120)
Aucune ligne vide detectee
Aucune valeur manquante detectee

VALIDATION REUSSIE
Le fichier est pret pour l'etape suivante !
```

## Validation

Verifiez que :
- [ ] Le fichier pollution_data.csv existe
- [ ] Le fichier contient exactement 1601 lignes
- [ ] La premiere ligne est l'en-tete : date,ville,polluant,valeur
- [ ] Toutes les dates sont au format YYYY-MM-DD
- [ ] Toutes les villes sont : Paris, Lyon, Marseille, Toulouse
- [ ] Tous les polluants sont : NO2, O3, PM10, SO2
- [ ] Toutes les valeurs sont des nombres entre 5 et 120
- [ ] Le script verify_data.py passe sans erreur

Si tous les points sont coches : Vous avez reussi cette etape a 100%

## Problemes courants

### Probleme 1 : ModuleNotFoundError: No module named 'csv'

Solution : Le module csv est integre a Python. Verifiez votre installation Python.

### Probleme 2 : Permission denied

Solution : Verifiez les permissions d'ecriture dans le dossier.

### Probleme 3 : Le fichier est vide

Solution : Verifiez que le script s'est execute sans erreur. Consultez les messages d'erreur.

Pour plus de problemes, consultez PROBLEMES-SOLUTIONS.md

## Prochaine etape

Une fois cette etape validee, passez a :
[Etape 3 : Stack ELK](../03-stack-elk/README.md)

