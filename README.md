# MOTHERSHIP ->

See Docker Hub
https://hub.docker.com/r/bubblepackpirate/mothership/

# Want to run & pull it?
> docker run -it -p 3000:3000 -p 8065:8065 -v mothership_db:/var/lib/mysql --name mothership  mothership:base


* Default creds: `admin`/`password`

Tags | defined
--- | ---
`:base` |  includes basic setup (theme, webhooks)
`:unconfigured` | "factory reset" or "first run" apps

# Includes Redmine Plugins:
* Redmine-slack (for posting into Mattermost webhooks)
* Additionals (formerly Redmine Tweaks, unlocks customization)
* Minelab (Updated theme based off GitLab

# TODO
* Bundle HTTPS support
* Provide Redmine Project templates (best practices)


# Dockerfile source
https://github.com/BubblePackPirate/MOTHERSHIP



