# Projet M2DI-EDO - API REST avec FastAPI et PostgreSQL

## Bienvenue dans votre projet de développement d'API

Ce document est votre guide principal pour réaliser votre projet de Master 2. Vous allez développer une API REST complète en suivant une approche pédagogique progressive, phase par phase.

## Vue d'ensemble du projet

Vous allez créer une **API REST complète pour un système de gestion de bibliothèque** en suivant les meilleures pratiques de développement moderne. Ce projet vous permettra de maîtriser la création d'APIs robustes, sécurisées, testées et documentées.

### Contexte métier

Vous développez une API pour une bibliothèque qui permet de :
- Gérer un catalogue de livres (ajout, modification, suppression, consultation)
- Gérer les utilisateurs et leur authentification
- Gérer les prêts de livres (emprunt, retour, historique)
- Consulter les statistiques et l'historique des prêts

Ce contexte métier vous permet de comprendre comment une API répond à des besoins réels et comment les différentes fonctionnalités s'articulent entre elles.

### Technologies utilisées

**Framework et langage :**
- Python 3.10+ : Langage de programmation
- FastAPI : Framework web moderne et performant pour créer des APIs
- Uvicorn : Serveur ASGI (Asynchronous Server Gateway Interface) pour FastAPI

**Base de données :**
- PostgreSQL : Base de données relationnelle robuste et fiable
- SQLAlchemy : ORM (Object-Relational Mapping) pour interagir avec PostgreSQL
- Alembic : Outil de migration de schéma (optionnel pour ce projet)

**Authentification et sécurité :**
- JWT (JSON Web Tokens) : Standard pour l'authentification stateless
- python-jose : Bibliothèque pour créer et vérifier les tokens JWT
- passlib : Bibliothèque pour le hachage sécurisé des mots de passe
- bcrypt : Algorithme de hachage pour les mots de passe

**Validation et documentation :**
- Pydantic : Validation de données avec typage statique
- OpenAPI/Swagger : Documentation automatique de l'API

**Tests :**
- pytest : Framework de tests pour Python
- httpx : Client HTTP asynchrone pour tester FastAPI

## Objectifs pédagogiques

À la fin de ce projet, vous serez capable de :

### Compétences techniques

1. **Développement d'API REST**
   - Créer une API REST complète avec FastAPI
   - Implémenter les opérations CRUD (Create, Read, Update, Delete)
   - Gérer la pagination et le filtrage
   - Implémenter l'authentification JWT
   - Valider les données avec Pydantic
   - Gérer les erreurs de manière appropriée

2. **Base de données**
   - Utiliser SQLAlchemy pour interagir avec PostgreSQL
   - Créer des modèles de données avec relations
   - Gérer les transactions
   - Comprendre les relations One-to-Many et Many-to-Many

3. **Tests et qualité**
   - Écrire des tests unitaires et d'intégration
   - Utiliser pytest pour automatiser les tests
   - Maintenir une bonne couverture de code

4. **Documentation et déploiement**
   - Documenter une API avec OpenAPI/Swagger
   - Déployer une API en production
   - Configurer les variables d'environnement

### Compétences méthodologiques

- Structurer un projet Python de manière professionnelle
- Suivre une méthodologie de développement par phases
- Utiliser Git pour le versionnement
- Appliquer les bonnes pratiques DevOps
- Documenter son code et son API

## Structure du projet

