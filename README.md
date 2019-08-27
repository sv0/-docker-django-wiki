RiotKit's docker container for Django Wiki
==========================================

[![Docker Repository on Quay](https://quay.io/repository/riotkit/django-wiki/status "Docker Repository on Quay")](https://quay.io/repository/riotkit/django-wiki)
[![Build Status](https://img.shields.io/travis/riotkit-org/docker-django-wiki/master.svg)](https://travis-ci.org/riotkit-org/docker-django-wiki)

###  Running

```bash
sudo docker run --name djangowiki_test --rm quay.io/riotkit/django-wiki:0.4.5
```

Configuration reference
-----------------------

List of all environment variables that could be used.

```yaml

- ADMIN_USER # (example value: riotkit)

# Admin's password
- ADMIN_PASSWORD # (example value: capitalism-is-a-disaster-for-billions-of-people)

# Admin's mail
- ADMIN_EMAIL # (example value: admin@example.org)

# Is this a PROD or DEV environment?
- DEBUG # (example value: false)

# Timezone
- TZ # (example value: Europe/Warsaw)


- USE_TZ # (example value: true)

# Application language (see: http://www.i18nguy.com/unicode/language-identifiers.html)
- LANGUAGE_CODE # (example value: en-US)


- SITE_ID # (example value: 1)

# Anonymous defaults
- WIKI_ANONYMOUS_WRITE # (example value: true)

# Anonymous defaults
- WIKI_ANONYMOUS_CREATE # (example value: false)

# Database type: mysql, sqlite3, postgresql, oracle
- DB_TYPE # (example value: sqlite3)

# Database name. For SQlite3 a filename, for others just a database name
- DB_NAME # (example value: db.sqlite3)

# Database user login
- DB_USER # (example value: None)

# Database user password
- DB_PASSWORD # (example value: None)

# Database host
- DB_HOST # (example value: None)

# Database port
- DB_PORT # (example value: None)

# Database charset
- DB_CHARSET # (example value: None)

# Database collation (MySQL only)
- DB_COLLATION # (example value: None)


- DB_ORA_DATAFILE # (example value: None)


- DB_ORA_DATAFILE_TMP # (example value: None)


- DB_ORA_DATAFILE_MAXSIZE # (example value: None)


- DB_ORA_DATAFILE_TMP_MAXSIZE # (example value: None)


- DB_ORA_DATAFILE_SIZE # (example value: None)

# Should the application use cache?
- USE_CACHE # (example value: false)

# Cache type
- CACHE_TYPE # (example value: filebased.FileBasedCache)

# Cache specification/location
- CACHE_LOCATION # (example value: /var/tmp/django_cache)


- CACHE_KEY_PREFIX # (example value: )

# The number of seconds before a cache entry is considered stale. If the value of this settings is None, cache entries will not expire.
- CACHE_TIMEOUT # (example value: 300)

# Default user who runs the project (id)
- DJANGO_USER_ID # (example value: 1000)

# Default group of a user that runs the project (gid)
- DJANGO_GROUP_ID # (example value: 1000)


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

Just set a tag on git, the container will automatically be built on quay.io and on hub.docker.com

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
