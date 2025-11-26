# Phase 8 : Interface de gestion des tâches

## 🎯 Objectif de la phase

Créer l'interface principale pour afficher, créer, modifier et supprimer les tâches.

## 📚 Rappels techniques essentiels

### useEffect
- **useEffect** : Hook pour les effets de bord
- **Dépendances** : Tableau de dépendances `[deps]`
- **Nettoyage** : Fonction de retour pour nettoyer
- **Chargement initial** : Charger les données au montage

### State Management
- **useState** : Gérer l'état local
- **Lifting State Up** : Remonter l'état si nécessaire
- **State Updates** : Mettre à jour l'état de manière immuable

### List Rendering
- **map()** : Rendre une liste d'éléments
- **key prop** : Identifiant unique pour chaque élément
- **Conditional Rendering** : Afficher conditionnellement

### Event Handlers
- **onClick** : Gérer les clics
- **onChange** : Gérer les changements
- **onSubmit** : Gérer la soumission

## 🏋️ Exercice pratique : Liste avec CRUD

**Objectif** : Créer une liste avec opérations CRUD

**Instructions :**

Créez `exercice-list/App.tsx` :
```tsx
import { useState } from 'react';

interface Item {
  id: number;
  text: string;
}

function App() {
  const [items, setItems] = useState<Item[]>([]);
  const [input, setInput] = useState('');

  const addItem = () => {
    if (!input.trim()) return;
    setItems([...items, { id: Date.now(), text: input }]);
    setInput('');
  };

  const deleteItem = (id: number) => {
    setItems(items.filter(item => item.id !== id));
  };

  return (
    <div>
      <input
        value={input}
        onChange={(e) => setInput(e.target.value)}
        placeholder="Nouvel élément"
      />
      <button onClick={addItem}>Ajouter</button>
      
      <ul>
        {items.map(item => (
          <li key={item.id}>
            {item.text}
            <button onClick={() => deleteItem(item.id)}>Supprimer</button>
          </li>
        ))}
      </ul>
    </div>
  );
}
```

**Vérification :**
- ✅ Vous pouvez ajouter des éléments
- ✅ Vous pouvez supprimer des éléments

## 📋 Tâches du projet

### Étape 1 : Créer la page Dashboard

Créez `frontend/src/pages/Dashboard.tsx`

**Structure :**
1. États :
   - `tasks` : Liste des tâches
   - `isLoading` : État de chargement
   - `filter` : Filtre actif ('all', 'active', 'completed')

2. useEffect :
   - Charger les tâches au montage du composant
   - Appeler `getTasks()` du service

3. Fonctions :
   - `loadTasks()` : Charger les tâches depuis l'API
   - `handleCreateTask()` : Créer une nouvelle tâche
   - `handleUpdateTask()` : Mettre à jour une tâche
   - `handleDeleteTask()` : Supprimer une tâche

4. JSX :
   - Header avec nom d'utilisateur et bouton logout
   - Formulaire de création de tâche
   - Filtres (Toutes, Actives, Complétées)
   - Liste des tâches

### Étape 2 : Créer le composant TaskForm

Créez `frontend/src/components/TaskForm.tsx`

**Props :**
- `onCreateTask: (title: string, description?: string) => void`

**Fonctionnalité :**
- Formulaire avec `title` (requis) et `description` (optionnel)
- Bouton de soumission
- Réinitialiser le formulaire après création

**Styling :** Utilisez Tailwind pour un design moderne

### Étape 3 : Créer le composant TaskList

Créez `frontend/src/components/TaskList.tsx`

**Props :**
- `tasks: Task[]`
- `onUpdateTask: (id: string, updates: {...}) => void`
- `onDeleteTask: (id: string) => void`

**Fonctionnalité :**
- Afficher la liste des tâches
- Gérer le cas vide (aucune tâche)
- Passer les props à TaskItem

### Étape 4 : Créer le composant TaskItem

Créez `frontend/src/components/TaskItem.tsx`

**Props :**
- `task: Task`
- `onUpdateTask: (id: string, updates: {...}) => void`
- `onDeleteTask: (id: string) => void`

**Fonctionnalité :**
- Afficher le titre et la description
- Checkbox pour marquer comme complété
- Boutons Edit et Delete
- Mode édition (optionnel) : pouvoir modifier directement

**À implémenter :**
1. Checkbox pour `completed`
2. Bouton Delete
3. Affichage conditionnel si complété (style différent)
4. Date de création (optionnel)

### Étape 5 : Implémenter le filtrage

Dans `Dashboard.tsx` :

**Fonction de filtrage :**
```typescript
const filteredTasks = tasks.filter(task => {
  if (filter === 'active') return !task.completed;
  if (filter === 'completed') return task.completed;
  return true;
});
```

**Boutons de filtre :**
- Toutes les tâches
- Tâches actives
- Tâches complétées

### Étape 6 : Intégrer le logout

Dans `Dashboard.tsx` :
1. Utilisez `useAuth()` pour accéder à `logout`
2. Créez un bouton logout dans le header
3. Appelez `logout()` et redirigez vers `/login`

### Étape 7 : Gérer les erreurs

**À faire :**
- Afficher les erreurs lors du chargement
- Afficher les erreurs lors des opérations CRUD
- Messages d'erreur clairs

## ✅ Livrable de la phase

À la fin de cette phase, vous devez avoir :

- [ ] Page Dashboard fonctionnelle
- [ ] Composant TaskForm pour créer des tâches
- [ ] Composant TaskList pour afficher les tâches
- [ ] Composant TaskItem pour chaque tâche
- [ ] Filtrage (toutes, actives, complétées)
- [ ] Création de tâches fonctionnelle
- [ ] Modification de tâches fonctionnelle
- [ ] Suppression de tâches fonctionnelle
- [ ] Marquer comme complété fonctionnel
- [ ] Bouton logout fonctionnel

## 🧪 Vérification

Testez toutes les fonctionnalités :

1. **Création :**
   - Créez une nouvelle tâche
   - Vérifiez qu'elle apparaît dans la liste

2. **Modification :**
   - Modifiez une tâche
   - Vérifiez que les changements sont sauvegardés

3. **Suppression :**
   - Supprimez une tâche
   - Vérifiez qu'elle disparaît

4. **Filtrage :**
   - Testez chaque filtre
   - Vérifiez que seules les tâches correspondantes s'affichent

5. **Complétion :**
   - Marquez une tâche comme complétée
   - Vérifiez le changement visuel

## 🐛 Problèmes courants

- **Tâches ne se chargent pas** : Vérifiez useEffect et l'appel API
- **État non mis à jour** : Vérifiez que vous mettez à jour l'état après les opérations
- **Erreur CORS** : Vérifiez le proxy dans Vite

## 📝 Notes importantes

- Toujours mettre à jour l'état local après les opérations API
- Gérer les états de chargement
- Feedback visuel pour les actions utilisateur
- Design responsive

## ➡️ Prochaine phase

Une fois cette phase terminée et vérifiée, passez à la **Phase 9 : Styling et UX**.


