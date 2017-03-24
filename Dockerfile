FROM ubuntu:16.04
MAINTAINER G6NUK (g6n@pnpenterprises.co.uk)
RUN apt-get update && \
    apt-get install -y isc-dhcp-server bind9 cron ntp ntpdate vim &&\
    apt-get clean && \
    /usr/sbin/rndc-confgen -a

COPY dhcpd.conf /etc/dhcp/ 
COPY named.conf.local /etc/bind/ 
COPY named.conf.options /etc/bind/ 
COPY home.local.zone /var/lib/bind/ 
COPY home.local.rev.zone /var/lib/bind/ 
COPY rootupd.cron /tmp/ 
COPY ukntp.conf /etc/ntp.conf

RUN chown root:bind /etc/bind/rndc.key && \
    chmod 640 /etc/bind/rndc.key && \
    chown root:root /var/lib/bind/*.zone && \
    chmod 644  /var/lib/bind/*.zone
    
CMD touch /var/lib/dhcp/dhcpd.leases && crontab /tmp/rootupd.cron && tail -f /var/lib/dhcp/dhcpd.leases
