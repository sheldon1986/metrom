#!/bin/bash

## libvirt process kill
ps -ef |grep libvirt |grep -v grep |awk -F " " '{print $2}' |xargs kill -9
service libvirtd stop

## libvirt Dir delete
if [[ `ls -l /usr/lib/libvirt |wc -l` > 0 ]]; then
	rm -rf /usr/lib/libvirt
fi

if [[ `ls -l /etc/libvirt |wc -l` > 0 ]]; then
	rm -rf /etc/libvirt
fi

if [[ `ls -l /var/lib/libvirt |wc -l` > 0 ]]; then
	rm -rf /var/lib/libvirt
fi

## libvirt Package Delete
if [[ `apt list |grep libvirt |grep installed |wc -l` > 0 ]]; then
	apt remove *libvirt* -y
fi

if [[ `apt list |grep libvirt |grep residual |wc -l` > 0 ]]; then
	dpkg -l | grep '^rc' | awk '{print $2}' | xargs sudo apt-get purge -y
fi

## libvirtUser Delete
if [[ `cat /etc/passwd |grep libvirt |wc -l` > 0 ]];then
	userdel libvirt-qemu
	userdel libvirt-dnsmasq
fi

## libvirt Group Delete
if [[ `cat /etc/group |grep libvirt |wc -l` > 0 ]];then
	groupdel libvirtd
fi

## KVM setting
echo "options kvm_intel nested=1" > /etc/modprobe.d/kvm-nested.conf
modprobe -r kvm_intel
modprobe kvm_intel

## sshd port change
if [[ `egrep Port\ 22 /etc/ssh/sshd_config` = Port\ 22 ]];then
	sed -i 's/Port\ 22/Port\ 2222/g' /etc/ssh/sshd_config
	service sshd restart
fi

## firewall setting
ufw disable
