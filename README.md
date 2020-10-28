# Weblate for YunoHost

[![Integration level](https://dash.yunohost.org/integration/weblate.svg)](https://dash.yunohost.org/appci/app/weblate) ![](https://ci-apps.yunohost.org/ci/badges/weblate.status.svg) ![](https://ci-apps.yunohost.org/ci/badges/weblate.maintain.svg)  
[![Install Weblate with YunoHost](https://install-app.yunohost.org/install-with-yunohost.png)](https://install-app.yunohost.org/?app=weblate)

> *This package allows you to install Weblate quickly and simply on a YunoHost server.  
If you don't have YunoHost, please consult [the guide](https://yunohost.org/#/install) to learn how to install it.*

## Overview

Weblate is a libre web-based translation tool with tight version control integration. It provides two user interfaces, propagation of translations across components, quality checks and automatic linking to source files.

**Shipped version:** 3.11.3

## Screenshots

![](https://weblate.org/static/img/BigScreenshot.png)

## Demo

* [YunoHost project uses Weblate for translations](https://translate.yunohost.org)

## Admin account

An admin user is created at installation, the login is what you provided at installation, the password is **weblate**.

## GitHub

You'll need to give Weblate a GitHub user and a token. Please read [GitHub's documentation about token](https://help.github.com/articles/creating-a-personal-access-token-for-the-command-line/).
This user will only be used to open the pull-request, each translation keep his author.

**SSH keys**, you will have to go in administration, and generate a public key for Weblate and add github.com so Weblate knows the fingerprint. Please note if your account already have a public key (ssh-rsa), you will have to manually add the Weblate's one to your GitHub account.

## Settings and upgrades

Almost everything related to Weblate's configuration is handled in a `settings.py` file.
You can edit the file `$final_path/local_settings.py` to enable or disable features.

# Miscellaneous

## LDAP connexion

It doesn't work yet, but while [it looks doable](https://docs.weblate.org/en/latest/admin/auth.html?highlight=LDAP#ldap-authentication), I'm unsure it is a good idea to connect this kind of tools to your LDAP.

#### Supported architectures

* x86-64 - [![Build Status](https://ci-apps.yunohost.org/ci/logs/weblate%20%28Apps%29.svg)](https://ci-apps.yunohost.org/ci/apps/weblate/)
* ARMv8-A - [![Build Status](https://ci-apps-arm.yunohost.org/ci/logs/weblate%20%28Apps%29.svg)](https://ci-apps-arm.yunohost.org/ci/apps/weblate/)

## Limitations

* Any known limitations.

## Additional information

* Other info you would like to add about this app.

## Links

 * Report a bug about this package: https://github.com/YunoHost-Apps/weblate_ynh
 * Report a bug about Weblate itself: https://github.com/WeblateOrg/weblate
 * Documentation: https://docs.weblate.org/
 * Weblate website: https://weblate.org/
 * YunoHost website: https://yunohost.org/

---

Developer info
----------------

Please send your pull request to the [testing branch](https://github.com/YunoHost-Apps/weblate_ynh/tree/testing).

To try the testing branch, please proceed like that.
```
sudo yunohost app install https://github.com/YunoHost-Apps/weblate_ynh/tree/testing --debug
or
sudo yunohost app upgrade weblate -u https://github.com/YunoHost-Apps/weblate_ynh/tree/testing --debug
```
