#!/sbin/sh

BB="busybox"
FILESYSTEM=$1

if [ $FILESYSTEM == "secondary" ]; then

   $BB mkdir -p /data/media/.secondrom
   second=/data/media/.secondrom/system.img

   if $BB [ ! -f $second ] ; then
	# create a file 650MB
	$BB dd if=/dev/zero of=$second bs=1024 count=657286 || exit 1
	# create ext4 filesystem
	$BB mke2fs -F -T ext4 $second || exit 1
   fi

elif [ $FILESYSTEM == "tertiary" ]; then

   $BB mkdir -p /data/media/.thirdrom
   third=/data/media/.thirdrom/system.img

   if $BB [ ! -f $third ] ; then
      # create a file 650MB
      $BB dd if=/dev/zero of=$third bs=1024 count=657286 || exit 1
      # create ext4 filesystem
      $BB mke2fs -F -T ext4 $third || exit 1
   fi

elif [ $FILESYSTEM == "quaternary" ]; then

   if ! $BB grep -q /storage/sdcard1 /proc/mounts; then
      $BB mkdir -p /storage/sdcard1
      $BB mount -t auto -o rw /dev/block/mmcblk1p1 /storage/sdcard1 || exit 1
   fi

   $BB mkdir -p /storage/sdcard1/romswitcher/.fourthrom
   fourth=/storage/sdcard1/romswitcher/.fourthrom/system.img

   if $BB [ ! -f $fourth ] ; then
	# create a file 2.5GB
	$BB dd if=/dev/zero of=$fourth bs=2048 count=2572864 || exit 1
	# create ext4 filesystem
	$BB mke2fs -F -T ext4 $fourth || exit 1
   fi

fi

exit 0
