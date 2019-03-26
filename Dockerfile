FROM redmine

WORKDIR /mothership

#Install random stuff
RUN export DEBIAN_FRONTEND=noninteractive && apt-get update && apt-get install -y ca-certificates gnupg locate iproute tcpdump nano lsb-release unzip

#Install mySQL 5.7, Set noninteractive cause it will prompt docker for shyt, and thus hang.
ADD https://dev.mysql.com/get/mysql-apt-config_0.8.6-1_all.deb .
RUN export DEBIAN_FRONTEND=noninteractive && dpkg -i mysql-apt-config_0.8.6-1_all.deb && apt-get update && apt-get install -y mysql-community-server

#
# Configure SQL
#
ENV MYSQL_ROOT_PASSWORD=
ENV MYSQL_USER=mmuser
ENV MYSQL_PASSWORD=password
ADD mysql_setup .
RUN service mysql start && chmod +x mysql_setup && ./mysql_setup && rm mysql-apt-config_0.8.6-1_all.deb mysql_setup

#
#SSL Certs
#
RUN openssl genrsa -passout pass:x -out server.pass.key 2048 && openssl rsa -passin pass:x -in server.pass.key -out server.key && rm server.pass.key
RUN openssl req -new -key server.key -out server.csr -subj "/C=US/ST=Mothersip/L=Cyberspace/O=Mothership/OU=Mothership/CN=mothership"
RUN openssl x509 -req -sha256 -days 365 -in server.csr -signkey server.key -out server.pem && rm server.csr


#
# Configure Mattermost -- Change all instances of "5.x.x" to new version to update
#
ADD https://releases.mattermost.com/5.7.1/mattermost-team-5.7.1-linux-amd64.tar.gz .
RUN tar -zxvf ./mattermost-team-5.7.1-linux-amd64.tar.gz && rm ./mattermost-team-5.7.1-linux-amd64.tar.gz
ADD config.json ./mattermost/config/config.json
#RUN mkdir ./mattermost-data

#
# Configure Redmine & Add Plugins
#
RUN ln -s /usr/src/redmine redmine
ADD database.yml redmine/config/

# Plugin formerly known as Redmine Tweaks
ADD https://github.com/AlphaNodes/additionals/archive/master.zip .
RUN unzip master.zip && mv additionals-master /mothership/redmine/plugins/additionals/

#Webhook Integration for Slack/Mattermost
ADD https://github.com/sciyoshi/redmine-slack/archive/master.zip .
RUN unzip master.zip && mv redmine-slack-master /mothership/redmine/plugins/redmine_slack

#Another (newer) theme
ADD https://github.com/mrliptontea/PurpleMine2/archive/master.zip . 
RUN unzip master.zip && mv PurpleMine2-master /mothership/redmine/public/themes/PurpleMine2 && rm master.zip

ADD redmine_start.sh redmine/
RUN cd redmine && export DEBIAN_FRONTEND=noninteractive && bundle install

#Finalize
ADD docker-entry.sh .
RUN chmod +x ./docker-entry.sh && chmod +x /usr/src/redmine/redmine_start.sh && ln -s /var/lib/mysql db
ENTRYPOINT ./docker-entry.sh

# Ports
EXPOSE 8065
EXPOSE 3000
