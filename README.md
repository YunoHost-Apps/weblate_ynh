# Weblate translation platform for YunoHost

The YunoHost team uses [Weblate](https://weblate.org) for translations: https://translate.yunohost.org

## Admin account

An admin user is created at installation, the login is what you provided at installation, the password is **weblate**.

## Github

You'll need to give weblate a github user and a token. Please read [github's documentation about token](https://help.github.com/articles/creating-a-personal-access-token-for-the-command-line/).
This user will only be used to open the pull-request, each translation keep his author.

## Settings and upgrades

Almost everything related to Weblate's configuration is handled in a `settings.py` file.
You'll probably edit it to enable or disable diverse features, it is stored in `$final_path/venv/lib/python2.7/site-packages/weblate/settings.py`.

Unfortunatly, this settings file also gets upgrades for each release.

This package will :

* generate a default settings file for your current installation,
* send you a diff with your actual settings (the content will be sent to *root*, and only basic information for weblate's admin),
* generate a default settings file the new weblate's version, that will **replace** your actual `settings.py`.

You'll have to **manually** add your previous changes to this new `settings.py`.

# Miscellaneous

## Weblate and databases

Weblate [recommands PostgreSQL](https://docs.weblate.org/en/latest/admin/install.html#database-setup-for-weblate), but YunoHost uses Mysql.

Carefull, this application install PostgreSQL and change the default configuration to ask for every connexion and every user a password (*local all all password*).

## LDAP connexion

It doesn't work yet, but while [it looks doable](https://docs.weblate.org/en/latest/admin/auth.html?highlight=LDAP#ldap-authentication), I'm unsure it is a good idea to connect this kind of tools to your LDAP.
