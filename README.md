# Weblate translation platform for YunoHost

The YunoHost team uses [Weblate](https://weblate.org) for translations: https://translate.yunohost.org


## Weblate and databases

Weblate [recommands PostgreSQL](https://docs.weblate.org/en/latest/admin/install.html#database-setup-for-weblate), but YunoHost uses Mysql.

Carefull, this installs PostgreSQL and change default configuration to ask for every connexion and every user a password (local all all password).

## LDAP connexion

It doesn't work yet, but it looks doable: https://docs.weblate.org/en/latest/admin/auth.html?highlight=LDAP#ldap-authentication
