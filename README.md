# Samba-Rclone-AAPL

This repository allows you to mount Rclone as an SMB share, which can be accessed on macOS and iOS devices (Thanks for fbarriga's [fuse_xattrs](https://github.com/fbarriga/fuse_xattrs) to make this work). To set up the Rclone mount for SMB shares, you will need to modify a few configuration files.
```txt
Rclone <---> fuse <---> fuse_xattrs <---> samba
```



## Prerequisites

- Docker installed on your system.
-  Basic knowledge of editing configuration files.

## Setup Instructions

1. Clone the Repository:
```bash
git clone https://github.com/Jaxktg/samba-rclone-aapl.git
cd samba-rclone-aapl
```

## Configure Rclone:
Modify the rclone.conf file located in the rclone_conf/ directory with your specific remote configurations.
## Edit Mount Scripts:
Adjust the mount-*.sh scripts in the mount_script/ directory to match your mount points and options.
## User Configuration:
Update the user.conf file with your SMB user credentials and preferences.
## Build and Run:
Build the Docker image and run the container using Docker Compose:

```bash
docker-compose up --build -d
```

## Access the SMB Share:
On your macOS or iOS device, connect to the SMB share using the network path provided in your setup.
```txt
smb://YOUR-IP/share_name
```


## Notes

Ensure all paths and configurations match your environment before starting the container.

Refer to the official [Rclone documentation](https://rclone.org/docs/) for advanced configuration options.

