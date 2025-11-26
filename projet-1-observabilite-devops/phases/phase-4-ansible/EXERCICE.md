# Exercice Phase 4 – Déployer Prometheus avec Ansible

## Objectif

Écrire un playbook unique qui :
1. Installe Docker (sur une VM Debian/Ubuntu ou une machine locale via SSH).
2. Copie un fichier de configuration `prometheus.yml`.
3. Lance un conteneur Prometheus prêt à être scrappé.

## Pré-requis

- Machine cible accessible en SSH (`ansible_host`, utilisateur, clé).
- Ansible installé sur votre poste (`ansible --version`).
- Fichier `prometheus.yml` de test (vous pouvez reprendre celui de l’application exemple).

## Étapes guidées

1. **Préparer l’inventaire**
   ```ini
   [observability]
   node1 ansible_host=192.168.56.10 ansible_user=vagrant
   ```
   - Ajoutez `ansible_ssh_private_key_file` si nécessaire.

2. **Créer le playbook `deploy-prometheus.yml`**
   - Structure conseillée :
     ```yaml
     ---
     - name: Install Docker and run Prometheus
       hosts: observability
       become: true
       vars:
         prometheus_config_dir: /opt/prometheus
     ```

3. **Ajouter les tâches essentielles**
   - Mise à jour du cache `apt` (module `apt`).
   - Installation de `docker.io` et `docker-compose` (ou paquets équivalents).
   - Démarrage/activation du service Docker (`systemd`).
   - Création du répertoire `/opt/prometheus` (`file`).
   - Copie du fichier `prometheus.yml` (`copy` ou `template`).
   - Déploiement du conteneur (`docker_container`) avec :
     - image `prom/prometheus:latest`
     - port `9090:9090`
     - montage du fichier de configuration et d’un volume nommé `prometheus-data`.

4. **Lancer le playbook**
   ```bash
   ansible-playbook -i inventory deploy-prometheus.yml
   ```

5. **Rendre le playbook idempotent**
   - Relancez la commande pour vérifier que toutes les tâches passent en `ok`.

## Vérifications

- `docker ps` montre le conteneur `prometheus`.
- Le dossier `/opt/prometheus` contient la configuration.
- http://node1:9090 est accessible depuis votre poste.

## Solution expliquée

Le dossier `corrections/` contient une solution détaillée (playbook + explications). Déchiffrez-la après avoir essayé, afin de comparer votre approche (utilisation des rôles, variables, handlers…).

## Variantes proposées

- Transformer ce playbook en rôle `roles/prometheus`.
- Ajouter un handler pour redémarrer le conteneur lorsque la configuration change.
- Utiliser `ansible-vault` pour stocker les mots de passe nécessaires à Docker Registry si vous poussez des images privées.

