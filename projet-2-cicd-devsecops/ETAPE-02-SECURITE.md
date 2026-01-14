# Etape 02 : Integration des outils de securite

## Objectif

Integrer des outils de scan de securite dans le pipeline CI/CD pour detecter les vulnerabilites automatiquement. Cette etape couvre Bandit (code Python), Trivy (vulnerabilites Docker), et SonarQube (analyse de qualite de code).

## Duree estimee

45 minutes-1h (avec GitLab)
1h-1h30 (en local avec SonarQube)

## Prérequis

- Python 3.8+ installe
- Docker installe (pour Trivy et SonarQube)
- Compte GitLab avec projet cree (pour la partie GitLab)
- Compréhension de base des concepts de securite

## Deux approches possibles

Cette etape propose deux approches :
1. **Avec GitLab CI/CD** : Utilise les fonctionnalites integrees de GitLab
2. **En local** : Tout fonctionne sur votre ordinateur (confidentialite garantie)

Vous pouvez choisir l'approche qui vous convient le mieux.

---

## PARTIE A : Avec GitLab CI/CD

### Etape 2.1 : Comprendre les outils de securite

**Bandit** : Scanner de securite specifique au code Python. Detecte les problemes de securite courants comme l'utilisation de fonctions dangereuses, les mots de passe en dur, etc.

**Trivy** : Scanner de vulnerabilites pour les images Docker et les systemes de fichiers. Detecte les vulnerabilites connues dans les dependances et les images de base.

**SonarQube** : Plateforme d'analyse de qualite de code. Analyse la qualite du code, detecte les bugs, les vulnerabilites, et les code smells.

### Etape 2.2 : Ajouter le stage de securite dans GitLab CI/CD

Modifiez votre fichier `.gitlab-ci.yml` pour ajouter un stage de securite :

```yaml
image: python:3.10

stages:
  - build
  - security
  - test

build-application:
  stage: build
  script:
    - echo "Installation des dependances"
    - pip install -r requirements.txt
    - echo "Build termine avec succes"
  only:
    - main
    - develop

# Scan de securite avec Bandit (code Python)
security-bandit:
  stage: security
  script:
    - echo "Installation de Bandit"
    - pip install bandit
    - echo "Scan du code Python avec Bandit"
    - bandit -r . -f json -o bandit-report.json || true
    - cat bandit-report.json
  artifacts:
    reports:
      sast: bandit-report.json
    paths:
      - bandit-report.json
    expire_in: 1 week
  only:
    - merge_requests
    - main

# Scan de vulnerabilites avec Trivy (images Docker)
security-trivy:
  stage: security
  image: aquasec/trivy:latest
  script:
    - echo "Scan des vulnerabilites avec Trivy"
    - trivy fs --exit-code 0 --severity HIGH,CRITICAL --format json -o trivy-report.json . || true
    - cat trivy-report.json
  artifacts:
    reports:
      container_scanning: trivy-report.json
    paths:
      - trivy-report.json
    expire_in: 1 week
  only:
    - merge_requests
    - main
  allow_failure: true

# Analyse de qualite avec SonarQube
security-sonarqube:
  stage: security
  image: sonarsource/sonar-scanner-cli:latest
  variables:
    SONAR_USER_HOME: "${CI_PROJECT_DIR}/.sonar"
    GIT_DEPTH: "0"
  cache:
    key: "${CI_JOB_NAME}"
    paths:
      - .sonar/cache
  script:
    - echo "Analyse de qualite avec SonarQube"
    - sonar-scanner
      -Dsonar.projectKey=${CI_PROJECT_PATH_SLUG}
      -Dsonar.sources=.
      -Dsonar.host.url=${SONARQUBE_URL}
      -Dsonar.login=${SONARQUBE_TOKEN}
      -Dsonar.python.version=3.10
  allow_failure: true
  only:
    - merge_requests
    - main

test-application:
  stage: test
  script:
    - echo "Execution des tests"
    - pip install -r requirements.txt
    - pip install pytest
    - python -m pytest tests/ || echo "Aucun test trouve"
  only:
    - merge_requests
    - main
```

**Explication de chaque section** :

**security-bandit** :
- Installe Bandit avec pip
- Execute un scan recursif (`-r .`) de tous les fichiers Python
- Genere un rapport JSON (`-f json -o bandit-report.json`)
- Le rapport est sauvegarde comme artefact GitLab

**security-trivy** :
- Utilise l'image Docker officielle de Trivy
- Scanne le systeme de fichiers (`trivy fs`)
- Filtre seulement les vulnerabilites HIGH et CRITICAL
- Genere un rapport JSON

