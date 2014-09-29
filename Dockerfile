FROM debian:jessie
MAINTAINER yaasita

#apt
ADD 02proxy /etc/apt/apt.conf.d/02proxy
RUN apt-get update
RUN apt-get upgrade -y

#ssh
RUN apt-get install -y openssh-server
RUN mkdir /var/run/sshd/
RUN mkdir /root/.ssh
ADD authorized_keys /root/.ssh/authorized_keys
RUN perl -i -ple 's/^(permitrootlogin\s)(.*)/\1yes/i' /etc/ssh/sshd_config
RUN echo root:root | chpasswd

# supervisor
RUN apt-get install -y supervisor
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
EXPOSE 22 80
CMD ["/usr/bin/supervisord"]

# package
RUN apt-get install -y vim aptitude htop

# jquery-file-upload
RUN apt-get install -y php5-gd php-pear \
 libapache2-mod-php5 apache2 apache2-utils php5-apcu 
RUN rm -rf /var/www
RUN mkdir /var/www
ADD 9.8.0.tar.gz /var/www/
RUN tar xvaf /var/www/
ADD jquery-file-upload/index.html /var/www/index.html
ADD php/php.ini /etc/php5/apache2/php.ini
ADD apache/apache2.conf /etc/apache2/apache2.conf
ADD apache/000-default.conf /etc/apache2/sites-available/000-default.conf
