# Etape 04 : Visualisation avec Kibana

## Objectif

Creer des visualisations et des dashboards dans Kibana pour analyser les donnees de pollution. Tout se fait en local sur votre ordinateur, aucune donnee n'est envoyee sur Internet.

## Duree estimee

45 minutes-1h

## Prérequis

- Stack ELK demarree et fonctionnelle (etape 03 validee)
- Kibana accessible sur http://localhost:5601
- Donnees indexees dans Elasticsearch

## Important : Tout en local

- Kibana fonctionne sur votre ordinateur uniquement
- Toutes les visualisations sont stockees localement
- Aucune donnee n'est envoyee sur Internet
- Vous pouvez travailler hors ligne une fois Kibana demarre

## Instructions pas a pas avec tous les details

### Etape 4.1 : Acceder a Kibana

**Action** : Ouvrir Kibana dans votre navigateur

1. Ouvrez votre navigateur web (Chrome, Firefox, Edge, Safari, etc.)
2. Dans la barre d'adresse, tapez exactement : `http://localhost:5601`
3. Appuyez sur Entree
4. Attendez que la page se charge (30-60 secondes la premiere fois)

**Ce que vous verrez** :
- Une page de chargement Kibana (logo Elasticsearch/Kibana)
- Puis la page d'accueil de Kibana

**Si la page ne se charge pas** :
- Verifiez que Kibana est demarre : `docker-compose ps`
- Attendez encore 1-2 minutes (Kibana peut etre lent)
- Actualisez la page (F5 ou Ctrl+R)

### Etape 4.2 : Configurer l'index pattern

**Action** : Dire a Kibana quels index utiliser

**Etape 4.2.1 : Acceder a la configuration des index patterns**

1. Dans Kibana, regardez le menu de gauche
2. Vous verrez plusieurs icones
3. Cliquez sur l'icone d'engrenage (Settings) en bas du menu
4. Le menu s'ouvre avec plusieurs options
5. Cliquez sur "Index Patterns" (ou "Index patterns")

**Etape 4.2.2 : Creer un nouvel index pattern**

1. Vous verrez une page avec la liste des index patterns (probablement vide)
2. En haut a droite, vous verrez un bouton "Create index pattern"
3. Cliquez sur ce bouton

**Etape 4.2.3 : Definir le nom de l'index pattern**

1. Dans le champ "Index pattern name", tapez exactement : `pollution-*`
2. Le caractere `*` est un wildcard qui signifie "tous les index commencant par pollution-"
3. Cliquez sur le bouton "Next step" en bas a droite

**Etape 4.2.4 : Selectionner le champ de temps**

1. Kibana vous demande de selectionner un champ de temps
2. Dans la liste "Time field", cherchez `@timestamp`
3. Selectionnez `@timestamp` dans la liste deroulante
4. Cliquez sur "Create index pattern" en bas a droite

**Resultat attendu** :
- Une page de confirmation s'affiche
- Vous voyez "Success" en vert
- Vous voyez des informations sur l'index pattern cree
- Le nombre de champs detectes est affiche (environ 4-5 champs)

**Si vous ne voyez pas @timestamp** :
- Verifiez que les donnees sont bien indexees dans Elasticsearch
- Attendez quelques secondes et actualisez la page
- Verifiez les logs de Logstash : `docker-compose logs logstash`

### Etape 4.3 : Explorer les donnees avec Discover

**Action** : Utiliser Discover pour voir et explorer les donnees

**Etape 4.3.1 : Acceder a Discover**

1. Dans le menu de gauche de Kibana
2. Cliquez sur "Discover" (icone de loupe ou de graphique)
3. La page Discover s'ouvre

**Etape 4.3.2 : Comprendre l'interface Discover**

L'interface Discover est divisee en plusieurs sections :

**Section superieure** :
- Barre de recherche : Pour rechercher dans les donnees
- Filtre temporel : Pour filtrer par periode
- Bouton "Refresh" : Pour actualiser les donnees