**security-sonarqube** :
- Utilise le scanner SonarQube officiel
- Configure le projet avec des variables d'environnement
- Envoie les resultats a votre instance SonarQube
- Necessite SONARQUBE_URL et SONARQUBE_TOKEN configures

### Etape 2.3 : Configurer SonarQube dans GitLab

**Etape 2.3.1 : Creer un projet SonarQube**

1. Allez sur votre instance SonarQube (ou creez-en une sur sonarcloud.io gratuitement)
2. Creer un nouveau projet
3. Copiez le "Project Key" et le "Token"

**Etape 2.3.2 : Ajouter les variables dans GitLab**

1. Allez sur votre projet GitLab
2. Settings → CI/CD → Variables
3. Ajoutez deux variables :
   - Key : `SONARQUBE_URL`
     Value : L'URL de votre instance SonarQube (ex: https://sonarcloud.io)
     Cochez "Mask variable"
   - Key : `SONARQUBE_TOKEN`
     Value : Votre token SonarQube
     Cochez "Mask variable" et "Protect variable"
4. Sauvegardez

### Etape 2.4 : Pousser les modifications

```bash
git add .gitlab-ci.yml
git commit -m "Ajout des scans de securite au pipeline (Bandit, Trivy, SonarQube)"
git push origin main
```

### Etape 2.5 : Verifier les scans dans GitLab

1. Allez sur votre projet GitLab
2. Cliquez sur "CI/CD" → "Pipelines"
3. Cliquez sur votre pipeline en cours d'execution
4. Verifiez que les jobs de securite s'executent :
   - security-bandit
   - security-trivy
   - security-sonarqube
5. Attendez que tous les jobs se terminent

### Etape 2.6 : Consulter les rapports de securite

**Dans GitLab** :
1. Allez sur "Security" → "Vulnerability Report"
2. Vous devriez voir les vulnerabilites detectees par Bandit et Trivy
3. Analysez les resultats et corrigez les problemes critiques

**Dans SonarQube** :
1. Allez sur votre instance SonarQube
2. Ouvrez votre projet
3. Consultez le dashboard avec :
   - Les vulnerabilites detectees
   - La qualite du code (code smells, bugs)
   - La couverture de code (si vous avez des tests)
   - Les metriques de maintenabilite

---

## PARTIE B : En local (confidentialite garantie)

Cette partie permet de faire tous les scans en local sur votre ordinateur, sans envoyer de donnees sur Internet.

### Etape 2.7 : Installer Bandit localement

**Action** : Installer Bandit sur votre ordinateur

**Commande** :
```bash
pip install bandit
```

**Verification** :
```bash
bandit --version
```

**Resultat attendu** :
```
bandit 1.7.5
```

### Etape 2.8 : Executer Bandit localement

**Action** : Scanner votre code Python avec Bandit

**Commande** :
```bash
bandit -r . -f json -o bandit-report.json
```

**Explication de la commande** :
- `-r .` : Scan recursif du repertoire courant
- `-f json` : Format de sortie JSON
- `-o bandit-report.json` : Fichier de sortie

**Resultat attendu** :
```
[main]  INFO    Using config: /path/to/bandit/config
[main]  INFO    Running on Python 3.10.0
Run started:2024-01-15 10:30:45.123456

Test results:
>> Issue: [B101:assert_used] Use of assert detected.
   Severity: Low   Confidence: High
   Location: tests/test_app.py:15
   More Info: https://bandit.readthedocs.io/en/latest/plugins/b101_assert_used.html
...

Files skipped (0):
```

**Consulter le rapport** :
```bash
cat bandit-report.json
```

### Etape 2.9 : Installer et executer Trivy localement

**Action** : Installer Trivy sur votre ordinateur

**Windows (avec Chocolatey)** :
```powershell
choco install trivy
```

**Linux** :
```bash
sudo apt-get install wget apt-transport-https gnupg lsb-release
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo apt-key add -
echo "deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main" | sudo tee -a /etc/apt/sources.list.d/trivy.list
sudo apt-get update
sudo apt-get install trivy
```

**macOS (avec Homebrew)** :
```bash
brew install trivy
```

**Verification** :
```bash
trivy --version
```

### Etape 2.10 : Scanner avec Trivy localement

**Action** : Scanner votre projet avec Trivy

**Commande** :
```bash
trivy fs --exit-code 0 --severity HIGH,CRITICAL --format json -o trivy-report.json .
```

