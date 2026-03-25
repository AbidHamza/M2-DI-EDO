# Etape 4 : Configuration avec Ansible

## Objectif

Dans cette etape, nous utilisons **Ansible** pour automatiser la configuration de notre stack d'observabilite. Si Terraform provisionne l'infrastructure (creer les conteneurs), Ansible **configure les services** (copier les fichiers de config, demarrer la stack, verifier l'etat).

---

## Pourquoi Ansible ?

### Le probleme sans Ansible

Sans automatisation, deployer la stack necessite de :
1. Se connecter au serveur manuellement
2. Installer Docker
3. Copier les fichiers de configuration un par un
4. Lancer `docker compose up`
5. Verifier que tout fonctionne
6. Configurer Grafana manuellement

Et recommencer pour chaque serveur, chaque environnement, chaque mise a jour...

### La solution Ansible

Avec Ansible, tout cela est decrit dans un **playbook YAML** executable en une commande :

```bash
ansible-playbook -i inventory.ini playbook.yml
```

**Avantages :**
- **Reproductible** : meme resultat a chaque execution
- **Idempotent** : relancer le playbook ne casse rien
- **Versionnable** : les playbooks sont dans Git
- **Sans agent** : Ansible utilise SSH (pas d'installation sur les cibles)
- **Lisible** : YAML est comprehensible meme sans formation

---

## Structure des Fichiers Ansible

```
ansible/
|-- inventory.ini                          # Liste des serveurs cibles
|-- playbook.yml                           # Playbook principal
|-- roles/
    |-- observability/
        |-- tasks/
        |   |-- main.yml                   # Taches du role
        |-- templates/
            |-- prometheus.yml.j2          # Template Prometheus (Jinja2)
            |-- alertmanager.yml.j2        # Template Alertmanager (Jinja2)
```

---

## 1. Inventaire (inventory.ini)

L'inventaire definit les machines cibles. Pour ce projet, nous travaillons en **local** :

```ini
[observability]
localhost ansible_connection=local ansible_python_interpreter=/usr/bin/python3
```

**Explication :**
- `[observability]` : nom du groupe de serveurs
- `localhost` : on execute les taches sur la machine locale
- `ansible_connection=local` : pas de SSH, execution directe
- `ansible_python_interpreter` : chemin vers Python (necessaire pour certains modules)

> **En production**, l'inventaire contiendrait les IPs ou noms DNS des serveurs distants avec connexion SSH.

---

## 2. Playbook Principal (playbook.yml)

Le playbook orchestre l'ensemble du deploiement :

```yaml
---
- name: Deploy Observability Stack
  hosts: observability
  become: yes    # Execution en tant que root (sudo)

  roles:
    - observability

  post_tasks:
    - name: Display access URLs
      debug:
        msg: |
          Stack deployed successfully!
          - Application: http://localhost:5000
          - Prometheus:  http://localhost:9090
          - Grafana:     http://localhost:3000 (admin/admin)
          - Alertmanager: http://localhost:9093
```

**Structure d'un playbook :**
- `name` : description du play
- `hosts` : groupe de serveurs cible (reference l'inventaire)
- `become` : elevation de privileges (sudo)
- `roles` : roles a executer
- `post_tasks` : taches executees apres les roles

---

## 3. Le Role `observability`

### Pourquoi un Role ?

Un role est un **ensemble reutilisable** de taches, templates et fichiers. Plutot que de tout mettre dans le playbook, on organise le code en roles :

```
roles/observability/
|-- tasks/main.yml        # Quoi faire
|-- templates/            # Fichiers de config avec variables
    |-- prometheus.yml.j2
    |-- alertmanager.yml.j2
```

### Taches (tasks/main.yml)

Les taches s'executent **dans l'ordre** et sont **idempotentes** :

1. **Verifier Docker** : s'assurer que Docker et Docker Compose sont installes
2. **Creer les repertoires** : structure de dossiers pour les configurations
3. **Copier les configurations** : templates Jinja2 → fichiers finaux
4. **Demarrer la stack** : `docker compose up -d`
5. **Attendre les services** : verifier que chaque service repond
6. **Configurer Grafana** : ajouter les datasources via l'API

### Idempotence en Pratique

Chaque tache verifie l'etat actuel avant d'agir :

```yaml
# Cette tache ne cree le repertoire que s'il n'existe pas deja
- name: Create configuration directories
  file:
    path: "{{ item }}"
    state: directory
  loop:
    - /opt/observability/prometheus
    - /opt/observability/grafana
```

Si vous relancez le playbook, cette tache affichera `ok` (rien a faire) au lieu de `changed`.

---

## 4. Templates Jinja2

### Pourquoi des Templates ?

Les templates Jinja2 (`.j2`) permettent d'injecter des **variables** dans les fichiers de configuration. Cela rend la configuration **parametrable** :

```yaml
# Dans le template prometheus.yml.j2 :
scrape_configs:
  - job_name: '{{ app_name }}'
    scrape_interval: {{ scrape_interval }}
    static_configs:
      - targets: ['{{ app_host }}:{{ app_port }}']
```

```yaml
# Dans le playbook ou les variables du role :
app_name: flask-app
scrape_interval: 15s
app_host: app
app_port: 5000
```

**Resultat genere :**
```yaml
scrape_configs:
  - job_name: 'flask-app'
    scrape_interval: 15s
    static_configs:
      - targets: ['app:5000']
```

### Avantages des Templates
- **Un seul template** pour dev, staging, prod (seules les variables changent)
- **Lisibilite** : les variables sont nommees de maniere explicite
- **Maintenabilite** : modifier une variable suffit, pas besoin de chercher dans les fichiers

---

## 5. Execution du Playbook

### Lancer le Deploiement

```bash
cd ansible/
ansible-playbook -i inventory.ini playbook.yml
```

### Verifier en Mode Dry-Run

```bash
ansible-playbook -i inventory.ini playbook.yml --check
```

Le mode `--check` simule l'execution sans rien modifier. Utile pour valider avant d'appliquer.

### Mode Verbose

```bash
ansible-playbook -i inventory.ini playbook.yml -vvv
```

Le mode verbose (`-v`, `-vv`, `-vvv`) affiche plus de details sur l'execution.

### Limiter a Certaines Taches

```bash
ansible-playbook -i inventory.ini playbook.yml --tags "config"
```

Les tags permettent d'executer uniquement certaines taches.

---

## 6. Integration Terraform + Ansible

Le workflow complet combine les deux outils :

```
1. terraform apply     → Cree l'infrastructure (conteneurs, reseaux)
2. ansible-playbook    → Configure les services (fichiers, dashboards)
```

Ou, pour ce projet avec Docker Compose :

```
1. ansible-playbook    → Installe Docker, copie les configs, lance docker-compose
```

> Terraform et Ansible sont **complementaires**, pas concurrents. L'un provisionne, l'autre configure.

---

## 7. Points Cles pour le Rapport

- Expliquez le concept d'**idempotence** avec un exemple concret
- Montrez la **sortie du playbook** (taches ok, changed, failed)
- Comparez **Ansible vs scripts Bash** : pourquoi Ansible est preferable
- Detaillez un **template Jinja2** et montrez le fichier genere
- Expliquez comment **passer a l'echelle** (inventaire avec N serveurs)
- Discutez de l'integration **Terraform + Ansible** dans un pipeline CI/CD
