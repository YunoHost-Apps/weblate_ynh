# Weblate translation platform for YunoHost

The YunoHost team uses [Weblate](https://weblate.org) for translations: https://translate.yunohost.org

## Admin

An admin user is created at installation, the login is what you provided at installation, the password is *weblate*.

# Github

You'll need to give weblate a github user and a token. Please read [github's documentation about token](https://help.github.com/articles/creating-a-personal-access-token-for-the-command-line/).

## Weblate and databases

Weblate [recommands PostgreSQL](https://docs.weblate.org/en/latest/admin/install.html#database-setup-for-weblate), but YunoHost uses Mysql.

Carefull, this application install PostgreSQL and change the default configuration to ask for every connexion and every user a password (local all all password).

## LDAP connexion

It doesn't work yet, but while [it looks doable](https://docs.weblate.org/en/latest/admin/auth.html?highlight=LDAP#ldap-authentication), I'm unsure it is a good idea to connect this kind of tools to your LDAP.
