# Etape 04 : Visualisation avec Kibana

## Objectif

Creer des visualisations et des dashboards dans Kibana pour analyser les donnees de pollution.

## Duree estimee

45 minutes-1h

## Instructions pas a pas

### Etape 4.1 : Acceder a Kibana

Ouvrez votre navigateur et allez sur :

http://localhost:5601

### Etape 4.2 : Configurer l'index pattern

1. Dans Kibana, cliquez sur "Management" (icone d'engrenage) dans le menu de gauche
2. Cliquez sur "Index Patterns"
3. Cliquez sur "Create index pattern"
4. Dans "Index pattern name", entrez : `pollution-*`
5. Cliquez sur "Next step"
6. Dans "Time field", selectionnez `@timestamp`
7. Cliquez sur "Create index pattern"

### Etape 4.3 : Explorer les donnees

1. Cliquez sur "Discover" dans le menu de gauche
2. Vous devriez voir les donnees de pollution
3. Utilisez les filtres pour explorer les donnees :
   - Filtrez par ville (ex: ville:Paris)
   - Filtrez par polluant (ex: polluant:NO2)
   - Filtrez par date

### Etape 4.4 : Creer une visualisation

1. Cliquez sur "Visualize Library" dans le menu de gauche
2. Cliquez sur "Create visualization"
3. Selectionnez "Vertical Bar" (graphique en barres)
4. Selectionnez l'index pattern `pollution-*`
5. Configurez la visualisation :
   - X-axis : Aggregation = "Terms", Field = "ville.keyword"
   - Y-axis : Aggregation = "Average", Field = "valeur"
   - Add sub-buckets : Split series, Aggregation = "Terms", Field = "polluant.keyword"
6. Cliquez sur "Update" pour voir le graphique
7. Cliquez sur "Save" et donnez un nom a votre visualisation

### Etape 4.5 : Creer un dashboard

1. Cliquez sur "Dashboards" dans le menu de gauche
2. Cliquez sur "Create dashboard"
3. Cliquez sur "Add" pour ajouter des visualisations
4. Selectionnez les visualisations que vous avez creees
5. Arrangez-les sur le dashboard
6. Cliquez sur "Save" et donnez un nom a votre dashboard

### Etape 4.6 : Creer d'autres visualisations

Essayez de creer :
- Un graphique en ligne montrant l'evolution de la pollution dans le temps
- Un graphique circulaire montrant la repartition par polluant
- Une carte de chaleur (heat map) montrant les valeurs par ville et polluant

## Verification

Avant de passer a l'etape suivante, verifiez que :

- [ ] L'index pattern `pollution-*` est cree
- [ ] Vous pouvez voir les donnees dans Discover
- [ ] Au moins une visualisation est creee
- [ ] Un dashboard est cree avec plusieurs visualisations

## Problemes courants

### Aucune donnee dans Kibana

**Solution** : Verifiez que Logstash a bien traite les donnees avec `docker-compose logs logstash`

### L'index pattern n'apparait pas

**Solution** : Attendez quelques secondes et actualisez la page. Verifiez aussi que les donnees sont bien indexees dans Elasticsearch

### Les visualisations ne s'affichent pas

**Solution** : Verifiez que vous avez selectionne le bon index pattern et que les champs existent

## Prochaine etape

Une fois cette etape validee, passez a :
[Etape 05 : CI/CD GitLab](ETAPE-05-CICD-GITLAB.md)
