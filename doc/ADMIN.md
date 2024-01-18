## GitHub

You'll need to give Weblate a GitHub user and a token. Please read [GitHub's documentation about token](https://help.github.com/articles/creating-a-personal-access-token-for-the-command-line/).
This user will only be used to open the pull-request, each translation keep his author.

**SSH keys**, you will have to go in administration, and generate a public key for Weblate and add github.com so Weblate knows the fingerprint. Please note if your account already have a public key (ssh-rsa), you will have to manually add the Weblate's one to your GitHub account.

## Settings and upgrades

Almost everything related to Weblate's configuration is handled in a `settings.py` file.
You can edit the file `__INSTALL_DIR__/local_settings.py` to enable or disable features.

# Miscellaneous

## LDAP connexion

It doesn't work yet, but while [it looks doable](https://docs.weblate.org/en/latest/admin/auth.html?highlight=LDAP#ldap-authentication), I'm unsure it is a good idea to connect this kind of tools to your LDAP.
