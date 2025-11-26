# Phase 7 : Pages d'authentification

## 🎯 Objectif de la phase

Créer les pages de connexion et d'inscription avec validation et gestion d'erreurs.

## 📚 Rappels techniques essentiels

### React Router
- **React Router** : Bibliothèque pour la navigation
- **BrowserRouter** : Router pour les URLs normales
- **Routes/Route** : Définir les routes
- **Navigate** : Redirection programmatique
- **useNavigate** : Hook pour naviguer

### Formulaires React
- **Controlled Components** : Les inputs sont contrôlés par React state
- **onChange** : Gérer les changements d'input
- **onSubmit** : Gérer la soumission du formulaire
- **e.preventDefault()** : Empêcher le rechargement de page

### Validation
- **Validation côté client** : Vérifier les données avant envoi
- **Messages d'erreur** : Afficher les erreurs à l'utilisateur
- **États de chargement** : Afficher un indicateur pendant la requête

### Gestion d'erreurs
- **try/catch** : Capturer les erreurs
- **Affichage** : Montrer les erreurs à l'utilisateur
- **Messages clairs** : Erreurs compréhensibles

## 🏋️ Exercice pratique : Formulaire avec validation

**Objectif** : Créer un formulaire avec validation

**Instructions :**

Créez `exercice-form/Form.tsx` :
```tsx
import { useState } from 'react';

function Form() {
  const [email, setEmail] = useState('');
  const [error, setError] = useState('');

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    
    if (!email.includes('@')) {
      setError('Email invalide');
      return;
    }
    
    console.log('Email valide:', email);
    setError('');
  };

  return (
    <form onSubmit={handleSubmit}>
      <input
        type="email"
        value={email}
        onChange={(e) => setEmail(e.target.value)}
        placeholder="Email"
      />
      {error && <p className="text-red-500">{error}</p>}
      <button type="submit">Envoyer</button>
    </form>
  );
}
```

**Vérification :**
- ✅ Le formulaire valide l'email
- ✅ Les erreurs s'affichent

## 📋 Tâches du projet

### Étape 1 : Configurer React Router

Dans `frontend/src/App.tsx` :

1. Importez `BrowserRouter`, `Routes`, `Route`, `Navigate`
2. Créez les routes :
   - `/login` → Page Login
   - `/register` → Page Register
   - `/dashboard` → Page Dashboard (protégée, à créer plus tard)
   - `/` → Redirige vers `/dashboard`
3. Enveloppez tout dans `BrowserRouter`

### Étape 2 : Créer la page Login

Créez `frontend/src/pages/Login.tsx`

**Structure attendue :**
1. États :
   - `email` et `password` (formulaire)
   - `error` (message d'erreur)
   - `isLoading` (état de chargement)

2. Fonction `handleSubmit` :
   - Empêcher le comportement par défaut
   - Appeler `login` du contexte
   - Gérer les erreurs
   - Rediriger vers `/dashboard` en cas de succès

3. JSX :
   - Formulaire avec deux inputs (email, password)
   - Bouton de soumission
   - Affichage des erreurs
   - Lien vers la page Register

**Styling avec Tailwind :**
- Utilisez des classes pour un design moderne
- Centrer le formulaire
- Ajouter des styles pour les inputs et le bouton

### Étape 3 : Créer la page Register

Créez `frontend/src/pages/Register.tsx`

**Structure similaire à Login mais avec :**
- Un champ supplémentaire : `username`
- Validation des champs
- Messages d'erreur appropriés
- Lien vers la page Login

**Validation à implémenter :**
- Email valide (format)
- Mot de passe minimum 6 caractères
- Username minimum 3 caractères

### Étape 4 : Créer un composant PrivateRoute

Créez `frontend/src/components/PrivateRoute.tsx`

**Fonctionnalité :**
- Vérifie si l'utilisateur est authentifié
- Si oui : affiche les enfants
- Si non : redirige vers `/login`

**À faire :**
1. Utilisez `useAuth()` pour vérifier l'authentification
2. Utilisez `Navigate` pour rediriger
3. Gérez l'état de chargement (pendant la vérification)

### Étape 5 : Protéger la route Dashboard

Dans `App.tsx` :
1. Importez `PrivateRoute`
2. Enveloppez la route `/dashboard` avec `<PrivateRoute>`

### Étape 6 : Améliorer l'UX

**Ajouts :**
- Indicateur de chargement sur les boutons
- Désactiver le bouton pendant le chargement
- Messages de succès (optionnel)
- Validation en temps réel (optionnel)

## ✅ Livrable de la phase

À la fin de cette phase, vous devez avoir :

- [ ] Page Login fonctionnelle
- [ ] Page Register fonctionnelle
- [ ] React Router configuré
- [ ] Composant PrivateRoute créé
- [ ] Validation des formulaires
- [ ] Gestion des erreurs
- [ ] Redirection après connexion/inscription
- [ ] Design avec Tailwind CSS

## 🧪 Vérification

Testez le flux complet :

1. **Inscription :**
   - Allez sur `/register`
   - Remplissez le formulaire
   - Soumettez
   - Vérifiez la redirection vers `/dashboard`
   - Vérifiez que le token est dans localStorage

2. **Connexion :**
   - Déconnectez-vous (supprimez le token)
   - Allez sur `/login`
   - Connectez-vous
   - Vérifiez la redirection

3. **Protection :**
   - Déconnectez-vous
   - Essayez d'accéder à `/dashboard`
   - Vérifiez la redirection vers `/login`

4. **Erreurs :**
   - Testez avec de mauvais identifiants
   - Vérifiez que l'erreur s'affiche

## 🐛 Problèmes courants

- **Redirection infinie** : Vérifiez la logique de PrivateRoute
- **Erreur non affichée** : Vérifiez la gestion d'erreurs dans handleSubmit
- **Token non sauvegardé** : Vérifiez le contexte AuthContext

## 📝 Notes importantes

- Toujours valider les données côté client ET serveur
- Gérer les états de chargement pour une meilleure UX
- Messages d'erreur clairs et utiles
- Design responsive

## ➡️ Prochaine phase

Une fois cette phase terminée et vérifiée, passez à la **Phase 8 : Interface de gestion des tâches**.


