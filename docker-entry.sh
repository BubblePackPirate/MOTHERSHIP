#!/bin/bash

echo "Starting MySQL"
service mysql restart

until mysqladmin -hlocalhost -P3306 -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" processlist; do
	echo "MySQL still not ready, sleeping"
	sleep 5
done

echo "*+*+*+*+*+*+*+*+*+*+ Starting Mattermost *+*+*+*+*+*+*+*+*+*+ "
cd /mothership/mattermost
exec ./bin/platform --config=config/config_docker.json &


echo "*+*+*+*+*+*+*+*+*+*+ Starting Redmine *+*+*+*+*+*+*+*+*+*+ "
cd /mothership/redmine
./redmine_start.sh rails server -b 0.0.0.0

echo "Something bad happened, I shouldnt be here! (redmine or mattermost failed to start, probably)"
echo "Now enjoy this lovely black hole"
tail -f /dev/null

