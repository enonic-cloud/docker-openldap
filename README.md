# Docker container for Openldap
This is a simple docker container for openldap.

## Usage
We recommend using docker-compose to start up the containers. But if you want, you can set them up manualy too. Just make shure you have the right Environment variables and storage volumes set.

To start up the instance, simply use docker-compose to build and deploy the instance.
```
docker-compose build
docker-compose up -d
```

If you haven't initialized the ldap server, now is a great time to do that. replace `dockeropenldap_ldap_1` with the container name 
```
docker exec -it dockeropenldap_ldap_1 /init/init.sh
```


## Configuration
### Environment variables
You need to set up the following environment variables:
- LDAP_ROOT_DN = root dn for ldap server
- LDAP_ROOT_PWD = password for the RootDN user
- LDAP_BASE_DN  = BaseDN for the ldap server

### Persistant storage volumes
The following paths can be mounted from volume to preserve state over redeployments
- /var/lib/ldap
- /etc/ldap/init
- /etc/ldap/slap.d

## Automatic import at init
The init script looks for the file "/init/export.ldif". If it finds it, then it will import that ldif file into the ldap store automaticly

## Backup
- Run `/usr/local/bin/backup-pre.sh` to export installation data to the folder - Backup the folder `/backup` from the container to you backup directory.
- Run `/usr/local/bin/backup-post.sh` to clean up.