**Section centrale** :
- Liste des documents : Affiche les donnees une par une
- Chaque ligne represente une mesure de pollution

**Section inferieure** :
- Liste des champs disponibles
- Statistiques sur les donnees

**Etape 4.3.3 : Voir les donnees**

1. Par defaut, Kibana affiche les donnees des dernieres 15 minutes
2. Cliquez sur le filtre temporel en haut a droite
3. Selectionnez "Last 1 year" ou "Absolute time range"
4. Definissez une periode qui inclut vos donnees (ex: 2023-01-01 a 2023-04-10)
5. Cliquez sur "Update"

**Resultat attendu** :
- Vous devriez voir des lignes de donnees dans la section centrale
- Chaque ligne montre une mesure avec les champs : date, ville, polluant, valeur

**Etape 4.3.4 : Examiner un document en detail**

1. Cliquez sur une ligne de donnees
2. Un panneau s'ouvre a droite avec les details du document
3. Vous verrez tous les champs avec leurs valeurs
4. Fermez le panneau en cliquant sur la croix ou en cliquant ailleurs

**Etape 4.3.5 : Filtrer les donnees**

**Filtrer par ville** :
1. Dans la liste des champs a gauche, trouvez "ville"
2. Cliquez sur "ville"
3. Cliquez sur le bouton "+" a cote d'une ville (ex: Paris)
4. Le filtre est ajoute en haut
5. Seules les donnees de Paris sont affichees

**Filtrer par polluant** :
1. Cliquez sur "polluant" dans la liste des champs
2. Cliquez sur le bouton "+" a cote d'un polluant (ex: NO2)
3. Seules les donnees pour NO2 sont affichees

**Combiner plusieurs filtres** :
- Vous pouvez ajouter plusieurs filtres
- Par exemple : ville=Paris ET polluant=NO2

**Supprimer un filtre** :
- Cliquez sur la croix a cote du filtre en haut

**Etape 4.3.6 : Utiliser la barre de recherche**

Dans la barre de recherche en haut, vous pouvez taper :

- `ville:Paris` : Affiche seulement les donnees de Paris
- `polluant:NO2` : Affiche seulement les donnees pour NO2
- `valeur:>50` : Affiche les valeurs superieures a 50
- `ville:Paris AND polluant:NO2` : Combine plusieurs conditions

**Exemples de recherches** :
```
ville:Paris
polluant:NO2 AND valeur:>60
ville:(Paris OR Lyon)
```

### Etape 4.4 : Creer une premiere visualisation

**Action** : Creer un graphique en barres montrant la moyenne de pollution par ville

**Etape 4.4.1 : Acceder a Visualize Library**

1. Dans le menu de gauche de Kibana
2. Cliquez sur "Visualize Library" (icone de graphique)
3. La page des visualisations s'ouvre

**Etape 4.4.2 : Creer une nouvelle visualisation**

1. En haut a droite, cliquez sur "Create visualization"
2. Une liste de types de visualisations s'affiche
3. Cliquez sur "Vertical Bar" (graphique en barres verticales)

**Etape 4.4.3 : Selectionner l'index pattern**

1. Une nouvelle page s'ouvre
2. Dans "Select a data view", selectionnez "pollution-*"
3. Cliquez sur "Create visualization"

**Etape 4.4.4 : Configurer l'axe X (horizontal)**

1. Dans la section "Data" a gauche, vous verrez "X-axis"
2. Cliquez sur "X-axis" pour l'ouvrir
3. Dans "Aggregation", selectionnez "Terms" dans la liste deroulante
4. Dans "Field", cliquez et selectionnez "ville.keyword"
   - Si vous ne voyez pas "ville.keyword", essayez "ville"
5. Cliquez sur "Update" en haut a droite

**Resultat attendu** :
- Un graphique s'affiche avec 4 barres (une par ville)
- Les barres montrent le nombre de documents par ville

