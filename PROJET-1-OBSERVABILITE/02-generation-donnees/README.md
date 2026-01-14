# Etape 2 : Generation de donnees

## Objectif de cette etape

Creer un script Python pour generer des donnees de test realistes qui seront utilisees dans la stack ELK.

Duree estimee : 30-45 minutes

## Vue d'ensemble

Dans cette etape, vous allez :
1. Comprendre le format de donnees necessaire
2. Creer un script Python pour generer des donnees
3. Valider la structure des donnees generees
4. Preparer les donnees pour l'indexation dans Elasticsearch

## Prérequis

- Python 3.8+ installe
- Module csv (inclus avec Python)
- Module datetime (inclus avec Python)
- Module random (inclus avec Python)

## Instructions

Pour des instructions detaillees pas a pas, consultez :
- [INSTRUCTIONS-PAS-A-PAS.md](INSTRUCTIONS-PAS-A-PAS.md)

Pour comprendre le code ligne par ligne, consultez :
- [CODE-EXPLIQUE.md](CODE-EXPLIQUE.md)

## Fichiers de cette etape

- generate_data.py : Script principal de generation de donnees
- config.py : Configuration centralisee
- verify_data.py : Script de verification des donnees generees
- test_data.py : Tests unitaires pour valider le code

## Execution

Pour generer les donnees :

```bash
python generate_data.py
```

Pour verifier les donnees generees :

```bash
python verify_data.py
```

## Resultat attendu

Apres l'execution, vous devriez avoir :
- Un fichier pollution_data.csv avec 1601 lignes (1 en-tete + 1600 donnees)
- Format CSV correct avec colonnes : date, ville, polluant, valeur
- Donnees pour 4 villes (Paris, Lyon, Marseille, Toulouse)
- Donnees pour 4 polluants (NO2, O3, PM10, SO2)
- 100 jours de donnees (du 2023-01-01 au 2023-04-10)

Pour plus de details, consultez :
- [SORTIE-ATTENDUE.md](SORTIE-ATTENDUE.md)

## Verification

Avant de passer a l'etape suivante, verifiez que :
- [ ] Le fichier pollution_data.csv existe
- [ ] Le fichier contient exactement 1601 lignes
- [ ] La premiere ligne est l'en-tete : date,ville,polluant,valeur
- [ ] Toutes les dates sont au format YYYY-MM-DD
- [ ] Toutes les villes sont : Paris, Lyon, Marseille, Toulouse
- [ ] Tous les polluants sont : NO2, O3, PM10, SO2
- [ ] Toutes les valeurs sont des nombres entre 5 et 120
- [ ] Le script verify_data.py passe sans erreur

## Problemes courants

Si vous rencontrez des problemes, consultez :
- [PROBLEMES-SOLUTIONS.md](PROBLEMES-SOLUTIONS.md)

## Concepts abordes

Dans cette etape, vous apprendrez :
- Comment generer des donnees de test realistes
- Comment structurer des donnees en format CSV
- Comment utiliser les modules Python standards (csv, datetime, random)
- Comment valider la qualite des donnees generees

## Prochaine etape

Une fois cette etape validee, passez a :
[Etape 3 : Stack ELK](../03-stack-elk/README.md)

