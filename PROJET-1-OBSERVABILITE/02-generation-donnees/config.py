"""
Configuration centralisee pour la generation de donnees

Ce fichier contient toutes les constantes de configuration utilisees
par le script de generation de donnees. Modifiez ces valeurs pour
personnaliser les donnees generees.
"""

from datetime import datetime

# Liste des villes pour lesquelles on genere des donnees
# Vous pouvez ajouter ou retirer des villes selon vos besoins
VILLES = [
    "Paris",
    "Lyon",
    "Marseille",
    "Toulouse"
]

# Liste des polluants mesures
# NO2 : Dioxyde d'azote
# O3  : Ozone
# PM10 : Particules fines de moins de 10 micrometres
# SO2 : Dioxyde de soufre
POLLUANTS = [
    "NO2",
    "O3",
    "PM10",
    "SO2"
]

# Date de debut de la periode de donnees
# Format : annee, mois, jour
DATE_DEBUT = datetime(2023, 1, 1)

# Nombre de jours de donnees a generer
# Pour 100 jours, vous aurez environ 3 mois de donnees
NOMBRE_JOURS = 100

# Nom du fichier de sortie
# Ce fichier sera cree dans le repertoire courant
FICHIER_SORTIE = "pollution_data.csv"

# Plages de valeurs realistes pour chaque polluant
# Format : (valeur_minimale, valeur_maximale) en microgrammes par metre cube
PLAGES_POLLUTION = {
    "NO2": (20, 80),   # Dioxyde d'azote - valeurs typiques en ville
    "O3": (30, 120),   # Ozone - peut varier beaucoup selon la saison
    "PM10": (10, 50),  # Particules fines de moins de 10 micrometres
    "SO2": (5, 30)     # Dioxyde de soufre - generalement plus faible
}

