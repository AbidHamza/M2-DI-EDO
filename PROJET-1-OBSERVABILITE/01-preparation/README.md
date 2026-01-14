# Etape 1 : Preparation de l'environnement

## Objectif de cette etape

Installer et configurer Docker pour pouvoir deployer la stack ELK dans les etapes suivantes.

Duree estimee : 15-30 minutes selon votre systeme

## Vue d'ensemble

Dans cette etape, vous allez :
1. Verifier si Docker est deja installe
2. Installer Docker si necessaire
3. Verifier que Docker fonctionne correctement
4. Installer Docker Compose si necessaire
5. Valider l'installation complete

## Prérequis

- Acces administrateur a votre ordinateur
- Connexion Internet
- 4 Go de RAM minimum disponibles

## Instructions

Pour des instructions detaillees pas a pas, consultez :
- [INSTRUCTIONS-PAS-A-PAS.md](INSTRUCTIONS-PAS-A-PAS.md)

Pour un guide d'installation complet, consultez :
- [GUIDE-INSTALLATION.md](GUIDE-INSTALLATION.md)

## Verification

Apres avoir suivi les instructions, verifiez votre installation avec :

```bash
./verify-setup.sh
```

Ou manuellement :

```bash
docker --version
docker-compose --version
docker run hello-world
```

## Problemes courants

Si vous rencontrez des problemes, consultez :
- [PROBLEMES-SOLUTIONS.md](PROBLEMES-SOLUTIONS.md)

## Sortie attendue

Apres cette etape, vous devriez voir :
- Docker version XX.XX.XX
- Docker Compose version XX.XX.XX
- Message "Hello from Docker!" apres avoir execute docker run hello-world

Pour plus de details, consultez :
- [SORTIE-ATTENDUE.md](SORTIE-ATTENDUE.md)

## Prochaine etape

Une fois cette etape validee, passez a :
[Etape 2 : Generation de donnees](../02-generation-donnees/README.md)