```
projet-2-api-fastapi-postgresql/
├── README.md                    # Ce fichier - Guide général
├── phases/                      # Guide pédagogique par phase
│   ├── phase-1-setup/           # Configuration initiale
│   ├── phase-2-database/       # Configuration PostgreSQL
│   ├── phase-3-models/          # Modèles SQLAlchemy
│   ├── phase-4-schemas/         # Schémas Pydantic
│   ├── phase-5-authentication/  # Authentification JWT
│   ├── phase-6-books-api/       # API CRUD pour les livres
│   ├── phase-7-loans-api/       # API pour les prêts
│   ├── phase-8-error-handling/  # Gestion des erreurs
│   ├── phase-9-testing/         # Tests unitaires et d'intégration
│   └── phase-10-deployment/     # Documentation et déploiement
├── docs/                        # Documentation et ressources
│   ├── architecture.md          # Architecture de l'application
│   ├── api-endpoints.md         # Documentation des endpoints
│   └── devops-practices.md      # Bonnes pratiques DevOps
├── app/                         # Code source de l'application
│   ├── main.py                  # Point d'entrée de l'application
│   ├── config.py                # Configuration
│   ├── database.py              # Connexion à la base de données
│   ├── models/                  # Modèles SQLAlchemy
│   ├── schemas/                 # Schémas Pydantic
│   ├── routes/                  # Routes API
│   ├── services/                # Logique métier
│   └── middleware/              # Middlewares
└── tests/                       # Tests unitaires et d'intégration
    ├── conftest.py              # Configuration pytest
    ├── test_auth.py             # Tests d'authentification
    ├── test_books.py            # Tests API livres
    └── test_loans.py              # Tests API prêts
```

## Plan des phases - Vue d'ensemble

Le projet est organisé en 10 phases progressives. Chaque phase construit sur la précédente et vous amène progressivement vers une API complète et professionnelle.

### Phase 1 : Configuration initiale de l'environnement
**Durée estimée :** 2-3 heures  
**Objectif :** Mettre en place l'environnement Python, FastAPI et la structure de base  
**Livrable :** Serveur FastAPI fonctionnel avec documentation Swagger accessible  
**Concepts clés :** Environnement virtuel Python, FastAPI, Uvicorn, Variables d'environnement

### Phase 2 : Configuration de PostgreSQL et SQLAlchemy
**Durée estimée :** 2-3 heures  
**Objectif :** Connecter PostgreSQL et configurer SQLAlchemy ORM  
**Livrable :** Connexion à PostgreSQL opérationnelle, session de base de données configurée  
**Concepts clés :** PostgreSQL, SQLAlchemy, Engine, Session, Connection String

### Phase 3 : Modèles de données (SQLAlchemy Models)
**Durée estimée :** 3-4 heures  
**Objectif :** Créer les modèles User, Book et Loan avec leurs relations  
**Livrable :** Modèles SQLAlchemy complets avec relations, tables créées en base  
**Concepts clés :** Modèles SQLAlchemy, Relations, ForeignKey, One-to-Many, Many-to-Many

### Phase 4 : Schémas Pydantic (Validation)
**Durée estimée :** 2-3 heures  
**Objectif :** Créer les schémas de validation avec Pydantic  
**Livrable :** Schémas Pydantic pour toutes les entités avec validations  
**Concepts clés :** Pydantic, Validation, Schémas, Field(), Types optionnels

### Phase 5 : Authentification JWT
**Durée estimée :** 4-5 heures  
**Objectif :** Implémenter l'inscription, la connexion et la protection des routes  
**Livrable :** Système d'authentification JWT complet et fonctionnel  
**Concepts clés :** JWT, bcrypt, Hachage de mot de passe, Dependency Injection

### Phase 6 : API CRUD pour les livres
**Durée estimée :** 4-5 heures  
**Objectif :** Créer les endpoints pour gérer les livres avec pagination et filtrage  
**Livrable :** API complète pour les livres (CRUD + pagination + filtrage)  
**Concepts clés :** CRUD, REST, Pagination, Filtrage, Query Parameters

### Phase 7 : API pour les prêts de livres
**Durée estimée :** 4-5 heures  
**Objectif :** Créer les endpoints pour gérer les prêts avec logique métier  
**Livrable :** API complète pour les prêts avec règles métier implémentées  
**Concepts clés :** Logique métier, Transactions, Relations SQLAlchemy

### Phase 8 : Gestion des erreurs et validation
**Durée estimée :** 2-3 heures  
**Objectif :** Améliorer la gestion des erreurs et les messages de validation  
**Livrable :** Gestion d'erreurs robuste avec messages clairs  
**Concepts clés :** Exception Handling, HTTP Status Codes, Messages d'erreur

### Phase 9 : Tests unitaires et d'intégration
**Durée estimée :** 4-5 heures  
**Objectif :** Écrire des tests pour valider le fonctionnement de l'API  
**Livrable :** Suite de tests complète avec bonne couverture  
**Concepts clés :** pytest, Fixtures, Tests unitaires, Tests d'intégration

