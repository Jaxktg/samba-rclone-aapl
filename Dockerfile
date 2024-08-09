# Use Alpine as the base image
FROM debian:latest

# Install the necessary packages
RUN apt update && apt install -y git \
				build-essential \
				libfuse-dev \
				cmake \
				rclone \
				samba \
				fuse3

# Copying smb.conf
COPY ./smb.conf /etc/samba/

# Set the working directory inside the container
WORKDIR /app

# Clone the repository
RUN git clone https://github.com/fbarriga/fuse_xattrs.git .

# Build & install the fuse_xattrs binaries 
RUN mkdir build; cd build
RUN cmake ..; make install

# Define the entry point or CMD to run the built binary
CMD ["service smbd start"]
CMD ["./yourbinary"]

