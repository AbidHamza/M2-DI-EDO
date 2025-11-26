# Correction Phase 2 : Conception de l'architecture

## Schéma d'architecture à créer

### Architecture complète

```
┌─────────────────────────────────────────────────────────────┐
│                    APPLICATION LAYER                         │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐     │
│  │   App 1      │  │   App 2      │  │   App 3      │     │
│  │  (Flask)     │  │  (Node.js)   │  │  (Python)    │     │
│  │  Port 5000   │  │  Port 3000   │  │  Port 8000   │     │
│  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘     │
│         │                 │                  │              │
│         └─────────────────┴──────────────────┘              │
│                    │                                         │
│                    ▼                                         │
│         ┌──────────────────────┐                            │
│         │   Prometheus         │                            │
│         │   (Scraping)         │                            │
│         │   Port 9090          │                            │
│         └──────────┬───────────┘                            │
└────────────────────┼─────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────┐
│              OBSERVABILITY LAYER                            │
│                                                              │
│  ┌──────────────┐      ┌──────────────┐                    │
│  │  Prometheus  │─────▶│ Alertmanager │                    │
│  │  (Storage)   │      │  (Routing)    │                    │
│  └──────┬───────┘      └──────┬───────┘                    │
│         │                      │                            │
│         │                      ▼                            │
│         │              ┌──────────────┐                    │
│         │              │ Notifications│                    │
│         │              │ (Email/Webhook)                   │
│         │              └──────────────┘                    │
│         │                                                    │
│         ▼                                                    │
│  ┌──────────────┐      ┌──────────────┐                    │
│  │   Grafana    │◀─────│    Loki      │                    │
│  │ (Dashboards) │      │  (Logs)      │                    │
│  │  Port 3000   │      │  Port 3100   │                    │
│  └──────────────┘      └──────┬───────┘                    │
│                                │                            │
│                                ▼                            │
│                        ┌──────────────┐                    │
│                        │  Promtail    │                    │
│                        │ (Log Agent) │                    │
│                        └──────────────┘                    │
└─────────────────────────────────────────────────────────────┘
```

### Flux de données

**Métriques :** Application → /metrics → Prometheus scrape → Storage → Grafana query

**Logs :** Application → stdout → Promtail → Loki → Grafana query

**Alertes :** Prometheus → Rules → Alertmanager → Routing → Notifications

### Intégration Terraform + Ansible

1. Terraform provisionne l'infrastructure
2. Ansible configure et déploie
3. Application supervisée

