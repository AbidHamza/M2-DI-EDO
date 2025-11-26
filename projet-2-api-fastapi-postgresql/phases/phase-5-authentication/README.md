# Phase 5 : Authentification JWT

## 🎯 Objectif de la phase

Implémenter un système d'authentification complet avec JWT : inscription, connexion et protection des routes.

## 📚 Rappels techniques essentiels

### JWT (JSON Web Token)
- **Structure** : `header.payload.signature`
- **Stateless** : Pas de session côté serveur
- **Payload** : Contient les données (userId, exp)
- **Signature** : Vérifie l'intégrité du token

### bcrypt
- **Hachage** : Transformation irréversible
- **Salt** : Ajoute de l'aléatoire (10 rounds recommandé)
- **Jamais en clair** : Ne stockez jamais les mots de passe en clair

### Dependency Injection (FastAPI)
- **Depends()** : Injection de dépendances
- **Reutilisable** : Fonction utilisable dans plusieurs routes
- **get_current_user** : Récupère l'utilisateur depuis le token

## 🏋️ Exercice pratique : Authentification JWT

**📖 Consultez le fichier `EXERCICE.md` dans ce dossier pour l'exercice complet avec correction détaillée.**

**Résumé de l'exercice :**
Implémentez un système d'authentification complet :
- Hachage de mot de passe avec bcrypt
- Génération et vérification de JWT
- Service d'authentification
- Middleware de protection
- Routes d'inscription et connexion

**Fichier :** `phases/phase-5-authentication/EXERCICE.md`

## 📋 Tâches du projet

### Étape 1 : Créer le service d'authentification

Créez `app/services/auth.py` :

**Fonctions à créer :**

1. **hash_password(password: str) -> str** :
   - Utilise bcrypt avec 10 rounds
   - Retourne le hash

2. **verify_password(plain_password: str, hashed_password: str) -> bool** :
   - Compare le mot de passe en clair avec le hash
   - Retourne True si correspond

3. **create_access_token(data: dict, expires_delta: timedelta = None) -> str** :
   - Crée un JWT avec les données
   - Ajoute l'expiration
   - Signe avec SECRET_KEY

4. **verify_token(token: str) -> dict** :
   - Vérifie et décode le JWT
   - Retourne le payload ou None si invalide

### Étape 2 : Créer le middleware d'authentification

Créez `app/middleware/auth.py` :

**Fonction get_current_user :**
1. Récupère le token depuis `Authorization: Bearer TOKEN`
2. Vérifie le token avec `verify_token()`
3. Extrait `userId` du payload
4. Récupère l'utilisateur depuis la base
5. Retourne l'utilisateur ou lève une exception 401

**À faire :**
- Utilisez `HTTPBearer` de FastAPI
- Utilisez `Depends()` pour l'injection
- Gérez les erreurs (token manquant, invalide, utilisateur non trouvé)

### Étape 3 : Créer les routes d'authentification

Créez `app/routes/auth.py` :

**Endpoints à créer :**

1. **POST /auth/register** :
   - Reçoit UserCreate
   - Vérifie si l'utilisateur existe
   - Hash le mot de passe
   - Crée l'utilisateur
   - Génère un token
   - Retourne Token (token + user)

2. **POST /auth/login** :
   - Reçoit UserLogin (email + password)
   - Trouve l'utilisateur par email
   - Vérifie le mot de passe
   - Génère un token
   - Retourne Token

3. **GET /auth/me** :
   - Route protégée
   - Retourne l'utilisateur connecté

### Étape 4 : Intégrer dans l'application

Dans `app/main.py` :
1. Importez les routes d'authentification
2. Ajoutez le router : `app.include_router(auth.router, prefix="/api/auth")`

### Étape 5 : Configurer SECRET_KEY

Dans `app/config.py` et `.env` :
- Ajoutez `SECRET_KEY` avec une valeur forte
- ⚠️ En production, utilisez un secret aléatoire et sécurisé

## ✅ Livrable de la phase

À la fin de cette phase, vous devez avoir :

- [ ] `app/services/auth.py` avec toutes les fonctions
- [ ] `app/middleware/auth.py` avec get_current_user
- [ ] `app/routes/auth.py` avec register, login, me
- [ ] Routes intégrées dans main.py
- [ ] SECRET_KEY configuré
- [ ] Vous pouvez vous inscrire
- [ ] Vous pouvez vous connecter
- [ ] Le token JWT est retourné
- [ ] Les routes protégées fonctionnent

## 🧪 Vérification

Testez avec Swagger ou Postman :

1. **Inscription :**
   ```json
   POST /api/auth/register
   {
     "username": "testuser",
     "email": "test@example.com",
     "password": "password123"
   }
   ```

2. **Connexion :**
   ```json
   POST /api/auth/login
   {
     "email": "test@example.com",
     "password": "password123"
   }
   ```

3. **Route protégée :**
   - Copiez le token retourné
   - Cliquez sur "Authorize" dans Swagger
   - Entrez : `Bearer VOTRE_TOKEN`
   - Testez `/api/auth/me`

## 🐛 Problèmes courants

- **"Invalid credentials"** : Vérifiez le mot de passe
- **"User already exists"** : Email ou username déjà utilisé
- **"Token invalid"** : Vérifiez SECRET_KEY et le format du token
- **401 Unauthorized** : Token manquant ou expiré

## 📝 Notes importantes

- **Ne stockez jamais** les mots de passe en clair
- **Utilisez des secrets forts** en production
- **Expiration** : Configurez une expiration raisonnable (ex: 30 minutes)
- **HTTPS** : Toujours en production pour protéger les tokens

## ➡️ Prochaine phase

Une fois cette phase terminée et vérifiée, passez à la **Phase 6 : API CRUD pour les livres**.

**Commitez votre travail :**
```bash
git add .
git commit -m "Phase 5: Authentification JWT complète"
```

