FROM ubuntu:14.04

MAINTAINER Erik Kaareng-Sunde <esu@enonic.com>

RUN apt-get update ; apt-get install -y slapd ldap-utils ; apt-get clean

ADD init /init
RUN chmod +x /init/*.sh

EXPOSE 389
CMD /usr/sbin/slapd -h "ldap://$HOSTNAME ldapi:///" -u openldap -g openldap -d 8