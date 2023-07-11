#!/bin/bash
nonce=$1
username=$2
password=$3
admin=$4
secret=$shared_secret

usage(){
	echo "Usage: $0 nonce username password admin/notadmin"
	exit 1
}

[[ $# -eq 0 ]] && usage

if [ -z "$1" ]
  then
    echo "nonce not provided"
    exit 1
fi

if [ -z "$2" ]
  then
    echo "username not provided"
    exit 1
fi

if [ -z "$3" ]
  then
    echo "password not provided"
    exit 1
fi

if [ -z "$4" ]
  then
    echo "admin/notadmin not provided"
    exit 1
fi


if [[ "$4" !=  "admin" && "$4" != "notadmin" ]]
  then
    echo "unacceptable value for admin: valid values are admin or notadmin"
    exit 1
fi
printf '%s\0%s\0%s\0%s' "$nonce" "$username" "$password" "$admin" |
  openssl sha1 -hmac "$secret" |
  awk '{print $2}'
