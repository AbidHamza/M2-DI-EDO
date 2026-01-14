# Guide de Demarrage Complet - GitLab

## Introduction

Ce guide vous accompagne pas a pas pour demarrer avec ce depot sur GitLab. Suivez les etapes dans l'ordre pour garantir votre succes.

## Etape 1 : Creer un compte GitLab

### 1.1 Acceder a GitLab

1. Allez sur https://gitlab.com
2. Cliquez sur "Register" en haut a droite

### 1.2 Creer votre compte

1. Entrez votre nom d'utilisateur
2. Entrez votre email
3. Creez un mot de passe securise
4. Cliquez sur "Register"

### 1.3 Verifier votre email

1. Ouvrez votre boite email
2. Cliquez sur le lien de verification dans l'email de GitLab
3. Votre compte est maintenant active

## Etape 2 : Installer Git

### 2.1 Verifier si Git est installe

Ouvrez un terminal et executez :

```bash
git --version
```

### 2.2 Installer Git si necessaire

Windows :
- Telechargez Git depuis https://git-scm.com/download/win
- Installez-le avec les options par defaut
- Redemarrez votre terminal

Linux :
```bash
sudo apt-get update
sudo apt-get install git
```

macOS :
```bash
brew install git
```

### 2.3 Configurer Git

Configurez Git avec votre nom et email :

```bash
git config --global user.name "Votre Nom"
git config --global user.email "votre.email@example.com"
```

## Etape 3 : Cloner le depot depuis GitLab

### 3.1 Obtenir l'URL du depot

L'URL du depot GitLab devrait etre :
```
https://gitlab.com/AbidHamza/M2-DI-EDO.git
```

### 3.2 Cloner le depot

Ouvrez un terminal et executez :

```bash
cd ~/Desktop
# ou cd ~/Documents selon votre preference

git clone https://gitlab.com/AbidHamza/M2-DI-EDO.git
```

### 3.3 Entrer dans le dossier

```bash
cd M2-DI-EDO
```

## Etape 4 : Verifier les prerequis

### 4.1 Verifier Python

```bash
python --version
# ou
python3 --version
```

Vous devez avoir Python 3.8 ou superieur.

### 4.2 Verifier Docker

```bash
docker --version
```

Si Docker n'est pas installe, consultez :
- [Guide d'installation Docker](PROJET-1-OBSERVABILITE/01-preparation/GUIDE-INSTALLATION.md)

## Etape 5 : Explorer la structure

### 5.1 Lister les fichiers

```bash
ls
# ou sur Windows
dir
```

### 5.2 Lire le README principal

```bash
cat README.md
# ou ouvrez-le avec votre editeur
```

## Etape 6 : Creer votre propre projet sur GitLab (optionnel)

Si vous voulez travailler sur votre propre copie :

### 6.1 Forker le projet

1. Allez sur https://gitlab.com/AbidHamza/M2-DI-EDO
2. Cliquez sur "Fork" en haut a droite
3. Choisissez votre namespace
4. Cliquez sur "Fork project"

### 6.2 Cloner votre fork

```bash
git clone https://gitlab.com/VOTRE-USERNAME/M2-DI-EDO.git
cd M2-DI-EDO
```

## Etape 7 : Choisir un projet

### Projet 1 : Observabilite DevOps

[Commencer le Projet 1](PROJET-1-OBSERVABILITE/README.md)

### Projet 2 : CI/CD DevSecOps

[Commencer le Projet 2](PROJET-2-CICD-DEVSECOPS/README.md)

### Lab0 : Equations differentielles

[Commencer le Lab0](LAB0-EDO/README.md)

## Prochaines etapes

Maintenant que vous avez :
- Un compte GitLab
- Git installe et configure
- Le depot clone
- Les prerequis verifies

Vous pouvez commencer un projet. Choisissez-en un et suivez les instructions pas a pas.

Bon apprentissage !

