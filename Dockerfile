FROM ubuntu:16.04
MAINTAINER G6NUK (g6n@pnpenterprises.co.uk)
RUN apt-get update && \
    apt-get install -y isc-dhcp-server bind9 cron ntp ntpdate vim &&\
    apt-get clean && \
    /usr/sbin/rndc-confgen -a

COPY g6nddns.key /etc/bind/ \
     dhcpd.conf /etc/dhcp/ \
     named.conf.local /etc/bind/ \
     home.local.zone /var/lib/bind/ \
     home.local.rev.zone /var/lib/bind/ \
     rootupd.cron /tmp/ \
     ukntp.conf /etc/ntp.conf

RUN chown root:bind /etc/bind/rndc.key && \
    chmod 640 /etc/bind/rndc.key && \
    chown root:root /var/lib/bind/*.zone && \
    chmod 644  /var/lib/bind/*.zone && \
    
CMD crontab /tmp/rootupd.cron && tail -f /var/lib/dhcp/dhcpd.leases
