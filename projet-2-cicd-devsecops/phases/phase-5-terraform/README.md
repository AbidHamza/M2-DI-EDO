# Phase 5 – Provisionnement avec Terraform

À cette étape, vous décrivez et automatisez toute l’infrastructure nécessaire à votre pipeline (serveurs applicatifs, runners, réseaux, stockage). Terraform devient la “source de vérité” de l’infra.

## Objectif concret

- Créer un dossier `terraform/` structuré (providers, variables, outputs, modules éventuels).
- Provisionner l’environnement cible (local, cloud gratuit ou hybride).
- Préparer l’intégration de Terraform dans le pipeline GitLab CI (plan/apply).

## Plan d’action

1. **Définir l’infrastructure cible**
   - Reprenez le schéma de Phase 2.
   - Listez les ressources (VM/app server, base, réseau, secrets).

2. **Structurer le projet Terraform**
   ```
   terraform/
   ├── main.tf
   ├── providers.tf
   ├── variables.tf
   ├── outputs.tf
   ├── terraform.tfvars (non commité)
   └── modules/ (optionnel)
   ```

3. **Configurer le provider et le state**
   - Provider local (Docker), cloud (AWS, GCP, Scaleway…).
   - State local (.tfstate) ou back-end distant (S3, Terraform Cloud).

4. **Déclarer les ressources**
   - Réseau, sécurité (Security Groups, firewall).
   - Instances/VM ou services managés.
   - Volumes/buckets pour les artifacts si besoin.

5. **Outputs et intégration pipeline**
   - Exposez IPs, URLs, identifiants à réutiliser dans Ansible.
   - Préparez les commandes pipeline :
     ```bash
     terraform fmt
     terraform init
     terraform plan -out plan.tfplan
     terraform apply plan.tfplan
     ```

6. **Documentation**
   - Un README dans `terraform/` décrivant comment exécuter, où se trouvent les credentials, comment détruire (`terraform destroy`).

## Livrables attendus

- Dossier Terraform complet et formaté (`terraform fmt`).
- Infrastructure provisionnée (ou plan documenté si l’exécution réelle n’est pas possible).
- Capture/log montrant `plan` et `apply`.
- Documentation sur la manière de lancer Terraform via la pipeline GitLab.

## Exercice associé

`EXERCICE.md` propose un scénario minimal (provider Docker ou AWS free tier). Réalisez-le pour valider vos commandes avant de décrire l’infrastructure finale. La **solution expliquée** se trouve dans `corrections/`.

## Checklist

- [ ] Provider et backend configurés.
- [ ] Ressources décrites et paramétrables via variables.
- [ ] Outputs fournis pour Ansible/pipeline.
- [ ] `terraform plan` propre et enregistré.
- [ ] Procédure documentée (init/plan/apply/destroy).

Ensuite, passez à la **Phase 6 – Ansible** pour automatiser la configuration et le déploiement sur l’infrastructure provisionnée.*** End Patch

