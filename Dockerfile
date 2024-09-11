# Use the official Ubuntu image as a base
FROM ubuntu:latest

# Install necessary packages and Docker
RUN apt-get update && apt-get install -y \
    sudo \
    curl \
    gnupg \
    lsb-release \
    && curl -fsSL https://get.docker.com -o get-docker.sh \
    && sh get-docker.sh \
    && rm get-docker.sh \
    && usermod -aG docker root \
    && apt-get clean

# Install OpenSSH Server
RUN apt-get install -y openssh-server \
    && mkdir /var/run/sshd \
    && echo 'root:password' | chpasswd

# Create a new SSH configuration file
RUN echo 'PermitRootLogin yes' > /etc/ssh/sshd_config.d/custom.conf \
    && echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config.d/custom.conf

# Start SSH service
CMD ["/usr/sbin/sshd", "-D"]
