#!/sbin/sh
#
#
#

MOUNTPOINT=$1
FILE=$2

updater_script_path="META-INF/com/google/android/updater-script"
echo "mountpoint: $MOUNTPOINT"
echo "file: $FILE"
rm -rf $MOUNTPOINT/.tmp/*
mkdir -p $MOUNTPOINT/.tmp || exit 1

if [ ! -s $FILE ] ; then
   echo "could not find the file! Are there spaces in the name or path?"
   exit 2
fi

unzip_binary -o $FILE $updater_script_path -d "$MOUNTPOINT"/.tmp || exit 1
#### use mount script ####
sed 's|mount("ext4", "EMMC", "/dev/block/mmcblk0p20", "/system");|run_program("/sbin/mount_recovery.sh", "tertiary");|g' -i "$MOUNTPOINT"/.tmp/$updater_script_path || exit 1

### also use script for formating ###
sed 's|format("ext4", "EMMC", "/dev/block/mmcblk0p20", "0", "/system");|run_program("/sbin/system_format.sh", "tertiary");|g' -i "$MOUNTPOINT"/.tmp/$updater_script_path || exit 1

sed 's|format("ext4", "EMMC", "/dev/block/mmcblk0p20");|run_program("/sbin/system_format.sh", "tertiary");|g' -i "$MOUNTPOINT"/.tmp/$updater_script_path || exit 1

# get the kernel
sed 's|package_extract_file("boot.img", "/dev/block/mmcblk0p9");|#|g' -i "$MOUNTPOINT"/.tmp/$updater_script_path || exit 1

# busybox mount
sed 's|run_program("/sbin/busybox", "mount", "/system");|run_program("/sbin/mount_recovery.sh", "tertiary");|g' -i "$MOUNTPOINT"/.tmp/$updater_script_path || exit 1

sed 's|run_program("/sbin/busybox", "mount", "/data");|run_program("/sbin/mount_recovery.sh", "tertiary");|g' -i "$MOUNTPOINT"/.tmp/$updater_script_path || exit 1

sed 's|run_program("/sbin/busybox", "mount", "/cache");|#|g' -i "$MOUNTPOINT"/.tmp/$updater_script_path || exit 1

cd $MOUNTPOINT/.tmp
zip $FILE $updater_script_path || exit 1
cd /

umount -f /system
exit 0
