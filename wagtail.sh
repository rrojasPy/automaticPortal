#!/bin/bash 

#####################################################################################
##### Data Base   #####
postgresUser="meta"
postgresPass="meta"
postgresDataBase="meta"

publicIP=$(wget -qO- ifconfig.co/ip)
##### Directorios #####

DirTemp="temporal"

#####################################################################################


echo "#### INSTALANDO DEPENDENCIAS "
##################
## Dependencias ##

# Update
sudo apt-get update -y

#Install python 3
sudo apt-get install python -y
echo "python 3 Instalado" >> ReporteInstalacion.txt

#Install python-pip 3
sudo apt-get install python3-pip -y
echo "python-pip Instalado" >> ReporteInstalacion.txt

#Install paquete libpq
sudo apt-get install libpq-dev -y 

# Install  python 3 venv
sudo apt-get install python3-venv -y


#Install postgres
#Postgres
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo apt-get update
sudo apt-get -y install postgresql
sudo apt-get install postgresql-12
echo "postgress 3 Instalado" >> ReporteInstalacion.txt


#######################################################################################################################################

mkdir ~/$DirTemp

## Base de datos ##
# Crear usuario, Base de Datos y establecer permisos

touch ~/$DirTemp/dbConfig.sql
echo "
create database ${postgresDataBase};
create user ${postgresUser} with password '${postgresPass}';
GRANT ALL PRIVILEGES ON DATABASE ${postgresDataBase} TO ${postgresUser};
GRANT ALL ON ALL TABLES IN SCHEMA public to ${postgresUser};
GRANT ALL ON ALL SEQUENCES IN SCHEMA public to  ${postgresUser};
GRANT ALL ON ALL FUNCTIONS IN SCHEMA public to ${postgresUser};" > ~/$DirTemp/dbConfig.sql

sudo -u postgres psql -f ~/$DirTemp/dbConfig.sql
echo "Crear Data Base:${postgresDataBase}, " >> ReporteInstalacion.txt


## Clonar proyecto
cd ~/
git clone https://gitlab.com/mpoletti-peduca/paraguayeduca-django.git
echo "Clonar gitlab " >> ReporteInstalacion.txt

mkdir env
python3 -m venv ~/env
source ~/env/bin/activate 
# Chequeo de rama 
cd ~/paraguayeduca-django/
git checkout develop
#mkdir ~/paraguayeduca-django/env
#python3 -m venv ~/paraguayeduca-django/env
#source ~/paraguayeduca-django/env/bin/activate
sudo apt update
sudo apt upgrade -y
pip install --upgrade pip
pip3 install --upgrade setuptools
pip3 install -r ~/paraguayeduca-django/requirements.txt
echo "Requerimientos instalados " >> ReporteInstalacion.txt

##Configurar local_settings.py
touch ~/paraguayeduca-django/meta/local_settings.py

echo "import os
from meta.settings import SITE_ROOT

DEBUG = True

PASS_SECRET = ''
WEBSERVICE_TOKEN = ''
TOKEN_USERKEY = ''
MOODLE_URL = ''

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql_psycopg2',
        'NAME': '${postgresDataBase}',
        'USER': '${postgresUser}',
        'PASSWORD': '${postgresPass}',
        'HOST': 'localhost',
        'PORT': '',
    }
}
" > ~/paraguayeduca-django/meta/local_settings.py

echo "Local_setting Generado" >> ReporteInstalacion.txt

## Poblar base de datos 
python ~/paraguayeduca-django/manage.py migrate
python ~/paraguayeduca-django/manage.py createsuperuser 
#python ~/paraguayeduca-django/manage.py runserver localhost:8000
deactivate
### Instalar Guanicorn 
# Instalacion
sudo apt install python-pip -y 
#sudo apt-get install gunicorn -y 
pip3 install gunicorn
pip install psycopg2-binary

# Ngicx
sudo apt-get install nginx -y


# Conect sguanicorn 
#cd ~/paraguayeduca-django
#gunicorn --bind 0.0.0.0:8000 meta.wsgi:application ## similar to runserver

# Install supervisor 
sudo apt-get install -y supervisor ## This command holds the website after we logout

# Config Supervisor
#cd /etc/supervisor/conf.d/
sudo touch /etc/supervisor/conf.d/gunicorn.conf
sudo chmod 777 gunicorn.conf
sudo echo "
[program:gunicorn]
directory=/home/ubuntu/paraguayeduca-django
command=/home/ubuntu/env/bin/gunicorn --workers 3 --bind unix:/home/ubuntu/paraguayeduca-django/app.sock meta.wsgi:application
autostart=true
autorestart=true
stderr_logfile=/var/log/gunicorn/gunicorn.err.log
stdout_logfile=/var/log/gunicorn/gunicorn.out.log

[group:guni]
programs:gunicorn" > /etc/supervisor/conf.d/gunicorn.conf

pip3 install gunicorn

# Conectar fichero de supervisor 
## Crear directorios 
sudo mkdir -p /var/log/gunicorn
sudo supervisorctl reread
sudo supervisorctl update all

##  Compruebe si gunicorn se está ejecutando en segundo plano
sudo supervisorctl status

## Cree la configuración de nginx para el sitio de django
#sudo touch /etc/nginx/sites-available/django.conf

#sudo chmod 777 django.conf
######################### INSERTAR ###############################################
sudo echo " 
server {
listen 80;
#server_name portalmeta.org.py www.portalmeta.org.py;
server_name ${publicIP};

 location / {
  include proxy_params;
  proxy_pass http://unix:/home/ubuntu/paraguayeduca-django/app.sock;
 }

 location /static/ {
  autoindex on;
  alias /home/ubuntu/paraguayeduca-django/static/;
 }

 location /media/ {
  autoindex on;
  alias /home/ubuntu/paraguayeduca-django/media/;
 }
}" > /etc/nginx/sites-available/django.conf

## Test fichero de configuracion 
sudo ln /etc/nginx/sites-available/django.conf /etc/nginx/sites-enabled/
sudo nginx -t

## Restart NGINX server 
sudo service nginx restart
