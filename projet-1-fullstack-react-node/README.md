# Projet M2DI-EDO - Application Web Full-Stack

## Bienvenue dans votre projet de développement full-stack

Ce document est votre guide principal pour réaliser votre projet de Master 2. Vous allez développer une application web complète en suivant une approche pédagogique progressive, phase par phase.

## Vue d'ensemble du projet

Vous allez créer une **application de gestion de tâches (Todo App)** complète avec une architecture full-stack moderne. Ce projet vous permettra de maîtriser les technologies essentielles du développement web moderne et de comprendre comment les différentes parties d'une application communiquent entre elles.

### Contexte pédagogique

Ce projet a été conçu spécifiquement pour les étudiants de M2DI-EDO. Il combine théorie et pratique pour vous permettre de :
- Comprendre l'architecture d'une application full-stack
- Maîtriser les technologies modernes du développement web
- Appliquer les bonnes pratiques de développement
- Déployer une application en production

### Technologies utilisées

**Backend :**
- Node.js : Runtime JavaScript côté serveur
- Express : Framework web pour Node.js
- TypeScript : Typage statique pour JavaScript
- MongoDB : Base de données NoSQL
- Mongoose : ODM (Object Document Mapper) pour MongoDB
- JWT : Authentification stateless

**Frontend :**
- React 18 : Bibliothèque JavaScript pour les interfaces utilisateur
- TypeScript : Typage statique
- Vite : Build tool moderne et performant
- Tailwind CSS : Framework CSS utility-first
- Axios : Client HTTP pour les requêtes API
- React Router : Gestion de la navigation

## Objectifs pédagogiques

À la fin de ce projet, vous serez capable de :

### Compétences techniques

1. **Développement backend**
   - Créer une API REST avec Express et TypeScript
   - Gérer une base de données MongoDB avec Mongoose
   - Implémenter un système d'authentification sécurisé avec JWT
   - Créer des endpoints CRUD complets
   - Gérer les erreurs et valider les données

2. **Développement frontend**
   - Créer des composants React réutilisables avec TypeScript
   - Gérer l'état de l'application (local et global)
   - Implémenter la navigation avec React Router
   - Communiquer avec une API REST
   - Créer une interface utilisateur moderne et responsive

3. **Intégration et déploiement**
   - Connecter le frontend au backend
   - Gérer l'authentification côté client
   - Déployer une application full-stack
   - Configurer les variables d'environnement

### Compétences méthodologiques

- Structurer un projet de manière professionnelle
- Suivre une méthodologie de développement par phases
- Utiliser Git pour le versionnement
- Documenter son code
- Tester son application

## Structure du projet

```
projet-1-fullstack-react-node/
├── README.md                    # Ce fichier - Guide général
├── phases/                      # Guide pédagogique par phase
│   ├── phase-1-backend-setup/   # Configuration backend
│   ├── phase-2-database-models/ # Modèles de données
│   ├── phase-3-authentication/     # Authentification JWT
│   ├── phase-4-api-crud/        # API CRUD
│   ├── phase-5-frontend-setup/   # Configuration frontend
│   ├── phase-6-api-services/    # Services API
│   ├── phase-7-auth-pages/      # Pages d'authentification
│   ├── phase-8-tasks-interface/  # Interface de gestion
│   ├── phase-9-styling-ux/      # Styling et UX
│   └── phase-10-deployment/     # Déploiement
├── docs/                        # Documentation et ressources
│   ├── architecture.md          # Architecture de l'application
│   └── api-endpoints.md         # Documentation des endpoints
└── starter/                     # Code minimal de démarrage (optionnel)
```

## Plan des phases - Vue d'ensemble

Le projet est organisé en 10 phases progressives. Chaque phase construit sur la précédente et vous amène progressivement vers une application complète.

### Phase 1 : Configuration initiale du backend
**Durée estimée :** 2-3 heures  
**Objectif :** Mettre en place le serveur Express avec TypeScript  
**Livrable :** Serveur Express fonctionnel qui répond aux requêtes HTTP  
**Concepts clés :** Node.js, Express, TypeScript, variables d'environnement

### Phase 2 : Configuration de MongoDB et modèles
**Durée estimée :** 2-3 heures  
**Objectif :** Connecter MongoDB et créer les modèles de données  
**Livrable :** Modèles User et Task créés, connexion MongoDB opérationnelle  
**Concepts clés :** MongoDB, Mongoose, Schémas, Modèles

