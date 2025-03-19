<!--
Ohart ongi: README hau automatikoki sortu da <https://github.com/YunoHost/apps/tree/master/tools/readme_generator>ri esker
EZ editatu eskuz.
-->

# Weblate YunoHost-erako

[![Integrazio maila](https://apps.yunohost.org/badge/integration/weblate)](https://ci-apps.yunohost.org/ci/apps/weblate/)
![Funtzionamendu egoera](https://apps.yunohost.org/badge/state/weblate)
![Mantentze egoera](https://apps.yunohost.org/badge/maintained/weblate)

[![Instalatu Weblate YunoHost-ekin](https://install-app.yunohost.org/install-with-yunohost.svg)](https://install-app.yunohost.org/?app=weblate)

*[Irakurri README hau beste hizkuntzatan.](./ALL_README.md)*

> *Pakete honek Weblate YunoHost zerbitzari batean azkar eta zailtasunik gabe instalatzea ahalbidetzen dizu.*  
> *YunoHost ez baduzu, kontsultatu [gida](https://yunohost.org/install) nola instalatu ikasteko.*

## Aurreikuspena

Weblate is a libre web-based translation tool with tight version control integration. It provides two user interfaces, propagation of translations across components, quality checks and automatic linking to source files.

**Paketatutako bertsioa:** 5.10.4~ynh1

**Demoa:** <https://hosted.weblate.org/>

## Pantaila-argazkiak

![Weblate(r)en pantaila-argazkia](./doc/screenshots/BigScreenshot.png)

## Dokumentazioa eta baliabideak

- Aplikazioaren webgune ofiziala: <https://weblate.org>
- Erabiltzaileen dokumentazio ofiziala: <https://docs.weblate.org/>
- Administratzaileen dokumentazio ofiziala: <https://docs.weblate.org/>
- Jatorrizko aplikazioaren kode-gordailua: <https://github.com/WeblateOrg/weblate>
- YunoHost Denda: <https://apps.yunohost.org/app/weblate>
- Eman errore baten berri: <https://github.com/YunoHost-Apps/weblate_ynh/issues>

## Garatzaileentzako informazioa

Bidali `pull request`a [`testing` abarrera](https://github.com/YunoHost-Apps/weblate_ynh/tree/testing).

`testing` abarra probatzeko, ondorengoa egin:

```bash
sudo yunohost app install https://github.com/YunoHost-Apps/weblate_ynh/tree/testing --debug
edo
sudo yunohost app upgrade weblate -u https://github.com/YunoHost-Apps/weblate_ynh/tree/testing --debug
```

**Informazio gehiago aplikazioaren paketatzeari buruz:** <https://yunohost.org/packaging_apps>
