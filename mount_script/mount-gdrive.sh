#!/bin/bash

#!/bin/bash

mkdir -p /mnt/backup-crypt
mkdir -p /mnt/backup-crypt-xattr

/usr/bin/rclone mount backup-crypt:/ /mnt/backup-crypt/ \
	-v \
	--vfs-cache-mode full \
	--daemon \
	--drive-pacer-burst 200 \
	--drive-pacer-min-sleep 10ms \
	--log-file ./rclone.log \
	--transfers 64 \
	--checkers 64 \
	--fast-list \
	--buffer-size=32M \
	--volname="Backup (Encrypted)" \
	--vfs-cache-max-age 5m \
	--vfs-cache-poll-interval 30s \
	--default-permissions \
	--allow-other

fuse_xattrs /mnt/backup-crypt /mnt/backup-crypt-xattr \
	-o big_writes \
	-o max_write=524288 \
	-o async_read \
	-o max_readahead=1310720 \
	-o kernel_cache \
	-o auto_cache \
	-o allow_other \
	-o umask=0000 \
	-o gid=$(getent group smbaccess | cut -d: -f3)