### Phase 3 : Routes et contrôleurs d'authentification
**Durée estimée :** 3-4 heures  
**Objectif :** Implémenter l'inscription et la connexion des utilisateurs  
**Livrable :** Endpoints d'authentification fonctionnels avec JWT  
**Concepts clés :** JWT, bcrypt, Middleware, Contrôleurs

### Phase 4 : API CRUD pour les tâches
**Durée estimée :** 3-4 heures  
**Objectif :** Créer les endpoints pour gérer les tâches  
**Livrable :** API complète pour créer, lire, modifier et supprimer des tâches  
**Concepts clés :** CRUD, REST, Protection de routes

### Phase 5 : Configuration du frontend React
**Durée estimée :** 2-3 heures  
**Objectif :** Initialiser le projet React avec Vite et TypeScript  
**Livrable :** Application React fonctionnelle avec Tailwind CSS configuré  
**Concepts clés :** React, Vite, TypeScript, Tailwind CSS

### Phase 6 : Service API et gestion de l'authentification
**Durée estimée :** 2-3 heures  
**Objectif :** Créer les services pour communiquer avec l'API backend  
**Livrable :** Services API fonctionnels et contexte d'authentification  
**Concepts clés :** Axios, Context API, localStorage

### Phase 7 : Pages d'authentification
**Durée estimée :** 3-4 heures  
**Objectif :** Créer les pages de connexion et d'inscription  
**Livrable :** Pages Login et Register fonctionnelles avec validation  
**Concepts clés :** React Router, Formulaires, Validation

### Phase 8 : Interface de gestion des tâches
**Durée estimée :** 4-5 heures  
**Objectif :** Créer l'interface principale pour afficher et gérer les tâches  
**Livrable :** Dashboard complet avec toutes les fonctionnalités CRUD  
**Concepts clés :** useState, useEffect, Gestion d'état, Listes

### Phase 9 : Styling et UX
**Durée estimée :** 3-4 heures  
**Objectif :** Améliorer l'interface utilisateur avec Tailwind CSS  
**Livrable :** Interface responsive et moderne avec animations  
**Concepts clés :** Responsive Design, UX/UI, Animations

### Phase 10 : Tests et déploiement
**Durée estimée :** 3-4 heures  
**Objectif :** Tester l'application et la déployer  
**Livrable :** Application déployée et accessible en ligne  
**Concepts clés :** Tests, Build, Déploiement, Variables d'environnement

**Durée totale estimée :** 30-40 heures

## Comment utiliser ce guide

### Méthodologie recommandée

1. **Lisez d'abord ce README** pour comprendre la vision globale du projet
2. **Suivez les phases dans l'ordre** - chaque phase construit sur la précédente
3. **Pour chaque phase :**
   - Lisez attentivement les rappels techniques
   - Réalisez l'exercice pratique (fichier EXERCICE.md)
   - Suivez les instructions étape par étape
   - Vérifiez les livrables avant de passer à la suivante
4. **Testez régulièrement** votre code
5. **Commitez votre travail** après chaque phase réussie

### Conseils pour réussir

- **Prenez votre temps** : Ne précipitez pas les phases
- **Testez souvent** : Vérifiez que votre code fonctionne à chaque étape
- **Lisez les erreurs** : Les messages d'erreur sont vos amis, ils vous indiquent le problème
- **Documentez** : Notez vos choix et vos difficultés
- **Demandez de l'aide** : Si vous êtes bloqué plus de 30 minutes, n'hésitez pas

## Prérequis

Avant de commencer, assurez-vous d'avoir :

### Logiciels installés

