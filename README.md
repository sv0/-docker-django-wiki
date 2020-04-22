RiotKit's docker container for Django Wiki
==========================================

[![Docker Repository on Quay](https://quay.io/repository/riotkit/django-wiki/status "Docker Repository on Quay")](https://quay.io/repository/riotkit/django-wiki)
[![Build Status](https://img.shields.io/travis/riotkit-org/docker-django-wiki/master.svg)](https://travis-ci.org/riotkit-org/docker-django-wiki)

###  Running

```bash
sudo docker run --name djangowiki_test --rm quay.io/riotkit/django-wiki:0.5
```

Check the list of available tags: https://quay.io/repository/riotkit/django-wiki?tag=latest&tab=tags

Configuration reference
-----------------------

List of all environment variables that could be used.

```yaml

- ADMIN_USER # (default: riotkit)

# Admin's password
- ADMIN_PASSWORD # (default: capitalism-is-a-disaster-for-billions-of-people)

# Admin's mail
- ADMIN_EMAIL # (default: admin@example.org)

# Is this a PROD or DEV environment?
- DEBUG # (default: false)

# Timezone
- TZ # (default: Europe/Warsaw)


- USE_TZ # (default: true)

# Application language (see: http://www.i18nguy.com/unicode/language-identifiers.html)
- LANGUAGE_CODE # (default: en-US)


- SITE_ID # (default: 1)

# Anonymous defaults
- WIKI_ANONYMOUS_WRITE # (default: true)

# Anonymous defaults
- WIKI_ANONYMOUS_CREATE # (default: false)

# Database type: mysql, sqlite3, postgresql, oracle
- DB_TYPE # (default: sqlite3)

# Database name. For SQlite3 a filename, for others just a database name
- DB_NAME # (default: db.sqlite3)

# Database user login
- DB_USER # (default: None)

# Database user password
- DB_PASSWORD # (default: None)

# Database host
- DB_HOST # (default: None)

# Database port
- DB_PORT # (default: None)

# Database charset
- DB_CHARSET # (default: None)

# How long to wait for database connection (in seconds)
- DB_WAIT_TIMEOUT # (default: 300)

# Database collation (MySQL only)
- DB_COLLATION # (default: None)


- DB_ORA_DATAFILE # (default: None)


- DB_ORA_DATAFILE_TMP # (default: None)


- DB_ORA_DATAFILE_MAXSIZE # (default: None)


- DB_ORA_DATAFILE_TMP_MAXSIZE # (default: None)


- DB_ORA_DATAFILE_SIZE # (default: None)

# Should the application use cache?
- USE_CACHE # (default: false)

# Cache type
- CACHE_TYPE # (default: filebased.FileBasedCache)

# Cache specification/location
- CACHE_LOCATION # (default: /var/tmp/django_cache)


- CACHE_KEY_PREFIX # (default: )

# The number of seconds before a cache entry is considered stale. If the value of this settings is None, cache entries will not expire.
- CACHE_TIMEOUT # (default: 300)

# Default user who runs the project (id)
- DJANGO_USER_ID # (default: 1000)

# Default group of a user that runs the project (gid)
- DJANGO_GROUP_ID # (default: 1000)


- RIOTKIT_UTILS_VERSION # (default: "master")


```

Volumes
-------

- /project/wikiproject/settings/secret_key
- /project/wikiproject/media
- /project/wikiproject/db (important if using SQLite3 database)

Developing the container
------------------------

- The container is built on quay.io and hub.docker com
- When you start working on it locally, at first run `make develop` to install git hooks
- README.md is automatically generated from README.md.j2, do not edit the generated version!
- Use `make` for building, pushing, etc.

Releasing
---------

On Travis CI the build is triggered each month, then all recent versions of Django Wiki are built. Already existing docker tags are not overwritten.
The build is also triggered on-commit. Snapshot version is made from master branch, and is always a latest master, can be unstable.

To release a bugfix version and REBUILD EXISTING TAGS just add "@force-rebuild" in commit message, recent 5 tags will be rebuilt (not all in registry).

Copyleft
--------

Created by **RiotKit Collective**, a libertarian, grassroot, non-profit organization providing technical support for the non-profit Anarchist movement.

Check out those initiatives:
- International Workers Association (https://iwa-ait.org)
- Federacja Anarchistyczna (http://federacja-anarchistyczna.pl)
- Związek Syndykalistów Polski (https://zsp.net.pl) (Polish section of IWA-AIT)
- Komitet Obrony Praw Lokatorów (https://lokatorzy.info.pl)
- Solidarity Federation (https://solfed.org.uk)
- Priama Akcia (https://priamaakcia.sk)
