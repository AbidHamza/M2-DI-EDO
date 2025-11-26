# Script PowerShell pour chiffrer toutes les corrections
# Usage: .\encrypt-all.ps1 [mot-de-passe]
# Si aucun mot de passe n'est fourni, utilise "M2DI-EDO-2025" par défaut

param(
    [string]$PASSWORD = "M2DI-EDO-2025"
)

Get-ChildItem -Recurse -Path . -Filter "CORRECTION.md" | Where-Object { 
    $_.FullName -like "*corrections*" -and 
    $_.Name -notlike "*.encrypted" -and
    $_.Name -ne "README.md"
} | ForEach-Object {
    $file = $_.FullName
    $encryptedFile = "$file.encrypted"
    
    Write-Host "Chiffrement de $file..."
    
    $content = Get-Content $file -Raw -Encoding UTF8
    $content | openssl enc -aes-256-cbc -salt -pbkdf2 -out $encryptedFile -pass pass:$PASSWORD
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ $encryptedFile créé" -ForegroundColor Green
        Remove-Item $file
    } else {
        Write-Host "✗ Erreur lors du chiffrement de $file" -ForegroundColor Red
    }
}

Write-Host "Chiffrement terminé. Mot de passe: $PASSWORD" -ForegroundColor Yellow