- **Node.js** (version 18 ou supérieure) : [nodejs.org](https://nodejs.org)
- **npm** (inclus avec Node.js) : Gestionnaire de paquets
- **MongoDB** : Base de données
  - Option locale : [mongodb.com](https://www.mongodb.com/try/download/community)
  - Option cloud (recommandée) : [MongoDB Atlas](https://www.mongodb.com/cloud/atlas) (gratuit)
- **Git** : [git-scm.com](https://git-scm.com)
- **Un éditeur de code** : VS Code recommandé avec extensions :
  - ESLint
  - Prettier
  - TypeScript

### Connaissances préalables

- Bases de JavaScript (ES6+)
- Notions de base de HTML/CSS
- Compréhension des concepts de base de données
- Utilisation basique de Git

## Concepts clés à maîtriser

### Architecture full-stack

Une application full-stack se compose de deux parties principales :

1. **Backend (serveur)** : Gère la logique métier, la base de données, l'authentification
2. **Frontend (client)** : Interface utilisateur qui communique avec le backend

Ces deux parties communiquent via une API REST (Representational State Transfer).

### API REST

Une API REST permet au frontend de demander des données au backend via des requêtes HTTP :
- GET : Récupérer des données
- POST : Créer des données
- PUT/PATCH : Modifier des données
- DELETE : Supprimer des données

### Authentification JWT

JWT (JSON Web Token) est un standard pour l'authentification. Un token est généré lors de la connexion et doit être envoyé avec chaque requête pour accéder aux ressources protégées.

### Base de données MongoDB

MongoDB est une base de données NoSQL orientée documents. Les données sont stockées sous forme de documents JSON (BSON).

## Commandes essentielles

### Backend

```bash
# Installer les dépendances
npm install

# Démarrer en mode développement (avec rechargement automatique)
npm run dev

# Build de production
npm run build

# Démarrer en production
npm start
```

### Frontend

```bash
# Installer les dépendances
npm install

# Démarrer le serveur de développement
npm run dev

# Build de production
npm run build

# Prévisualiser le build de production
npm run preview
```

## Bonnes pratiques à suivre

### Sécurité

- Ne jamais commiter les fichiers `.env` contenant des secrets
- Toujours valider les données côté serveur
- Utiliser HTTPS en production
- Hasher les mots de passe (jamais en clair)

### Code

- Utiliser des noms de variables et fonctions clairs
- Commenter le code complexe
- Suivre les conventions de nommage
- Séparer les responsabilités (routes, contrôleurs, modèles)

### Git

- Commiter régulièrement avec des messages clairs
- Créer des branches pour les fonctionnalités importantes
- Ne jamais commiter les fichiers générés (node_modules, dist, etc.)

## Ressources utiles

### Documentation officielle

- [React Documentation](https://react.dev)
- [Express Documentation](https://expressjs.com)
- [MongoDB Documentation](https://www.mongodb.com/docs/)
- [TypeScript Documentation](https://www.typescriptlang.org/docs/)
- [Tailwind CSS Documentation](https://tailwindcss.com/docs)

### Outils de développement

- [Postman](https://www.postman.com) : Tester les APIs
- [MongoDB Compass](https://www.mongodb.com/products/compass) : Interface graphique pour MongoDB
- [VS Code](https://code.visualstudio.com) : Éditeur de code recommandé

## Aide et support

### Problèmes courants

**Erreur de connexion MongoDB :**
- Vérifiez que MongoDB est démarré (si installation locale)
- Vérifiez l'URL de connexion dans `.env`
- Vérifiez les permissions de l'utilisateur

**Erreur de module non trouvé :**
- Vérifiez que vous avez bien installé les dépendances (`npm install`)
- Vérifiez que vous êtes dans le bon dossier
- Vérifiez les chemins d'import

**Erreur TypeScript :**
- Vérifiez la configuration `tsconfig.json`
- Vérifiez que les types sont correctement importés

### Où trouver de l'aide

1. **Documentation** : Consultez d'abord la documentation officielle
2. **Phases** : Relisez la phase concernée, les exercices contiennent souvent la solution
3. **Stack Overflow** : Recherchez des solutions similaires
4. **Enseignant** : N'hésitez pas à demander de l'aide si vous êtes bloqué

## Checklist de démarrage

Avant de commencer la Phase 1, vérifiez que vous avez :

- [ ] Node.js installé (`node --version`)
- [ ] npm installé (`npm --version`)
- [ ] MongoDB installé ou accès à MongoDB Atlas
- [ ] Git installé et configuré
- [ ] Un éditeur de code installé
- [ ] Postman ou un client HTTP installé (pour tester l'API)
- [ ] Lu et compris ce README
- [ ] Créé un dépôt Git pour votre projet

## Prochaines étapes

1. **Créez votre dépôt Git** (si ce n'est pas déjà fait)
2. **Allez dans le dossier `phases/phase-1-backend-setup/`**
3. **Lisez le README de la Phase 1**
4. **Commencez par l'exercice pratique** (fichier EXERCICE.md)
5. **Suivez les instructions étape par étape**

## Conclusion

Ce projet est conçu pour vous accompagner dans l'apprentissage du développement full-stack. Prenez votre temps, testez régulièrement, et n'hésitez pas à expérimenter. Chaque phase vous apporte de nouvelles compétences qui vous seront utiles dans votre carrière de développeur.

Bon courage pour votre projet !

---

*Note : Ce guide est évolutif. N'hésitez pas à le consulter régulièrement et à prendre des notes sur vos apprentissages.*
