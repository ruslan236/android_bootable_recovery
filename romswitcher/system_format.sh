#!/sbin/sh

BB="busybox"

if [ "$1" == "secondary" ] ; then
   if $BB grep -q /data /proc/mounts; then
      second=/data/media/.secondrom/system.img
   else
      second=/.firstrom/media/.secondrom/system.img
   fi

   $BB umount -f /system
   $BB mkdir -p /system

   $BB mount -t ext4 -o rw $second /system || exit 1
   $BB rm -rf /system/*
   $BB rm -rf /system/.*
   $BB mke2fs -F -T ext4 $second || exit 1

elif [ "$1" == "tertiary" ] ; then
   if $BB grep -q /data /proc/mounts; then
      third=/data/media/.thirdrom/system.img
    else
      third=/.firstrom/media/.thirdrom/system.img
   fi

   $BB umount -f /system
   $BB mkdir -p /system

   $BB mount -t ext4 -o rw $third /system || exit 1
   $BB rm -rf /system/*
   $BB rm -rf /system/.*
   $BB mke2fs -F -T ext4 $third || exit 1

elif [ "$1" == "quaternary" ] ; then
   if ! $BB grep -q /storage/sdcard1 /proc/mounts; then
      $BB mkdir -p /storage/sdcard1
      $BB mount -t auto -o rw /dev/block/mmcblk1p1 /storage/sdcard1 || exit 1
   fi

   fourth=/storage/sdcard1/romswitcher/.fourthrom/system.img

   $BB umount -f /system
   $BB mkdir -p /system

   $BB mount -t ext4 -o rw $fourth /system || exit 1
   $BB rm -rf /system/*
   $BB rm -rf /system/.*
   $BB mke2fs -F -T ext4 $fourth || exit 1
else

   exit 1
   echo "failed to format system.img"

fi

exit 0
