FROM honeyshawn/hadoop:2.7.6

MAINTAINER honeyshawn

USER root

ADD bootstrap.sh /etc/bootstrap.sh
RUN chown root:root /etc/bootstrap.sh
RUN chmod 700 /etc/bootstrap.sh

CMD ["/etc/bootstrap.sh"]