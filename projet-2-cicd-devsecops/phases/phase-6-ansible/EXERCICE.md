# Exercice Phase 6 : Playbook Ansible pour déploiement

## Exercice à réaliser

Créez un playbook Ansible pour déployer l'application sur les serveurs provisionnés.

## Correction complète

```yaml
# deploy.yml
---
- name: Deploy application
  hosts: app_servers
  become: yes
  vars:
    app_name: example-api
    app_port: 8000
    docker_image: "registry.gitlab.com/group/project:latest"
  
  tasks:
    - name: Ensure Docker is installed
      package:
        name: docker.io
        state: present
      when: ansible_os_family == "Debian"
    
    - name: Start Docker service
      systemd:
        name: docker
        state: started
        enabled: yes
    
    - name: Create application directory
      file:
        path: /opt/{{ app_name }}
        state: directory
        mode: '0755'
    
    - name: Create docker-compose file
      template:
        src: docker-compose.yml.j2
        dest: /opt/{{ app_name }}/docker-compose.yml
        mode: '0644'
    
    - name: Login to Docker registry
      docker_login:
        registry: "{{ docker_registry }}"
        username: "{{ docker_username }}"
        password: "{{ docker_password }}"
    
    - name: Pull latest image
      command: docker pull {{ docker_image }}
    
    - name: Stop and remove old container
      docker_container:
        name: "{{ app_name }}"
        state: absent
    
    - name: Start application container
      docker_container:
        name: "{{ app_name }}"
        image: "{{ docker_image }}"
        state: started
        restart_policy: unless-stopped
        ports:
          - "{{ app_port }}:8000"
        env:
          ENVIRONMENT: "{{ environment }}"
    
    - name: Wait for application to be ready
      uri:
        url: "http://localhost:{{ app_port }}/health"
        method: GET
        status_code: 200
      register: result
      until: result.status == 200
      retries: 10
      delay: 5
    
    - name: Verify deployment
      uri:
        url: "http://localhost:{{ app_port }}/"
        method: GET
      register: health_check
    
    - name: Display deployment status
      debug:
        msg: "Application deployed successfully at http://{{ ansible_host }}:{{ app_port }}"
```

## Explications détaillées

**hosts: app_servers** : Groupe de serveurs cibles

**vars** : Variables du playbook

**package module** : Installe Docker

**template module** : Génère docker-compose.yml depuis un template

**docker_login** : Authentification au registry

**docker_container** : Gère les conteneurs

**uri module** : Vérifie que l'application répond

**retries/delay** : Réessaie jusqu'à ce que l'app soit prête

## Template docker-compose

```yaml
# templates/docker-compose.yml.j2
version: '3.8'
services:
  app:
    image: {{ docker_image }}
    ports:
      - "{{ app_port }}:8000"
    environment:
      ENVIRONMENT: {{ environment }}
    restart: unless-stopped
```

## Exécution

```bash
ansible-playbook -i inventory deploy.yml -e "environment=production"
```

## Vérification

Vérifiez que :
- L'application est déployée
- Accessible sur le port configuré
- Health check répond

