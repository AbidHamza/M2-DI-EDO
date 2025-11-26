# Exercice Phase 5 : Premier composant React avec TypeScript

## 📝 Exercice à réaliser

Créez une application React avec :
1. Composant de compteur avec useState
2. Composant de formulaire avec gestion d'état
3. Liste d'éléments avec map()
4. Styling avec Tailwind CSS

## ✅ Correction complète

```tsx
// src/App.tsx
import { useState } from 'react';

interface Item {
  id: number;
  text: string;
}

function App() {
  const [count, setCount] = useState<number>(0);
  const [items, setItems] = useState<Item[]>([]);
  const [input, setInput] = useState<string>('');

  const addItem = () => {
    if (!input.trim()) return;
    
    const newItem: Item = {
      id: Date.now(),
      text: input.trim()
    };
    
    setItems([...items, newItem]);
    setInput('');
  };

  const deleteItem = (id: number) => {
    setItems(items.filter(item => item.id !== id));
  };

  return (
    <div className="min-h-screen bg-gray-100 py-8 px-4">
      <div className="max-w-2xl mx-auto">
        <h1 className="text-3xl font-bold text-center mb-8">
          Exercice React + TypeScript
        </h1>

        {/* Compteur */}
        <div className="bg-white p-6 rounded-lg shadow mb-6">
          <h2 className="text-xl font-semibold mb-4">Compteur</h2>
          <div className="flex items-center space-x-4">
            <button
              onClick={() => setCount(count - 1)}
              className="bg-red-500 text-white px-4 py-2 rounded hover:bg-red-600"
            >
              -
            </button>
            <span className="text-2xl font-bold">{count}</span>
            <button
              onClick={() => setCount(count + 1)}
              className="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600"
            >
              +
            </button>
            <button
              onClick={() => setCount(0)}
              className="bg-gray-500 text-white px-3 py-2 rounded hover:bg-gray-600"
            >
              Reset
            </button>
          </div>
        </div>

        {/* Formulaire */}
        <div className="bg-white p-6 rounded-lg shadow mb-6">
          <h2 className="text-xl font-semibold mb-4">Ajouter un élément</h2>
          <div className="flex space-x-2">
            <input
              type="text"
              value={input}
              onChange={(e) => setInput(e.target.value)}
              onKeyPress={(e) => e.key === 'Enter' && addItem()}
              placeholder="Nouvel élément"
              className="flex-1 px-4 py-2 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-500"
            />
            <button
              onClick={addItem}
              className="bg-green-500 text-white px-6 py-2 rounded hover:bg-green-600"
            >
              Ajouter
            </button>
          </div>
        </div>

        {/* Liste */}
        <div className="bg-white p-6 rounded-lg shadow">
          <h2 className="text-xl font-semibold mb-4">
            Liste ({items.length} élément{items.length > 1 ? 's' : ''})
          </h2>
          
          {items.length === 0 ? (
            <p className="text-gray-500 text-center py-8">
              Aucun élément. Ajoutez-en un !
            </p>
          ) : (
            <ul className="space-y-2">
              {items.map((item) => (
                <li
                  key={item.id}
                  className="flex items-center justify-between p-3 bg-gray-50 rounded hover:bg-gray-100"
                >
                  <span>{item.text}</span>
                  <button
                    onClick={() => deleteItem(item.id)}
                    className="text-red-500 hover:text-red-700 px-2"
                  >
                    Supprimer
                  </button>
                </li>
              ))}
            </ul>
          )}
        </div>
      </div>
    </div>
  );
}

export default App;
```

## 📚 Explications détaillées

### 1. useState avec TypeScript

```tsx
const [count, setCount] = useState<number>(0);
```

**Explication :**
- `<number>` : Type générique TypeScript
- `0` : Valeur initiale
- `[count, setCount]` : Destructuring du tuple

### 2. Interface pour les types

```tsx
interface Item {
  id: number;
  text: string;
}
```

**Explication :**
- Définit la structure d'un Item
- TypeScript vérifie la conformité

### 3. Mise à jour d'état immuable

```tsx
setItems([...items, newItem]);
```

**Explication :**
- `[...items]` : Spread operator (copie)
- Ajoute le nouvel élément
- Ne modifie pas l'état directement

### 4. Filtrage d'éléments

```tsx
setItems(items.filter(item => item.id !== id));
```

**Explication :**
- `filter()` : Crée un nouveau tableau
- Garde tous les éléments sauf celui avec l'ID

### 5. Rendu conditionnel

```tsx
{items.length === 0 ? (
  <p>Aucun élément</p>
) : (
  <ul>...</ul>
)}
```

**Explication :**
- Opérateur ternaire
- Affiche conditionnellement

### 6. map() pour les listes

```tsx
{items.map((item) => (
  <li key={item.id}>{item.text}</li>
))}
```

**Explication :**
- `map()` : Transforme chaque élément
- `key` : Identifiant unique requis par React

## 🧪 Comment tester

1. **Démarrer le serveur :**
   ```bash
   npm run dev
   ```

2. **Tester les fonctionnalités :**
   - Cliquez sur + et - pour le compteur
   - Ajoutez des éléments dans la liste
   - Supprimez des éléments

## ✅ Checklist

- [ ] Le compteur fonctionne
- [ ] Le formulaire ajoute des éléments
- [ ] La liste affiche les éléments
- [ ] La suppression fonctionne
- [ ] Tailwind CSS est appliqué
- [ ] Pas d'erreurs TypeScript

---

**Excellent ! Vous maîtrisez React avec TypeScript ! 🎉**

