FROM redmine

WORKDIR /mothership

#Install random stuff
RUN export DEBIAN_FRONTEND=noninteractive && apt-get update && apt-get install -y ca-certificates locate tcpdump nano lsb-release unzip

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

RUN service mysql start && chmod +x mysql_setup && ./mysql_setup

#SSL certs?
#
#
#

#
# Configure Mattermost -- Change all instances of "4.3.1" to new version to update
#
ADD https://releases.mattermost.com/4.3.1/mattermost-team-4.3.1-linux-amd64.tar.gz .
RUN tar -zxvf ./mattermost-team-4.3.1-linux-amd64.tar.gz
ADD config_docker.json ./mattermost/config/config_docker.json
RUN mkdir ./mattermost-data

#
# Configure Redmine
#
RUN mkdir ./redmine-data && ln -s /usr/src/redmine redmine
ADD database.yml redmine/config/

# Plugin formerly known as Redmine Tweaks
ADD https://github.com/AlphaNodes/additionals/archive/master.zip .
#RUN unzip additionals-master.zip
RUN unzip master.zip
RUN mv additionals-master /mothership/redmine/plugins/additionals/

#Webhook Integration for Slack/Mattermost
ADD https://github.com/sciyoshi/redmine-slack/archive/master.zip .
RUN unzip master.zip
RUN mv redmine-slack-master /mothership/redmine/plugins/redmine_slack

#Theme only...Brings Remine in line with GitLab theme 
ADD https://github.com/hardpixel/minelab/archive/master.zip .
RUN unzip master.zip
RUN mv minelab-master /mothership/redmine/public/themes/minelab

ADD redmine_start.sh redmine/
RUN bundle install

#Finalize
ADD docker-entry.sh .
RUN chmod +x ./docker-entry.sh && chmod +x /usr/src/redmine/redmine_start.sh
ENTRYPOINT ./docker-entry.sh

VOLUME /mothership

# Ports
EXPOSE 8065
EXPOSE 3000
