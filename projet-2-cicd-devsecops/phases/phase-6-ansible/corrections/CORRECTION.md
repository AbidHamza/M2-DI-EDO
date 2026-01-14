# Correction Phase 6 : Ansible pour déploiement

## Playbook complet

```yaml
---
- name: Deploy application
  hosts: all
  become: yes
  vars:
    app_name: example-api
    docker_image: "{{ docker_image }}"
    app_port: 8000
  
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
    
    - name: Pull latest image
      command: docker pull {{ docker_image }}
    
    - name: Stop old container
      docker_container:
        name: "{{ app_name }}"
        state: absent
    
    - name: Start application
      docker_container:
        name: "{{ app_name }}"
        image: "{{ docker_image }}"
        state: started
        restart_policy: unless-stopped
        ports:
          - "{{ app_port }}:8000"
    
    - name: Wait for application
      uri:
        url: "http://localhost:{{ app_port }}/health"
        status_code: 200
      register: result
      until: result.status == 200
      retries: 10
      delay: 5
```

### Template docker-compose.yml.j2

```yaml
version: '3.8'
services:
  app:
    image: {{ docker_image }}
    ports:
      - "{{ app_port }}:8000"
    restart: unless-stopped
```

### Intégration dans GitLab CI

```yaml
deploy:
  stage: deploy
  script:
    - ansible-playbook -i inventory deploy.yml -e "docker_image=$DOCKER_IMAGE"
```

