# [Keskne](https://translate.google.com/#view=home&op=translate&sl=et&tl=en&text=keskne)

Reverse proxy server for hosting multiple sites on one instance.

## Server Setup

### Docker-machine Setup

[Go here](https://www.digitalocean.com/community/tutorials/how-to-provision-and-manage-remote-docker-hosts-with-docker-machine-on-ubuntu-16-04#step-3-%E2%80%94-provisioning-a-dockerized-host-using-docker-machine)

This machine will run all the containers on it. After setup, you can use `docker-machine ssh <name>` for the next section.

### Generating certs

This will generate a wildcard cert, that works on all first-level subdomains.

[Go here](https://cloud.digitalocean.com/settings/api/tokens) to get another DO API token for the server. Then run this stuff:

```
apt-get update
apt-get install software-properties-common
add-apt-repository universe
add-apt-repository ppa:certbot/certbot
apt-get update
apt-get install certbot python3-certbot-dns-digitalocean
echo "dns_digitalocean_token = <token>" > ~/do.ini
chmod 600 ~/do.ini
certbot -a dns-digitalocean -i nginx -d "*.<domain>" -d <domain> --server https://acme-v02.api.letsencrypt.org/directory --dns-digitalocean-credentials ~/do.ini certonly
```

Make sure to use the
Needed for HTTPS. This installs the certsInstall to `/app/certs/live/lucaspickering.me/`

[Instructions from here](https://certbot.eff.org/lets-encrypt/ubuntubionic-nginx)

## Updating

Before running any of these steps, you should set your server as the active docker machine.

### Keskne

To update the Keskne revproxy, run:

```
./build_keskne.sh
```

### Updating Services

To pull in updates for all services, run:

**(The revproxy pull will always fail)**

```
./deploy.sh
```

To only pull new images for certain services, run:

```
./deploy.sh <service> ...
```
