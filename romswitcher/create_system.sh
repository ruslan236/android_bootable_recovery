#!/sbin/sh

BB="busybox"
FILESYSTEM=$1
UMOUNT="busybox umount -f"

BLOCKDEVICE=mmcblk0p21 #data

if [ $FILESYSTEM == "secondary" ]; then

   $BB mkdir -p /data/media/.secondrom
   system=/data/media/.secondrom/system.img

   if $BB [ ! -f $system ] ; then
	# create a file 650MB
	$BB dd if=/dev/zero of=$system bs=1024 count=657286 || exit 1
	# create ext4 filesystem
	$BB mke2fs -F -T ext4 $system || exit 1
   fi

fi

exit 0
