# Correction Phase 4 : Premier playbook Ansible

## Correction complète

### Structure du projet Ansible

Créez cette structure :
```
ansible/
├── playbook.yml
├── inventory
└── group_vars/
    └── all.yml
```

### Fichier inventory

```ini
[servers]
localhost ansible_connection=local

# Ou pour un serveur distant
# server1 ansible_host=192.168.1.100 ansible_user=ubuntu
```

**Explications :**
- `[servers]` : Nom du groupe de serveurs
- `localhost` : Nom du serveur
- `ansible_connection=local` : Exécuter localement (pas besoin de SSH)
- Pour un serveur distant, utilisez `ansible_host` et `ansible_user`

### Fichier playbook.yml

```yaml
---
- name: Install Docker and deploy Prometheus
  hosts: all
  become: yes
  tasks:
    - name: Update apt cache (Linux)
      apt:
        update_cache: yes
      when: ansible_os_family == "Debian"
      ignore_errors: yes
    
    - name: Install Docker (Linux)
      apt:
        name:
          - docker.io
          - docker-compose
        state: present
      when: ansible_os_family == "Debian"
      ignore_errors: yes
    
    - name: Start Docker service (Linux)
      systemd:
        name: docker
        state: started
        enabled: yes
      when: ansible_os_family == "Debian"
      ignore_errors: yes
    
    - name: Install Docker Desktop (Windows - nécessite pré-installation manuelle)
      win_chocolatey:
        name: docker-desktop
        state: present
      when: ansible_os_family == "Windows"
      ignore_errors: yes
    
    - name: Create directory for Prometheus config
      file:
        path: /opt/prometheus
        state: directory
        mode: '0755'
      when: ansible_os_family != "Windows"
    
    - name: Create directory for Prometheus config (Windows)
      win_file:
        path: C:\prometheus
        state: directory
      when: ansible_os_family == "Windows"
    
    - name: Copy Prometheus configuration
      copy:
        src: prometheus.yml
        dest: /opt/prometheus/prometheus.yml
        mode: '0644'
      when: ansible_os_family != "Windows"
    
    - name: Copy Prometheus configuration (Windows)
      win_copy:
        src: prometheus.yml
        dest: C:\prometheus\prometheus.yml
      when: ansible_os_family == "Windows"
    
    - name: Deploy Prometheus container
      docker_container:
        name: prometheus
        image: prom/prometheus:latest
        state: started
        restart_policy: unless-stopped
        ports:
          - "9090:9090"
        volumes:
          - /opt/prometheus/prometheus.yml:/etc/prometheus/prometheus.yml
          - prometheus-data:/prometheus
      when: ansible_os_family != "Windows"
    
    - name: Deploy Prometheus container (Windows)
      win_docker_container:
        name: prometheus
        image: prom/prometheus:latest
        state: started
        restart_policy: unless-stopped
        ports:
          - "9090:9090"
        volumes:
          - C:\prometheus\prometheus.yml:/etc/prometheus/prometheus.yml
          - prometheus-data:/prometheus
      when: ansible_os_family == "Windows"
```

### Version simplifiée (Linux/Mac uniquement)

Si vous êtes sur Linux ou Mac, voici une version plus simple :

```yaml
---
- name: Install Docker and deploy Prometheus
  hosts: all
  become: yes
  tasks:
    - name: Update apt cache
      apt:
        update_cache: yes
    
    - name: Install Docker
      apt:
        name:
          - docker.io
          - docker-compose
        state: present
    
    - name: Start Docker service
      systemd:
        name: docker
        state: started
        enabled: yes
    
    - name: Add user to docker group
      user:
        name: "{{ ansible_user }}"
        groups: docker
        append: yes
    
    - name: Create directory for Prometheus config
      file:
        path: /opt/prometheus
        state: directory
        mode: '0755'
    
    - name: Copy Prometheus configuration
      copy:
        src: prometheus.yml
        dest: /opt/prometheus/prometheus.yml
        mode: '0644'
    
    - name: Deploy Prometheus container
      docker_container:
        name: prometheus
        image: prom/prometheus:latest
        state: started
        restart_policy: unless-stopped
        ports:
          - "9090:9090"
        volumes:
          - /opt/prometheus/prometheus.yml:/etc/prometheus/prometheus.yml
          - prometheus-data:/prometheus
```

### Explications détaillées

**name :** Description de la tâche (affichée lors de l'exécution)

**hosts: all :** Exécute sur tous les hosts de l'inventory

**become: yes :** Exécute avec les privilèges root (nécessaire pour installer Docker)

**apt module :** Gère les paquets sur Debian/Ubuntu
- `update_cache: yes` : Met à jour la liste des paquets
- `name` : Liste des paquets à installer
- `state: present` : S'assure que les paquets sont installés

**systemd module :** Gère les services systemd
- `name: docker` : Nom du service
- `state: started` : Démarre le service
- `enabled: yes` : Active le démarrage automatique

**file module :** Gère les fichiers et dossiers
- `path` : Chemin du fichier/dossier
- `state: directory` : Crée un dossier
- `mode` : Permissions (0755 = rwxr-xr-x)

**copy module :** Copie des fichiers
- `src` : Fichier source (relatif au playbook)
- `dest` : Destination
- `mode` : Permissions

**docker_container module :** Gère les conteneurs Docker
- `name` : Nom du conteneur
- `image` : Image Docker à utiliser
- `state: started` : Démarre le conteneur
- `restart_policy` : Politique de redémarrage
- `ports` : Mappage des ports
- `volumes` : Montage de volumes

**when :** Condition d'exécution
- `ansible_os_family == "Debian"` : Exécute seulement sur Debian/Ubuntu

### Commandes d'exécution

**Windows :**
```powershell
# Installer Ansible
pip install ansible

# Aller dans le dossier ansible
cd ansible

# Tester la connexion
ansible all -i inventory -m ping

# Vérifier la syntaxe
ansible-playbook --syntax-check playbook.yml

# Exécuter le playbook
ansible-playbook -i inventory playbook.yml
```

**Linux/Mac :**
```bash
# Installer Ansible
sudo apt install ansible  # Linux
brew install ansible      # Mac

# Aller dans le dossier ansible
cd ansible

# Tester la connexion
ansible all -i inventory -m ping

# Vérifier la syntaxe
ansible-playbook --syntax-check playbook.yml

# Exécuter le playbook
ansible-playbook -i inventory playbook.yml
```

### Vérification

1. **Vérifiez que Docker est installé :**
   ```bash
   docker --version
   ```

2. **Vérifiez que le conteneur tourne :**
   ```bash
   docker ps | grep prometheus
   ```

3. **Accédez à Prometheus :**
   - Ouvrez http://localhost:9090

### Problèmes courants

**Erreur : Permission denied**
- Solution : Utilisez `become: yes` ou exécutez avec `sudo`

**Erreur : Docker module not found**
- Solution : Installez le module Docker pour Ansible
  ```bash
  pip install docker
  ```

**Erreur : Cannot connect to Docker**
- Solution : Vérifiez que Docker est démarré et que l'utilisateur est dans le groupe docker

## Points clés à retenir

1. **Ansible est idempotent** : Vous pouvez exécuter le playbook plusieurs fois sans problème
2. **YAML sensible à l'indentation** : Utilisez 2 espaces, pas de tabulations
3. **Modules réutilisables** : Ansible a des centaines de modules pour tout faire
4. **Inventories flexibles** : Vous pouvez gérer des centaines de serveurs

## Prochaine étape

Maintenant que vous maîtrisez Ansible, passez à la Phase 5 pour configurer Prometheus en détail.