**Explication** :
- `fs` : Scan du systeme de fichiers
- `--exit-code 0` : Ne pas echouer meme si des vulnerabilites sont trouvees
- `--severity HIGH,CRITICAL` : Filtrer seulement les severites elevees
- `--format json` : Format JSON
- `-o trivy-report.json` : Fichier de sortie

**Resultat attendu** :
```json
{
  "Results": [
    {
      "Target": "requirements.txt",
      "Class": "lang-pkgs",
      "Type": "python",
      "Vulnerabilities": [...]
    }
  ]
}
```

### Etape 2.11 : Installer SonarQube localement avec Docker

**Action** : Deployer SonarQube sur votre ordinateur avec Docker

**Etape 2.11.1 : Creer un fichier docker-compose.yml pour SonarQube**

Creez un fichier `docker-compose-sonarqube.yml` :

```yaml
version: '3.8'

services:
  sonarqube:
    image: sonarqube:community
    container_name: sonarqube
    ports:
      - "9000:9000"
    environment:
      - SONAR_ES_BOOTSTRAP_CHECKS_DISABLE=true
    volumes:
      - sonarqube_data:/opt/sonarqube/data
      - sonarqube_extensions:/opt/sonarqube/extensions
      - sonarqube_logs:/opt/sonarqube/logs
    networks:
      - sonar

networks:
  sonar:
    driver: bridge

volumes:
  sonarqube_data:
  sonarqube_extensions:
  sonarqube_logs:
```

**Etape 2.11.2 : Demarrer SonarQube**

```bash
docker-compose -f docker-compose-sonarqube.yml up -d
```

**Attendre 1-2 minutes** que SonarQube demarre completement.

**Etape 2.11.3 : Acceder a SonarQube**

1. Ouvrez votre navigateur
2. Allez sur http://localhost:9000
3. Connectez-vous avec :
   - Username : admin
   - Password : admin
4. Changez le mot de passe a la premiere connexion

### Etape 2.12 : Configurer un projet dans SonarQube local

**Etape 2.12.1 : Creer un nouveau projet**

1. Dans SonarQube, cliquez sur "Create Project"
2. Selectionnez "Manually"
3. Donnez un nom a votre projet (ex: "mon-projet-devsecops")
4. Donnez une clé de projet (ex: "mon-projet-devsecops")
5. Cliquez sur "Set Up"

**Etape 2.12.2 : Generer un token**

1. Cliquez sur "Generate a token"
2. Donnez un nom au token (ex: "token-local")
3. Cliquez sur "Generate"
4. **IMPORTANT** : Copiez le token immediatement (il ne sera plus visible)

### Etape 2.13 : Installer le scanner SonarQube localement

**Action** : Installer le scanner SonarQube sur votre ordinateur

**Windows** :
1. Telechargez depuis https://docs.sonarqube.org/latest/analysis/scan/sonarscanner/
2. Extrayez l'archive
3. Ajoutez le dossier bin au PATH

**Linux/Mac** :
```bash
# Telecharger et installer
wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-5.0.1.3006-linux.zip
unzip sonar-scanner-cli-*.zip
sudo mv sonar-scanner-* /opt/sonar-scanner
sudo ln -s /opt/sonar-scanner/bin/sonar-scanner /usr/local/bin/sonar-scanner
```

**Verification** :
```bash
sonar-scanner --version
```

### Etape 2.14 : Creer un fichier de configuration SonarQube

**Action** : Creer le fichier sonar-project.properties

Creez un fichier `sonar-project.properties` a la racine de votre projet :

```properties
sonar.projectKey=mon-projet-devsecops
sonar.projectName=Mon Projet DevSecOps
sonar.projectVersion=1.0
sonar.sources=.
sonar.sourceEncoding=UTF-8
sonar.python.version=3.10
sonar.exclusions=**/tests/**,**/venv/**,**/env/**
```

**Explication** :
- `sonar.projectKey` : Clé du projet dans SonarQube
- `sonar.sources` : Repertoire source a analyser
- `sonar.exclusions` : Fichiers/dossiers a exclure

### Etape 2.15 : Executer l'analyse SonarQube localement

**Action** : Lancer l'analyse avec le scanner SonarQube

**Commande** :
```bash
sonar-scanner \
  -Dsonar.host.url=http://localhost:9000 \
  -Dsonar.login=VOTRE_TOKEN_ICI
```

**Remplacez VOTRE_TOKEN_ICI** par le token genere a l'etape 2.12.2.

