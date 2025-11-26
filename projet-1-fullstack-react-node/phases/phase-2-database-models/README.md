# Phase 2 : Configuration de MongoDB et modèles

## 🎯 Objectif de la phase

Connecter MongoDB à votre application et créer les modèles de données (User et Task).

## 📚 Rappels techniques essentiels

### MongoDB
- **MongoDB** : Base de données NoSQL orientée documents
- **Collections** : Équivalent des tables en SQL (ex: `users`, `tasks`)
- **Documents** : Équivalent des lignes en SQL (objets JSON)
- **MongoDB Atlas** : Service cloud gratuit pour MongoDB

### Mongoose
- **Mongoose** : ODM (Object Document Mapper) pour MongoDB et Node.js
- **Schema** : Définit la structure d'un document (champs, types, validations)
- **Model** : Classe qui permet d'interagir avec une collection
- **Méthodes** : `create()`, `find()`, `findOne()`, `updateOne()`, `deleteOne()`

### Concepts clés
- **Connection String** : URL de connexion à MongoDB
- **Async/Await** : Gestion asynchrone des opérations de base de données
- **Validation** : Vérification des données avant insertion

## 🏋️ Exercice pratique : Premier modèle Mongoose

**Objectif** : Créer un modèle simple et tester la connexion

**Instructions :**

1. Créez un dossier `exercice-mongoose`
2. Installez : `npm install mongoose dotenv`
3. Créez `.env` :
   ```
   MONGODB_URI=mongodb://localhost:27017/testdb
   ```
4. Créez `test-connection.js` :
   ```javascript
   const mongoose = require('mongoose');
   require('dotenv').config();

   const connectDB = async () => {
     try {
       await mongoose.connect(process.env.MONGODB_URI);
       console.log('MongoDB Connected');
     } catch (error) {
       console.error('Error:', error);
       process.exit(1);
     }
   };

   connectDB();
   ```
5. Créez un modèle simple `models/Product.js` :
   ```javascript
   const mongoose = require('mongoose');

   const ProductSchema = new mongoose.Schema({
     name: { type: String, required: true },
     price: { type: Number, required: true }
   });

   module.exports = mongoose.model('Product', ProductSchema);
   ```
6. Testez la création :
   ```javascript
   const Product = require('./models/Product');
   
   const createProduct = async () => {
     const product = await Product.create({ name: 'Laptop', price: 999 });
     console.log('Product created:', product);
   };
   ```

**Vérification :**
- ✅ La connexion MongoDB fonctionne
- ✅ Vous pouvez créer un document

## 📋 Tâches du projet

### Étape 1 : Configurer la connexion MongoDB

1. Créez `backend/src/config/database.ts` :
   ```typescript
   import mongoose from 'mongoose';

   export const connectDB = async () => {
     try {
       const conn = await mongoose.connect(
         process.env.MONGODB_URI || 'mongodb://localhost:27017/todoapp'
       );
       console.log(`MongoDB Connected: ${conn.connection.host}`);
     } catch (error) {
       console.error('Error connecting to MongoDB:', error);
       process.exit(1);
     }
   };
   ```

2. Appelez `connectDB()` dans `src/index.ts` après avoir chargé dotenv

### Étape 2 : Créer le modèle User

Créez `backend/src/models/User.ts` :

**Structure attendue :**
- `username` : String, unique, requis, min 3 caractères
- `email` : String, unique, requis, format email valide
- `password` : String, requis, min 6 caractères
- `createdAt` : Date (automatique avec timestamps)

**À faire :**
1. Importez les types nécessaires de mongoose
2. Créez le Schema avec les validations
3. Activez `timestamps: true` pour createdAt/updatedAt
4. Exportez le modèle

**Indices :**
- Utilisez `unique: true` pour email et username
- Utilisez `required: [true, 'Message']` pour les champs obligatoires
- Utilisez `minlength` pour la longueur minimale

### Étape 3 : Créer le modèle Task

Créez `backend/src/models/Task.ts` :

**Structure attendue :**
- `title` : String, requis, max 200 caractères
- `description` : String, optionnel, max 1000 caractères
- `completed` : Boolean, défaut false
- `userId` : ObjectId, référence vers User, requis
- `createdAt` : Date (automatique)
- `updatedAt` : Date (automatique)

**À faire :**
1. Créez le Schema avec les champs demandés
2. Utilisez `Schema.Types.ObjectId` et `ref: 'User'` pour userId
3. Activez `timestamps: true`

### Étape 4 : Tester la connexion et les modèles

Créez un script de test `backend/src/test-models.ts` (temporaire) :

**À faire :**
1. Connectez-vous à MongoDB
2. Créez un utilisateur de test
3. Créez une tâche de test liée à cet utilisateur
4. Affichez les résultats dans la console

**Indice :** Utilisez `try/catch` pour gérer les erreurs

## ✅ Livrable de la phase

À la fin de cette phase, vous devez avoir :

- [ ] `src/config/database.ts` avec la fonction `connectDB()`
- [ ] `src/models/User.ts` avec le modèle User complet
- [ ] `src/models/Task.ts` avec le modèle Task complet
- [ ] La connexion MongoDB fonctionne au démarrage du serveur
- [ ] Les modèles sont correctement exportés
- [ ] Vous pouvez créer un utilisateur et une tâche de test

## 🧪 Vérification

Testez votre configuration :

1. Démarrez MongoDB (localement ou utilisez MongoDB Atlas)
2. Démarrez le serveur : `npm run dev`
3. Vérifiez dans les logs que MongoDB est connecté
4. Utilisez MongoDB Compass ou un script de test pour vérifier :
   - La création d'un utilisateur
   - La création d'une tâche liée à un utilisateur

**Résultat attendu :**
- Console affiche : `MongoDB Connected: ...`
- Les collections `users` et `tasks` existent dans MongoDB
- Vous pouvez insérer des documents

## 🐛 Problèmes courants

- **Erreur de connexion** : Vérifiez que MongoDB est démarré et que l'URI est correcte
- **Erreur "Schema hasn't been registered"** : Vérifiez que vous importez les modèles avant de les utiliser
- **Validation échoue** : Vérifiez que les données respectent les contraintes du schema

## 📝 Notes importantes

- Le mot de passe sera haché dans la phase suivante (ne le stockez jamais en clair)
- Les relations entre User et Task seront utilisées dans les phases suivantes
- MongoDB crée automatiquement les collections au premier insert

## ➡️ Prochaine phase

Une fois cette phase terminée et vérifiée, passez à la **Phase 3 : Routes et contrôleurs d'authentification**.


