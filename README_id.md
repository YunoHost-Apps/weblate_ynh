<!--
N.B.: README ini dibuat secara otomatis oleh <https://github.com/YunoHost/apps/tree/master/tools/readme_generator>
Ini TIDAK boleh diedit dengan tangan.
-->

# Weblate untuk YunoHost

[![Tingkat integrasi](https://dash.yunohost.org/integration/weblate.svg)](https://ci-apps.yunohost.org/ci/apps/weblate/) ![Status kerja](https://ci-apps.yunohost.org/ci/badges/weblate.status.svg) ![Status pemeliharaan](https://ci-apps.yunohost.org/ci/badges/weblate.maintain.svg)

[![Pasang Weblate dengan YunoHost](https://install-app.yunohost.org/install-with-yunohost.svg)](https://install-app.yunohost.org/?app=weblate)

*[Baca README ini dengan bahasa yang lain.](./ALL_README.md)*

> *Paket ini memperbolehkan Anda untuk memasang Weblate secara cepat dan mudah pada server YunoHost.*  
> *Bila Anda tidak mempunyai YunoHost, silakan berkonsultasi dengan [panduan](https://yunohost.org/install) untuk mempelajari bagaimana untuk memasangnya.*

## Ringkasan

Weblate is a libre web-based translation tool with tight version control integration. It provides two user interfaces, propagation of translations across components, quality checks and automatic linking to source files.

**Versi terkirim:** 5.5.3~ynh1

**Demo:** <https://hosted.weblate.org/>

## Tangkapan Layar

![Tangkapan Layar pada Weblate](./doc/screenshots/BigScreenshot.png)

## Dokumentasi dan sumber daya

- Website aplikasi resmi: <https://weblate.org>
- Dokumentasi pengguna resmi: <https://docs.weblate.org/>
- Dokumentasi admin resmi: <https://docs.weblate.org/>
- Depot kode aplikasi hulu: <https://github.com/WeblateOrg/weblate>
- Gudang YunoHost: <https://apps.yunohost.org/app/weblate>
- Laporkan bug: <https://github.com/YunoHost-Apps/weblate_ynh/issues>

## Info developer

Silakan kirim pull request ke [`testing` branch](https://github.com/YunoHost-Apps/weblate_ynh/tree/testing).

Untuk mencoba branch `testing`, silakan dilanjutkan seperti:

```bash
sudo yunohost app install https://github.com/YunoHost-Apps/weblate_ynh/tree/testing --debug
atau
sudo yunohost app upgrade weblate -u https://github.com/YunoHost-Apps/weblate_ynh/tree/testing --debug
```

**Info lebih lanjut mengenai pemaketan aplikasi:** <https://yunohost.org/packaging_apps>
