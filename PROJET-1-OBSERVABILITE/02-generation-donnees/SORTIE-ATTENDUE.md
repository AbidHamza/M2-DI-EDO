# Sortie Attendue - Etape 2 : Generation de donnees

## Ce que vous devriez voir

Ce document montre exactement ce que vous devriez voir a chaque etape.

## Etape 1 : Execution du script

### Commande
```bash
python generate_data.py
```

### Sortie attendue
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
  30/100 jours generes...
  40/100 jours generes...
  50/100 jours generes...
  60/100 jours generes...
  70/100 jours generes...
  80/100 jours generes...
  90/100 jours generes...
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
   3: ['2023-01-01', 'Paris', 'PM10', '23.45']
   4: ['2023-01-01', 'Paris', 'SO2', '12.34']
   5: ['2023-01-01', 'Lyon', 'NO2', '38.56']

============================================================
SUCCES ! Vous pouvez passer a l'etape suivante.
============================================================
```

## Etape 2 : Verification du fichier

### Commande
```bash
head -n 10 pollution_data.csv
```

### Sortie attendue
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
2023-01-01,Marseille,O3,65.78
```

## Etape 3 : Verification du nombre de lignes

### Commande
```bash
wc -l pollution_data.csv
```

### Sortie attendue
```
1601 pollution_data.csv
```
(1600 lignes de donnees + 1 ligne d'en-tete = 1601)

## Etape 4 : Verification avec le script

### Commande
```bash
python verify_data.py
```

### Sortie attendue
```
Verification du fichier de donnees...
Fichier trouve : pollution_data.csv
En-tete correct : ['date', 'ville', 'polluant', 'valeur']
Nombre de lignes correct : 1600
Villes valides : ['Lyon', 'Marseille', 'Paris', 'Toulouse']
Polluants valides : ['NO2', 'O3', 'PM10', 'SO2']
Aucune ligne vide detectee
Aucune valeur manquante detectee

============================================================
VALIDATION REUSSIE
============================================================
Le fichier est pret pour l'etape suivante !
```

## Structure du fichier attendu

### Ligne 1 : En-tete
```
date,ville,polluant,valeur
```

### Lignes suivantes : Donnees
- Format : YYYY-MM-DD,VILLE,POLLUANT,VALEUR
- Exemple : 2023-01-01,Paris,NO2,45.23

### Nombre total de lignes
- 1 ligne d'en-tete
- 100 jours × 4 villes × 4 polluants = 1600 lignes de donnees
- Total : 1601 lignes

## Checklist de validation

Avant de passer a l'etape suivante, verifiez :

- [ ] Le fichier pollution_data.csv existe
- [ ] Le fichier contient exactement 1601 lignes
- [ ] La premiere ligne est l'en-tete : date,ville,polluant,valeur
- [ ] Toutes les dates sont au format YYYY-MM-DD
- [ ] Toutes les villes sont : Paris, Lyon, Marseille, Toulouse
- [ ] Tous les polluants sont : NO2, O3, PM10, SO2
- [ ] Toutes les valeurs sont des nombres entre 5 et 120
- [ ] Le script verify_data.py passe sans erreur

Si tous les points sont coches : Vous etes pret pour l'etape suivante !

## Si la sortie est differente

1. Comparez votre sortie avec celle attendue ci-dessus
2. Identifiez les differences
3. Consultez PROBLEMES-SOLUTIONS.md pour trouver la solution
4. Executez le diagnostic : ./diagnose.sh

