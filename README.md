# README

## Instructions pour seeder et configurer l'expérience candidat

Pour initialiser la base de données et seeder les données, exécutez les commandes suivantes :

```bash
rails db:create db:migrate db:seed
EditionCompetition.update_all(status: "published")
```

Lancer un serveur ngrok afin de pouvoir effectuer les payments
```bash
ngrok http 3000
```
Vérifier sur Stripe d'avoir configuré le webhook
