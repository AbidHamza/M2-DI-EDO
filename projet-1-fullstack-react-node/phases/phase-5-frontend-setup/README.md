# Phase 5 : Configuration du frontend React

## 🎯 Objectif de la phase

Initialiser le projet React avec Vite, TypeScript et Tailwind CSS.

## 📚 Rappels techniques essentiels

### React
- **React** : Bibliothèque JavaScript pour créer des interfaces utilisateur
- **Composants** : Blocs réutilisables de l'interface
- **JSX** : Syntaxe qui ressemble à HTML mais est du JavaScript
- **Props** : Données passées d'un composant parent à un enfant
- **State** : Données qui peuvent changer dans un composant

### Vite
- **Vite** : Build tool moderne et rapide
- **Hot Module Replacement (HMR)** : Rechargement instantané pendant le développement
- **Fast** : Démarrage rapide grâce à l'ESM natif

### TypeScript
- **TypeScript** : JavaScript avec typage statique
- **Types** : Définir les types de variables, fonctions, props
- **Interfaces** : Définir la structure d'objets
- **Avantages** : Détection d'erreurs avant l'exécution

### Tailwind CSS
- **Tailwind** : Framework CSS utility-first
- **Classes utilitaires** : `bg-blue-500`, `text-center`, `p-4`
- **Responsive** : `md:`, `lg:`, `xl:` pour les breakpoints
- **Pas de CSS custom** : Tout se fait avec des classes

## 🏋️ Exercice pratique : Premier composant React

**📖 Consultez le fichier `EXERCICE.md` dans ce dossier pour l'exercice complet avec correction détaillée.**

**Résumé de l'exercice :**
Créez une application React avec :
- Composant de compteur avec useState
- Formulaire avec gestion d'état
- Liste d'éléments avec map()
- Styling avec Tailwind CSS

**L'exercice complet avec :**
- ✅ Code complet avec tous les composants
- ✅ Explications détaillées de React hooks
- ✅ Gestion d'état immuable
- ✅ Rendu conditionnel et listes

**Fichier :** `phases/phase-5-frontend-setup/EXERCICE.md`

## 📋 Tâches du projet

### Étape 1 : Initialiser le projet React

1. Créez le dossier `frontend/` à la racine du projet
2. Ouvrez un terminal dans ce dossier
3. Initialisez Vite + React + TypeScript :
   ```bash
   npm create vite@latest . -- --template react-ts
   ```
4. Installez les dépendances : `npm install`

### Étape 2 : Installer les dépendances supplémentaires

Installez les packages nécessaires :
```bash
npm install axios react-router-dom
npm install -D tailwindcss postcss autoprefixer
```

### Étape 3 : Configurer Tailwind CSS

1. Initialisez Tailwind :
   ```bash
   npx tailwindcss init -p
   ```

2. Modifiez `tailwind.config.js` :
   ```javascript
   export default {
     content: [
       "./index.html",
       "./src/**/*.{js,ts,jsx,tsx}",
     ],
     theme: {
       extend: {},
     },
     plugins: [],
   }
   ```

3. Modifiez `src/index.css` :
   ```css
   @tailwind base;
   @tailwind components;
   @tailwind utilities;
   ```

4. Importez `index.css` dans `src/main.tsx`

### Étape 4 : Créer la structure des dossiers

Créez la structure suivante dans `src/` :
```
src/
├── components/     # Composants réutilisables
├── pages/         # Pages de l'application
├── services/      # Services API
├── contexts/      # Contextes React
└── types/         # Types TypeScript
```

### Étape 5 : Configurer Vite pour le proxy

Modifiez `vite.config.ts` pour ajouter un proxy vers le backend :
```typescript
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [react()],
  server: {
    port: 3000,
    proxy: {
      '/api': {
        target: 'http://localhost:5000',
        changeOrigin: true
      }
    }
  }
})
```

### Étape 6 : Créer un composant de test

Créez `src/components/TestComponent.tsx` pour tester Tailwind :
```tsx
const TestComponent = () => {
  return (
    <div className="min-h-screen bg-gray-100 flex items-center justify-center">
      <div className="bg-white p-8 rounded-lg shadow-lg">
        <h1 className="text-2xl font-bold text-blue-600 mb-4">
          Frontend configuré !
        </h1>
        <p className="text-gray-700">
          React + TypeScript + Vite + Tailwind CSS
        </p>
      </div>
    </div>
  );
};

export default TestComponent;
```

Affichez ce composant dans `App.tsx` pour vérifier que tout fonctionne.

## ✅ Livrable de la phase

À la fin de cette phase, vous devez avoir :

- [ ] Un dossier `frontend/` avec Vite + React + TypeScript
- [ ] Tailwind CSS installé et configuré
- [ ] La structure de dossiers créée
- [ ] React Router installé
- [ ] Axios installé
- [ ] Le proxy configuré dans Vite
- [ ] `npm run dev` démarre le serveur de développement
- [ ] Tailwind CSS fonctionne (testez avec des classes)

## 🧪 Vérification

1. Démarrez le serveur : `npm run dev`
2. Ouvrez `http://localhost:3000`
3. Vérifiez que l'application s'affiche
4. Testez Tailwind : ajoutez `bg-red-500` à un élément et vérifiez le changement
5. Ouvrez la console du navigateur : pas d'erreurs

**Résultat attendu :**
- Application React fonctionnelle
- Styles Tailwind appliqués
- Pas d'erreurs dans la console

## 🐛 Problèmes courants

- **Erreur Vite** : Vérifiez que vous êtes dans le bon dossier
- **Tailwind ne fonctionne pas** : Vérifiez que `index.css` est importé
- **Port déjà utilisé** : Changez le port dans `vite.config.ts`

## 📝 Notes importantes

- Le proxy permet d'éviter les problèmes CORS en développement
- Tailwind nécessite que les fichiers soient dans `content` du config
- TypeScript vous aidera à détecter les erreurs

## ➡️ Prochaine phase

Une fois cette phase terminée et vérifiée, passez à la **Phase 6 : Service API et gestion de l'authentification**.


