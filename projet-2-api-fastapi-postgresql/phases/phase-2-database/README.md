# Phase 2 : Configuration de PostgreSQL et SQLAlchemy

## 🎯 Objectif de la phase

Connecter votre application à PostgreSQL et configurer SQLAlchemy ORM pour interagir avec la base de données.

## 📚 Rappels techniques essentiels

### PostgreSQL
- **PostgreSQL** : Base de données relationnelle open-source
- **ACID** : Propriétés transactionnelles (Atomicité, Cohérence, Isolation, Durabilité)
- **Relations** : Tables liées par des clés étrangères
- **SQL** : Langage de requête structuré

### SQLAlchemy
- **ORM** : Object-Relational Mapping - Mappe les objets Python aux tables SQL
- **Engine** : Point de connexion à la base de données
- **Session** : Contexte de transaction avec la base
- **Base** : Classe de base pour les modèles

### Connection String
- **Format** : `postgresql://user:password@host:port/database`
- **Exemple** : `postgresql://postgres:password@localhost:5432/library_db`
- **Cloud** : Utilisez l'URL fournie par votre service (ElephantSQL, Supabase, etc.)

### Sessions SQLAlchemy
- **SessionLocal** : Factory pour créer des sessions
- **get_db()** : Dependency pour FastAPI
- **Context Manager** : Gestion automatique de la session (with statement)

## 🏋️ Exercice pratique : Connexion PostgreSQL et CRUD

**📖 Consultez le fichier `EXERCICE.md` dans ce dossier pour l'exercice complet avec correction détaillée.**

**Résumé de l'exercice :**
Créez un script Python qui :
- Se connecte à PostgreSQL avec SQLAlchemy
- Crée une table `products`
- Implémente toutes les opérations CRUD (Create, Read, Update, Delete)
- Gère les sessions et les erreurs

**L'exercice complet avec :**
- ✅ Code complet avec toutes les opérations CRUD
- ✅ Explications détaillées de chaque concept
- ✅ Gestion des erreurs avec try/except
- ✅ Guide de test complet
- ✅ Points clés à retenir

**Fichier :** `phases/phase-2-database/EXERCICE.md`

## 📋 Tâches du projet

### Étape 1 : Installer PostgreSQL (si pas déjà fait)

