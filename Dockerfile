# syntax=docker/dockerfile:1
FROM debian:12
# install app dependencies
RUN apt-get update && apt-get install -y apache2 mariadb-client mariadb-server cpanminus libapache2-mod-perl2 libdbd-mysql-perl libtimedate-perl libnet-dns-perl libnet-ldap-perl libio-socket-ssl-perl libpdf-api2-perl libsoap-lite-perl libtext-csv-xs-perl libjson-xs-perl libapache-dbi-perl libxml-libxml-perl libxml-libxslt-perl libyaml-perl libarchive-zip-perl libcrypt-eksblowfish-perl libencode-hanextra-perl libmail-imapclient-perl libtemplate-perl libdatetime-perl libmoo-perl bash-completion libyaml-libyaml-perl libjavascript-minifier-xs-perl libcss-minifier-xs-perl libauthen-sasl-perl libauthen-ntlm-perl libhash-merge-perl libical-parser-perl libspreadsheet-xlsx-perl libcrypt-jwt-perl libcrypt-openssl-x509-perl jq wget libcpan-audit-perl libdata-uuid-perl libdbd-odbc-perl libdbd-pg-perl sudo cron
# Download Znuny
RUN cd /opt && wget https://download.znuny.org/releases/znuny-latest-6.5.tar.gz && tar xfz znuny-latest-6.5.tar.gz
# Create a symlink
RUN ln -s /opt/znuny-6.5.14 /opt/otrs
# Add user for Debian/Ubuntu
RUN useradd -d /opt/otrs -c 'Znuny user' -g www-data -s /bin/bash -M -N otrs
# Copy Default Config
RUN cp /opt/otrs/Kernel/Config.pm.dist /opt/otrs/Kernel/Config.pm
# Set permissions
RUN /opt/otrs/bin/otrs.SetPermissions.pl
# As otrs User - Rename default cronjobs
RUN su - otrs && cd /opt/otrs/var/cron && for foo in *.dist; do cp $foo `basename $foo .dist`; done
RUN ~otrs/bin/otrs.CheckModules.pl --all
RUN cpanm install Jq
RUN ln -s /opt/otrs/scripts/apache2-httpd.include.conf /etc/apache2/conf-available/zzz_znuny.conf
RUN sudo -u otrs /opt/otrs/bin/Cron.sh start

EXPOSE 80