**Etape 4.4.5 : Configurer l'axe Y (vertical) pour la moyenne**

1. Dans la section "Metrics" a gauche, vous verrez "Y-axis"
2. Cliquez sur "Y-axis" pour l'ouvrir
3. Dans "Aggregation", selectionnez "Average" dans la liste deroulante
4. Dans "Field", selectionnez "valeur"
5. Cliquez sur "Update"

**Resultat attendu** :
- Le graphique change
- Les barres montrent maintenant la moyenne de pollution par ville
- Les valeurs sont affichees au-dessus de chaque barre

**Etape 4.4.6 : Ajouter une separation par polluant**

1. Sous "Buckets", cliquez sur "Add" ou "Split series"
2. Dans "Aggregation", selectionnez "Terms"
3. Dans "Field", selectionnez "polluant.keyword" (ou "polluant")
4. Cliquez sur "Update"

**Resultat attendu** :
- Le graphique change
- Chaque ville a maintenant plusieurs barres (une par polluant)
- Les barres sont colorees differemment selon le polluant
- Une legende s'affiche en bas

**Etape 4.4.7 : Sauvegarder la visualisation**

1. En haut a droite, cliquez sur "Save"
2. Dans le champ "Title", donnez un nom a votre visualisation
   - Exemple : "Moyenne de pollution par ville et polluant"
3. Cliquez sur "Confirm" ou "Save"

**Resultat attendu** :
- La visualisation est sauvegardee
- Vous retournez a la page Visualize Library
- Votre visualisation apparaît dans la liste

### Etape 4.5 : Creer un graphique en ligne

**Action** : Creer un graphique montrant l'evolution de la pollution dans le temps

**Etape 4.5.1 : Creer une nouvelle visualisation**

1. Dans Visualize Library, cliquez sur "Create visualization"
2. Selectionnez "Line" (graphique en ligne)
3. Selectionnez l'index pattern "pollution-*"

**Etape 4.5.2 : Configurer l'axe X avec la date**

1. Dans "X-axis", selectionnez :
   - Aggregation : "Date Histogram"
   - Field : "@timestamp"
   - Interval : "Daily" (quotidien)
2. Cliquez sur "Update"

**Etape 4.5.3 : Configurer l'axe Y avec la moyenne**

1. Dans "Y-axis", selectionnez :
   - Aggregation : "Average"
   - Field : "valeur"
2. Cliquez sur "Update"

**Resultat attendu** :
- Un graphique en ligne s'affiche
- L'axe X montre les dates
- L'axe Y montre la moyenne de pollution
- La ligne montre l'evolution dans le temps

**Etape 4.5.4 : Separer par ville**

1. Cliquez sur "Add" sous "Buckets"
2. Selectionnez "Split series"
3. Aggregation : "Terms"
4. Field : "ville.keyword"
5. Cliquez sur "Update"

**Resultat attendu** :
- Plusieurs lignes s'affichent (une par ville)
- Chaque ligne a une couleur differente
- Une legende montre les villes

**Etape 4.5.5 : Sauvegarder**

1. Cliquez sur "Save"
2. Donnez un nom : "Evolution de la pollution dans le temps"
3. Confirmez

### Etape 4.6 : Creer un graphique circulaire (pie chart)

**Action** : Creer un graphique montrant la repartition par polluant

**Etape 4.6.1 : Creer une nouvelle visualisation**

1. Cliquez sur "Create visualization"
2. Selectionnez "Pie" (graphique circulaire)
3. Selectionnez "pollution-*"

**Etape 4.6.2 : Configurer le graphique**

1. Dans "Slice by", selectionnez :
   - Aggregation : "Terms"
   - Field : "polluant.keyword"
2. Dans "Size by", selectionnez :
   - Aggregation : "Sum"
   - Field : "valeur"
3. Cliquez sur "Update"

