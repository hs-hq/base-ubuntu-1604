# Base container for Holberton School
#
# Allow SSH connection to the container

FROM ubuntu:16.04
MAINTAINER Guillaume Salva <guillaume@holbertonschool.com>

RUN apt-get update
RUN apt-get -y upgrade

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=America/Los_Angeles
RUN apt-get install -y tzdata

# curl/wget/git
RUN apt-get install -y sudo openssh-server
RUN apt-get install -y curl wget git
# vim/emacs
RUN apt-get install -y vim emacs
# Shell
RUN apt-get install -y bc
RUN apt-get install -y shellcheck
# C
RUN apt-get install -y build-essential gcc
RUN apt-get install -y valgrind
RUN apt-get install -y ltrace
RUN apt-get install -y strace
RUN apt-get install -y libc6-dev-i386
RUN apt-get install -y libssl-dev
RUN apt-get install -y nasm
# Sysadmin
RUN apt-get install -y nmap
RUN apt-get install -y dnsutils
RUN apt-get install -y netcat
RUN apt-get install -y iputils-ping

# MySQL
RUN apt-get install -y mysql-server
RUN usermod -d /var/lib/mysql/ mysql
RUN apt-get install -y libmysqlclient-dev

RUN apt-get install -y lsof

# Set the locale
RUN apt-get install -y locales
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Install Betty    
RUN git clone https://github.com/holbertonschool/Betty.git /tmp/Betty \
    && cd /tmp/Betty \
    && ./install.sh \
    && cd - \
    && rm -rf /tmp/Betty

# man
RUN apt-get install -y sudo man manpages-dev manpages-posix-dev man-db

# Setup SSH
RUN mkdir /var/run/sshd \
    && sed -ri 's/^PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed -ri 's/^#PasswordAuthentication/PasswordAuthentication/' /etc/ssh/sshd_config \
    && sed -ri 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config \
    && sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config 
    
COPY run.sh /etc/sandbox_run.sh
RUN chmod u+x /etc/sandbox_run.sh

CMD ["/etc/sandbox_run.sh"]
