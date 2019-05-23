# [Keskne](https://translate.google.com/#view=home&op=translate&sl=et&tl=en&text=keskne)

Reverse proxy server for hosting multiple sites on one instance.

## Server Setup

### Generating certs

[Go here](https://certbot.eff.org/lets-encrypt/ubuntubionic-nginx)

### Docker-machine Setup

[Go here](https://www.digitalocean.com/community/tutorials/how-to-provision-and-manage-remote-docker-hosts-with-docker-machine-on-ubuntu-16-04#step-3-%E2%80%94-provisioning-a-dockerized-host-using-docker-machine)

## Updating Servers

```
docker-compose pull
docker-compose stop
docker-compose volume prune -f # Wips out old static files
docker-compose up -d
```
