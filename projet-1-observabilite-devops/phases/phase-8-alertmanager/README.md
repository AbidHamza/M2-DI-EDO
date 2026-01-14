# Phase 8 – Alertmanager et scénarios d’alertes

Cette phase transforme vos règles Prometheus en notifications actionnables. Vous devez définir comment, quand et vers qui les alertes sont envoyées.

## Objectif concret

- Déployer Alertmanager (Docker/Ansible).
- Configurer le routage (groupes, délais, récepteurs email/webhook/Slack).
- Tester deux scénarios d’alerte complets (warning vs critical).

## Plan d’action

1. **Déploiement**
   - Utilisez un rôle Ansible `alertmanager` ou Docker Compose.
   - Exposez le port 9093.
   - Montez `alertmanager.yml` + dossiers de templates.

2. **Configurer `alertmanager.yml`**
   - Bloc `global` : SMTP ou paramètres communs.
   - Bloc `route` :
     - `group_by`: `['alertname','environment','service']`
     - `group_wait`, `group_interval`, `repeat_interval`.
     - Routes enfants selon la sévérité.
   - `receivers` :
     - email (Gmail, Mailgun…)
     - webhook (ex: un endpoint local)
     - Slack/Teams si souhaité.

3. **Mettre à jour les règles Prometheus**
   - Ajoutez des labels `severity` cohérents (warning/critical).
   - Vérifiez que les alertes pointent bien vers Alertmanager (`alerting.alertmanagers`).

4. **Tester**
   - Simulez une alerte en arrêtant un service ou en modifiant un seuil.
   - Vérifiez dans l’UI Alertmanager (http://host:9093) et dans vos canaux (email/webhook).
   - Documentez chaque test (date, alerte, résultat).

5. **Sécurité / secrets**
   - Stockez les mots de passe SMTP dans `ansible-vault` ou variables d’environnement.
   - Ne committez jamais les secrets en clair.

## Livrables attendus

- Fichier `alertmanager.yml` propre et commenté.
- Templates de notification (optionnel mais recommandé).
- Preuve de tests (captures ou logs).
- Documentation “mode opératoire” pour ajouter une nouvelle route/receiver.

## Exercice associé

`EXERCICE.md` contient une configuration de base (SMTP + webhook) à adapter. Une **solution expliquée** est disponible dans `corrections/` pour comparer vos choix de routage.

## Checklist

- [ ] Alertmanager tourne et reçoit les alertes de Prometheus.
- [ ] Au moins deux routes configurées (warning vs critical).
- [ ] Les secrets SMTP/webhook sont sécurisés.
- [ ] Des tests ont été réalisés et documentés.

Ensuite, passez à la **Phase 9 – Intégration complète** pour valider toute la chaîne en conditions quasi-réelles.

