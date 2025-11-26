# Exercice Phase 4 : Premier playbook Ansible

## Exercice à réaliser

Créez un playbook Ansible pour installer Docker et déployer Prometheus.

## Correction complète

```yaml
# playbook.yml
---
- name: Install Docker and deploy Prometheus
  hosts: all
  become: yes
  tasks:
    - name: Update apt cache
      apt:
        update_cache: yes
      when: ansible_os_family == "Debian"
    
    - name: Install Docker
      apt:
        name:
          - docker.io
          - docker-compose
        state: present
      when: ansible_os_family == "Debian"
    
    - name: Start Docker service
      systemd:
        name: docker
        state: started
        enabled: yes
    
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

## Explications détaillées

**hosts: all** : Exécute sur tous les hosts de l'inventory

**become: yes** : Exécute avec les privilèges root

**apt module** : Installe des paquets sur Debian/Ubuntu

**systemd module** : Gère les services systemd

**file module** : Gère les fichiers et dossiers

**copy module** : Copie des fichiers

**docker_container module** : Gère les conteneurs Docker

## Inventory

```ini
# inventory
[servers]
server1 ansible_host=192.168.1.100
```

## Exécution

```bash
ansible-playbook -i inventory playbook.yml
```

## Vérification

Vérifiez que :
- Docker est installé
- Prometheus est déployé
- Accessible sur http://server1:9090

