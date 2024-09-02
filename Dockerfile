# Use Alpine as the base image
FROM debian:latest

# Install the necessary packages
RUN apt update && apt install -y git \
				supervisor \
				build-essential \
				libfuse-dev \
				cmake \
				rclone \
				samba \
				fuse3


# Copying smb.conf
COPY ./smb.conf /etc/samba/

# Copying rclone.conf
COPY ./rclone_conf/* /root/.config/rclone/

# Set the working directory inside the container
WORKDIR /app

# Copy your script into the container

COPY entrypoint.sh /

# Clone the repository
RUN git clone https://github.com/fbarriga/fuse_xattrs.git

# Build & install the fuse_xattrs binaries
WORKDIR /app/fuse_xattrs
RUN mkdir build
WORKDIR /app/fuse_xattrs/build
RUN cmake ..; make install

# Make the script executable
RUN chmod +x /entrypoint.sh

EXPOSE 139 445

ENTRYPOINT ["/entrypoint.sh"]
