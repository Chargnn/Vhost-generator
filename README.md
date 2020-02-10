# Vhost-generator
Apache vhost config generator for linux

Usage:

To add vhost

./hostsGenerator.sh a test ~/vhosts/test/public 7.4

will add vhost **test**, ssh keys and will be accessible via **https://test.local** using php7.4

To remove

./hostsGenerator.sh r test

To update ssl keys

./hostsGenerator.sh ssh
