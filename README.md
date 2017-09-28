# Weblate translation platform for YunoHost

The YunoHost team uses [Weblate](https://weblate.org) for translations: https://translate.yunohost.org

## Admin

An admin user is created at installation, the login is what you provided at installation, the password is *weblate*.

# Github

Pulling works fine. But pushing still needs some love. Please read [Weblate's documentation about this](https://docs.weblate.org/en/latest/vcs.html).

I understant we need to manually install [hub](https://github.com/github/hub), a tool that creates pull-requests.
Which will require to download and install a binary file, as Debian 8 don't have Go>=1.8

## Weblate and databases

Weblate [recommands PostgreSQL](https://docs.weblate.org/en/latest/admin/install.html#database-setup-for-weblate), but YunoHost uses Mysql.

Carefull, this application install PostgreSQL and change the default configuration to ask for every connexion and every user a password (local all all password).

## LDAP connexion

It doesn't work yet, but while [it looks doable](https://docs.weblate.org/en/latest/admin/auth.html?highlight=LDAP#ldap-authentication), I'm unsure it is a good idea to link this kind of tools to you LDAP.