### Phase 10 : Documentation et déploiement
**Durée estimée :** 3-4 heures  
**Objectif :** Finaliser la documentation et déployer l'API  
**Livrable :** API déployée en production et documentée  
**Concepts clés :** OpenAPI/Swagger, Déploiement, Variables d'environnement

**Durée totale estimée :** 30-40 heures

## Comment utiliser ce guide

### Méthodologie recommandée

1. **Lisez d'abord ce README** pour comprendre la vision globale du projet
2. **Suivez les phases dans l'ordre** - chaque phase construit sur la précédente
3. **Pour chaque phase :**
   - Lisez attentivement les rappels techniques
   - Réalisez l'exercice pratique (fichier EXERCICE.md dans chaque phase)
   - Suivez les instructions étape par étape
   - Vérifiez les livrables avant de passer à la suivante
4. **Testez régulièrement** votre code avec Swagger UI
5. **Commitez votre travail** après chaque phase réussie

### Conseils pour réussir

- **Prenez votre temps** : Ne précipitez pas les phases, la compréhension est plus importante que la vitesse
- **Testez souvent** : Utilisez Swagger UI pour tester vos endpoints à chaque étape
- **Lisez les erreurs** : Les messages d'erreur Python sont généralement clairs et vous indiquent le problème
- **Documentez** : Notez vos choix et vos difficultés dans un journal de bord
- **Demandez de l'aide** : Si vous êtes bloqué plus de 30 minutes, n'hésitez pas à demander

## Prérequis

Avant de commencer, assurez-vous d'avoir :

### Logiciels installés

