# Phase 1 : Configuration initiale du backend

## 🎯 Objectif de la phase

Mettre en place un serveur Express avec TypeScript qui répond aux requêtes HTTP.

## 📚 Rappels techniques essentiels

### Node.js et npm
- **Node.js** : Runtime JavaScript côté serveur
- **npm** : Gestionnaire de paquets pour Node.js
- **package.json** : Fichier de configuration du projet (dépendances, scripts)

### TypeScript
- **TypeScript** : Sur-ensemble de JavaScript avec typage statique
- **tsconfig.json** : Configuration du compilateur TypeScript
- **Types** : Définitions de types pour éviter les erreurs à l'exécution

### Express.js
- **Express** : Framework web minimaliste pour Node.js
- **Middleware** : Fonctions exécutées entre la requête et la réponse
- **Routes** : Définition des endpoints de l'API
- **Request/Response** : Objets représentant la requête HTTP et la réponse

### Variables d'environnement
- **.env** : Fichier pour stocker les variables d'environnement (non versionné)
- **dotenv** : Package pour charger les variables d'environnement
- **Sécurité** : Ne jamais commiter les fichiers `.env` avec des secrets

## 🏋️ Exercice pratique : Premier serveur Express

**📖 Consultez le fichier `EXERCICE.md` dans ce dossier pour l'exercice complet avec correction détaillée.**

**Résumé de l'exercice :**
Créez un serveur Express avec TypeScript qui :
- Écoute sur le port 5000
- A des routes GET et POST
- Configure CORS
- Parse le JSON

**L'exercice complet avec :**
- ✅ Code complet commenté
- ✅ Explications ligne par ligne
- ✅ Guide de test avec curl et Postman
- ✅ Types TypeScript expliqués

**Fichier :** `phases/phase-1-backend-setup/EXERCICE.md`

## 📋 Tâches du projet

### Étape 1 : Initialiser le projet backend

1. Créez le dossier `backend/` à la racine du projet
2. Ouvrez un terminal dans ce dossier
3. Initialisez npm : `npm init -y`
4. Modifiez `package.json` pour ajouter les scripts nécessaires

### Étape 2 : Installer les dépendances

Installez les dépendances de production :
```bash
npm install express mongoose dotenv cors bcryptjs jsonwebtoken
```

Installez les dépendances de développement :
```bash
npm install -D typescript @types/node @types/express @types/cors @types/bcryptjs @types/jsonwebtoken ts-node nodemon
```

### Étape 3 : Configurer TypeScript

Créez `backend/tsconfig.json` avec cette configuration :
```json
{
  "compilerOptions": {
    "target": "ES2020",
    "module": "commonjs",
    "lib": ["ES2020"],
    "outDir": "./dist",
    "rootDir": "./src",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "resolveJsonModule": true,
    "moduleResolution": "node"
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist"]
}
```

### Étape 4 : Configurer les scripts npm

Dans `backend/package.json`, ajoutez/modifiez les scripts :
```json
{
  "scripts": {
    "dev": "nodemon src/index.ts",
    "build": "tsc",
    "start": "node dist/index.js"
  }
}
```

### Étape 5 : Créer le fichier d'environnement

Créez `backend/.env.example` (template) :
```
PORT=5000
MONGODB_URI=mongodb://localhost:27017/todoapp
JWT_SECRET=your_super_secret_jwt_key_change_this_in_production
NODE_ENV=development
```

Créez `backend/.env` (copie de `.env.example` et modifiez les valeurs)

### Étape 6 : Créer le point d'entrée

Créez `backend/src/index.ts` :
```typescript
import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';

dotenv.config();

const app = express();
const PORT = process.env.PORT || 5000;

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Route de test
app.get('/api/health', (req, res) => {
  res.json({ status: 'OK', message: 'Server is running' });
});

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
```

### Étape 7 : Créer le fichier .gitignore

Créez `backend/.gitignore` :
```
node_modules/
dist/
.env
*.log
```

## ✅ Livrable de la phase

À la fin de cette phase, vous devez avoir :

- [ ] Un dossier `backend/` avec la structure de base
- [ ] `package.json` avec toutes les dépendances installées
- [ ] `tsconfig.json` configuré
- [ ] Fichier `.env` créé (non versionné)
- [ ] `src/index.ts` avec un serveur Express fonctionnel
- [ ] Le serveur démarre avec `npm run dev`
- [ ] La route `/api/health` répond correctement

## 🧪 Vérification

Testez votre serveur :

1. Démarrez le serveur : `npm run dev`
2. Dans un autre terminal, testez :
   ```bash
   curl http://localhost:5000/api/health
   ```
   Ou utilisez Postman pour faire une requête GET à `http://localhost:5000/api/health`

**Résultat attendu :**
```json
{
  "status": "OK",
  "message": "Server is running"
}
```

## 🐛 Problèmes courants

- **Erreur "Cannot find module"** : Vérifiez que vous avez bien installé les dépendances avec `npm install`
- **Port déjà utilisé** : Changez le PORT dans `.env` ou arrêtez le processus qui utilise le port 5000
- **Erreur TypeScript** : Vérifiez que `tsconfig.json` est correctement configuré

## ➡️ Prochaine phase

Une fois cette phase terminée et vérifiée, passez à la **Phase 2 : Configuration de MongoDB et modèles**.


