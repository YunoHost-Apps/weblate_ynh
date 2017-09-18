# Weblate translation platform for YunoHost

The YunoHost team uses [Weblate](https://weblate.org) for its community: http://translate.yunohost.org/

## Weblate & Mysql

Weblate [recommands PostgreSQL](https://docs.weblate.org/en/latest/admin/install.html#database-setup-for-weblate), but YunoHost uses Mysql.

You should make sure to change this settings in your mysql config file:

* set global innodb_file_format = BARRACUDA;
* set global innodb_large_prefix = ON;

If you experience some transaction issues, please read [Transaction-locking help](https://docs.weblate.org/en/latest/admin/install.html#transaction-locking).
