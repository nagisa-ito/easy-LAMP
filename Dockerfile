###################
# php56           #
# postgres, mysql #
###################

FROM centos:centos6.9

#System Update & Install packages
RUN yum -y update
RUN yum -y install httpd

RUN yum install -y epel-release
RUN rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
RUN yum install -y --enablerepo=remi,remi-php56 php php-devel php-mbstring php-pdo php-mysql php-gd php-xml php-intl php-xml php-xmlrpc php-soap php-pecl-apc php-odbc
# add postgres
RUN yum -y --enablerepo=remi-php56 install php-pdo php-pgsql
RUN sed -ri 's/;date.timezone =/date.timezone = Asia\/Tokyo/g' /etc/php.ini
RUN sed -ri 's/display_errors = Off/display_errors = On/g' /etc/php.ini
RUN sed -ri 's/;error_log = php_errors.log/error_log = \/var\/log\/php_errors.log/g' /etc/php.ini

# SSHD
RUN yum install -y openssh-server
RUN echo 'root:root' |chpasswd

# Set up SSHD config
RUN sed -ri 's/#PermitRootLogin yes/PermitRootLogin yes/g' /etc/ssh/sshd_config

# Init SSHD
RUN /etc/init.d/sshd start
RUN /etc/init.d/sshd stop

# Apache
RUN yum -y install httpd
RUN sed -ri '/<Directory "\/var\/www\/html">/,/<\/Directory>/s/    AllowOverride None/    AllowOverride All/' /etc/httpd/conf/httpd.conf && \
    sed -ri '/<Directory "\/var\/www\/html">/,/<\/Directory>/s/    Options Indexes FollowSymLinks/    Options Indexes FollowSymLinks Includes/' /etc/httpd/conf/httpd.conf && \
    sed -ri 's/DirectoryIndex index.html index.html.var/DirectoryIndex index.html index.shtml index.html.var/' /etc/httpd/conf/httpd.conf

#vim
RUN yum -y install vim

# entrypoint
RUN echo '#!/bin/bash' >> /root/init.sh
RUN echo '/etc/init.d/httpd start' >> /root/init.sh
RUN echo 'date > /var/log/date.log' >> /root/init.sh
RUN echo 'tail -f /dev/null' >> /root/init.sh
RUN chmod +x /root/init.sh



EXPOSE 22
EXPOSE 80
EXPOSE 8080
CMD /usr/sbin/sshd -D
#CMD /usr/sbin/httpd -D FOREGROUND
CMD ["/root/init.sh"]
