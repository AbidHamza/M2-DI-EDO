#!/bin/bash
# Script pour chiffrer toutes les corrections
# Usage: ./encrypt-all.sh [mot-de-passe]
# Si aucun mot de passe n'est fourni, utilise "M2DI-EDO-2025" par défaut

PASSWORD="${1:-M2DI-EDO-2025}"

find . -path "*/corrections/*.md" ! -name "*.encrypted" -type f | while read file; do
    encrypted_file="${file}.encrypted"
    echo "Chiffrement de $file..."
    openssl enc -aes-256-cbc -salt -pbkdf2 \
        -in "$file" \
        -out "$encrypted_file" \
        -pass pass:"$PASSWORD" 2>/dev/null
    if [ $? -eq 0 ]; then
        echo "✓ $encrypted_file créé"
        rm "$file"  # Supprimer le fichier non chiffré
    else
        echo "✗ Erreur lors du chiffrement de $file"
    fi
done

echo "Chiffrement terminé. Mot de passe: $PASSWORD"

