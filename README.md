[![Install Weblate with YunoHost](https://install-app.yunohost.org/install-with-yunohost.png)](https://install-app.yunohost.org/?app=weblate)
![](https://dash.yunohost.org/integration/weblate.svg)
# Weblate translation platform for YunoHost

The YunoHost team uses [Weblate](https://weblate.org) for translations: https://translate.yunohost.org

## Admin account

An admin user is created at installation, the login is what you provided at installation, the password is **weblate**.

## Weblate 3.0 upgrade

This upgrade is a major one, remember to read this page before upgrading: https://docs.weblate.org/en/latest/admin/upgrade.html#upgrade-3

After upgrading:

 * All existing users and groups have been migrated to new model.
 * Any per user permissions are removed, please assign users to appropriate groups and roles to grant them permissions.
 * Any custom groups will not have any permissions after upgrade, please grant the permissions again.

## Github

You'll need to give weblate a github user and a token. Please read [github's documentation about token](https://help.github.com/articles/creating-a-personal-access-token-for-the-command-line/).
This user will only be used to open the pull-request, each translation keep his author.

**Careful**, I still have to understand why, but you'll have to **manually** move your hub binary frile from /var/www/$app/bin/ to /usr/bin to enable pull request on github. I'm close to fix this.

**SSH keys**, you'll have to go in administration, and generate a public key for weblate and add github.com so weblate knows the fingerprint. Please note if your account already have a public key (ssh-rsa), you'll have to manually add the weblate's one to your github account.

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

## State of this package

* works fine:
[x] install/remove/backup/remove/upgrade with x86_64

* to be confirmed:
[ ] ARM support

* to be added:
[ ] strenghen uwsgi systemd security (https://github.com/YunoHost-Apps/kresus_ynh/pull/21/commits/0ce4979d5037b111aa9698ed5552135bf0ed7165)
[ ] use jq instead of grep/sed
[ ] change URL script
[ ] use debian package for lxml (may unlock ARM support)
[ ] Add configuration options using the YunoHost interface (https://forum.yunohost.org/t/yunohost-3-1-minor-stable-release-version-stable-mineure/5445)
[ ] Add fail2ban script
[ ] Use redis+hiredis for cache?
[ ] Enable CHECK_LIST?
[ ] Enable AUTOFIX_LIST?
[ ] Enable Translation Memory?

## Links

 * Report a bug about this package: https://github.com/YunoHost-Apps/weblate_ynh
 * Report a bug about Weblate itself: https://github.com/WeblateOrg/weblate
 * Documentation: https://docs.weblate.org/
 * Weblate website: https://weblate.org/
 * YunoHost website: https://yunohost.org/
