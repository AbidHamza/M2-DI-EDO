# Phase 6 : Service API et gestion de l'authentification

## 🎯 Objectif de la phase

Créer les services pour communiquer avec l'API backend et gérer l'état d'authentification.

## 📚 Rappels techniques essentiels

### Axios
- **Axios** : Client HTTP pour faire des requêtes API
- **Instance** : Configuration réutilisable avec `axios.create()`
- **Interceptors** : Modifier les requêtes/réponses automatiquement
- **Headers** : Ajouter des headers (ex: Authorization)

### Context API
- **Context** : Partage d'état entre composants sans props drilling
- **Provider** : Fournit les données aux enfants
- **useContext** : Hook pour accéder au contexte
- **Global State** : État accessible partout dans l'app

### localStorage
- **localStorage** : Stockage persistant côté navigateur
- **setItem/getItem** : Sauvegarder/récupérer des données
- **removeItem** : Supprimer des données
- **JSON.stringify/parse** : Convertir objets en string

### Async/Await
- **Promises** : Opérations asynchrones
- **async/await** : Syntaxe pour gérer les Promises
- **try/catch** : Gestion des erreurs asynchrones

## 🏋️ Exercice pratique : Axios et Context

**Objectif** : Comprendre Axios et Context API

**Instructions :**

1. Créez `exercice-axios/index.js` :
   ```javascript
   const axios = require('axios');
   
   const api = axios.create({
     baseURL: 'https://jsonplaceholder.typicode.com'
   });
   
   // Interceptor pour ajouter un header
   api.interceptors.request.use(config => {
     config.headers.Authorization = 'Bearer token123';
     return config;
   });
   
   // Test
   (async () => {
     try {
       const response = await api.get('/posts/1');
       console.log(response.data);
     } catch (error) {
       console.error('Error:', error);
     }
   })();
   ```

2. Créez `exercice-context/App.jsx` :
   ```jsx
   import { createContext, useContext, useState } from 'react';
   
   const UserContext = createContext();
   
   function App() {
     const [user, setUser] = useState(null);
     
     return (
       <UserContext.Provider value={{ user, setUser }}>
         <Child />
       </UserContext.Provider>
     );
   }
   
   function Child() {
     const { user, setUser } = useContext(UserContext);
     return <button onClick={() => setUser('John')}>Set User</button>;
   }
   ```

**Vérification :**
- ✅ Vous comprenez Axios et les interceptors
- ✅ Vous comprenez Context API

## 📋 Tâches du projet

### Étape 1 : Créer l'instance Axios

Créez `frontend/src/services/api.ts`

**À faire :**
1. Importez axios
2. Créez une instance avec `axios.create()`
3. Configurez `baseURL` (utilisez une variable d'environnement ou `http://localhost:5000/api`)
4. Configurez les headers par défaut (`Content-Type: application/json`)
5. Ajoutez un interceptor pour ajouter le token JWT :
   - Récupérez le token depuis `localStorage`
   - Ajoutez-le dans `Authorization: Bearer TOKEN`
6. Exportez l'instance

**Indice :**
```typescript
api.interceptors.request.use((config) => {
  const token = localStorage.getItem('token');
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});
```

### Étape 2 : Créer le service d'authentification

Créez `frontend/src/services/authService.ts`

**Fonctions à créer :**

1. **`register`** :
   - Prend `username`, `email`, `password`
   - Fait un POST vers `/auth/register`
   - Retourne la réponse

2. **`login`** :
   - Prend `email`, `password`
   - Fait un POST vers `/auth/login`
   - Retourne la réponse

3. **`logout`** :
   - Supprime le token et l'utilisateur de `localStorage`

**Types TypeScript :**
Créez des interfaces pour les données :
```typescript
export interface RegisterData {
  username: string;
  email: string;
  password: string;
}

export interface LoginData {
  email: string;
  password: string;
}
```

### Étape 3 : Créer le service des tâches

Créez `frontend/src/services/taskService.ts`

**Fonctions à créer :**

1. **`getTasks`** : GET `/tasks`
2. **`createTask`** : POST `/tasks` avec `title` et `description`
3. **`updateTask`** : PUT `/tasks/:id` avec les données à mettre à jour
4. **`deleteTask`** : DELETE `/tasks/:id`

**Types TypeScript :**
Créez une interface `Task` :
```typescript
export interface Task {
  _id: string;
  title: string;
  description?: string;
  completed: boolean;
  userId: string;
  createdAt: string;
  updatedAt: string;
}
```

### Étape 4 : Créer le contexte d'authentification

Créez `frontend/src/contexts/AuthContext.tsx`

**À faire :**
1. Créez le contexte avec `createContext`
2. Créez le Provider qui :
   - Gère l'état `user` et `isAuthenticated`
   - Charge l'utilisateur depuis `localStorage` au démarrage
   - Fournit les fonctions `login`, `register`, `logout`
3. Créez un hook `useAuth()` pour utiliser le contexte
4. Dans `login` et `register` :
   - Appelez le service
   - Sauvegardez le token et l'utilisateur dans `localStorage`
   - Mettez à jour l'état

**Structure attendue :**
```typescript
interface AuthContextType {
  user: User | null;
  isAuthenticated: boolean;
  isLoading: boolean;
  login: (data: LoginData) => Promise<void>;
  register: (data: RegisterData) => Promise<void>;
  logout: () => void;
}
```

### Étape 5 : Intégrer le Provider dans l'application

Dans `frontend/src/App.tsx` :
1. Importez `AuthProvider`
2. Enveloppez l'application avec `<AuthProvider>`

## ✅ Livrable de la phase

À la fin de cette phase, vous devez avoir :

- [ ] `src/services/api.ts` avec l'instance Axios configurée
- [ ] `src/services/authService.ts` avec register, login, logout
- [ ] `src/services/taskService.ts` avec toutes les opérations CRUD
- [ ] `src/contexts/AuthContext.tsx` avec le Provider et le hook
- [ ] Le Provider intégré dans `App.tsx`
- [ ] Les types TypeScript définis
- [ ] Le token est automatiquement ajouté aux requêtes
- [ ] L'état d'authentification est géré globalement

## 🧪 Vérification

Testez dans la console du navigateur :

1. Ouvrez les DevTools
2. Testez manuellement :
   ```javascript
   // Dans la console
   const { useAuth } = require('./contexts/AuthContext');
   // Ou testez directement les services
   ```

3. Vérifiez que le token est dans `localStorage` après connexion
4. Vérifiez que les requêtes incluent le header Authorization

**Résultat attendu :**
- Les services fonctionnent
- Le contexte gère l'état
- Le token est automatiquement ajouté

## 🐛 Problèmes courants

- **CORS error** : Vérifiez que le proxy est configuré dans Vite
- **Token non ajouté** : Vérifiez l'interceptor Axios
- **Erreur TypeScript** : Vérifiez que les types sont correctement définis

## 📝 Notes importantes

- Le token doit être stocké de manière sécurisée (localStorage est OK pour ce projet)
- Gérer les erreurs dans les services (try/catch)
- Le contexte doit charger l'utilisateur au démarrage

## ➡️ Prochaine phase

Une fois cette phase terminée et vérifiée, passez à la **Phase 7 : Pages d'authentification**.


