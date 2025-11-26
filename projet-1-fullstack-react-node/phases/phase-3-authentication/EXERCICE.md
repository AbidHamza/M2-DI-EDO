# Exercice Phase 3 : Authentification JWT avec Express

## 📝 Exercice à réaliser

Implémentez un système d'authentification complet :
1. Hash de mot de passe avec bcrypt
2. Génération et vérification de JWT
3. Routes d'inscription et connexion
4. Middleware de protection des routes

## ✅ Correction complète

```typescript
// src/controllers/authController.ts
import { Request, Response } from 'express';
import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';
import User from '../models/User';

const JWT_SECRET = process.env.JWT_SECRET || 'secret';

export const register = async (req: Request, res: Response) => {
  try {
    const { username, email, password } = req.body;

    // Validation
    if (!username || !email || !password) {
      return res.status(400).json({ message: 'All fields required' });
    }

    // Vérifier si l'utilisateur existe
    const existingUser = await User.findOne({ 
      $or: [{ email }, { username }] 
    });
    
    if (existingUser) {
      return res.status(400).json({ message: 'User already exists' });
    }

    // Hash le mot de passe
    const hashedPassword = await bcrypt.hash(password, 10);

    // Créer l'utilisateur
    const user = await User.create({
      username,
      email,
      password: hashedPassword
    });

    // Générer le token JWT
    const token = jwt.sign(
      { userId: user._id },
      JWT_SECRET,
      { expiresIn: '7d' }
    );

    res.status(201).json({
      message: 'User created successfully',
      token,
      user: {
        id: user._id,
        username: user.username,
        email: user.email
      }
    });
  } catch (error: any) {
    res.status(500).json({ message: error.message });
  }
};

export const login = async (req: Request, res: Response) => {
  try {
    const { email, password } = req.body;

    if (!email || !password) {
      return res.status(400).json({ message: 'Email and password required' });
    }

    // Trouver l'utilisateur
    const user = await User.findOne({ email });
    if (!user) {
      return res.status(401).json({ message: 'Invalid credentials' });
    }

    // Vérifier le mot de passe
    const isPasswordValid = await bcrypt.compare(password, user.password);
    if (!isPasswordValid) {
      return res.status(401).json({ message: 'Invalid credentials' });
    }

    // Générer le token
    const token = jwt.sign(
      { userId: user._id },
      JWT_SECRET,
      { expiresIn: '7d' }
    );

    res.json({
      message: 'Login successful',
      token,
      user: {
        id: user._id,
        username: user.username,
        email: user.email
      }
    });
  } catch (error: any) {
    res.status(500).json({ message: error.message });
  }
};
```

```typescript
// src/middleware/auth.ts
import { Request, Response, NextFunction } from 'express';
import jwt from 'jsonwebtoken';

export interface AuthRequest extends Request {
  userId?: string;
}

const JWT_SECRET = process.env.JWT_SECRET || 'secret';

export const authMiddleware = (
  req: AuthRequest,
  res: Response,
  next: NextFunction
) => {
  try {
    // Récupérer le token depuis le header
    const authHeader = req.headers.authorization;
    
    if (!authHeader) {
      return res.status(401).json({ message: 'Authentication required' });
    }

    // Format: "Bearer TOKEN"
    const token = authHeader.split(' ')[1];

    if (!token) {
      return res.status(401).json({ message: 'Token missing' });
    }

    // Vérifier le token
    const decoded = jwt.verify(token, JWT_SECRET) as { userId: string };
    
    // Ajouter userId à la requête
    req.userId = decoded.userId;
    
    // Passer au middleware suivant
    next();
  } catch (error) {
    res.status(401).json({ message: 'Invalid or expired token' });
  }
};
```

## 📚 Explications détaillées

### 1. Hash de mot de passe

```typescript
const hashedPassword = await bcrypt.hash(password, 10);
```

**Explication :**
- `bcrypt.hash()` : Hash asynchrone
- `10` : Nombre de rounds (bon compromis)
- Résultat : Hash irréversible

### 2. Vérification de mot de passe

```typescript
const isValid = await bcrypt.compare(password, user.password);
```

**Explication :**
- Compare le mot de passe en clair avec le hash
- Retourne true/false

### 3. Génération JWT

```typescript
const token = jwt.sign(
  { userId: user._id },
  JWT_SECRET,
  { expiresIn: '7d' }
);
```

**Explication :**
- `{ userId }` : Payload (données dans le token)
- `JWT_SECRET` : Clé de signature
- `expiresIn` : Durée de vie

### 4. Vérification JWT

```typescript
const decoded = jwt.verify(token, JWT_SECRET);
```

**Explication :**
- Vérifie la signature
- Vérifie l'expiration
- Retourne le payload décodé

### 5. Middleware d'authentification

```typescript
export const authMiddleware = (req, res, next) => {
  // Vérifier le token
  // Ajouter userId à req
  next(); // Continuer
};
```

**Explication :**
- `next()` : Passe au middleware suivant
- `req.userId` : Disponible dans les routes suivantes

## 🧪 Comment tester

1. **Inscription :**
   ```bash
   curl -X POST http://localhost:5000/api/auth/register \
     -H "Content-Type: application/json" \
     -d '{"username":"test","email":"test@test.com","password":"test123"}'
   ```

2. **Connexion :**
   ```bash
   curl -X POST http://localhost:5000/api/auth/login \
     -H "Content-Type: application/json" \
     -d '{"email":"test@test.com","password":"test123"}'
   ```

3. **Route protégée :**
   ```bash
   curl http://localhost:5000/api/protected \
     -H "Authorization: Bearer VOTRE_TOKEN"
   ```

## ✅ Checklist

- [ ] Hash de mot de passe fonctionne
- [ ] Vérification de mot de passe fonctionne
- [ ] Génération JWT fonctionne
- [ ] Vérification JWT fonctionne
- [ ] Inscription fonctionne
- [ ] Connexion fonctionne
- [ ] Middleware protège les routes

---

**Parfait ! Vous maîtrisez l'authentification JWT ! 🎉**

