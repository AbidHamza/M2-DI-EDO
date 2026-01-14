#!/bin/bash

# Script de chiffrement des corrections (pour l'enseignant)
# Usage: ./encrypt.sh [mot-de-passe]

set -e

# Couleurs
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}=== Chiffrement des corrections ===${NC}"
echo ""

# Vérifier openssl
if ! command -v openssl &> /dev/null; then
    echo "Erreur: openssl n'est pas installé"
    exit 1
fi

# Obtenir le mot de passe
if [ -z "$1" ]; then
    echo -e "${YELLOW}Entrez le mot de passe de chiffrement:${NC}"
    read -s PASSWORD
    echo ""
    echo -e "${YELLOW}Confirmez le mot de passe:${NC}"
    read -s PASSWORD_CONFIRM
    echo ""
    
    if [ "$PASSWORD" != "$PASSWORD_CONFIRM" ]; then
        echo "Erreur: Les mots de passe ne correspondent pas"
        exit 1
    fi
else
    PASSWORD="$1"
fi

if [ -z "$PASSWORD" ]; then
    echo "Erreur: Mot de passe vide"
    exit 1
fi

# Trouver tous les fichiers de correction non chiffrés
CORRECTION_FILES=$(find . -path "*/corrections/*" -name "*.md" -o -path "*/corrections/*" -name "*.yml" -o -path "*/corrections/*" -name "*.yaml" | grep -v ".encrypted")

if [ -z "$CORRECTION_FILES" ]; then
    echo "Aucun fichier de correction trouvé"
    exit 0
fi

# Compteur
COUNT=0

# Chiffrer chaque fichier
for FILE in $CORRECTION_FILES; do
    ENCRYPTED_FILE="${FILE}.encrypted"
    
    echo -n "Chiffrement de $FILE... "
    
    if openssl enc -aes-256-cbc -salt -pbkdf2 \
        -in "$FILE" \
        -out "$ENCRYPTED_FILE" \
        -pass pass:"$PASSWORD" 2>/dev/null; then
        echo -e "${GREEN}✓${NC}"
        # Supprimer le fichier original (optionnel, commenté pour sécurité)
        # rm "$FILE"
        ((COUNT++))
    else
        echo "✗"
    fi
done

echo ""
echo -e "${GREEN}Succès: $COUNT fichier(s) chiffré(s)${NC}"
echo -e "${YELLOW}Important: Notez le mot de passe dans un endroit sûr !${NC}"

