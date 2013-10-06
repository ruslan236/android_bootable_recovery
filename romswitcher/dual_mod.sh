#!/sbin/sh
#
#
#

MOUNTPOINT=$1
FILE=$2

updater_script_path="META-INF/com/google/android/updater-script"
echo "mountpoint: $MOUNTPOINT"
echo "file: $FILE"
rm -rf $MOUNTPOINT/.dualboot/*
mkdir -p $MOUNTPOINT/.dualboot || exit 1

if [ ! -s $FILE ] ; then
echo "could not find the file! Are there spaces in the name or path?"
exit 2
fi

unzip_binary -o $FILE $updater_script_path -d "$MOUNTPOINT"/.dualboot || exit 1
#### use mount script ####
sed 's|mount("ext4", "EMMC", "/dev/block/mmcblk0p20", "/system");|run_program("/sbin/mount_dual.sh", "secondary");|g' -i "$MOUNTPOINT"/.dualboot/$updater_script_path || exit 1

### also use script for formating ###
sed 's|format("ext4", "EMMC", "/dev/block/mmcblk0p20", "0", "/system");|run_program("/sbin/system_format.sh");|g' -i "$MOUNTPOINT"/.dualboot/$updater_script_path || exit 1

sed 's|format("ext4", "EMMC", "/dev/block/mmcblk0p20");|run_program("/sbin/system_format.sh");|g' -i "$MOUNTPOINT"/.dualboot/$updater_script_path || exit 1

# get the kernel
sed 's|package_extract_file("boot.img", "/dev/block/mmcblk0p9");|#|g' -i "$MOUNTPOINT"/.dualboot/$updater_script_path || exit 1

cd $MOUNTPOINT/.dualboot
zip $FILE $updater_script_path || exit 1
echo "installing rom now ..."
cd /

umount -f /system
exit 0
