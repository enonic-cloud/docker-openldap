#!/bin/bash
if [[ -f /etc/ldap/init/init.ldif ]]
	then
	echo "Found /etc/ldap/init/init.ldif skipping ldap init."
	exit 1
fi

echo "generating /etc/ldap/init/init.ldif file"
cat > /etc/ldap/init/init.ldif << EOF
dn: olcDatabase=hdb,cn=config
objectClass: olcDatabaseConfig
objectClass: olcHdbConfig
olcDatabase: hdb
olcDbDirectory: /var/lib/ldap
olcSuffix: $LDAP_BASE_DN
olcAccess: {0}to attrs=userPassword,shadowLastChange by self write by anonymous auth by  dn="$LDAP_ROOT_DN" write by * none
olcAccess: {1}to dn.base="" by * read
olcAccess: {2}to * by self write by dn="$LDAP_ROOT_DN" write by * read
olcLastMod: TRUE
olcRootDN: $LDAP_ROOT_DN
olcRootPW: $( slappasswd -s $LDAP_ROOT_PWD )
olcDbCheckpoint: 512 30
olcDbConfig: {0}set_cachesize 0 2097152 0
olcDbConfig: {1}set_lk_max_objects 1500
olcDbConfig: {2}set_lk_max_locks 1500
olcDbConfig: {3}set_lk_max_lockers 1500
olcDbIndex: objectClass,uid,uidNumber,gidNumber,memberUid   eq
olcDbIndex: cn,mail,surname,givenname                       eq,subinitial
EOF
echo "Setting up ldap server with init file: /etc/ldap/init/init.ldif"
ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/ldap/init/init.ldif

echo "Generating /etc/ldap/init/init2.ldif file"
cat > /etc/ldap/init/init2.ldif << EOF
dn: $LDAP_BASE_DN
dc: $(echo $LDAP_BASE_DN | cut -d= -f2)
o: auto generated domain component
objectClass: top
objectClass: dcObject
objectClass: organization
EOF

echo "Adding entry $LDAP_BASE_DN in /etc/ldap/init/init2.ldif"
ldapadd -H ldapi:/// -D $LDAP_ROOT_DN -w $LDAP_ROOT_PWD -f /etc/ldap/init/init2.ldif

if [[ -f /init/export.ldif ]]
	then
	echo "Found /init/export.ldif. Importing..."
	ldapadd -H ldapi:/// -D $LDAP_ROOT_DN -w $LDAP_ROOT_PWD -f /init/export.ldif
fi

