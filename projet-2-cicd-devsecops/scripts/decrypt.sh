#!/bin/bash

# Script de déchiffrement des corrections
# Usage: ./decrypt.sh

set -e

# Couleurs pour les messages
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== Déchiffrement des corrections ===${NC}"
echo ""

# Vérifier que openssl est installé
if ! command -v openssl &> /dev/null; then
    echo -e "${RED}Erreur: openssl n'est pas installé${NC}"
    echo "Installez openssl pour continuer."
    exit 1
fi

# Demander le mot de passe
echo -e "${YELLOW}Entrez le mot de passe de déchiffrement:${NC}"
read -s PASSWORD
echo ""

if [ -z "$PASSWORD" ]; then
    echo -e "${RED}Erreur: Mot de passe vide${NC}"
    exit 1
fi

# Trouver tous les fichiers chiffrés
ENCRYPTED_FILES=$(find . -name "*.encrypted" -type f)

if [ -z "$ENCRYPTED_FILES" ]; then
    echo -e "${YELLOW}Aucun fichier chiffré trouvé${NC}"
    exit 0
fi

# Compteur de fichiers déchiffrés
COUNT=0
FAILED=0

# Déchiffrer chaque fichier
for ENCRYPTED_FILE in $ENCRYPTED_FILES; do
    # Nom du fichier de sortie (sans .encrypted)
    OUTPUT_FILE="${ENCRYPTED_FILE%.encrypted}"
    
    echo -n "Déchiffrement de $ENCRYPTED_FILE... "
    
    # Déchiffrer
    if openssl enc -d -aes-256-cbc -salt -pbkdf2 \
        -in "$ENCRYPTED_FILE" \
        -out "$OUTPUT_FILE" \
        -pass pass:"$PASSWORD" 2>/dev/null; then
        echo -e "${GREEN}✓${NC}"
        ((COUNT++))
    else
        echo -e "${RED}✗${NC}"
        ((FAILED++))
        # Supprimer le fichier partiellement créé
        rm -f "$OUTPUT_FILE"
    fi
done

echo ""
if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}Succès: $COUNT fichier(s) déchiffré(s)${NC}"
else
    echo -e "${RED}Erreur: $FAILED fichier(s) n'ont pas pu être déchiffré(s)${NC}"
    echo -e "${YELLOW}Vérifiez que le mot de passe est correct${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}Les corrections sont maintenant disponibles dans les dossiers corrections/ de chaque phase${NC}"

