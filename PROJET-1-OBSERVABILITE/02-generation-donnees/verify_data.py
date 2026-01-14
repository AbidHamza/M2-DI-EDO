"""
Script de verification des donnees generees

Ce script verifie que le fichier CSV genere est valide et pret
pour etre utilise dans la stack ELK.
"""

import csv
from pathlib import Path
from datetime import datetime

# Configuration attendue
FICHIER_ATTENDU = "pollution_data.csv"
EN_TETE_ATTENDU = ["date", "ville", "polluant", "valeur"]
VILLES_ATTENDUES = ["Paris", "Lyon", "Marseille", "Toulouse"]
POLLUANTS_ATTENDUS = ["NO2", "O3", "PM10", "SO2"]
NOMBRE_LIGNES_ATTENDU = 1601  # 1 en-tete + 1600 donnees


def verifier_fichier():
    """Verifie que le fichier CSV est valide."""
    print("Verification du fichier de donnees...")
    
    fichier = Path(FICHIER_ATTENDU)
    
    # Verifier que le fichier existe
    if not fichier.exists():
        print(f"ERREUR : Le fichier {FICHIER_ATTENDU} n'existe pas")
        return False
    
    print(f"Fichier trouve : {FICHIER_ATTENDU}")
    
    # Lire le fichier
    with open(fichier, 'r', encoding='utf-8') as f:
        reader = csv.reader(f)
        lignes = list(reader)
    
    # Verifier l'en-tete
    if lignes[0] != EN_TETE_ATTENDU:
        print(f"ERREUR : En-tete incorrect")
        print(f"  Attendu : {EN_TETE_ATTENDU}")
        print(f"  Trouve : {lignes[0]}")
        return False
    
    print(f"En-tete correct : {lignes[0]}")
    
    # Verifier le nombre de lignes
    if len(lignes) != NOMBRE_LIGNES_ATTENDU:
        print(f"ATTENTION : Nombre de lignes inattendu")
        print(f"  Attendu : {NOMBRE_LIGNES_ATTENDU}")
        print(f"  Trouve : {len(lignes)}")
    else:
        print(f"Nombre de lignes correct : {len(lignes) - 1}")
    
    # Verifier le format des donnees
    erreurs = []
    villes_trouvees = set()
    polluants_trouves = set()
    
    for i, ligne in enumerate(lignes[1:], start=2):  # Commencer a la ligne 2 (apres l'en-tete)
        # Verifier le nombre de colonnes
        if len(ligne) != 4:
            erreurs.append(f"Ligne {i} : Nombre de colonnes incorrect ({len(ligne)} au lieu de 4)")
            continue
        
        date_str, ville, polluant, valeur_str = ligne
        
        # Verifier le format de la date
        try:
            datetime.strptime(date_str, "%Y-%m-%d")
        except ValueError:
            erreurs.append(f"Ligne {i} : Format de date incorrect ({date_str})")
        
        # Verifier la ville
        if ville not in VILLES_ATTENDUES:
            erreurs.append(f"Ligne {i} : Ville inconnue ({ville})")
        villes_trouvees.add(ville)
        
        # Verifier le polluant
        if polluant not in POLLUANTS_ATTENDUS:
            erreurs.append(f"Ligne {i} : Polluant inconnu ({polluant})")
        polluants_trouves.add(polluant)
        
        # Verifier la valeur
        try:
            valeur = float(valeur_str)
            if valeur < 5 or valeur > 120:
                erreurs.append(f"Ligne {i} : Valeur hors plage ({valeur})")
        except ValueError:
            erreurs.append(f"Ligne {i} : Valeur non numerique ({valeur_str})")
        
        # Verifier les valeurs vides
        if not date_str or not ville or not polluant or not valeur_str:
            erreurs.append(f"Ligne {i} : Valeur manquante")
    
    # Afficher les resultats
    if erreurs:
        print(f"\nERREURS TROUVEES ({len(erreurs)}) :")
        for erreur in erreurs[:10]:  # Afficher seulement les 10 premieres erreurs
            print(f"  - {erreur}")
        if len(erreurs) > 10:
            print(f"  ... et {len(erreurs) - 10} autres erreurs")
        return False
    
    # Verifier que toutes les villes sont presentes
    if set(VILLES_ATTENDUES) != villes_trouvees:
        print(f"ATTENTION : Villes manquantes")
        print(f"  Attendu : {VILLES_ATTENDUES}")
        print(f"  Trouve : {sorted(villes_trouvees)}")
    else:
        print(f"Villes valides : {sorted(villes_trouvees)}")
    
    # Verifier que tous les polluants sont presents
    if set(POLLUANTS_ATTENDUS) != polluants_trouves:
        print(f"ATTENTION : Polluants manquants")
        print(f"  Attendu : {POLLUANTS_ATTENDUS}")
        print(f"  Trouve : {sorted(polluants_trouves)}")
    else:
        print(f"Polluants valides : {sorted(polluants_trouves)}")
    
    print("Aucune ligne vide detectee")
    print("Aucune valeur manquante detectee")
    
    print("\n" + "=" * 60)
    print("VALIDATION REUSSIE")
    print("=" * 60)
    print("Le fichier est pret pour l'etape suivante !")
    
    return True


if __name__ == "__main__":
    try:
        if verifier_fichier():
            exit(0)
        else:
            exit(1)
    except Exception as e:
        print(f"\nERREUR lors de la verification : {e}")
        exit(1)