**Option 1 : Installation locale**
1. Téléchargez PostgreSQL depuis [postgresql.org](https://www.postgresql.org/download/)
2. Installez-le avec les paramètres par défaut
3. Notez le mot de passe du superutilisateur `postgres`

**Option 2 : Service cloud (recommandé pour débuter)**
1. Créez un compte sur [ElephantSQL](https://www.elephantsql.com) (gratuit)
2. Créez une nouvelle instance
3. Récupérez l'URL de connexion (format : `postgresql://user:pass@host:port/dbname`)

### Étape 2 : Créer la base de données

**Si PostgreSQL local :**
```sql
-- Se connecter à PostgreSQL
psql -U postgres

-- Créer la base de données
CREATE DATABASE library_db;

-- Créer un utilisateur (optionnel)
CREATE USER library_user WITH PASSWORD 'your_password';
GRANT ALL PRIVILEGES ON DATABASE library_db TO library_user;
```

**Si service cloud :**
- La base de données est déjà créée, utilisez l'URL fournie

### Étape 3 : Créer le fichier database.py

Créez `app/database.py` :

**À faire :**
1. Importez `create_engine`, `sessionmaker`, `declarative_base` de SQLAlchemy
2. Importez `settings` depuis `app.config`
3. Créez l'engine avec `create_engine(settings.DATABASE_URL)`
4. Créez `SessionLocal` avec `sessionmaker(autocommit=False, autoflush=False, bind=engine)`
5. Créez `Base = declarative_base()` pour les modèles
6. Créez une fonction `get_db()` qui est un générateur (yield) pour FastAPI

**Structure attendue :**
```python
from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from app.config import settings

# Créer l'engine
engine = create_engine(
    settings.DATABASE_URL,
    pool_pre_ping=True,  # Vérifie la connexion avant utilisation
    echo=settings.DEBUG   # Affiche les requêtes SQL en mode debug
)

# Créer la session factory
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

# Base pour les modèles
Base = declarative_base()

# Dependency pour FastAPI
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
```

### Étape 4 : Mettre à jour config.py

Dans `app/config.py`, assurez-vous que `DATABASE_URL` est bien défini :

**Format attendu :**
```
DATABASE_URL=postgresql://user:password@localhost:5432/library_db
```

**Pour un service cloud :**
- Utilisez l'URL complète fournie par le service

### Étape 5 : Mettre à jour .env

Dans votre fichier `.env`, mettez à jour `DATABASE_URL` avec vos informations :

```
DATABASE_URL=postgresql://postgres:your_password@localhost:5432/library_db
```

**⚠️ Important :** Remplacez `your_password` par votre vrai mot de passe

### Étape 6 : Tester la connexion

Créez un script de test `test_db_connection.py` à la racine :

```python
from app.database import engine
from sqlalchemy import text

def test_connection():
    try:
        with engine.connect() as connection:
            result = connection.execute(text("SELECT 1"))
            print("✅ Connexion PostgreSQL réussie !")
            print(f"Résultat: {result.fetchone()}")
    except Exception as e:
        print(f"❌ Erreur de connexion: {e}")

if __name__ == "__main__":
    test_connection()
```

Exécutez :
```bash
python test_db_connection.py
```

### Étape 7 : Créer les tables (temporaire)

Dans `app/main.py`, ajoutez temporairement pour créer les tables :

```python
from app.database import Base, engine

# Créer les tables (temporaire, sera remplacé par Alembic plus tard)
Base.metadata.create_all(bind=engine)
```

**Note :** Cette approche est pour le développement. En production, utilisez Alembic pour les migrations.

## ✅ Livrable de la phase

À la fin de cette phase, vous devez avoir :

- [ ] PostgreSQL installé ou accès à une instance cloud
- [ ] Base de données `library_db` créée
- [ ] `app/database.py` avec engine, SessionLocal, Base et get_db()
- [ ] `DATABASE_URL` configuré dans `.env`
- [ ] La connexion à PostgreSQL fonctionne
- [ ] Vous pouvez exécuter des requêtes SQL simples

## 🧪 Vérification

Testez votre configuration :

1. **Test de connexion :**
   ```bash
   python test_db_connection.py
   ```
   Devrait afficher : `✅ Connexion PostgreSQL réussie !`

2. **Vérifier dans PostgreSQL :**
   ```sql
   -- Se connecter
   psql -U postgres -d library_db
   
   -- Lister les tables (devrait être vide pour l'instant)
   \dt
   ```

3. **Démarrer le serveur :**
   ```bash
   uvicorn app.main:app --reload
   ```
   Devrait démarrer sans erreur de connexion

## 🐛 Problèmes courants

- **Erreur de connexion** : 
  - Vérifiez que PostgreSQL est démarré
  - Vérifiez l'URL de connexion dans `.env`
  - Vérifiez le mot de passe

- **Module psycopg2 non trouvé** :
  ```bash
  pip install psycopg2-binary
  ```

- **Erreur "database does not exist"** :
  - Créez la base de données avec `CREATE DATABASE library_db;`

- **Erreur d'authentification** :
  - Vérifiez le nom d'utilisateur et le mot de passe
  - Pour PostgreSQL local, vérifiez `pg_hba.conf`

## 📝 Notes importantes

- **Pool de connexions** : SQLAlchemy gère automatiquement un pool de connexions
- **Sessions** : Toujours fermer les sessions après utilisation
- **Transactions** : Les sessions gèrent automatiquement les transactions
- **Cloud vs Local** : Les services cloud sont plus faciles pour débuter

## 🔒 Sécurité

- ❌ Ne commitez jamais les mots de passe dans le code
- ✅ Utilisez des variables d'environnement
- ✅ Utilisez des mots de passe forts en production
- ✅ Limitez les accès à la base de données

## ➡️ Prochaine phase

Une fois cette phase terminée et vérifiée, passez à la **Phase 3 : Modèles de données (SQLAlchemy Models)**.

**Commitez votre travail :**
```bash
git add .
git commit -m "Phase 2: Configuration PostgreSQL et SQLAlchemy"
```

