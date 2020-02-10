#!/bin/bash

# $1 [a, r, ssl]
#	a = add
#	r = remove
# 	ssl = update ssl (remove and create)
#
# $2 domain
#
# $3 public directory to 
#
# $4 php version

# Add vhost
if [ $1 == 'a' ]; then

 echo 'Creating apache conf file'
 cp ./default.conf /etc/apache2/sites-enabled/$2.acoulombe.conf
 cd /etc/apache2/sites-enabled

 # Creating and replacing apache2 conf file
 sed -i 's,domain.local,'"$2"'.local,g' $2.acoulombe.conf
 sed -i 's,/home/acoulombe/vhosts/src-directory,'"$3"',g' $2.acoulombe.conf
 sed -i 's,/home/acoulombe/ssl/domain.local.pem,/home/acoulombe/ssl/'"$2"'.local.pem,g' $2.acoulombe.conf
 sed -i 's,/home/acoulombe/ssl/domain.local-key.pem,/home/acoulombe/ssl/'"$2"'.local-key.pem,g' $2.acoulombe.conf
 sed -i 's,/run/php/php5.6,/run/php/php'"$4"',g' $2.acoulombe.conf

 # Creating ssl
 echo 'Creating SSL files'
 cd ~/ssl
 mkcert $2.local

 # Replacing hosts
 echo 'Adding to hosts file'
 cd /etc/
 echo '127.0.0.1       '"$2"'.local' >>  hosts

fi

# Remove vhost
if [ $1 == 'r' ]; then

 # Remove ssl files
 echo 'Removing SSL'
 cd ~/ssl
 rm $2.local*

 # Remove hosts
 echo 'Removing hosts'
 cd /etc/
 sed -i -e '/127.0.0.1       '"$2"'.local/d' hosts

 # Remove apache2 conf
 echo 'Removing apache conf files'
 cd /etc/apache2/sites-enabled
 rm $2.acoulombe.conf

 # Remove apache2 log files
 echo 'Removing apache log files'
 cd /var/log/apache2
 rm $2.local_apache_*

fi

if [ $1 == 'ssl' ]; then

 # Remove then create ssl cert
 echo 'Updating ssl certs'
 cd ~/ssl
 rm $2.local*
 mkcert $2.local

fi

service apache2 reload
alert Ready
