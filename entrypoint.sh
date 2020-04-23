#!/bin/bash

source /etc/profile
set -e

create_user () {
    out=$(echo "from django.contrib.auth.models import User; User.objects.create_superuser(username='${1}', password='${2}', email='${3}')" | sudo -E -u django bash -c "cd /project && ./manage.py shell" || true)
    result=$?

    if [[ "$out" == *"IntegrityError"* ]] || [[ "$out" == *"UNIQUE constraint failed"* ]]; then
        return 0
    fi

    if [[ $result > 0 ]]; then
        echo " >> Error while creating a superuser account"
        echo "$out"
    fi

    return $result
}

prepare_permissions () {
    echo " >> Setting user id and group id"
    usermod -u "$DJANGO_USER_ID" django
    groupmod -g "$DJANGO_GROUP_ID" django

    echo " >> Correcting permissions"
    chown django:django -R /project/wikiproject/db /project/wikiproject/media /project/wikiproject/settings/secret_key

    if [[ "$CACHE_TYPE" == "filebased.FileBasedCache" ]]; then
        echo " >> Creating $CACHE_LOCATION and setting correct permissions"
        mkdir -p "$CACHE_LOCATION"
        chown django:django -R "$CACHE_LOCATION"
    fi
}

prepare_app () {
    echo " >> Performing migrations"
    sudo -E -u django bash -c "cd /project && ./manage.py migrate"
}

wait_for_database () {
    if [[ "${DB_TYPE}" == "postgresql" ]]; then
        echo " >> Waiting for PostgreSQL to be up"
        db_type="postgres"
    elif [[ "${DB_TYPE}" == "mysql" ]]; then
        echo " >> Waiting for MySQL to be up"
        db_type="mysql"
    else
        echo " >> Unsupported database type, not waiting for"
        return 0
    fi

    wait-for-db-to-be-ready --type "${db_type}" --host "${DB_HOST}" --port "${DB_PORT}" --timeout "${DB_WAIT_TIMEOUT}"
}

echo "# ==================================================================================="
echo "#   RiotKit's Django Wiki container"
echo "#   Created by independent, autonomous libertarian tech collective"
echo "#"
echo "#   Made especially for Anarchist Movement"
echo "#   See: riotkit.org and github.com/riotkit-org"
echo "# ==================================================================================="

cd /project || exit 1

# prepare the application, set administrator account
wait_for_database
prepare_permissions
prepare_app
create_user "$ADMIN_USER" "$ADMIN_PASSWORD" "$ADMIN_EMAIL"

exec sudo -E -u django bash -c "cd /project && gunicorn -b 0.0.0.0:8000 wikiproject.wsgi ${GUNICORN_OPTS}"
