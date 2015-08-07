############################################################
# Dockerfile: CentOS6 & OpenVPN
############################################################
FROM centos:centos6

MAINTAINER CarbonSphere <CarbonSphere@gmail.com>

# Set environment variable
ENV HOME 						/root
ENV TERM 						xterm

RUN yum -y update; yum -y install epel-release; yum -y clean all

RUN yum -y install openvpn; yum -y clean all

EXPOSE 1194/tcp

ADD ovpn_start.sh /root/ovpn_start.sh

WORKDIR /etc/openvpn

CMD ["/root/ovpn_start.sh"]
