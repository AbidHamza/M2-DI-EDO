"""
Generateur de donnees de pollution pour le projet ELK Stack

Ce script genere des donnees CSV simulees de pollution atmospherique
pour differentes villes et polluants sur une periode donnee.

Auteur : Projet M2-DI-EDO
Date : 2024
"""

import csv
from datetime import datetime, timedelta
import random
from pathlib import Path

# ============================================================================
# CONFIGURATION
# ============================================================================
# Modifiez ces valeurs pour personnaliser les donnees generees

# Liste des villes pour lesquelles on genere des donnees
VILLES = ["Paris", "Lyon", "Marseille", "Toulouse"]

# Liste des polluants mesures
POLLUANTS = ["NO2", "O3", "PM10", "SO2"]

# Date de debut de la periode de donnees
DATE_DEBUT = datetime(2023, 1, 1)

# Nombre de jours de donnees a generer
NOMBRE_JOURS = 100

# Nom du fichier de sortie
FICHIER_SORTIE = "pollution_data.csv"

# ============================================================================
# FONCTIONS
# ============================================================================

def generer_valeur_pollution(polluant):
    """
    Genere une valeur de pollution realiste selon le type de polluant.
    
    Cette fonction retourne une valeur aleatoire dans une plage realiste
    selon le type de polluant. Les plages sont basees sur des valeurs
    typiques observees dans les villes europeennes.
    
    Arguments:
        polluant (str): Type de polluant (NO2, O3, PM10, SO2)
    
    Retourne:
        float: Valeur de pollution en microgrammes par metre cube (ug/m3)
    """
    # Plages de valeurs realistes selon le polluant
    # Ces valeurs sont basees sur des observations reelles
    plages = {
        "NO2": (20, 80),   # Dioxyde d'azote - valeurs typiques en ville
        "O3": (30, 120),   # Ozone - peut varier beaucoup selon la saison
        "PM10": (10, 50),  # Particules fines de moins de 10 micrometres
        "SO2": (5, 30)     # Dioxyde de soufre - generalement plus faible
    }
    
    # Recuperer la plage pour ce polluant, ou utiliser une valeur par defaut
    min_val, max_val = plages.get(polluant, (10, 100))
    
    # Generer une valeur aleatoire dans la plage et l'arrondir a 2 decimales
    return round(random.uniform(min_val, max_val), 2)


def generer_donnees():
    """
    Genere le fichier CSV avec les donnees de pollution.
    
    Le fichier contiendra une ligne par combinaison :
    - Date × Ville × Polluant
    
    Par exemple, pour 100 jours, 4 villes et 4 polluants :
    - 1 ligne d'en-tete
    - 100 × 4 × 4 = 1600 lignes de donnees
    
    Retourne:
        Path: Chemin vers le fichier genere
    """
    print("=" * 60)
    print("GENERATEUR DE DONNEES DE POLLUTION")
    print("=" * 60)
    print(f"Generation de {NOMBRE_JOURS} jours de donnees...")
    print(f"Villes : {', '.join(VILLES)}")
    print(f"Polluants : {', '.join(POLLUANTS)}")
    
    # Calcul du nombre total de lignes
    # Pour chaque jour, on genere une ligne pour chaque combinaison ville/polluant
    total_lignes = NOMBRE_JOURS * len(VILLES) * len(POLLUANTS)
    print(f"Total de lignes a generer : {total_lignes}")
    print()
    
    # Creer le chemin vers le fichier de sortie
    fichier_sortie = Path(FICHIER_SORTIE)
    
    # Ouvrir le fichier en mode ecriture
    # newline="" est necessaire pour eviter les lignes vides supplementaires sur Windows
    # encoding="utf-8" assure la compatibilite avec tous les caracteres
    with open(fichier_sortie, mode="w", newline="", encoding="utf-8") as file:
        # Creer un objet writer pour ecrire dans le fichier CSV
        writer = csv.writer(file)
        
        # Ecrire l'en-tete du CSV
        # Cette ligne definit les colonnes du fichier
        writer.writerow(["date", "ville", "polluant", "valeur"])
        
        # Generer les donnees
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
                    writer.writerow([date, ville, polluant, valeur])
                    lignes_generees += 1
            
            # Afficher la progression tous les 10 jours
            if (jour + 1) % 10 == 0:
                print(f"  {jour + 1}/{NOMBRE_JOURS} jours generes...")
    
    print()
    print("Generation terminee !")
    print(f"Fichier cree : {fichier_sortie.absolute()}")
    print(f"Lignes generees : {lignes_generees}")
    
    return fichier_sortie


def verifier_fichier(fichier):
    """
    Verifie que le fichier genere est valide.
    
    Cette fonction effectue plusieurs verifications :
    - Le fichier existe
    - L'en-tete est correct
    - Le nombre de lignes est correct
    - Le format des donnees est valide
    
    Arguments:
        fichier (Path): Chemin vers le fichier CSV a verifier
    
    Retourne:
        bool: True si le fichier est valide, False sinon
    """
    print()
    print("Verification du fichier...")
    
    # Verifier que le fichier existe
    if not fichier.exists():
        print(f"ERREUR : Le fichier {fichier} n'existe pas")
        return False
    
    # Lire le fichier et verifier son contenu
    with open(fichier, 'r', encoding='utf-8') as f:
        reader = csv.reader(f)
        lignes = list(reader)
    
    # Verifier l'en-tete
    if lignes[0] != ["date", "ville", "polluant", "valeur"]:
        print(f"ERREUR : En-tete incorrect")
        print(f"  Attendu : ['date', 'ville', 'polluant', 'valeur']")
        print(f"  Trouve : {lignes[0]}")
        return False
    
    # Verifier le nombre de lignes
    nombre_lignes_attendu = NOMBRE_JOURS * len(VILLES) * len(POLLUANTS) + 1  # +1 pour l'en-tete
    if len(lignes) != nombre_lignes_attendu:
        print(f"ATTENTION : Nombre de lignes inattendu")
        print(f"   Attendu : {nombre_lignes_attendu}")
        print(f"   Trouve : {len(lignes)}")
    else:
        print(f"Fichier valide : {len(lignes) - 1} lignes de donnees")
    
    # Afficher un echantillon des premieres lignes
    print()
    print("Echantillon des premieres lignes :")
    for i, ligne in enumerate(lignes[:6]):
        print(f"   {i}: {ligne}")
    
    return True


# ============================================================================
# POINT D'ENTREE
# ============================================================================

if __name__ == "__main__":
    """
    Point d'entree principal du script.
    
    Cette section s'execute uniquement si le script est lance directement,
    et non s'il est importe comme module.
    """
    try:
        # Generation des donnees
        fichier = generer_donnees()
        
        # Verification du fichier genere
        if verifier_fichier(fichier):
            print()
            print("=" * 60)
            print("SUCCES ! Vous pouvez passer a l'etape suivante.")
            print("=" * 60)
        else:
            print()
            print("=" * 60)
            print("ERREUR lors de la verification du fichier")
            print("=" * 60)
            exit(1)
        
    except Exception as e:
        print()
        print("=" * 60)
        print(f"ERREUR lors de la generation : {e}")
        print("=" * 60)
        raise