**Resultat attendu** :
```
INFO: Scanner configuration file: /opt/sonar-scanner/conf/sonar-scanner.properties
INFO: Project root configuration file: sonar-project.properties
INFO: SonarScanner 5.0.1.3006
INFO: Java 11.0.19
INFO: User cache: /home/user/.sonar/cache
INFO: Analyzing on SonarQube server 10.0.0.68432
INFO: Default locale: "en_US", source code encoding: "UTF-8"
INFO: Load project settings
INFO: Load project settings (done) | time=123ms
INFO: Load quality profiles
...
INFO: ANALYSIS SUCCESSFUL
INFO: You can browse http://localhost:9000/dashboard?id=mon-projet-devsecops
```

### Etape 2.16 : Consulter les resultats dans SonarQube

**Action** : Voir les resultats de l'analyse

1. Ouvrez votre navigateur
2. Allez sur http://localhost:9000
3. Cliquez sur votre projet
4. Consultez le dashboard avec :
   - Les vulnerabilites detectees
   - Les bugs trouves
   - Les code smells
   - La couverture de code
   - Les metriques de qualite

### Etape 2.17 : Creer un script de scan local complet

**Action** : Creer un script qui execute tous les scans localement

Creez un fichier `scan-security.sh` (Linux/Mac) ou `scan-security.bat` (Windows) :

**Pour Linux/Mac (scan-security.sh)** :
```bash
#!/bin/bash
# Script de scan de securite local complet

set -e

echo "============================================================"
echo "SCAN DE SECURITE LOCAL"
echo "============================================================"
echo "Tous les scans s'executent sur votre ordinateur"
echo "Aucune donnee n'est envoyee sur Internet"
echo ""

# Scan Bandit
echo "SCAN 1 : BANDIT (Code Python)"
echo "-----------------------------"
if command -v bandit &> /dev/null; then
    bandit -r . -f json -o bandit-report.json
    echo "Rapport Bandit genere : bandit-report.json"
else
    echo "ATTENTION : Bandit n'est pas installe"
    echo "Installez-le avec : pip install bandit"
fi
echo ""

# Scan Trivy
echo "SCAN 2 : TRIVY (Vulnerabilites)"
echo "--------------------------------"
if command -v trivy &> /dev/null; then
    trivy fs --exit-code 0 --severity HIGH,CRITICAL --format json -o trivy-report.json .
    echo "Rapport Trivy genere : trivy-report.json"
else
    echo "ATTENTION : Trivy n'est pas installe"
fi
echo ""

# Scan SonarQube
echo "SCAN 3 : SONARQUBE (Qualite de code)"
echo "-------------------------------------"
if command -v sonar-scanner &> /dev/null; then
    if [ -z "$SONAR_TOKEN" ]; then
        echo "ATTENTION : Variable SONAR_TOKEN non definie"
        echo "Exportez-la avec : export SONAR_TOKEN=votre_token"
    else
        sonar-scanner \
          -Dsonar.host.url=http://localhost:9000 \
          -Dsonar.login=$SONAR_TOKEN
        echo "Analyse SonarQube terminee"
        echo "Consultez les resultats sur http://localhost:9000"
    fi
else
    echo "ATTENTION : SonarQube Scanner n'est pas installe"
fi
echo ""

echo "============================================================"
echo "SCANS TERMINES"
echo "============================================================"
echo "Rapports generes :"
echo "  - bandit-report.json"
echo "  - trivy-report.json"
echo "  - Resultats SonarQube sur http://localhost:9000"
```

**Pour Windows (scan-security.bat)** :
```batch
@echo off
echo ============================================================
echo SCAN DE SECURITE LOCAL
echo ============================================================
echo Tous les scans s'executent sur votre ordinateur
echo Aucune donnee n'est envoyee sur Internet
echo.

REM Scan Bandit
echo SCAN 1 : BANDIT (Code Python)
echo -----------------------------
bandit --version >nul 2>&1
if errorlevel 1 (
    echo ATTENTION : Bandit n'est pas installe
    echo Installez-le avec : pip install bandit
) else (
    bandit -r . -f json -o bandit-report.json
    echo Rapport Bandit genere : bandit-report.json
)
echo.

REM Scan Trivy
echo SCAN 2 : TRIVY (Vulnerabilites)
echo --------------------------------
trivy --version >nul 2>&1
if errorlevel 1 (
    echo ATTENTION : Trivy n'est pas installe
) else (
    trivy fs --exit-code 0 --severity HIGH,CRITICAL --format json -o trivy-report.json .
    echo Rapport Trivy genere : trivy-report.json
)
echo.

REM Scan SonarQube
echo SCAN 3 : SONARQUBE (Qualite de code)
echo -------------------------------------
sonar-scanner --version >nul 2>&1
if errorlevel 1 (
    echo ATTENTION : SonarQube Scanner n'est pas installe
) else (
    if "%SONAR_TOKEN%"=="" (
        echo ATTENTION : Variable SONAR_TOKEN non definie
        echo Definissez-la avec : set SONAR_TOKEN=votre_token
    ) else (
        sonar-scanner -Dsonar.host.url=http://localhost:9000 -Dsonar.login=%SONAR_TOKEN%
        echo Analyse SonarQube terminee
        echo Consultez les resultats sur http://localhost:9000
    )
)
echo.

echo ============================================================
echo SCANS TERMINES
echo ============================================================
```

