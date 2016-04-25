#!/bin/bash
BACKUP_DIR=/backup

if [[ ! -d $BACKUP_DIR ]]
	then
	mkdir $BACKUP_DIR
fi

rm -rf $BACKUP_DIR/*
echo "Saving environment variables"
cat > $BACKUP_DIR/auth.env << EOF
LDAP_ROOT_DN=$LDAP_ROOT_DN
LDAP_ROOT_PWD=$LDAP_ROOT_PWD
LDAP_BASE_DN=$LDAP_BASE_DN
EOF

echo "Copying running configuration"
cp -rf /etc/ldap/init $BACKUP_DIR/running_init

echo "exporting $LDAP_BASE_DN"
ldapsearch -H ldapi:/// -D $LDAP_AUTH_DN -w $LDAP_AUTH_PWD -z 0 -x -b "$LDAP_BASE_DN"  '(objectclass=*)' > $BACKUP_DIR/export.ldif
