#!/sbin/sh

BB="busybox"

if [ "$1" == "secondary" ] ; then
   system=/.firstrom/media/.secondrom/system.img
   $BB umount -f /system
   $BB mkdir -p /system

   $BB mount -t ext4 -o rw $system /system || exit 1
   $BB rm -rf /system/*
   $BB rm -rf /system/.*
   $BB mke2fs -F -T ext4 $system || exit 1
fi

exit 0
