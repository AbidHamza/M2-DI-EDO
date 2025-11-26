# Phase 10 : Tests et déploiement

## 🎯 Objectif de la phase

Tester l'application complète et la déployer en production.

## 📚 Rappels techniques essentiels

### Build de production
- **Build** : Compilation et optimisation du code
- **Minification** : Réduction de la taille des fichiers
- **Optimization** : Optimisation des performances
- **Environment Variables** : Variables d'environnement pour la production

### Déploiement
- **Frontend** : Vercel, Netlify, GitHub Pages
- **Backend** : Render, Railway, Heroku, AWS
- **Database** : MongoDB Atlas (cloud)

### Tests
- **Tests manuels** : Tester tous les flux utilisateur
- **Tests de régression** : Vérifier que tout fonctionne
- **Tests de performance** : Vérifier les temps de chargement

### Sécurité
- **Variables d'environnement** : Ne jamais commiter les secrets
- **HTTPS** : Utiliser HTTPS en production
- **CORS** : Configurer CORS correctement

## 🏋️ Exercice pratique : Build et preview

**Objectif** : Comprendre le processus de build

**Instructions :**

1. Dans un projet Vite :
   ```bash
   npm run build
   npm run preview
   ```

2. Vérifiez le dossier `dist/` créé

3. Testez l'application en mode production

**Vérification :**
- ✅ Le build fonctionne
- ✅ L'application preview fonctionne

## 📋 Tâches du projet

### Étape 1 : Tests manuels complets

**Checklist de tests :**

1. **Authentification :**
   - [ ] Inscription fonctionne
   - [ ] Connexion fonctionne
   - [ ] Logout fonctionne
   - [ ] Protection des routes fonctionne
   - [ ] Gestion des erreurs d'authentification

2. **Tâches :**
   - [ ] Création de tâche
   - [ ] Modification de tâche
   - [ ] Suppression de tâche
   - [ ] Marquer comme complété
   - [ ] Filtrage fonctionne
   - [ ] Isolation des tâches par utilisateur

3. **UX :**
   - [ ] Responsive sur mobile/tablette/desktop
   - [ ] États de chargement visibles
   - [ ] Messages d'erreur clairs
   - [ ] Navigation fluide

4. **Erreurs :**
   - [ ] Gestion des erreurs réseau
   - [ ] Gestion des erreurs de validation
   - [ ] Messages d'erreur appropriés

### Étape 2 : Optimiser pour la production

**Backend :**

1. **Variables d'environnement :**
   - Créez `.env.production` (ne pas commiter)
   - Configurez les variables pour la production
   - `NODE_ENV=production`
   - `MONGODB_URI` (MongoDB Atlas)
   - `JWT_SECRET` (fort et aléatoire)

2. **Build :**
   - `npm run build` compile TypeScript
   - Vérifiez le dossier `dist/`

**Frontend :**

1. **Variables d'environnement :**
   - Créez `.env.production`
   - `VITE_API_URL` : URL de l'API en production

2. **Build :**
   - `npm run build` crée le dossier `dist/`
   - Vérifiez que le build fonctionne

### Étape 3 : Préparer MongoDB Atlas

**À faire :**

1. Créez un compte sur [MongoDB Atlas](https://www.mongodb.com/cloud/atlas)
2. Créez un cluster gratuit
3. Créez un utilisateur de base de données
4. Whitelist votre IP (ou 0.0.0.0/0 pour toutes les IPs)
5. Récupérez la connection string
6. Mettez à jour `MONGODB_URI` dans `.env.production`

### Étape 4 : Déployer le backend

**Option 1 : Render (recommandé)**

1. Créez un compte sur [Render](https://render.com)
2. Créez un nouveau "Web Service"
3. Connectez votre dépôt GitHub
4. Configuration :
   - Build Command : `npm install && npm run build`
   - Start Command : `npm start`
   - Environment Variables : Ajoutez toutes les variables de `.env.production`
5. Déployez

**Option 2 : Railway**

1. Créez un compte sur [Railway](https://railway.app)
2. Créez un nouveau projet
3. Connectez votre dépôt
4. Configurez les variables d'environnement
5. Déployez

### Étape 5 : Déployer le frontend

**Option 1 : Vercel (recommandé)**

1. Créez un compte sur [Vercel](https://vercel.com)
2. Importez votre projet GitHub
3. Configuration :
   - Framework Preset : Vite
   - Build Command : `npm run build`
   - Output Directory : `dist`
   - Environment Variables : `VITE_API_URL` (URL de votre backend déployé)
4. Déployez

**Option 2 : Netlify**

1. Créez un compte sur [Netlify](https://netlify.com)
2. Importez votre projet
3. Configurez de la même manière
4. Déployez

### Étape 6 : Mettre à jour les URLs

**À faire :**

1. **Frontend :**
   - Mettez à jour `VITE_API_URL` avec l'URL du backend déployé
   - Redéployez le frontend

2. **Backend :**
   - Configurez CORS pour autoriser l'URL du frontend
   - Redéployez si nécessaire

### Étape 7 : Tests en production

**Checklist :**

1. [ ] L'application est accessible en ligne
2. [ ] L'inscription fonctionne
3. [ ] La connexion fonctionne
4. [ ] Les tâches se chargent
5. [ ] CRUD des tâches fonctionne
6. [ ] Pas d'erreurs dans la console
7. [ ] Performance acceptable

### Étape 8 : Documentation finale

**Créez un fichier `DEPLOYMENT.md` :**

1. **URLs de production :**
   - Frontend : ...
   - Backend : ...

2. **Variables d'environnement nécessaires :**
   - Liste toutes les variables

3. **Instructions de déploiement :**
   - Étapes pour redéployer

## ✅ Livrable de la phase

À la fin de cette phase, vous devez avoir :

- [ ] Application testée complètement
- [ ] Backend déployé et accessible
- [ ] Frontend déployé et accessible
- [ ] MongoDB Atlas configuré
- [ ] Variables d'environnement configurées
- [ ] Application fonctionnelle en production
- [ ] Documentation de déploiement

## 🧪 Vérification

Testez en production :

1. **URLs :**
   - Frontend accessible
   - Backend accessible
   - API répond correctement

2. **Fonctionnalités :**
   - Toutes les fonctionnalités fonctionnent
   - Pas d'erreurs

3. **Performance :**
   - Temps de chargement acceptable
   - Pas de lenteurs

## 🐛 Problèmes courants

- **CORS errors** : Vérifiez la configuration CORS du backend
- **Variables d'environnement** : Vérifiez qu'elles sont bien configurées
- **Build errors** : Vérifiez les logs de build

## 📝 Notes importantes

- Ne jamais commiter les fichiers `.env` avec des secrets
- Utiliser HTTPS en production
- Configurer CORS correctement
- Tester avant et après déploiement

## 🎉 Félicitations !

Votre application full-stack est maintenant déployée et fonctionnelle !

**Prochaines étapes possibles :**
- Ajouter des fonctionnalités (recherche, catégories, etc.)
- Améliorer les performances
- Ajouter des tests automatisés
- Améliorer la sécurité

---

**Projet terminé ! 🚀**