**Resultat attendu** :
- Un graphique circulaire s'affiche
- Chaque secteur represente un polluant
- La taille de chaque secteur represente la somme des valeurs

**Etape 4.6.3 : Sauvegarder**

1. Cliquez sur "Save"
2. Nommez-la : "Repartition par polluant"
3. Confirmez

### Etape 4.7 : Creer un dashboard

**Action** : Combiner plusieurs visualisations dans un dashboard

**Etape 4.7.1 : Acceder aux dashboards**

1. Dans le menu de gauche, cliquez sur "Dashboards"
2. La page des dashboards s'ouvre

**Etape 4.7.2 : Creer un nouveau dashboard**

1. Cliquez sur "Create dashboard" en haut a droite
2. Une page vide s'ouvre avec "Add panels"

**Etape 4.7.3 : Ajouter des visualisations**

1. Cliquez sur "Add" ou "Add panel"
2. Une liste de vos visualisations s'affiche
3. Cochez les visualisations que vous voulez ajouter :
   - "Moyenne de pollution par ville et polluant"
   - "Evolution de la pollution dans le temps"
   - "Repartition par polluant"
4. Cliquez sur "Add" ou "Add to dashboard"

**Resultat attendu** :
- Les visualisations apparaissent sur le dashboard
- Elles sont arrangees automatiquement

**Etape 4.7.4 : Rearranger les visualisations**

1. Passez la souris sur une visualisation
2. Vous verrez une icone de deplacement en haut a gauche
3. Cliquez et maintenez, puis deplacez la visualisation
4. Relachez pour la placer a la nouvelle position

**Etape 4.7.5 : Redimensionner les visualisations**

1. Passez la souris sur le coin inferieur droit d'une visualisation
2. Le curseur change en fleche de redimensionnement
3. Cliquez et tirez pour redimensionner
4. Relachez quand la taille vous convient

**Etape 4.7.6 : Sauvegarder le dashboard**

1. En haut a droite, cliquez sur "Save"
2. Dans "Title", donnez un nom : "Dashboard Pollution Atmospherique"
3. Cliquez sur "Save"

**Resultat attendu** :
- Le dashboard est sauvegarde
- Vous retournez a la liste des dashboards
- Votre dashboard apparaît dans la liste

### Etape 4.8 : Utiliser le dashboard

**Action** : Explorer et utiliser le dashboard cree

**Etape 4.8.1 : Ouvrir le dashboard**

1. Dans la liste des dashboards, cliquez sur votre dashboard
2. Le dashboard s'ouvre avec toutes les visualisations

**Etape 4.8.2 : Appliquer des filtres globaux**

1. En haut du dashboard, vous verrez une barre de filtres
2. Cliquez sur "Add filter"
3. Selectionnez un champ (ex: ville)
4. Selectionnez une valeur (ex: Paris)
5. Cliquez sur "Save"

**Resultat attendu** :
- Toutes les visualisations du dashboard sont filtrees
- Seules les donnees de Paris sont affichees

**Etape 4.8.3 : Modifier la periode temporelle**

1. En haut a droite, cliquez sur le filtre temporel
2. Selectionnez une nouvelle periode
3. Cliquez sur "Update"

**Resultat attendu** :
- Toutes les visualisations sont mises a jour avec la nouvelle periode

**Etape 4.8.4 : Actualiser les donnees**

1. Cliquez sur le bouton "Refresh" en haut
2. Les donnees sont actualisees depuis Elasticsearch

## Verification complete

Avant de passer a l'etape suivante, verifiez que :

- [ ] Kibana est accessible sur http://localhost:5601
- [ ] L'index pattern `pollution-*` est cree et configure
- [ ] Vous pouvez voir les donnees dans Discover
- [ ] Au moins 3 visualisations differentes sont creees :
  - [ ] Un graphique en barres
  - [ ] Un graphique en ligne
  - [ ] Un graphique circulaire
