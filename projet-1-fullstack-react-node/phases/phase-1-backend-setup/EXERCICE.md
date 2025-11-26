# Exercice Phase 1 : Premier serveur Express avec TypeScript

## 📝 Exercice à réaliser

Créez un serveur Express avec TypeScript qui :
1. Écoute sur le port 5000
2. A une route GET `/` qui retourne un message de bienvenue
3. A une route GET `/api/health` qui retourne le statut
4. A une route POST `/api/users` qui accepte JSON et retourne les données
5. Configure CORS pour accepter toutes les origines

## ✅ Correction complète

```typescript
// src/index.ts
import express, { Request, Response } from 'express';
import cors from 'cors';
import dotenv from 'dotenv';

// Charger les variables d'environnement
dotenv.config();

// Créer l'application Express
const app = express();
const PORT = process.env.PORT || 5000;

// Middleware
app.use(cors()); // Autorise toutes les origines
app.use(express.json()); // Parse le JSON des requêtes
app.use(express.urlencoded({ extended: true })); // Parse les formulaires

// Interface pour les données utilisateur
interface UserData {
  name: string;
  email: string;
}

// Route racine
app.get('/', (req: Request, res: Response) => {
  res.json({
    message: 'Bienvenue sur mon API Express',
    version: '1.0.0',
    endpoints: {
      health: '/api/health',
      users: '/api/users (POST)'
    }
  });
});

// Route de santé
app.get('/api/health', (req: Request, res: Response) => {
  res.json({
    status: 'OK',
    message: 'Server is running',
    timestamp: new Date().toISOString()
  });
});

// Route POST pour créer un utilisateur
app.post('/api/users', (req: Request, res: Response) => {
  try {
    const userData: UserData = req.body;
    
    // Validation basique
    if (!userData.name || !userData.email) {
      return res.status(400).json({
        error: 'Name and email are required'
      });
    }
    
    // Simuler la création (en réalité, on sauvegarderait en base)
    const createdUser = {
      id: Date.now(), // ID temporaire
      ...userData,
      createdAt: new Date().toISOString()
    };
    
    res.status(201).json({
      message: 'User created successfully',
      user: createdUser
    });
  } catch (error) {
    res.status(500).json({
      error: 'Internal server error'
    });
  }
});

// Démarrer le serveur
app.listen(PORT, () => {
  console.log(`🚀 Server is running on port ${PORT}`);
  console.log(`📖 Health check: http://localhost:${PORT}/api/health`);
});
```

## 📚 Explications détaillées

### 1. Imports TypeScript

```typescript
import express, { Request, Response } from 'express';
```

**Explication :**
- `express` : Framework web
- `Request, Response` : Types TypeScript pour les paramètres de route
- Typage statique : Détecte les erreurs avant l'exécution

### 2. Variables d'environnement

```typescript
dotenv.config();
const PORT = process.env.PORT || 5000;
```

**Explication :**
- `dotenv.config()` : Charge le fichier `.env`
- `process.env.PORT` : Variable d'environnement
- `|| 5000` : Valeur par défaut si non définie

### 3. Middleware CORS

```typescript
app.use(cors());
```

**Explication :**
- Autorise les requêtes depuis n'importe quelle origine
- ⚠️ En production, spécifiez les origines autorisées

### 4. Middleware JSON

```typescript
app.use(express.json());
```

**Explication :**
- Parse automatiquement le JSON des requêtes
- Rend disponible `req.body` avec les données parsées

### 5. Interface TypeScript

```typescript
interface UserData {
  name: string;
  email: string;
}
```

**Explication :**
- Définit la structure des données
- TypeScript vérifie que les données correspondent

### 6. Routes avec types

```typescript
app.get('/', (req: Request, res: Response) => {
  // ...
});
```

**Explication :**
- `Request` : Type pour la requête
- `Response` : Type pour la réponse
- Autocomplétion dans l'IDE

## 🧪 Comment tester

1. **Démarrer le serveur :**
   ```bash
   npm run dev
   ```

2. **Tester avec curl :**
   ```bash
   # Route GET
   curl http://localhost:5000/
   
   # Health check
   curl http://localhost:5000/api/health
   
   # POST
   curl -X POST http://localhost:5000/api/users \
     -H "Content-Type: application/json" \
     -d '{"name":"John","email":"john@example.com"}'
   ```

3. **Tester avec Postman :**
   - Créez une requête GET vers `http://localhost:5000/`
   - Créez une requête POST vers `http://localhost:5000/api/users`

## ✅ Checklist

- [ ] Le serveur démarre sans erreur
- [ ] La route `/` fonctionne
- [ ] La route `/api/health` fonctionne
- [ ] La route POST `/api/users` accepte JSON
- [ ] CORS est configuré
- [ ] TypeScript compile sans erreur

---

**Excellent ! Vous maîtrisez Express avec TypeScript ! 🎉**

