# Exercice Phase 8 – Alertmanager + Routage des alertes

## Objectif

Créer un fichier `alertmanager.yml` qui :
- route les alertes warning vers un email ;
- route les alertes critical vers un webhook ;
- applique un grouping cohérent pour éviter le spam.

## Étapes guidées

1. **Déployer Alertmanager localement**
   ```bash
   docker run -d --name alertmanager \
     -p 9093:9093 \
     -v $(pwd)/alertmanager.yml:/etc/alertmanager/alertmanager.yml \
     prom/alertmanager
   ```

2. **Écrire `alertmanager.yml`**
   ```yaml
   global:
     resolve_timeout: 5m
     smtp_smarthost: 'smtp.gmail.com:587'
     smtp_from: 'alerts@example.com'
     smtp_auth_username: 'alerts@example.com'
     smtp_auth_password: 'APP_PASSWORD'   # à protéger

   route:
     receiver: default
     group_by: ['alertname', 'environment', 'service']
     group_wait: 10s
     group_interval: 1m
     repeat_interval: 12h
     routes:
       - match:
           severity: critical
         receiver: webhook
       - match:
           severity: warning
         receiver: email

   receivers:
     - name: default
       email_configs:
         - to: 'oncall@example.com'
           send_resolved: true

     - name: email
       email_configs:
         - to: 'team@example.com'
           subject: '[WARNING] {{ .GroupLabels.alertname }}'

     - name: webhook
       webhook_configs:
         - url: 'http://localhost:5001/alerts'
           send_resolved: true
   ```

3. **Adapter les alertes Prometheus**
   - Ajoutez `labels: { severity: "warning" }` ou `"critical"` dans vos règles.

4. **Tester**
   - Simulez une alerte en changeant un seuil ou en arrêtant l’application.
   - Consultez http://localhost:9093 pour voir les alertes.
   - Vérifiez la réception (email réel ou service webhook mocké).

## Vérifications attendues

- Les alertes apparaissent dans Alertmanager.
- Les emails/webhooks sont envoyés selon la sévérité.
- Le grouping empêche l’envoi massif (une alerte par groupe).

## Solution expliquée

Accès dans `corrections/` (configuration commentée + template d’email). Consultez-la pour comprendre :
- l’impact de `group_wait` et `repeat_interval` ;
- la mise en forme des notifications (templates Go).

## Conseils

- Utilisez un mot de passe d’application pour Gmail (ou un SMTP local).
- Stockez les secrets dans `ansible-vault` avant de les versionner.

