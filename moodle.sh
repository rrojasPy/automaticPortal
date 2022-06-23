#!/bin/bash root


sudo apt update
sudo apt install apache2
sudo apt install php php-pgsql libapache2-mod-php -y
sudo apt install postgresql postgresql-contrib -y
sudo su - postgres

##
# psql
# \password postgres
   postgres=# CREATE USER moodleuser WITH PASSWORD 'meta';
   postgres=# CREATE DATABASE moodle WITH OWNER moodleuser;

#

# Instalar pgadmin
sudo wget -qO /etc/apt/trusted.gpg.d/pgdg.asc https://www.postgresql.org/media/keys/ACCC4CF8.asc
sudo apt update

sudo sh -c echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -sc)-pgdg main" | sudo tee /etc/apt/sources.list.d/pgdg.list

sudo curl https://www.pgadmin.org/static/packages_pgadmin_org.pub | sudo apt-key add
sudo sh -c 'echo "deb https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/$(lsb_release -cs) pgadmin4 main" > /etc/apt/sources.list.d/pgadmin4.list && apt update'

curl https://www.pgadmin.org/static/packages_pgadmin_org.pub | sudo apt-key add
sudo sh -c 'echo "deb https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/$(lsb_release -cs) pgadmin4 main" > /etc/apt/sources.list.d/pgadmin4.list && apt update'
sudo apt install pgadmin4


sudo apt install pgadmin4 pgadmin4-apache2 -y

# Instalacion moodle

git clone git://git.moodle.org/moodle.git
git clone -b MOODLE_39_STABLE git://git.moodle.org/moodle.git
sudo cp -r moodle/ /var/www/html/
sudo chown -R root /var/www/html/moodle/
sudo chmod -R 0755 /var/www/html/moodle/
sudo find /var/www/html/mocdodle/ -type f -exec chmod 0644 {} \;

sudo mkdir /var/www/moodledata
sudo chmod 0777 /var/www/moodledata/
sudo chown www-data /var/www/html/moodle/

#Se instalan paquetes necesarios de php:
sudo apt-get install php7.4-curl -y
sudo apt-get install php7.4-xml -y
sudo apt-get install php7.4-zip -y
sudo apt-get install php7.4-mbstring -y
sudo apt-get install php7.4-gd -y
sudo apt-get install php7.4-intl -y
sudo apt-get install php7.4-xmlrpc -y
sudo apt-get install php7.4-soap
sudo systemctl restart apache2 -y

cd /var/www/html/moodle/admin/cli/
sudo -u www-data /usr/bin/php install.php



