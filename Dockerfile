FROM ubuntu:latest

RUN apt update && apt upgrade -y && apt install -y dumb-init gnupg gnupg2 gnupg1 locales iptables && locale-gen en_US en_US.UTF-8 && dpkg-reconfigure locales && ln -sf /usr/share/zoneinfo/UTC /etc/localtime

# Install Pritunl
COPY pritunl.list /etc/apt/sources.list.d
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv 7568D9BB55FF9E5287D586017AE645C0CF8E292A && apt-get update && apt install -y pritunl
RUN mkdir -p /etc/security && \
    sh -c 'echo "* hard nofile 64000" >> /etc/security/limits.conf' && \
    sh -c 'echo "* soft nofile 64000" >> /etc/security/limits.conf' && \
    sh -c 'echo "root hard nofile 64000" >> /etc/security/limits.conf' && \
    sh -c 'echo "root soft nofile 64000" >> /etc/security/limits.conf'

EXPOSE 80
EXPOSE 443
EXPOSE 1194

ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["pritunl"]
