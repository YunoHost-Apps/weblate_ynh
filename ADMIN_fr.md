## GitHub

Vous devrez donner à Weblate un utilisateur GitHub et un jeton. Veuillez lire [la documentation de GitHub sur le jeton](https://help.github.com/articles/creating-a-personal-access-token-for-the-command-line/).
Cet utilisateur ne sera utilisé que pour ouvrir la pull-request, chaque traduction garde son auteur.

**Clés SSH**, vous devrez vous rendre dans l'administration, générer une clé publique pour Weblate et ajouter github.com pour que Weblate connaisse l'empreinte digitale. Veuillez noter que si votre compte possède déjà une clé publique (ssh-rsa), vous devrez ajouter manuellement celle de Weblate à votre compte GitHub.

## Paramètres et mises à niveau

Presque tout ce qui concerne la configuration de Weblate est géré dans un fichier `settings.py`.
Vous pouvez éditer le fichier `$final_path/local_settings.py` pour activer ou désactiver des fonctionnalités.

# Divers

## Connexion LDAP

Cela ne fonctionne pas encore, mais bien que [cela semble faisable](https://docs.weblate.org/en/latest/admin/auth.html?highlight=LDAP#ldap-authentication), je ne suis pas sûr que ce soit le cas une bonne idée de connecter ce genre d'outils à votre LDAP. 
