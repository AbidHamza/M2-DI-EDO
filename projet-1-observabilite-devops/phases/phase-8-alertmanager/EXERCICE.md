# Exercice Phase 8 : Configuration Alertmanager

## Exercice à réaliser

Configurez Alertmanager pour router les alertes vers email ou webhook.

## Correction complète

```yaml
# alertmanager.yml
global:
  resolve_timeout: 5m
  # Configuration SMTP pour email
  smtp_smarthost: 'smtp.gmail.com:587'
  smtp_from: 'alerts@example.com'
  smtp_auth_username: 'alerts@example.com'
  smtp_auth_password: 'your-password'

# Templates pour les notifications
templates:
  - '/etc/alertmanager/templates/*.tmpl'

# Configuration du routage
route:
  # Route par défaut
  receiver: 'default-receiver'
  group_by: ['alertname', 'cluster', 'service']
  group_wait: 10s
  group_interval: 10s
  repeat_interval: 12h
  
  # Routes spécifiques
  routes:
    # Alertes critiques vers le webhook
    - match:
        severity: critical
      receiver: 'webhook-receiver'
      continue: true
    
    # Alertes warning vers email
    - match:
        severity: warning
      receiver: 'email-receiver'

# Récepteurs (destinations des alertes)
receivers:
  - name: 'default-receiver'
    email_configs:
      - to: 'admin@example.com'
        subject: 'Alert: {{ .GroupLabels.alertname }}'
        html: '{{ range .Alerts }}{{ .Annotations.description }}{{ end }}'

  - name: 'email-receiver'
    email_configs:
      - to: 'team@example.com'
        subject: 'Warning: {{ .GroupLabels.alertname }}'
        send_resolved: true

  - name: 'webhook-receiver'
    webhook_configs:
      - url: 'http://webhook-server:5000/alerts'
        send_resolved: true
```

## Explications détaillées

**global** : Configuration globale (SMTP, timeouts)

**route** : Configuration du routage des alertes

**group_by** : Regroupe les alertes similaires

**group_wait** : Attend avant d'envoyer un groupe

**receivers** : Destinations des alertes

**email_configs** : Configuration email

**webhook_configs** : Configuration webhook

**match** : Conditions de routage

## Template de notification (optionnel)

```go
// templates/email.tmpl
{{ define "email.default.subject" }}
[{{ .Status | toUpper }}{{ if eq .Status "firing" }}:{{ .Alerts.Firing | len }}{{ end }}] {{ .GroupLabels.alertname }}
{{ end }}

{{ define "email.default.html" }}
{{ range .Alerts }}
Alert: {{ .Labels.alertname }}<br>
Severity: {{ .Labels.severity }}<br>
Description: {{ .Annotations.description }}<br>
{{ end }}
{{ end }}
```

## Vérification

1. Déclenchez une alerte (simulez une erreur)
2. Vérifiez qu'Alertmanager reçoit l'alerte
3. Vérifiez que la notification est envoyée (email/webhook)

## Problèmes courants

- **Emails non reçus** : Vérifiez SMTP et credentials
- **Webhook non appelé** : Vérifiez l'URL et la connectivité
- **Alertes dupliquées** : Ajustez group_wait et group_interval

