#!/bin/bash

set -e

create_user () {
    out=$(echo "from django.contrib.auth.models import User; User.objects.create_superuser(username='${1}', password='${2}', email='${3}')" | sudo -u django bash -c "cd /project && ./manage.py shell")
    result=$?

    if [[ "$out" == *"UNIQUE constraint failed"* ]]; then
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
}

prepare_app () {
    echo " >> Performing migrations"
    sudo -u django bash -c "cd /project && ./manage.py migrate"
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
prepare_permissions
prepare_app
create_user "$ADMIN_USER" "$ADMIN_PASSWORD" "$ADMIN_EMAIL"

exec sudo -u django bash -c "cd /project && gunicorn -b 0.0.0.0:8000 wikiproject.wsgi"