- [ ] Un dashboard est cree avec plusieurs visualisations
- [ ] Les filtres fonctionnent sur le dashboard
- [ ] Les visualisations s'affichent correctement

## Problemes courants et solutions detaillees

### Probleme 1 : Aucune donnee dans Kibana

**Symptomes** :
- Discover ne montre aucune donnee
- Les visualisations sont vides

**Solutions** :

1. Verifiez que les donnees sont indexees :
   ```bash
   curl http://localhost:9200/_cat/indices?v
   ```
   Vous devriez voir des index "pollution-*"

2. Verifiez les logs de Logstash :
   ```bash
   docker-compose logs logstash | tail -50
   ```
   Cherchez les erreurs

3. Verifiez la periode temporelle dans Discover :
   - Cliquez sur le filtre temporel
   - Selectionnez une periode qui inclut vos donnees (2023-01-01 a 2023-04-10)
   - Cliquez sur "Update"

4. Redemarrez Logstash :
   ```bash
   docker-compose restart logstash
   ```

### Probleme 2 : L'index pattern n'apparait pas

**Symptomes** :
- Vous ne pouvez pas creer l'index pattern
- Le message "No matching indices found" apparait

**Solutions** :

1. Verifiez que les donnees sont indexees dans Elasticsearch :
   ```bash
   curl http://localhost:9200/_cat/indices?v | grep pollution
   ```

2. Attendez quelques minutes et reessayez :
   - Parfois Kibana met du temps a detecter les nouveaux index

3. Verifiez que Logstash fonctionne :
   ```bash
   docker-compose logs logstash
   ```

4. Redemarrez Kibana :
   ```bash
   docker-compose restart kibana
   ```

### Probleme 3 : Les visualisations ne s'affichent pas

**Symptomes** :
- Les visualisations sont vides
- Message d'erreur dans les visualisations

**Solutions** :

1. Verifiez que vous avez selectionne le bon index pattern :
   - Il doit etre "pollution-*"

2. Verifiez que les champs existent :
   - Dans Discover, verifiez que vous voyez les champs : ville, polluant, valeur

3. Verifiez la periode temporelle :
   - Les visualisations utilisent la periode definie en haut
   - Assurez-vous qu'elle inclut vos donnees

4. Verifiez les noms de champs :
   - Utilisez "ville.keyword" et "polluant.keyword" si disponibles
   - Sinon, utilisez "ville" et "polluant"

### Probleme 4 : Les graphiques sont vides

**Symptomes** :
- Les graphiques s'affichent mais sans donnees
- Message "No results found"

**Solutions** :

1. Verifiez la periode temporelle :
   - Cliquez sur le filtre temporel
   - Selectionnez "Last 1 year" ou une periode absolue incluant vos donnees

2. Verifiez les aggregations :
   - Les champs doivent etre correctement selectionnes
   - Utilisez les champs avec ".keyword" si disponibles

3. Actualisez les donnees :
   - Cliquez sur "Refresh" dans Kibana

## Commandes utiles

**Voir les index dans Elasticsearch** :
```bash
curl http://localhost:9200/_cat/indices?v
```

**Compter les documents** :
```bash
curl http://localhost:9200/pollution-*/_count
```

**Rechercher des documents** :
```bash
curl "http://localhost:9200/pollution-*/_search?q=ville:Paris&pretty"
```

## Notes importantes

- Toutes les visualisations sont stockees localement dans Kibana
- Les donnees restent dans Elasticsearch sur votre machine
- Aucune donnee n'est envoyee sur Internet
- Vous pouvez exporter les visualisations et dashboards si besoin
- Les filtres appliques sur le dashboard affectent toutes les visualisations

## Prochaine etape

Une fois cette etape validee avec au moins un dashboard fonctionnel, vous pouvez passer a :
[Etape 05 : CI/CD en local](ETAPE-05-CICD-GITLAB.md)
