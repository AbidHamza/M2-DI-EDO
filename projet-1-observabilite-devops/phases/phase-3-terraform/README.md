# Phase 3 – Provisionnement avec Terraform

Après avoir posé l’architecture (phase 2), vous automatisez désormais la création de l’infrastructure avec Terraform. Cette étape est évaluée dans la partie “Implémentation” (40 pts) et servira de base aux phases Ansible/observabilité.

## Objectif concret

Obtenir un dossier `terraform/` capable de :
- initialiser un provider (local Docker, cloud gratuit ou VM locale) ;
- créer toutes les ressources nécessaires à l’écosystème (réseaux, machines, volumes, stockage) ;
- exposer les informations dont Ansible aura besoin (IPs, ports, chemins via `outputs`).

## Approche recommandée

1. **Clarifier l’infrastructure ciblée**
   - Reprenez votre schéma d’architecture.
   - Listez les ressources exactes à créer (machines monitoring, réseau observability, volumes persistants…).

2. **Initialiser le projet Terraform**
   - Structure conseillée :
     ```
     terraform/
     ├── main.tf
     ├── providers.tf
     ├── variables.tf
     ├── outputs.tf
     ├── terraform.tfvars        # valeurs locales
     └── modules/ (optionnel)
     ```
   - Ajoutez un fichier `README.md` dans le dossier pour documenter les commandes de base.

3. **Configurer le provider et l’état**
   - Choisissez un provider adapté (Docker pour du local, ou un cloud free-tier).
   - Définissez clairement le backend de state (local par défaut, ou distant si vous travaillez en équipe).

4. **Déclarer les ressources**
   - Réseau / sous-réseaux / security groups ou networks Docker.
   - Machines ou conteneurs qui accueilleront Prometheus, Loki, Grafana, Alertmanager, application exemple.
   - Volumes ou buckets nécessaires pour la persistance.
   - Préparez des tags/labels cohérents (ex : `env = "dev"`, `service = "observability"`).

5. **Paramétrer les variables et outputs**
   - Variables d’entrée : taille des VM, ports exposés, chemins des fichiers.
   - Outputs : IPs, URLs des services, identifiants réseau. Ces valeurs seront reprises dans Ansible (`inventory` dynamique possible).

6. **Valider et documenter**
   - Commandes incontournables :
     ```bash
     terraform fmt
     terraform init
     terraform plan
     terraform apply
     ```
   - Documentez les étapes de déploiement/retrait (`terraform destroy`) ainsi que les prérequis (versions, authentification).

## Livrables attendus

- Dossier `terraform/` complet et versionné.
- Infrastructure réellement provisionnée (ou plan documenté si l’exécution est impossible, mais justifié).
- Documentation courte décrivant : ressources créées, variables importantes, outputs, commandes d’exploitation.
- Capture ou export du plan (`terraform plan -out plan.tfplan`) pour preuve de fonctionnement.

## Exercice associé

Avant de déployer toute l’architecture, réalisez l’exercice décrit dans `EXERCICE.md`. Il vous guide vers un scénario minimal (provider Docker local) afin de :
- tester la syntaxe Terraform ;
- apprivoiser les commandes `init/plan/apply/destroy` ;
- disposer d’un exemple concret à réutiliser.
La **solution expliquée** est accessible dans `corrections/` après déchiffrement (voir scripts à la racine).

## Checklist de fin de phase

- [ ] Le provider Terraform est initialisé et fonctionnel.
- [ ] Les ressources essentielles de l’architecture sont décrites dans `main.tf` (ou des modules).
- [ ] Les variables et outputs sont documentés.
- [ ] `terraform plan` est propre (pas de changements non justifiés).
- [ ] Le state est sauvegardé (local ou distant) et ignoré correctement dans Git.
- [ ] Vous savez détruire proprement l’infrastructure (`terraform destroy`).

Quand tout est validé, commitez vos changements puis passez à la **Phase 4 – Configuration avec Ansible** pour installer et paramétrer automatiquement les composants déployés.

