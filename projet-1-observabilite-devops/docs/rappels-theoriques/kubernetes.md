# Rappels théoriques : Kubernetes

## Introduction

Kubernetes (K8s) est un système open source d'orchestration de conteneurs qui automatise le déploiement, la mise à l'échelle et la gestion des applications conteneurisées.

## Concepts fondamentaux

### Cluster Kubernetes

Un cluster est composé de :
- **Master (Control Plane)** : Gère le cluster
- **Nodes (Workers)** : Exécutent les applications

### Pods

**Définition** : Plus petite unité déployable dans Kubernetes. Un Pod contient un ou plusieurs conteneurs qui partagent :
- Réseau (même IP)
- Stockage (volumes)
- Namespace

**Exemple** :
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: example-pod
spec:
  containers:
  - name: app
    image: nginx:latest
    ports:
    - containerPort: 80
```

### Deployments

**Définition** : Gère les Pods et assure la disponibilité de l'application.

**Fonctionnalités** :
- Réplication (nombre de Pods)
- Mise à jour progressive (rolling update)
- Rollback automatique

**Exemple** :
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: example-deployment
spec:
  replicas: 3
  selector:
    matchLabels:
      app: example
  template:
    metadata:
      labels:
        app: example
    spec:
      containers:
      - name: app
        image: nginx:latest
        ports:
        - containerPort: 80
```

### Services

**Définition** : Expose les Pods avec une IP stable et un DNS.

**Types** :
- **ClusterIP** : IP interne au cluster (défaut)
- **NodePort** : Expose sur un port de chaque node
- **LoadBalancer** : IP externe (cloud)

**Exemple** :
```yaml
apiVersion: v1
kind: Service
metadata:
  name: example-service
spec:
  selector:
    app: example
  ports:
  - port: 80
    targetPort: 80
  type: LoadBalancer
```

### ConfigMaps et Secrets

**ConfigMap** : Stocke la configuration non sensible
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
data:
  config.yaml: |
    key: value
```

**Secret** : Stocke les données sensibles (chiffrées en base64)
```yaml
apiVersion: v1
kind: Secret
metadata:
  name: app-secret
type: Opaque
data:
  password: cGFzc3dvcmQ=  # base64
```

## Monitoring avec Prometheus dans Kubernetes

### Service Discovery

Prometheus découvre automatiquement les Pods via :
- **Kubernetes API** : Interroge l'API pour trouver les Pods
- **Annotations** : Labels sur les Pods pour le scraping

**Exemple d'annotation** :
```yaml
metadata:
  annotations:
    prometheus.io/scrape: "true"
    prometheus.io/port: "9090"
    prometheus.io/path: "/metrics"
```

### ServiceMonitor (Prometheus Operator)

Si vous utilisez Prometheus Operator :
```yaml
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: example-monitor
spec:
  selector:
    matchLabels:
      app: example
  endpoints:
  - port: metrics
    interval: 30s
```

## Déploiement d'une application dans Kubernetes

### Étape 1 : Créer le Deployment

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: example-app
spec:
  replicas: 2
  selector:
    matchLabels:
      app: example-app
  template:
    metadata:
      labels:
        app: example-app
    spec:
      containers:
      - name: app
        image: your-registry/example-app:latest
        ports:
        - containerPort: 5000
        env:
        - name: ENV
          value: "production"
```

### Étape 2 : Exposer avec un Service

```yaml
apiVersion: v1
kind: Service
metadata:
  name: example-app-service
spec:
  selector:
    app: example-app
  ports:
  - port: 80
    targetPort: 5000
  type: LoadBalancer
```

### Étape 3 : Configurer Prometheus

```yaml
# prometheus-configmap.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: prometheus-config
data:
  prometheus.yml: |
    scrape_configs:
      - job_name: 'kubernetes-pods'
        kubernetes_sd_configs:
          - role: pod
        relabel_configs:
          - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_scrape]
            action: keep
            regex: true
```

## Exercices pratiques

### Exercice 1 : Déployer une application simple

**Objectif** : Déployer une application Flask dans Kubernetes avec monitoring.

**Tâches** :
1. Créez un Deployment pour une application Flask
2. Exposez-la avec un Service
3. Configurez les annotations Prometheus
4. Vérifiez que Prometheus scrape les métriques

**Solution** : Voir `corrections/EXERCICE-1-KUBERNETES.md.encrypted`

### Exercice 2 : Mise à l'échelle automatique

**Objectif** : Configurer l'auto-scaling basé sur les métriques CPU.

**Tâches** :
1. Créez un HorizontalPodAutoscaler (HPA)
2. Configurez les métriques CPU
3. Testez la mise à l'échelle

**Solution** : Voir `corrections/EXERCICE-2-HPA.md.encrypted`

### Exercice 3 : Service Discovery avec Prometheus

**Objectif** : Configurer la découverte automatique des Pods.

**Tâches** :
1. Configurez Prometheus pour découvrir les Pods Kubernetes
2. Ajoutez les annotations nécessaires
3. Vérifiez que les métriques sont collectées

**Solution** : Voir `corrections/EXERCICE-3-SERVICE-DISCOVERY.md.encrypted`

## Commandes Kubernetes essentielles

```bash
# Lister les Pods
kubectl get pods

# Décrire un Pod
kubectl describe pod <pod-name>

# Logs d'un Pod
kubectl logs <pod-name>

# Exécuter une commande dans un Pod
kubectl exec -it <pod-name> -- /bin/bash

# Appliquer un fichier YAML
kubectl apply -f deployment.yaml

# Supprimer une ressource
kubectl delete -f deployment.yaml

# Port-forward pour accéder localement
kubectl port-forward <pod-name> 8080:80
```

## Bonnes pratiques

1. **Labels cohérents** : Utilisez des labels standards
2. **Resource limits** : Définissez toujours des limites CPU/mémoire
3. **Health checks** : Configurez liveness et readiness probes
4. **Secrets** : Ne commitez jamais les secrets, utilisez Kubernetes Secrets
5. **Namespaces** : Organisez les ressources avec des namespaces

## Ressources supplémentaires

- [Documentation officielle Kubernetes](https://kubernetes.io/docs/)
- [Kubernetes en pratique](https://kubernetes.io/docs/tutorials/)
- [Prometheus Operator](https://github.com/prometheus-operator/prometheus-operator)

