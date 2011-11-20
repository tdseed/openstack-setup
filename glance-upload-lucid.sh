#!/bin/bash

# Import Settings
. settings

if [ ! -f "lucid-server-cloudimg-amd64.tar.gz" ] ; then
	echo "Downloading image"
	wget http://cloud-images.ubuntu.com/lucid/current/lucid-server-cloudimg-amd64.tar.gz
fi

if [ ! -f "lucid-server-cloudimg-amd64.img" ] ; then
        echo "Extracting image"
	tar xfzv lucid-server-cloudimg-amd64.tar.gz
fi

TOKEN=`./obtain-token.sh`
echo "Uploading kernel"
RVAL=`glance -A $TOKEN add name="ubuntu-lucid-kernel" is_public=true container_format=aki disk_format=aki < lucid-server-cloudimg-amd64-vmlinuz-virtual`
KERNEL_ID=`echo $RVAL | cut -d":" -f2 | tr -d " "`

echo "Uploading image"
glance -A $TOKEN add name="ubuntu-lucid" is_public=true container_format=ami kernel_id=$KERNEL_ID disk_format=ami < lucid-server-cloudimg-amd64.img
