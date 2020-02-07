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

This should be set up behind Cloudflare, in which case Cloudflare provides its own certs. We can use a self-signed cert locally and Cloudflare will accept that.

```sh
./x.py gencert
```

Once that is working, you can optionally replace the self-signed cert with a [Cloudflare Origin CA cert](https://support.cloudflare.com/hc/en-us/articles/115000479507#h_30e5cf09-6e98-48e1-a9f1-427486829feb), then set the SSL/TLS mode in Cloudflare to "Full (Strict)".

### Adding Secrets

All the secrets are managed through Docker secrets. You can look at `docker-stack.yml` for the list of secrets you need to populate, or use `x.py` to do it:

```sh
./x.py secrets
```

Make sure to clean out your shell history after running those.

### Database Backup/Restore

Certain DBs under postgres get backed up automatically every night. To add another DB to the backup list, see `postgres/backup.sh`.

To restore the DB, shell into the postgres container, and run:

```sh
cd /var/lib/postgresql
s3cmd get s3://$S3_BUCKET/<file name>
tar xzvf <file name>
psql -c "CREATE DATABASE <db>;" # If necessary
psql <db> < backups/<db>.bak
```

## Updating

### Keskne

`keskne-revproxy` is built from the official nginx-amplify image. Unfortunately there's no official Docker repository for that image, so we have to build it ourselves from the git repo. If you change any configuration and need to rebuild a core image:

```sh
./x.py build --push [service] ... # If no services are specified, it rebuilds/pushes all
```

### Updating Services

Before running these steps, you should set your server as the active docker machine.

To pull in updates for all services, run:

```sh
./x.py deploy
```

## Development

Keskne can be run in development with minor setup. First:

```sh
cp env.json dev.env.json
```

Then edit `dev.env.json` to change `KESKNE_IMAGE_TAG`, `KESKNE_LOGS_DIR`, and the hostnames. You may have to edit `/etc/hosts` to add domains that point to `127.0.0.1`. Then:

```sh
docker swarm init
./x.py -e dev.env.json build --push
./x.py -e dev.env.json gencert
./x.py -e dev.env.json secrets --placeholder
./x.py -e dev.env.json deploy --make-logs
```
