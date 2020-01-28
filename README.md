# [Keskne](https://translate.google.com/#view=home&op=translate&sl=et&tl=en&text=keskne)

Reverse proxy server for hosting multiple sites on one instance.

## Server Setup

### Docker Machine Setup

[Set up docker machine on the remote host with this.](https://www.digitalocean.com/community/tutorials/how-to-provision-and-manage-remote-docker-hosts-with-docker-machine-on-ubuntu-16-04#step-3-%E2%80%94-provisioning-a-dockerized-host-using-docker-machine)

This machine will run all the containers on it. Then, you can `docker-machine ssh <name>` for everything below.

### Docker Swarm Setup

On the remote host:

```sh
docker swarm init
```

### Generating certs

Run these commands on the remote host (with `docker-machine ssh <name>`). This will generate a wildcard cert, that works on all first-level subdomains.

[Go here](https://cloud.digitalocean.com/settings/api/tokens) to get another DO API token for the server. Then run this stuff on the server:

(TODO: Make this a friendlier script)

```sh
apt-get update
apt-get install software-properties-common
add-apt-repository universe
add-apt-repository ppa:certbot/certbot
apt-get update
apt-get install certbot python3-certbot-dns-digitalocean
echo "dns_digitalocean_token = <token>" > ~/do.ini
chmod 600 ~/do.ini
DOMAIN=<domain> certbot -a dns-digitalocean -i nginx -d "*.$DOMAIN" -d $DOMAIN --server https://acme-v02.api.letsencrypt.org/directory --dns-digitalocean-credentials ~/do.ini certonly
```

This installs the certs to `/app/certs/live/lucaspickering.me/`

[Instructions from here](https://certbot.eff.org/lets-encrypt/ubuntubionic-nginx)

### Adding Secrets

All the secrets are managed through Docker secrets. You can look at `docker-stack.yml` for the list of secrets you need to populate. Use this command:

```sh
echo <secret_value> | docker secret create <secret_name> -
```

Make sure to clean out your shell history after running those.

### Database Backup/Restore

Certain DBs under postgres get backed up automatically every night. To add another DB to the backup list, see `postgres/backup.sh`.

To restore the DB, shell into the postgres container, and run:

```sh
cd /var/lib/postgresql
s3cmd get s3://$S3_BUCKET/backups.tar.gz
tar xzvf backups.tar.gz
psql -c "CREATE DATABASE <db>;" # If necessary
psql <db> < backups/<db>.bak
```

## Updating

### Keskne

`keskne-revproxy` is built from the official nginx-amplify image. Unfortunately there's no official Docker repository for that image, so we have to build it ourselves from the git repo. If you change any configuration and need to rebuild a core image:

```sh
./build_push.sh [service] ... # If no services are specified, it rebuilds/pushes all
```

### Updating Services

Before running these steps, you should set your server as the active docker machine.

To pull in updates for all services, run:

```sh
./deploy.sh
```

For each service, this will only recreate the container if the image changed.

## Development

Keskne can be run in development with minor changes. First, edit `.env` to change the service hostnames and the tag used for docker images. Then, run:

```sh
./build_push.sh
./gencert.sh # Fill in garbage
./deploy.sh
```

Honestly I haven't tested those steps from scratch but they'll get you close at least.
