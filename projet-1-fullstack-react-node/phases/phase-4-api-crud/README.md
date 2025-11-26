# Phase 4 : API CRUD pour les tâches

## 🎯 Objectif de la phase

Créer les endpoints pour gérer les tâches (Create, Read, Update, Delete) avec protection par authentification.

## 📚 Rappels techniques essentiels

### CRUD Operations
- **Create** : Créer une nouvelle ressource (POST)
- **Read** : Lire une ou plusieurs ressources (GET)
- **Update** : Mettre à jour une ressource (PUT/PATCH)
- **Delete** : Supprimer une ressource (DELETE)

### RESTful API
- **REST** : Architectural style pour les APIs
- **Ressources** : Les tâches sont des ressources
- **HTTP Methods** : GET, POST, PUT, DELETE
- **Status Codes** : 200 (OK), 201 (Created), 404 (Not Found), etc.

### Protection des routes
- **Middleware d'authentification** : Vérifier le token avant d'accéder
- **userId** : Récupéré depuis le token décodé
- **Isolation des données** : Chaque utilisateur voit uniquement ses tâches

### Validation
- **Validation des données** : Vérifier les données avant traitement
- **Erreurs 400** : Données invalides
- **Erreurs 404** : Ressource non trouvée
- **Erreurs 401** : Non authentifié

## 🏋️ Exercice pratique : CRUD simple

**Objectif** : Créer un CRUD simple pour comprendre les opérations

**Instructions :**

Créez `exercice-crud/server.js` :
```javascript
const express = require('express');
const app = express();
app.use(express.json());

let items = []; // Simule une base de données
let nextId = 1;

// CREATE
app.post('/items', (req, res) => {
  const { name } = req.body;
  if (!name) return res.status(400).json({ error: 'Name required' });
  
  const item = { id: nextId++, name };
  items.push(item);
  res.status(201).json(item);
});

// READ ALL
app.get('/items', (req, res) => {
  res.json(items);
});

// READ ONE
app.get('/items/:id', (req, res) => {
  const item = items.find(i => i.id === parseInt(req.params.id));
  if (!item) return res.status(404).json({ error: 'Not found' });
  res.json(item);
});

// UPDATE
app.put('/items/:id', (req, res) => {
  const item = items.find(i => i.id === parseInt(req.params.id));
  if (!item) return res.status(404).json({ error: 'Not found' });
  
  item.name = req.body.name;
  res.json(item);
});

// DELETE
app.delete('/items/:id', (req, res) => {
  const index = items.findIndex(i => i.id === parseInt(req.params.id));
  if (index === -1) return res.status(404).json({ error: 'Not found' });
  
  items.splice(index, 1);
  res.status(204).send();
});

app.listen(3000, () => console.log('Server running'));
```

**Vérification :**
- ✅ Testez toutes les opérations CRUD
- ✅ Comprenez les codes de statut HTTP

## 📋 Tâches du projet

### Étape 1 : Créer le contrôleur des tâches

Créez `backend/src/controllers/taskController.ts`

**Fonction `createTask` :**
1. Récupérez `title` et `description` depuis `req.body`
2. Validez que `title` est présent
3. Récupérez `userId` depuis `req.userId` (middleware auth)
4. Créez la tâche avec `userId`
5. Retournez la tâche créée (status 201)

**Fonction `getTasks` :**
1. Récupérez `userId` depuis `req.userId`
2. Trouvez toutes les tâches où `userId` correspond
3. Triez par date de création (plus récent en premier)
4. Retournez la liste des tâches

**Fonction `updateTask` :**
1. Récupérez `id` depuis `req.params`
2. Récupérez `userId` depuis `req.userId`
3. Trouvez la tâche par `id` ET `userId` (sécurité)
4. Si non trouvée, retournez 404
5. Mettez à jour les champs fournis (`title`, `description`, `completed`)
6. Sauvegardez et retournez la tâche mise à jour

**Fonction `deleteTask` :**
1. Récupérez `id` depuis `req.params`
2. Récupérez `userId` depuis `req.userId`
3. Trouvez et supprimez la tâche par `id` ET `userId`
4. Si non trouvée, retournez 404
5. Retournez un message de succès (status 204)

### Étape 2 : Créer les routes des tâches

Créez `backend/src/routes/taskRoutes.ts`

**À faire :**
1. Importez Express Router
2. Importez le middleware d'authentification
3. Importez les fonctions du contrôleur
4. Appliquez le middleware à toutes les routes : `router.use(authMiddleware)`
5. Créez les routes :
   - `POST /` → `createTask`
   - `GET /` → `getTasks`
   - `PUT /:id` → `updateTask`
   - `DELETE /:id` → `deleteTask`
6. Exportez le router

### Étape 3 : Intégrer les routes dans l'application

Dans `backend/src/index.ts` :
1. Importez les routes des tâches
2. Utilisez `app.use('/api/tasks', taskRoutes)`

### Étape 4 : Mettre à jour le middleware

Dans `backend/src/middleware/auth.ts`, assurez-vous que :
1. Le type `AuthRequest` est correctement défini
2. Le middleware ajoute `userId` à `req`
3. Le middleware fonctionne avec les contrôleurs

## ✅ Livrable de la phase

À la fin de cette phase, vous devez avoir :

- [ ] `src/controllers/taskController.ts` avec les 4 fonctions CRUD
- [ ] `src/routes/taskRoutes.ts` avec toutes les routes protégées
- [ ] Les routes intégrées dans `src/index.ts`
- [ ] Vous pouvez créer une tâche (avec authentification)
- [ ] Vous pouvez récupérer vos tâches
- [ ] Vous pouvez modifier une tâche
- [ ] Vous pouvez supprimer une tâche
- [ ] Les tâches sont isolées par utilisateur

## 🧪 Vérification

Testez avec Postman (n'oubliez pas le token dans l'header) :

**1. Créer une tâche :**
```bash
POST http://localhost:5000/api/tasks
Authorization: Bearer VOTRE_TOKEN
Content-Type: application/json

{
  "title": "Ma première tâche",
  "description": "Description de la tâche"
}
```

**2. Récupérer toutes les tâches :**
```bash
GET http://localhost:5000/api/tasks
Authorization: Bearer VOTRE_TOKEN
```

**3. Modifier une tâche :**
```bash
PUT http://localhost:5000/api/tasks/TASK_ID
Authorization: Bearer VOTRE_TOKEN
Content-Type: application/json

{
  "completed": true
}
```

**4. Supprimer une tâche :**
```bash
DELETE http://localhost:5000/api/tasks/TASK_ID
Authorization: Bearer VOTRE_TOKEN
```

**5. Test de sécurité :**
- Créez une tâche avec l'utilisateur A
- Essayez de la modifier avec l'utilisateur B → Devrait échouer (404)

## 🐛 Problèmes courants

- **401 Unauthorized** : Vérifiez que le token est dans l'header Authorization
- **404 Not Found** : Vérifiez que la tâche appartient à l'utilisateur connecté
- **Erreur userId** : Vérifiez que le middleware ajoute bien `userId` à `req`

## 📝 Notes importantes

- Toutes les routes doivent être protégées par authentification
- Vérifiez toujours que la tâche appartient à l'utilisateur
- Utilisez les codes HTTP appropriés
- Validez les données d'entrée

## ➡️ Prochaine phase

Une fois cette phase terminée et vérifiée, passez à la **Phase 5 : Configuration du frontend React**.