**Rendre executable (Linux/Mac)** :
```bash
chmod +x scan-security.sh
```

**Executer** :
```bash
# Linux/Mac
./scan-security.sh

# Windows
scan-security.bat
```

---

## Verification

Avant de passer a l'etape suivante, verifiez que :

**Avec GitLab** :
- [ ] Le stage "security" est ajoute au pipeline
- [ ] Les scans Bandit, Trivy et SonarQube s'executent
- [ ] Les rapports sont generes et accessibles dans GitLab
- [ ] Les vulnerabilites sont visibles dans GitLab Security
- [ ] Les resultats SonarQube sont visibles dans votre instance SonarQube

**En local** :
- [ ] Bandit est installe et fonctionne
- [ ] Trivy est installe et fonctionne
- [ ] SonarQube est deploye et accessible sur http://localhost:9000
- [ ] Le scanner SonarQube est installe
- [ ] Les rapports bandit-report.json et trivy-report.json sont generes
- [ ] Les resultats SonarQube sont visibles dans le dashboard

## Problemes courants

### Bandit ne trouve pas de fichiers

**Solution** : Verifiez que vous avez des fichiers Python dans votre projet. Bandit ne scanne que les fichiers .py

### Trivy echoue

**Solution** : C'est normal si vous n'avez pas de Dockerfile ou de requirements.txt. Le scan peut echouer mais cela n'empeche pas le pipeline de continuer avec `allow_failure: true`

### SonarQube ne demarre pas

**Solution** :
- Verifiez que Docker fonctionne : `docker ps`
- Consultez les logs : `docker-compose -f docker-compose-sonarqube.yml logs`
- Verifiez que le port 9000 n'est pas deja utilise
- Augmentez la memoire allouee a Docker (minimum 4 Go recommande)

### Erreur "SONAR_TOKEN not found"

**Solution** :
- Verifiez que vous avez genere un token dans SonarQube
- Exportez la variable d'environnement :
  - Linux/Mac : `export SONAR_TOKEN=votre_token`
  - Windows : `set SONAR_TOKEN=votre_token`

### Les rapports ne s'affichent pas dans GitLab

**Solution** :
- Attendez quelques minutes et actualisez la page
- Verifiez que le format des rapports est correct (JSON)
- Verifiez que les artefacts sont bien configures dans .gitlab-ci.yml

### SonarQube Scanner ne trouve pas le projet

**Solution** :
- Verifiez que le fichier sonar-project.properties existe
- Verifiez que sonar.projectKey correspond a la clé dans SonarQube
- Verifiez que SONAR_TOKEN est correct

## Commandes utiles

**Bandit** :
```bash
# Scan simple
bandit -r .

# Scan avec rapport HTML
bandit -r . -f html -o bandit-report.html

# Scan avec niveau de severite minimum
bandit -r . -ll  # Low et Low+
```

**Trivy** :
```bash
# Scan d'une image Docker
trivy image python:3.10

# Scan avec rapport HTML
trivy fs --format template --template "@contrib/html.tpl" -o trivy-report.html .
```

**SonarQube** :
```bash
# Verifier la configuration
sonar-scanner -Dsonar.host.url=http://localhost:9000 -Dsonar.login=TOKEN -X

# Arreter SonarQube
docker-compose -f docker-compose-sonarqube.yml down

# Voir les logs SonarQube
docker-compose -f docker-compose-sonarqube.yml logs -f
```

## Notes importantes

- Les scans de securite sont essentiels pour detecter les vulnerabilites tot
- Bandit est specifique au code Python
- Trivy scanne les dependances et les images Docker
- SonarQube fournit une analyse complete de la qualite du code
- En local, tout reste sur votre ordinateur (confidentialite garantie)
- Avec GitLab, les rapports sont integres dans l'interface GitLab

## Prochaine etape

Une fois cette etape validee, passez a :
[Etape 03 : Container Registry](ETAPE-03-CONTAINER-REGISTRY.md)
