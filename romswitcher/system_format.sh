#!/sbin/sh

BB="busybox"

$BB umount -f /system
$BB mkdir -p /system
system=/.firstrom/media/.secondrom/system.img
$BB mount -t ext4 -o rw $system /system
$BB rm -rf /system/*
$BB rm -rf /system/.*
$BB mke2fs -F -T ext4 $system || exit 1

exit 0
