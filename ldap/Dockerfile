FROM ubuntu:14.04

MAINTAINER Erik Kaareng-Sunde <esu@enonic.com>

RUN apt-get update ; apt-get install -y slapd ldap-utils ; apt-get clean

ADD init /init
ADD backup-pre.sh /usr/local/bin/backup-pre.sh
ADD backup-post.sh /usr/local/bin/backup-post.sh
RUN chmod +x /usr/local/bin/backup-*.sh
RUN chmod +x /init/*.sh

EXPOSE 389
CMD /usr/sbin/slapd -h "ldap://$HOSTNAME ldapi:///" -u openldap -g openldap -d 8