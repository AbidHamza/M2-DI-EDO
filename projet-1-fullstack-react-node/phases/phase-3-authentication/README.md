# Phase 3 : Routes et contrôleurs d'authentification

## 🎯 Objectif de la phase

Implémenter l'inscription et la connexion des utilisateurs avec authentification JWT.

## 📚 Rappels techniques essentiels

### JWT (JSON Web Token)
- **JWT** : Standard pour transmettre des informations de manière sécurisée
- **Structure** : `header.payload.signature`
- **Stateless** : Le serveur n'a pas besoin de stocker la session
- **Payload** : Contient les données (ex: userId, exp)

### bcrypt
- **bcrypt** : Algorithme de hachage pour les mots de passe
- **Hash** : Transformation irréversible du mot de passe
- **Salt Rounds** : Nombre d'itérations (10 est un bon compromis)
- **Jamais en clair** : Ne stockez jamais les mots de passe en clair

### Middleware Express
- **Middleware** : Fonction exécutée entre la requête et la réponse
- **next()** : Passe au middleware suivant
- **req, res, next** : Paramètres du middleware
- **Protection de routes** : Vérifier le token avant d'accéder à une route

### Contrôleurs
- **Controller** : Logique métier pour gérer les requêtes
- **Séparation des responsabilités** : Routes → Contrôleurs → Modèles
- **Gestion d'erreurs** : try/catch pour gérer les erreurs

## 🏋️ Exercice pratique : Authentification JWT

**📖 Consultez le fichier `EXERCICE.md` dans ce dossier pour l'exercice complet avec correction détaillée.**

**Résumé de l'exercice :**
Implémentez un système d'authentification complet :
- Hash de mot de passe avec bcrypt
- Génération et vérification de JWT
- Routes d'inscription et connexion
- Middleware de protection

**L'exercice complet avec :**
- ✅ Code complet avec contrôleurs et middleware
- ✅ Explications détaillées de chaque concept
- ✅ Guide de test avec curl
- ✅ Gestion d'erreurs

**Fichier :** `phases/phase-3-authentication/EXERCICE.md`

## 📋 Tâches du projet

### Étape 1 : Créer le contrôleur d'authentification

Créez `backend/src/controllers/authController.ts`

**Fonction `register` :**
1. Récupérez `username`, `email`, `password` depuis `req.body`
2. Validez que tous les champs sont présents
3. Vérifiez si l'utilisateur existe déjà (email ou username)
4. Hachez le mot de passe avec bcrypt (10 rounds)
5. Créez l'utilisateur dans la base de données
6. Générez un JWT avec `userId` dans le payload
7. Retournez le token et les informations utilisateur (sans le mot de passe)

**Fonction `login` :**
1. Récupérez `email` et `password` depuis `req.body`
2. Trouvez l'utilisateur par email
3. Vérifiez que l'utilisateur existe
4. Comparez le mot de passe avec `bcrypt.compare()`
5. Si valide, générez un JWT
6. Retournez le token et les informations utilisateur

**Gestion d'erreurs :**
- Utilisez `try/catch` pour toutes les opérations
- Retournez des codes HTTP appropriés (400, 401, 500)
- Messages d'erreur clairs

### Étape 2 : Créer les routes d'authentification

Créez `backend/src/routes/authRoutes.ts`

**À faire :**
1. Importez Express Router
2. Importez les fonctions du contrôleur
3. Créez les routes :
   - `POST /register` → `register`
   - `POST /login` → `login`
4. Exportez le router

### Étape 3 : Créer le middleware d'authentification

Créez `backend/src/middleware/auth.ts`

**Fonction `authMiddleware` :**
1. Récupérez le token depuis `req.headers.authorization` (format: "Bearer TOKEN")
2. Vérifiez que le token existe
3. Vérifiez le token avec `jwt.verify()`
4. Extrayez `userId` du payload
5. Ajoutez `userId` à `req` (créez une interface pour étendre Request)
6. Appelez `next()` si tout est valide
7. Retournez une erreur 401 si le token est invalide

**Indice :** Créez une interface pour étendre Request :
```typescript
export interface AuthRequest extends Request {
  userId?: string;
}
```

### Étape 4 : Intégrer les routes dans l'application

Dans `backend/src/index.ts` :
1. Importez les routes d'authentification
2. Utilisez `app.use('/api/auth', authRoutes)`

### Étape 5 : Configurer JWT_SECRET

Dans `backend/.env`, ajoutez :
```
JWT_SECRET=votre_secret_super_securise_changez_en_production
```

## ✅ Livrable de la phase

À la fin de cette phase, vous devez avoir :

- [ ] `src/controllers/authController.ts` avec `register` et `login`
- [ ] `src/routes/authRoutes.ts` avec les routes configurées
- [ ] `src/middleware/auth.ts` avec le middleware de protection
- [ ] Les routes intégrées dans `src/index.ts`
- [ ] `JWT_SECRET` configuré dans `.env`
- [ ] Vous pouvez vous inscrire via `POST /api/auth/register`
- [ ] Vous pouvez vous connecter via `POST /api/auth/login`
- [ ] Le token JWT est retourné après inscription/connexion

## 🧪 Vérification

Testez avec Postman ou curl :

**1. Test d'inscription :**
```bash
POST http://localhost:5000/api/auth/register
Content-Type: application/json

{
  "username": "testuser",
  "email": "test@example.com",
  "password": "password123"
}
```

**Résultat attendu :**
```json
{
  "message": "User created successfully",
  "token": "eyJhbGc...",
  "user": {
    "id": "...",
    "username": "testuser",
    "email": "test@example.com"
  }
}
```

**2. Test de connexion :**
```bash
POST http://localhost:5000/api/auth/login
Content-Type: application/json

{
  "email": "test@example.com",
  "password": "password123"
}
```

**3. Test avec token invalide :**
```bash
GET http://localhost:5000/api/protected
Authorization: Bearer invalid_token
```

Devrait retourner 401.

## 🐛 Problèmes courants

- **"User already exists"** : Normal si vous testez plusieurs fois, changez l'email
- **"Invalid credentials"** : Vérifiez que le mot de passe correspond
- **Erreur JWT** : Vérifiez que `JWT_SECRET` est défini dans `.env`
- **Token non trouvé** : Vérifiez le format "Bearer TOKEN" dans l'header

## 📝 Notes importantes

- Le mot de passe doit être haché avant stockage
- Ne retournez jamais le mot de passe dans les réponses
- Le token doit expirer (ex: 7 jours)
- En production, utilisez un `JWT_SECRET` fort et aléatoire

## ➡️ Prochaine phase

Une fois cette phase terminée et vérifiée, passez à la **Phase 4 : API CRUD pour les tâches**.