- **Python 3.10 ou supérieur** : [python.org](https://www.python.org/downloads/)
- **PostgreSQL** :
  - Option locale : [postgresql.org](https://www.postgresql.org/download/)
  - Option cloud (recommandée) : [ElephantSQL](https://www.elephantsql.com) (gratuit) ou [Supabase](https://supabase.com)
- **Git** : [git-scm.com](https://git-scm.com)
- **Un éditeur de code** : VS Code recommandé avec extensions :
  - Python
  - Pylance
  - SQLTools

### Connaissances préalables

- Bases de Python (variables, fonctions, classes, imports)
- Notions de base de données relationnelles (tables, relations, clés)
- Compréhension des concepts HTTP (GET, POST, PUT, DELETE)
- Utilisation basique de Git

## Concepts clés à maîtriser

### API REST

Une API REST (Representational State Transfer) est un style d'architecture pour créer des services web. Les principes REST incluent :
- Utilisation des méthodes HTTP (GET, POST, PUT, DELETE)
- URLs pour identifier les ressources
- Format JSON pour les données
- Stateless : chaque requête contient toutes les informations nécessaires

### ORM (Object-Relational Mapping)

SQLAlchemy est un ORM qui permet d'interagir avec la base de données en utilisant des objets Python plutôt que du SQL brut. Cela rend le code plus maintenable et portable.

### Authentification JWT

JWT (JSON Web Token) est un standard pour l'authentification stateless. Un token est généré lors de la connexion et contient des informations sur l'utilisateur. Ce token doit être envoyé avec chaque requête pour accéder aux ressources protégées.

### Validation avec Pydantic

Pydantic permet de valider automatiquement les données d'entrée et de sortie. Cela garantit que les données sont correctes avant traitement et évite de nombreuses erreurs.

## Commandes essentielles

### Développement

```bash
# Créer un environnement virtuel
python -m venv venv

# Activer l'environnement virtuel
# Windows
venv\Scripts\activate
# Linux/Mac
source venv/bin/activate

# Installer les dépendances
pip install -r requirements.txt

# Démarrer le serveur de développement
uvicorn app.main:app --reload

# Accéder à la documentation Swagger
# Ouvrir http://localhost:8000/docs dans le navigateur
```

### Tests

```bash
# Exécuter tous les tests
pytest

# Exécuter avec couverture de code
pytest --cov=app

# Exécuter un fichier de test spécifique
pytest tests/test_auth.py

# Exécuter avec output détaillé
pytest -v
```

### Base de données

```bash
# Se connecter à PostgreSQL (si installé localement)
psql -U postgres

# Créer la base de données
CREATE DATABASE library_db;
```

## Bonnes pratiques à suivre

### Sécurité

- Ne jamais commiter les fichiers `.env` contenant des secrets
- Utiliser des secrets forts en production
- Toujours valider les données avec Pydantic
- Hasher les mots de passe (jamais en clair)
- Utiliser HTTPS en production

### Code

- Séparer les responsabilités (routes, services, modèles)
- Utiliser des noms de variables et fonctions clairs
- Commenter le code complexe
- Suivre les conventions PEP 8 (style Python)
- Écrire des docstrings pour les fonctions importantes

### Git

- Commiter régulièrement avec des messages clairs
- Créer des branches pour les fonctionnalités importantes
- Ne jamais commiter les fichiers générés ou sensibles

### Tests

- Écrire des tests pour chaque fonctionnalité
- Maintenir une bonne couverture de code (> 80%)
- Tester les cas d'erreur
- Automatiser les tests (CI/CD)

## Ressources utiles

### Documentation officielle

- [FastAPI Documentation](https://fastapi.tiangolo.com)
- [SQLAlchemy Documentation](https://docs.sqlalchemy.org)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [Pydantic Documentation](https://docs.pydantic.dev)
- [pytest Documentation](https://docs.pytest.org)

### Tutoriels

- [FastAPI Tutorial](https://fastapi.tiangolo.com/tutorial/)
- [SQLAlchemy Tutorial](https://docs.sqlalchemy.org/en/20/tutorial/)
- [PostgreSQL Tutorial](https://www.postgresql.org/docs/current/tutorial.html)

### Outils

- [Postman](https://www.postman.com) : Tester les APIs
- [DBeaver](https://dbeaver.io) : Client PostgreSQL
- [pgAdmin](https://www.pgadmin.org) : Interface PostgreSQL

## Aide et support

### Problèmes courants

**Erreur de connexion PostgreSQL :**
- Vérifiez que PostgreSQL est démarré (si installation locale)
- Vérifiez l'URL de connexion dans `.env`
- Vérifiez les permissions de l'utilisateur
- Vérifiez que le firewall n'bloque pas la connexion

**Erreur d'import :**
- Vérifiez que vous êtes dans le bon environnement virtuel
- Vérifiez que toutes les dépendances sont installées
- Vérifiez les chemins d'import

**Erreur de validation Pydantic :**
- Vérifiez le format des données envoyées
- Consultez les messages d'erreur de Pydantic (très détaillés)
- Vérifiez les schémas dans `app/schemas/`

### Où trouver de l'aide

1. **Documentation** : Consultez d'abord la documentation officielle
2. **Phases** : Relisez la phase concernée, les exercices contiennent souvent la solution
3. **Stack Overflow** : Recherchez des solutions similaires
4. **Enseignant** : N'hésitez pas à demander de l'aide si vous êtes bloqué

## Checklist de démarrage

Avant de commencer la Phase 1, vérifiez que vous avez :

- [ ] Python 3.10+ installé (`python --version`)
- [ ] PostgreSQL installé ou accès à une instance cloud
- [ ] Git installé et configuré
- [ ] Un éditeur de code installé
- [ ] Postman ou un client HTTP installé (pour tester l'API)
- [ ] Lu et compris ce README
- [ ] Créé un dépôt Git pour votre projet

## Prochaines étapes

1. **Créez votre dépôt Git** (si ce n'est pas déjà fait)
2. **Allez dans le dossier `phases/phase-1-setup/`**
3. **Lisez le README de la Phase 1**
4. **Commencez par l'exercice pratique** (fichier EXERCICE.md)
5. **Suivez les instructions étape par étape**

## Conclusion

Ce projet est conçu pour vous accompagner dans l'apprentissage du développement d'API REST. Vous allez acquérir des compétences essentielles qui vous seront utiles dans votre carrière de développeur. Prenez votre temps, testez régulièrement, et n'hésitez pas à expérimenter.

Bon courage pour votre projet !

---

*Note : Ce guide est évolutif. N'hésitez pas à le consulter régulièrement et à prendre des notes sur vos apprentissages.*
