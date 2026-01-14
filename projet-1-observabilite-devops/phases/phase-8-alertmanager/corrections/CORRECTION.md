# Correction Phase 8 : Configuration Alertmanager

## Configuration complète

### alertmanager.yml

```yaml
global:
  resolve_timeout: 5m
  smtp_smarthost: 'smtp.gmail.com:587'
  smtp_from: 'alerts@example.com'
  smtp_auth_username: 'alerts@example.com'
  smtp_auth_password: 'your-password'

route:
  receiver: 'default-receiver'
  group_by: ['alertname', 'cluster', 'service']
  group_wait: 10s
  group_interval: 10s
  repeat_interval: 12h
  
  routes:
    - match:
        severity: critical
      receiver: 'webhook-receiver'
      continue: true
    
    - match:
        severity: warning
      receiver: 'email-receiver'

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

### Configuration Prometheus

Dans `prometheus.yml`, ajoutez :

```yaml
alerting:
  alertmanagers:
    - static_configs:
        - targets:
          - alertmanager:9093
```

### Test

1. Déclenchez une alerte (simulez une erreur)
2. Vérifiez dans Prometheus → Alerts
3. Vérifiez qu'Alertmanager reçoit l'alerte
4. Vérifiez que la notification est envoyée

