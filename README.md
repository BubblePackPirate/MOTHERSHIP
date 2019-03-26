# MOTHERSHIP ->

# One line setup
> docker run -it -p 3000:3000 -p 8065:8065 -v mothership_db:/var/lib/mysql --name mothership  mothership:base



Tags | defined
--- | ---
`:base` |  includes basic setup (theme, webhooks) * Default creds: `admin`/`password`
`:unconfigured` | "factory reset" or "first run" apps
`:latest` | "factory reset" or "first run" apps

# Includes Redmine Plugins:
* Redmine-slack (for posting into Mattermost webhooks)
* Additionals (formerly Redmine Tweaks, unlocks customization)
* Minelab (Updated theme based off GitLab)
* Purplemine2 (Another theme)

# TODO
* Provide Redmine Project templates (best practices)

On Docker Hub
https://hub.docker.com/r/bubblepackpirate/mothership/

