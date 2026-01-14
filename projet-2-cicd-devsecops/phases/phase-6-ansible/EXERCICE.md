# Exercice Phase 6 – Playbook `deploy.yml`

## Objectif

Écrire un playbook Ansible qui :
- installe Docker s’il n’est pas présent ;
- récupère l’image depuis votre registry ;
- lance le conteneur de l’application et vérifie `/health`.

## Étapes guidées

1. **Inventaire minimal**
   ```ini
   [app_servers]
   192.168.56.10 ansible_user=vagrant
   ```

2. **Playbook `playbooks/deploy.yml`**
   ```yaml
   ---
   - name: Deploy FastAPI app
     hosts: app_servers
     become: true
     vars:
       app_name: example-api
       app_port: 8000
       docker_image: "registry.gitlab.com/group/project:latest"
     tasks:
       - name: Install Docker (Debian)
         apt:
           name: docker.io
           state: present
         when: ansible_os_family == "Debian"

       - name: Ensure Docker is running
         systemd:
           name: docker
           state: started
           enabled: true

       - name: Pull application image
         docker_image:
           name: "{{ docker_image }}"
           source: pull

       - name: Run application container
         docker_container:
           name: "{{ app_name }}"
           image: "{{ docker_image }}"
           restart_policy: unless-stopped
           state: started
           ports:
             - "{{ app_port }}:8000"

       - name: Check health endpoint
         uri:
           url: "http://localhost:{{ app_port }}/health"
           status_code: 200
         register: health
         retries: 5
         delay: 5
         until: health.status == 200
   ```

3. **Variables sensibles**
   - Stockez `docker_username`, `docker_password` dans `group_vars/all/vault.yml` ou dans GitLab CI (et utilisez `docker_login` si besoin).

4. **Commandes**
   ```bash
   ansible-playbook -i inventories/dev/hosts playbooks/deploy.yml
   ```

## Vérifications attendues

- Le conteneur apparaît (`docker ps`).
- L’endpoint `/health` répond 200.
- Le playbook est rejouable sans erreur (idempotent).

## Solution expliquée

Dans `corrections/`, vous trouverez un playbook plus complet utilisant des rôles (`docker`, `app`) et un template `docker-compose`. Comparez vos choix (modules, variables, checks).

## Pour aller plus loin

- Créer un rôle `roles/app` avec `tasks`, `templates`, `defaults`.
- Gérer plusieurs environnements (`environment=staging` via `-e`).
- Intégrer ce playbook dans le job `deploy_dev` du pipeline GitLab CI.*** End Patch

