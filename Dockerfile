ARG VERSION="0.4.5"

FROM alpine:3.11
LABEL maintainer "Carlo Mandelli"
LABEL maintainer RiotKit <riotkit@riseup.net>

ARG VERSION

ENV ADMIN_USER=riotkit \
    # Admin's password
    ADMIN_PASSWORD=capitalism-is-a-disaster-for-billions-of-people \
    # Admin's mail
    ADMIN_EMAIL=admin@example.org \
    # Is this a PROD or DEV environment?
    DEBUG=false \
    # Timezone
    TZ=Europe/Warsaw \
    USE_TZ=true \
    # Application language (see: http://www.i18nguy.com/unicode/language-identifiers.html)
    LANGUAGE_CODE=en-US \
    SITE_ID=1 \
    # Anonymous defaults
    WIKI_ANONYMOUS_WRITE=true \
    # Anonymous defaults
    WIKI_ANONYMOUS_CREATE=false \
    # Database type: mysql, sqlite3, postgresql, oracle
    DB_TYPE=sqlite3 \
    # Database name. For SQlite3 a filename, for others just a database name
    DB_NAME=db.sqlite3 \
    # Database user login
    DB_USER=None \
    # Database user password
    DB_PASSWORD=None \
    # Database host
    DB_HOST=None \
    # Database port
    DB_PORT=None \
    # Database charset
    DB_CHARSET=None \
    # How long to wait for database connection (in seconds)
    DB_WAIT_TIMEOUT=300 \
    # Database collation (MySQL only)
    DB_COLLATION=None \
    DB_ORA_DATAFILE=None \
    DB_ORA_DATAFILE_TMP=None \
    DB_ORA_DATAFILE_MAXSIZE=None \
    DB_ORA_DATAFILE_TMP_MAXSIZE=None \
    DB_ORA_DATAFILE_SIZE=None \
    # Should the application use cache?
    USE_CACHE=false \
    # Cache type
    CACHE_TYPE=filebased.FileBasedCache \
    # Cache specification/location
    CACHE_LOCATION=/var/tmp/django_cache \
    CACHE_KEY_PREFIX= \
    # The number of seconds before a cache entry is considered stale. If the value of this settings is None, cache entries will not expire.
    CACHE_TIMEOUT=300 \
    # Default user who runs the project (id)
    DJANGO_USER_ID=1000 \
    # Default group of a user that runs the project (gid)
    DJANGO_GROUP_ID=1000

# Base
RUN apk --update add python3 py3-pip bash py3-pillow make shadow sudo libpq curl bash postgresql-client \
    && rm -rf /var/cache/apk/* \
    && ([[ "$VERSION" == "master" ]] || pip3 --no-cache-dir install wiki==${VERSION}) \
    && ([[ "$VERSION" != "master" ]] || pip3 --no-cache-dir install --pre wiki) \
    && pip3 --no-cache-dir install gunicorn \
    && ln -s /usr/bin/python3 /usr/bin/python

# Install RiotKit utils
ENV RIOTKIT_UTILS_VERSION="2.2.0"
RUN curl "https://raw.githubusercontent.com/riotkit-org/ci-utils/v${RIOTKIT_UTILS_VERSION}/ci-integration/any.sh" -s | bash

# PostgreSQL support
RUN apk add --update --virtual .build-deps gcc musl-dev python3-dev postgresql-dev \
    && rm -rf /var/cache/apk/* \
    && pip3 --no-cache-dir install psycopg2 \
    && apk --purge del .build-deps

ADD ./project /project
ADD ./Makefile /project/

# - Migrate the database initially (if will be using SQLite3)
# - Copy static files from Python module to our project
# - Add target user
# - For security delete the key generated during the build
RUN mkdir -p /var/tmp/django_cache \
    && cd /project \
    && ./manage.py migrate \
    && ./manage.py collectstatic --no-input \
    && addgroup -g 1000 django \
    && adduser -S -D -u 1000 django -G django \
    && rm /project/wikiproject/settings/secret_key/* -rf

ADD ./entrypoint.sh /
RUN chmod +x /entrypoint.sh

#VOLUME /project/wikiproject/settings/secret_key.py
#VOLUME /project/wikiproject/media
#VOLUME /project/wikiproject/db

EXPOSE 80
WORKDIR /project
ENTRYPOINT ["/entrypoint.sh"]
