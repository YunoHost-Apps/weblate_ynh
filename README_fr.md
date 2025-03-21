<!--
Nota bene : ce README est automatiquement généré par <https://github.com/YunoHost/apps/tree/master/tools/readme_generator>
Il NE doit PAS être modifié à la main.
-->

# Weblate pour YunoHost

[![Niveau d’intégration](https://apps.yunohost.org/badge/integration/weblate)](https://ci-apps.yunohost.org/ci/apps/weblate/)
![Statut du fonctionnement](https://apps.yunohost.org/badge/state/weblate)
![Statut de maintenance](https://apps.yunohost.org/badge/maintained/weblate)

[![Installer Weblate avec YunoHost](https://install-app.yunohost.org/install-with-yunohost.svg)](https://install-app.yunohost.org/?app=weblate)

*[Lire le README dans d'autres langues.](./ALL_README.md)*

> *Ce package vous permet d’installer Weblate rapidement et simplement sur un serveur YunoHost.*  
> *Si vous n’avez pas YunoHost, consultez [ce guide](https://yunohost.org/install) pour savoir comment l’installer et en profiter.*

## Vue d’ensemble

Weblate est un outil de traduction libre avec une intégration étroite du contrôle de version. Il fournit deux interfaces utilisateur, la propagation des traductions entre les composants, les contrôles de qualité et la liaison automatique aux fichiers source. 

**Version incluse :** 5.10.4~ynh1

**Démo :** <https://hosted.weblate.org/>

## Captures d’écran

![Capture d’écran de Weblate](./doc/screenshots/BigScreenshot.png)

## Documentations et ressources

- Site officiel de l’app : <https://weblate.org>
- Documentation officielle utilisateur : <https://docs.weblate.org/>
- Documentation officielle de l’admin : <https://docs.weblate.org/>
- Dépôt de code officiel de l’app : <https://github.com/WeblateOrg/weblate>
- YunoHost Store : <https://apps.yunohost.org/app/weblate>
- Signaler un bug : <https://github.com/YunoHost-Apps/weblate_ynh/issues>

## Informations pour les développeurs

Merci de faire vos pull request sur la [branche `testing`](https://github.com/YunoHost-Apps/weblate_ynh/tree/testing).

Pour essayer la branche `testing`, procédez comme suit :

```bash
sudo yunohost app install https://github.com/YunoHost-Apps/weblate_ynh/tree/testing --debug
ou
sudo yunohost app upgrade weblate -u https://github.com/YunoHost-Apps/weblate_ynh/tree/testing --debug
```

**Plus d’infos sur le packaging d’applications :** <https://yunohost.org/packaging_apps>
